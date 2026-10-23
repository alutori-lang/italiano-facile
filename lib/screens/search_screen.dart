import 'dart:async';

import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/big_dictionary.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/big_entry.dart';
import '../models/learner_language.dart';
import '../models/word.dart';
import '../services/online_lookup_service.dart';
import '../services/search_service.dart';
import '../services/text_norm.dart';
import '../ui/theme.dart';
import '../ui/widgets/big_entry_card.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/screen_header.dart';
import '../ui/widgets/tricolour_frame.dart';
import '../ui/widgets/word_card.dart';
import 'big_entry_screen.dart';
import 'my_words_screen.dart';
import 'settings_screen.dart';
import 'word_detail_screen.dart';

/// The first and most important tab: one dominant multilingual search field
/// with live, typo- and accent-tolerant results over words and phrases.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery, this.controller});

  final String? initialQuery;

  /// Owned by a caller that outlives this screen — [HomeShell] passes one so
  /// the query (and, via [_runSearch], the results) survive this screen being
  /// unmounted and rebuilt when the user switches tabs and back. When absent,
  /// the screen creates and owns its own, as it does when pushed on its own
  /// (My Words' "did you mean" flow, screenshot mode).
  final TextEditingController? controller;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const SearchService _service = SearchService();

  late final TextEditingController _controller = widget.controller ??
      TextEditingController(text: widget.initialQuery ?? '');
  List<SearchHit> _hits = const <SearchHit>[];
  List<Word> _suggestions = const <Word>[];
  OnlineLookupResult? _onlineResult;
  bool _onlineLoading = false;
  bool _onlineFailed = false;

  // The big offline dictionary (see [BigDictionary]): its answers come after
  // the curated words, which have pictures and explanations. A big answer
  // whose headword is also a curated word is shown as that curated card.
  BigDictionary? _big;
  List<SearchHit> _bigWords = const <SearchHit>[];
  List<BigHit> _bigEntries = const <BigHit>[];

  /// Curated words already found by the curated search that the big
  /// dictionary also found, with ITS (better) score: "love" is only a loose
  /// curated match for some words but the exact big meaning of l'amore.
  Map<String, int> _bigBoost = const <String, int>{};

  /// Frequency rank of the big entry behind a curated word or a big card
  /// (lower = more common): breaks ties between equal scores.
  Map<String, int> _bigRank = const <String, int>{};
  bool _bigPending = false;
  int _bigSeq = 0;
  bool _bigIndexedSeen = false;
  Timer? _serverTimer;
  bool _serverSearching = false;
  ServerLookupStatus _server = ServerLookupStatus.off;

  /// Curated words by their normalized headword without article.
  static Map<String, Word>? _curatedByBare;
  static Map<String, Word> get _curated => _curatedByBare ??= () {
        final Map<String, Word> map = <String, Word>{};
        for (final Word word in WordRepository.instance.all) {
          if (word.isPhrase) continue;
          map.putIfAbsent(TextNorm.norm(word.bare), () => word);
        }
        return map;
      }();

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    // Either a query passed in directly, or one already sitting in a
    // controller handed down from an earlier visit to this screen.
    final String text = widget.controller?.text ?? widget.initialQuery ?? '';
    if (text.isNotEmpty) {
      // Results for a pre-filled query are computed after the first frame,
      // when the locale is available.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _runSearch(text, remember: false);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BigDictionary? big = AppScope.of(context).big;
    if (!identical(big, _big)) {
      _big?.removeListener(_onBigChanged);
      _big = big;
      _big?.addListener(_onBigChanged);
    }
  }

  @override
  void dispose() {
    _serverTimer?.cancel();
    _big?.removeListener(_onBigChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  /// The big dictionary finished copying or indexing: refresh the answer for
  /// what is already typed, and the "Preparazione…" notice.
  void _onBigChanged() {
    if (!mounted) return;
    final BigDictionary? big = _big;
    final LearnerLanguage lang = AppScope.languageOf(context);
    final bool indexed = big != null && big.ready && big.isIndexed(lang);
    final bool refresh = indexed != _bigIndexedSeen;
    _bigIndexedSeen = indexed;
    setState(() {});
    if (refresh && _controller.text.trim().isNotEmpty) {
      _runBig(_controller.text, lang, _hits);
    }
  }

  Future<void> _runBig(
    String query,
    LearnerLanguage lang,
    List<SearchHit> hits,
  ) async {
    final int seq = ++_bigSeq;
    _serverTimer?.cancel();
    final BigDictionary? big = _big;
    if (big == null || !big.ready || query.trim().isEmpty) {
      if (_bigWords.isNotEmpty ||
          _bigEntries.isNotEmpty ||
          _bigPending ||
          _serverSearching ||
          _server != ServerLookupStatus.off) {
        setState(() {
          _bigWords = const <SearchHit>[];
          _bigEntries = const <BigHit>[];
          _bigBoost = const <String, int>{};
          _bigRank = const <String, int>{};
          _bigPending = false;
          _serverSearching = false;
          _server = ServerLookupStatus.off;
        });
      }
      return;
    }
    setState(() => _bigPending = true);
    final List<BigHit> found = await big.lookup(query, lang);
    if (!mounted || seq != _bigSeq) return;
    final Set<String> shown = <String>{
      for (final SearchHit hit in hits) hit.word.id,
    };
    final Set<String> curatedHits = Set<String>.of(shown);
    final List<SearchHit> words = <SearchHit>[];
    final List<BigHit> entries = <BigHit>[];
    final Map<String, int> boost = <String, int>{};
    final Map<String, int> rank = <String, int>{};
    for (final BigHit hit in found) {
      final Word? curated = _curated[TextNorm.norm(hit.entry.it)];
      if (curated != null) {
        final int? r = hit.entry.rank;
        if (r != null && r < (rank[curated.id] ?? 1 << 30)) {
          rank[curated.id] = r;
        }
        if (curatedHits.contains(curated.id)) {
          if (hit.score > (boost[curated.id] ?? 0)) {
            boost[curated.id] = hit.score;
          }
        } else if (shown.add(curated.id)) {
          words.add(SearchHit(curated, hit.score));
        }
      } else {
        entries.add(hit);
      }
    }
    setState(() {
      _bigWords = words;
      _bigEntries = entries;
      _bigBoost = boost;
      _bigRank = rank;
      _bigPending = false;
      _server = ServerLookupStatus.off;
      _serverSearching = false;
    });
    // Nothing anywhere on the phone: ask the word server once the user
    // stops typing (only when it is configured — see ServerConfig). It can
    // take up to a minute (the server may ask Gemini), so it is shown.
    if (hits.isEmpty &&
        found.isEmpty &&
        big.serverEnabled &&
        query.trim().length >= 2) {
      _serverTimer = Timer(const Duration(milliseconds: 700), () async {
        if (!mounted || seq != _bigSeq) return;
        setState(() => _serverSearching = true);
        final ServerLookup answer = await big.askServer(query, lang);
        if (!mounted || seq != _bigSeq) return;
        final BigEntry? entry = answer.entry;
        setState(() {
          _serverSearching = false;
          _server = answer.status;
          if (entry != null) _bigEntries = <BigHit>[BigHit(entry, 1000)];
        });
      });
    }
  }

  /// Curated and big-dictionary answers in ONE list, best match first: a
  /// big-dictionary word that matches exactly (e.g. "piyar" → l'amore) comes
  /// before a curated word that only matched loosely. A curated word gets
  /// the better of its curated and its big score. On equal scores the more
  /// common word (big frequency rank) wins, then the curated card (picture,
  /// explanation).
  List<Widget> _mergedResults() {
    final List<MergedItem<Widget>> items = <MergedItem<Widget>>[];
    for (final SearchHit hit in <SearchHit>[..._hits, ..._bigWords]) {
      final int boosted = _bigBoost[hit.word.id] ?? 0;
      items.add(MergedItem<Widget>(
        boosted > hit.score ? boosted : hit.score,
        _bigRank[hit.word.id],
        true,
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.l),
          child: WordCard(
            word: hit.word,
            heroTag: 'word-picture:${hit.word.id}',
            onTap: () => _openWord(hit.word),
          ),
        ),
      ));
    }
    for (final BigHit hit in _bigEntries) {
      items.add(MergedItem<Widget>(
        hit.score,
        hit.entry.rank,
        false,
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.m),
          child: BigEntryCard(
            entry: hit.entry,
            onTap: () => _openBigEntry(hit.entry),
          ),
        ),
      ));
    }
    return <Widget>[
      for (final MergedItem<Widget> item in MergedItem.order(items)) item.value,
    ];
  }

  void _openBigEntry(BigEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BigEntryScreen(entry: entry),
      ),
    );
  }

  void _runSearch(String query, {bool remember = true}) {
    final LearnerLanguage lang = AppScope.languageOf(context);
    final List<SearchHit> hits = _service.search(query, lang);
    setState(() {
      _hits = hits;
      _onlineResult = null;
      _onlineFailed = false;
      _suggestions =
          hits.isEmpty ? _service.suggestions(query, lang) : const <Word>[];
    });
    _runBig(query, lang, hits);
    if (remember && hits.isNotEmpty && query.trim().length >= 2) {
      AppScope.of(context).progress.addRecentSearch(query.trim());
    }
  }

  Future<void> _searchOnline() async {
    setState(() {
      _onlineLoading = true;
      _onlineFailed = false;
    });
    final OnlineLookupResult? result =
        await AppScope.of(context).online.lookup(_controller.text);
    if (!mounted) return;
    setState(() {
      _onlineLoading = false;
      _onlineResult = result;
      _onlineFailed = result == null;
    });
  }

  void _openWord(Word word) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordDetailScreen(word: word),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final AppScope scope = AppScope.of(context);
    final WordRepository repo = WordRepository.instance;
    final String query = _controller.text.trim();
    final BigDictionary? big = scope.big;
    final bool anyResult =
        _hits.isNotEmpty || _bigWords.isNotEmpty || _bigEntries.isNotEmpty;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ScreenHeader(
              title: t.tabSearch,
              // One count, so it fits on one line next to the language pill
              // (the big dictionary holds words and phrases together).
              subtitle: t.wordsAndPhrasesTotal(
                repo.wordCount + repo.phraseCount + (big?.entryCount ?? 0),
              ),
              subtitleOneLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: HeaderPill(
                      key: const ValueKey<String>('search-language'),
                      label: translationLanguageLabel(t, scope.settings),
                      onTap: () => showTranslationLanguagePicker(context),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey<String>('search-settings'),
                    visualDensity: VisualDensity.compact,
                    tooltip: t.settingsTitle,
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TricolourFrame(
              child: TextField(
                key: const ValueKey<String>('search-field'),
                controller: _controller,
                textInputAction: TextInputAction.search,
                onChanged: (String value) => _runSearch(value, remember: false),
                onSubmitted: _runSearch,
                decoration: InputDecoration(
                  hintText: t.searchHint,
                  // The tricolour frame is the border here.
                  filled: true,
                  fillColor: context.surface,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          key: const ValueKey<String>('search-clear'),
                          tooltip: t.clearRecent,
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _controller.clear();
                            _runSearch('', remember: false);
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.l),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppSpace.xxl),
                children: <Widget>[
                  if (big != null && big.showPreparing)
                    Padding(
                      key: const ValueKey<String>('big-preparing'),
                      padding: const EdgeInsets.only(bottom: AppSpace.l),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: AppSpace.m),
                          Expanded(
                            child: Text(
                              t.bigPreparing,
                              style: context.texts.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (query.isEmpty) ..._idleContent(t, scope),
                  if (query.isNotEmpty) ..._mergedResults(),
                  // While the big dictionary is still answering, do not
                  // flash "nothing found".
                  if (query.isNotEmpty && !anyResult && _serverSearching)
                    Row(
                      key: const ValueKey<String>('big-online-searching'),
                      children: <Widget>[
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: AppSpace.m),
                        Expanded(
                          child: Text(
                            t.bigSearchingOnline,
                            style: context.texts.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  if (query.isNotEmpty &&
                      !anyResult &&
                      !_serverSearching &&
                      (_server == ServerLookupStatus.notAllowed ||
                          _server == ServerLookupStatus.notFound))
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.l),
                      child: Text(
                        _server == ServerLookupStatus.notAllowed
                            ? t.bigNotAllowed
                            : t.bigNotFoundOnline,
                        key: ValueKey<String>(
                          _server == ServerLookupStatus.notAllowed
                              ? 'big-online-not-allowed'
                              : 'big-online-not-found',
                        ),
                        style: context.texts.bodyMedium,
                      ),
                    ),
                  if (query.isNotEmpty &&
                      !anyResult &&
                      !_bigPending &&
                      !_serverSearching)
                    ..._emptyContent(t, query),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _idleContent(AppLocalizations t, AppScope scope) {
    final List<String> recents = scope.progress.recentSearches;
    final List<Word> myWords = WordRepository.instance
        .byIds(scope.progress.myWordIds)
        .take(3)
        .toList();

    return <Widget>[
      if (recents.isNotEmpty) ...<Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                t.recentSearches.toUpperCase(),
                style: context.texts.labelSmall,
              ),
            ),
            TextButton(
              key: const ValueKey<String>('clear-recents'),
              onPressed: scope.progress.clearRecentSearches,
              child: Text(t.clearRecent),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.s),
        Wrap(
          spacing: AppSpace.s,
          runSpacing: AppSpace.s,
          children: recents
              .map(
                (String term) => ActionChip(
                  key: ValueKey<String>('recent:$term'),
                  label: Text(term),
                  onPressed: () {
                    _controller.text = term;
                    _runSearch(term, remember: false);
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpace.xl),
      ],
      Row(
        children: <Widget>[
          Expanded(
            child: Text(
              t.myWords.toUpperCase(),
              style: context.texts.labelSmall,
            ),
          ),
          TextButton(
            key: const ValueKey<String>('open-my-words'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MyWordsScreen(),
              ),
            ),
            child: Text(t.myWords),
          ),
        ],
      ),
      const SizedBox(height: AppSpace.s),
      if (myWords.isEmpty)
        Text(t.myWordsEmpty, style: context.texts.bodySmall)
      else
        ...myWords.map(
          (Word word) => WordRow(word: word, onTap: () => _openWord(word)),
        ),
    ];
  }

  List<Widget> _emptyContent(AppLocalizations t, String query) {
    return <Widget>[
      Text(t.noResults, style: context.texts.titleLarge),
      const SizedBox(height: AppSpace.m),
      if (_suggestions.isNotEmpty) ...<Widget>[
        Text(t.didYouMean, style: context.texts.bodySmall),
        const SizedBox(height: AppSpace.s),
        ..._suggestions.map(
          (Word word) => WordRow(word: word, onTap: () => _openWord(word)),
        ),
        const SizedBox(height: AppSpace.l),
      ],
      if (AppScope.of(context).online.configured)
        OutlinedButton(
          key: const ValueKey<String>('search-online'),
          onPressed: _onlineLoading ? null : _searchOnline,
          child: ButtonContent(
            icon: Icons.public_rounded,
            label: _onlineLoading ? t.searchingOnline : t.searchOnline,
          ),
        ),
      if (_onlineFailed) ...<Widget>[
        const SizedBox(height: AppSpace.m),
        Text(t.offlineNotice, style: context.texts.bodySmall),
      ],
      if (_onlineResult != null) ...<Widget>[
        const SizedBox(height: AppSpace.l),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.l + 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  t.onlineResultTitle.toUpperCase(),
                  style: context.texts.labelSmall,
                ),
                const SizedBox(height: AppSpace.s),
                Text(
                  _onlineResult!.term,
                  style: context.texts.displaySmall?.copyWith(
                    color: AppColors.italianRed,
                  ),
                ),
                const SizedBox(height: AppSpace.s),
                Text(_onlineResult!.extract, style: context.texts.bodyMedium),
                const SizedBox(height: AppSpace.s),
                Text(_onlineResult!.sourceUrl, style: context.texts.bodySmall),
              ],
            ),
          ),
        ),
      ],
    ];
  }
}

