import 'dart:math';

import '../models/word.dart';

/// Picks the ten words of the day.
///
/// The choice is deterministic for a given (personal id, date) pair — the same
/// user opening the app twice on the same day sees the same ten words — but
/// two different users on the same date get different ones, because the seed
/// mixes the personal id into the shuffle.
class DailyWordsService {
  const DailyWordsService();

  static const int wordsPerDay = 10;

  /// Roughly 4 nouns, 3 verbs, 2 adjectives / useful words, 1 phrase.
  static const Map<WordType, int> mix = <WordType, int>{
    WordType.noun: 4,
    WordType.verb: 3,
    WordType.adjective: 2,
    WordType.phrase: 1,
  };

  /// A stable 32-bit seed from the personal id and the day.
  static int seedFor(String personalId, String dayKey) {
    int hash = 0x811c9dc5;
    for (final int unit in '$personalId|$dayKey'.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }

  /// [all] is the whole dictionary, [seen] the ids already shown on earlier
  /// days. Words that have not been seen come first; once everything has been
  /// seen the pool starts again from the full list.
  List<Word> pick({
    required List<Word> all,
    required Set<String> seen,
    required String personalId,
    required String dayKey,
    int count = wordsPerDay,
  }) {
    if (all.isEmpty) return const <Word>[];
    final Random random = Random(seedFor(personalId, dayKey));

    List<Word> pool = all.where((Word w) => !seen.contains(w.id)).toList();
    if (pool.length < count) {
      // Everything (or almost) has been seen: start a new cycle, but keep the
      // still-unseen words at the front so they are not skipped.
      final List<Word> rest =
          all.where((Word w) => seen.contains(w.id)).toList()..shuffle(random);
      pool = <Word>[...pool, ...rest];
    }

    final List<Word> chosen = <Word>[];
    final Set<String> used = <String>{};

    // Fill the type mix first.
    for (final MapEntry<WordType, int> entry in mix.entries) {
      final List<Word> ofType = pool
          .where((Word w) => w.type == entry.key && !used.contains(w.id))
          .toList()
        ..shuffle(random);
      for (final Word word in ofType.take(entry.value)) {
        chosen.add(word);
        used.add(word.id);
      }
    }

    // Top up from whatever is left when a type is short.
    if (chosen.length < count) {
      final List<Word> rest =
          pool.where((Word w) => !used.contains(w.id)).toList()
            ..shuffle(random);
      for (final Word word in rest) {
        if (chosen.length >= count) break;
        chosen.add(word);
        used.add(word.id);
      }
    }

    chosen.shuffle(random);
    return chosen.length > count ? chosen.sublist(0, count) : chosen;
  }
}
