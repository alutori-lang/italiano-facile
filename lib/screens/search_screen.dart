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
    final List<SearchHit> words = <SearchHit>[];
    final List<BigHit> entries = <BigHit>[];
    for (final BigHit hit in found) {
      final Word? curated = _curated[TextNorm.norm(hit.entry.it)];
      if (curated != null) {
        if (shown.add(curated.id)) words.add(SearchHit(curated, hit.score));
      } else {
        entries.add(hit);
      }
    }
    setState(() {
      _bigWords = words;
      _bigEntries = entries;
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
  /// before a curated word that only matched loosely. On equal scores the
  /// curated card (picture, explanation) wins.
  List<Widget> _mergedResults() {
    final List<(int, int, Widget)> items = <(int, int, Widget)>[];
    for (final SearchHit hit in <SearchHit>[..._hits, ..._bigWords]) {
      items.add((
        hit.score,
        1,
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
      items.add((
        hit.score,
        0,
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.m),
          child: BigEntryCard(
            entry: hit.entry,
            onTap: () => _openBigEntry(hit.entry),
          ),
        ),
      ));
    }
    items.sort(((int, int, Widget) a, (int, int, Widget) b) {
      final int byScore = b.$1.compareTo(a.$1);
      return byScore != 0 ? byScore : b.$2.compareTo(a.$2);
    });
    return <Widget>[for (final (int, int, Widget) item in items) item.$3];
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
              subtitle: t.wordsAndPhrases(
                repo.wordCount + (big?.entryCount ?? 0),
                repo.phraseCount,
              ),
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