/// One row of the merged Search list (see [_SearchScreenState]).
class MergedItem<T> {
  const MergedItem(this.score, this.rank, this.curated, this.value);

  final int score;

  /// Big-dictionary frequency rank, lower = more common; null = unknown.
  final int? rank;
  final bool curated;
  final T value;

  /// Best score first; equal scores: more common word, then the curated
  /// card, then the original order (a stable sort).
  static List<MergedItem<T>> order<T>(List<MergedItem<T>> items) {
    final List<(int, MergedItem<T>)> indexed = <(int, MergedItem<T>)>[
      for (int i = 0; i < items.length; i++) (i, items[i]),
    ];
    indexed.sort(((int, MergedItem<T>) a, (int, MergedItem<T>) b) {
      final int byScore = b.$2.score.compareTo(a.$2.score);
      if (byScore != 0) return byScore;
      final int ra = a.$2.rank ?? 1 << 30;
      final int rb = b.$2.rank ?? 1 << 30;
      if (ra != rb) return ra.compareTo(rb);
      if (a.$2.curated != b.$2.curated) return a.$2.curated ? -1 : 1;
      return a.$1.compareTo(b.$1);
    });
    return <MergedItem<T>>[for (final (int, MergedItem<T>) e in indexed) e.$2];
  }
}
