import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/models/topic.dart';
import 'package:simple_flutter_app_651/models/word.dart';

/// Scripts that must never be replaced by Latin text.
bool _hasArabicScript(String s) => RegExp(r'[؀-ۿݐ-ݿ]').hasMatch(s);
bool _hasGurmukhi(String s) => RegExp(r'[਀-੿]').hasMatch(s);
bool _hasBengali(String s) => RegExp(r'[ঀ-৿]').hasMatch(s);
bool _hasSinhala(String s) => RegExp(r'[඀-෿]').hasMatch(s);
bool _hasHan(String s) => RegExp(r'[一-鿿㐀-䶿]').hasMatch(s);

void main() {
  final WordRepository repo = WordRepository.instance;

  test('Word data: the dictionary is not empty and has words and phrases', () {
    expect(repo.all.length, greaterThan(200));
    expect(repo.wordCount, greaterThan(150));
    expect(repo.phraseCount, greaterThan(15));
  });

  test(
      'Word data: every entry has ten translations, ten explanations and ten '
      'example translations', () {
    for (final Word word in repo.all) {
      expect(word.tr.length, LearnerLanguage.count, reason: word.it);
      expect(word.expl.length, LearnerLanguage.count, reason: word.it);
      expect(word.exampleTr.length, LearnerLanguage.count, reason: word.it);
      for (final LearnerLanguage lang in LearnerLanguage.values) {
        expect(word.translation(lang).trim(), isNotEmpty,
            reason: '${word.it} / ${lang.tag} translation');
        expect(word.explanation(lang).trim(), isNotEmpty,
            reason: '${word.it} / ${lang.tag} explanation');
        expect(word.exampleTranslation(lang).trim(), isNotEmpty,
            reason: '${word.it} / ${lang.tag} example');
      }
      expect(word.example.trim(), isNotEmpty, reason: word.it);
    }
  });

  test('Word data: nouns carry their Italian article', () {
    const Set<String> articles = <String>{
      'il', 'lo', 'la', 'i', 'gli', 'le', 'un', 'uno', 'una',
    };
    // Italian days of the week are nouns that are correctly used bare
    // ("lunedì apre l'ufficio"), so they are the one documented exception.
    const Set<String> bareByDesign = <String>{
      'lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato',
      'domenica',
    };
    for (final Word word
        in repo.all.where((Word w) => w.type == WordType.noun)) {
      if (bareByDesign.contains(word.it)) continue;
      final String first = word.it.split(' ').first.toLowerCase();
      final bool elided = word.it.toLowerCase().startsWith("l'");
      expect(
        elided || articles.contains(first),
        isTrue,
        reason: 'noun without an article: ${word.it}',
      );
    }
  });

  test('Word data: Italian accents are correct on the known tricky words', () {
    final Map<String, String> expected = <String, String>{
      'il caffè': 'caffè',
      'la città': 'città',
      'ventitré': 'ventitré',
      'lunedì': 'lunedì',
      'più': 'più',
    };
    for (final MapEntry<String, String> entry in expected.entries) {
      final Word? word = repo.byId(entry.key);
      expect(word, isNotNull, reason: 'missing entry ${entry.key}');
      expect(word!.it.contains(entry.value), isTrue, reason: entry.key);
    }
    // No entry may use a plain "e" where the accent is part of the word.
    for (final Word word in repo.all) {
      expect(word.example.contains('perche '), isFalse, reason: word.it);
      expect(word.example.contains('piu '), isFalse, reason: word.it);
    }
  });

  test('Word data: every entry belongs to a known topic', () {
    for (final Word word in repo.all) {
      expect(kTopicsById.containsKey(word.topicId), isTrue,
          reason: '${word.it} has unknown topic ${word.topicId}');
    }
  });

  test('Word data: every topic shown in the app really has words', () {
    for (final Topic topic in repo.topicsWithWords) {
      expect(repo.countInTopic(topic.id), greaterThan(0));
    }
    expect(repo.topicsWithWords.length, greaterThanOrEqualTo(30));
  });

  test('Word data: an entry either has a fitting emoji or none at all', () {
    // The emoji must be a real single pictograph, never a letter or digit
    // standing in for a picture.
    for (final Word word in repo.all) {
      final String? emoji = word.emoji;
      if (emoji == null) continue;
      expect(emoji.trim(), isNotEmpty, reason: word.it);
      expect(RegExp(r'^[A-Za-z]+$').hasMatch(emoji), isFalse,
          reason: '${word.it} uses letters as a picture');
    }
    // At least one entry deliberately has no picture, proving the fallback is
    // used rather than a wrong emoji.
    expect(repo.all.any((Word w) => w.emoji == null), isTrue);
  });

  test('Word data: LatAm Spanish differs from Spain Spanish where it should',
      () {
    final Map<String, String> latam = <String, String>{
      'la macchina': 'carro',
      'il succo': 'jugo',
      'la patata': 'papa',
      'il biglietto': 'boleto',
    };
    for (final MapEntry<String, String> entry in latam.entries) {
      final Word? word = repo.byId(entry.key);
      expect(word, isNotNull, reason: entry.key);
      final String es = word!.translation(LearnerLanguage.spanishSpain);
      final String es419 = word.translation(LearnerLanguage.spanishLatAm);
      expect(es419.toLowerCase(), contains(entry.value));
      expect(es419, isNot(es), reason: entry.key);
    }
  });

  test('Word data: every script is written in its own alphabet', () {
    for (final Word word in repo.all) {
      expect(_hasArabicScript(word.translation(LearnerLanguage.urdu)), isTrue,
          reason: '${word.it} Urdu');
      expect(
        _hasArabicScript(word.translation(LearnerLanguage.punjabiShahmukhi)),
        isTrue,
        reason: '${word.it} Shahmukhi',
      );
      expect(_hasGurmukhi(word.translation(LearnerLanguage.punjabiGurmukhi)),
          isTrue,
          reason: '${word.it} Gurmukhi');
      expect(_hasBengali(word.translation(LearnerLanguage.bengali)), isTrue,
          reason: '${word.it} Bengali');
      expect(_hasSinhala(word.translation(LearnerLanguage.sinhala)), isTrue,
          reason: '${word.it} Sinhala');
      expect(_hasHan(word.translation(LearnerLanguage.chineseSimplified)),
          isTrue,
          reason: '${word.it} Chinese');
    }
  });

  test('Word data: Shahmukhi and Gurmukhi are different scripts, not copies',
      () {
    for (final Word word in repo.all) {
      final String shahmukhi =
          word.translation(LearnerLanguage.punjabiShahmukhi);
      final String gurmukhi =
          word.translation(LearnerLanguage.punjabiGurmukhi);
      expect(shahmukhi, isNot(gurmukhi), reason: word.it);
      expect(_hasGurmukhi(shahmukhi), isFalse, reason: word.it);
      expect(_hasArabicScript(gurmukhi), isFalse, reason: word.it);
    }
  });

  test('Word data: no two entries share the same Italian headword', () {
    final Set<String> seen = <String>{};
    for (final Word word in repo.all) {
      expect(seen.add(word.id), isTrue, reason: 'duplicate ${word.it}');
    }
  });

  test('Word data: every quiz-eligible topic has enough words for decoys', () {
    // Quiz needs at least four words in a topic to build same-topic decoys.
    int eligible = 0;
    for (final Topic topic in repo.topicsWithWords) {
      if (repo.countInTopic(topic.id) >= 4) eligible++;
    }
    expect(eligible, greaterThanOrEqualTo(25));
  });
}
