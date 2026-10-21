import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/learner_language.dart';
import '../models/word.dart';
import '../services/online_lookup_service.dart';
import '../services/search_service.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/screen_header.dart';
import '../ui/widgets/word_card.dart';
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
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _runSearch(String query, {bool remember = true}) {
    final LearnerLanguage lang = AppScope.languageOf(context);
    final List<SearchHit> hits = _service.search(query, lang);
    setState(() {
      _hits = hits;
      _onlineResult = null;
      _onlineFailed = false;
      _suggestions = hits.isEmpty
          ? _service.suggestions(query, lang)
          : const <Word>[];
    });
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

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ScreenHeader(
              title: t.tabSearch,
              subtitle: t.wordsAndPhrases(repo.wordCount, repo.phraseCount),
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
            TextField(
              key: const ValueKey<String>('search-field'),
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: (String value) => _runSearch(value, remember: false),
              onSubmitted: _runSearch,
              decoration: InputDecoration(
                hintText: t.searchHint,
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
            const SizedBox(height: AppSpace.l),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppSpace.xxl),
                children: <Widget>[
                  if (query.isEmpty) ..._idleContent(t, scope),
                  if (query.isNotEmpty && _hits.isNotEmpty)
                    ..._hits.map(
                      (SearchHit hit) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpace.l),
                        child: WordCard(
                          word: hit.word,
                          heroTag: 'word-picture:${hit.word.id}',
                          onTap: () => _openWord(hit.word),
                        ),
                      ),
                    ),
                  if (query.isNotEmpty && _hits.isEmpty)
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
    final List<Word> myWords =
        WordRepository.instance.byIds(scope.progress.myWordIds).take(3).toList();

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
