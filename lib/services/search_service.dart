import '../data/word_repository.dart';
import '../models/learner_language.dart';
import '../models/word.dart';

/// One search hit, with the score used to order the list.
class SearchHit {
  const SearchHit(this.word, this.score);

  final Word word;
  final int score;
}

/// Offline search over the bundled dictionary.
///
/// It is deliberately forgiving: accents and capitals are ignored, small typos
/// are tolerated, conjugated verb forms find the infinitive, and the query may
/// be written in Italian or in any of the ten translation languages.
class SearchService {
  const SearchService();

  static const int _maxResults = 40;

  /// Strips accents, lowercases and drops punctuation so "Città" == "citta".
  static String normalize(String input) {
    const Map<String, String> folding = <String, String>{
      'à': 'a', 'á': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ç': 'c', 'ñ': 'n', 'ý': 'y',
    };
    final StringBuffer out = StringBuffer();
    for (final int rune in input.toLowerCase().runes) {
      final String ch = String.fromCharCode(rune);
      final String? folded = folding[ch];
      if (folded != null) {
        out.write(folded);
      } else if (ch == '\'' || ch == '’' || ch == '-') {
        out.write(' ');
      } else if (_isPunctuation(ch)) {
        out.write(' ');
      } else {
        out.write(ch);
      }
    }
    return out.toString().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool _isPunctuation(String ch) =>
      '.,;:!?"«»()[]{}/\\&%#*+=_<>|~^`'.contains(ch);

  /// Maps a conjugated Italian verb form back to candidate infinitives:
  /// "parlo", "parli", "parlava" → "parlare". Returns possible stems, not
  /// guaranteed words; the caller matches them against the dictionary.
  static Set<String> verbCandidates(String normalizedQuery) {
    final Set<String> out = <String>{};
    const List<String> endings = <String>[
      'o', 'i', 'a', 'e', 'iamo', 'amo', 'ate', 'ete', 'ite', 'ano', 'ono',
      'avo', 'avi', 'ava', 'avamo', 'avate', 'avano',
      'ero', 'erai', 'era', 'ato', 'uto', 'ito', 'isco', 'isci', 'isce',
      'iscono', 'ai', 'asti', 'ammo', 'aste', 'arono',
    ];
    for (final String ending in endings) {
      if (normalizedQuery.length > ending.length + 2 &&
          normalizedQuery.endsWith(ending)) {
        final String stem =
            normalizedQuery.substring(0, normalizedQuery.length - ending.length);
        out.add('${stem}are');
        out.add('${stem}ere');
        out.add('${stem}ire');
      }
    }
    return out;
  }

  /// Damerau-Levenshtein distance, capped so long strings stay cheap.
  ///
  /// Swapping two neighbouring letters counts as ONE slip, which is what a
  /// real typo usually is: "pomodroo" is one slip from "pomodoro", while
  /// "pomodorzz" is two and is therefore treated as a different word.
  static int editDistance(String a, String b, {int max = 3}) {
    if (a == b) return 0;
    if ((a.length - b.length).abs() > max) return max + 1;
    if (a.isEmpty) return b.length <= max ? b.length : max + 1;
    if (b.isEmpty) return a.length <= max ? a.length : max + 1;
    List<int> twoAgo = List<int>.filled(b.length + 1, 0);
    List<int> previous = List<int>.generate(b.length + 1, (int i) => i);
    List<int> current = List<int>.filled(b.length + 1, 0);
    for (int i = 1; i <= a.length; i++) {
      current[0] = i;
      int rowMin = current[0];
      for (int j = 1; j <= b.length; j++) {
        final int cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        int value = previous[j - 1] + cost;
        if (previous[j] + 1 < value) value = previous[j] + 1;
        if (current[j - 1] + 1 < value) value = current[j - 1] + 1;
        if (i > 1 &&
            j > 1 &&
            a.codeUnitAt(i - 1) == b.codeUnitAt(j - 2) &&
            a.codeUnitAt(i - 2) == b.codeUnitAt(j - 1) &&
            twoAgo[j - 2] + 1 < value) {
          value = twoAgo[j - 2] + 1;
        }
        current[j] = value;
        if (value < rowMin) rowMin = value;
      }
      if (rowMin > max) return max + 1;
      final List<int> spare = twoAgo;
      twoAgo = previous;
      previous = current;
      current = spare;
    }
    return previous[b.length];
  }

  /// Full search. [lang] decides which translation column is searched first,
  /// but every language is searched, so a user can type in any of them.
  List<SearchHit> search(String rawQuery, LearnerLanguage lang) {
    final String query = normalize(rawQuery);
    if (query.isEmpty) return const <SearchHit>[];
    final Set<String> verbForms = verbCandidates(query);
    final List<SearchHit> hits = <SearchHit>[];

    for (final Word word in WordRepository.instance.all) {
      final int score = _scoreWord(word, rawQuery, query, verbForms, lang);
      if (score > 0) hits.add(SearchHit(word, score));
    }

    hits.sort((SearchHit a, SearchHit b) {
      final int byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.word.it.length.compareTo(b.word.it.length);
    });
    return hits.length > _maxResults ? hits.sublist(0, _maxResults) : hits;
  }

  int _scoreWord(
    Word word,
    String rawQuery,
    String query,
    Set<String> verbForms,
    LearnerLanguage lang,
  ) {
    final String italian = normalize(word.it);
    final String bare = normalize(word.bare);

    if (italian == query || bare == query) return 1000;
    if (verbForms.contains(bare) || verbForms.contains(italian)) return 950;
    if (bare.startsWith(query) || italian.startsWith(query)) return 900;

    // The user's own language first, then all the others.
    final String own = normalize(word.translation(lang));
    if (own == query) return 880;
    if (own.startsWith(query)) return 840;
    if (own.contains(query)) return 780;

    for (final LearnerLanguage other in LearnerLanguage.values) {
      if (other == lang) continue;
      final String translation = normalize(word.translation(other));
      if (translation == query) return 820;
      if (translation.startsWith(query)) return 760;
      if (translation.contains(query)) return 700;
    }

    if (italian.contains(query)) return 680;

    // Explanation and example text are searched last, so they never outrank
    // a real headword match.
    if (normalize(word.explanation(lang)).contains(query)) return 400;
    if (normalize(word.example).contains(query)) return 380;
    if (normalize(word.exampleTranslation(lang)).contains(query)) return 360;

    // Finally, tolerate ONE slip on the headword itself: a wrong, missing,
    // extra or swapped letter. Two slips would start matching unrelated
    // words, so a query that far off is answered with "Did you mean…?"
    // suggestions instead of a confident result.
    const int allowed = 1;
    if (query.length >= 4) {
      if (editDistance(bare, query, max: allowed) <= allowed) return 600;
      if (editDistance(own, query, max: allowed) <= allowed) return 560;
      for (final String token in bare.split(' ')) {
        if (token.length >= 4 &&
            editDistance(token, query, max: allowed) <= allowed) {
          return 540;
        }
      }
    }
    return 0;
  }

  /// "Did you mean…?" candidates for a query that found nothing exact.
  List<Word> suggestions(String rawQuery, LearnerLanguage lang,
      {int limit = 5}) {
    final String query = normalize(rawQuery);
    if (query.length < 2) return const <Word>[];
    final List<SearchHit> scored = <SearchHit>[];
    for (final Word word in WordRepository.instance.all) {
      final int distance = editDistance(normalize(word.bare), query, max: 4);
      final int ownDistance =
          editDistance(normalize(word.translation(lang)), query, max: 4);
      final int best = distance < ownDistance ? distance : ownDistance;
      if (best <= 4) scored.add(SearchHit(word, 100 - best));
    }
    scored.sort((SearchHit a, SearchHit b) => b.score.compareTo(a.score));
    return scored
        .take(limit)
        .map((SearchHit hit) => hit.word)
        .toList(growable: false);
  }
}
