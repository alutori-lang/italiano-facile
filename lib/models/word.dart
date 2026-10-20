import 'learner_language.dart';

enum WordType { noun, verb, adjective, phrase }

/// One dictionary entry.
///
/// [tr], [expl] and [exTr] always hold exactly ten strings, in the order of
/// [LearnerLanguage]. The data files are positional for compactness, so the
/// constructor asserts the length instead of trusting it.
class Word {
  const Word({
    required this.it,
    required this.type,
    required this.topicId,
    required this.emoji,
    required this.tr,
    required this.expl,
    required this.example,
    required this.exampleTr,
  })  : assert(tr.length == LearnerLanguage.count),
        assert(expl.length == LearnerLanguage.count),
        assert(exampleTr.length == LearnerLanguage.count);

  /// Italian headword. Nouns always carry their article ("il pomodoro").
  final String it;
  final WordType type;
  final String topicId;

  /// A single emoji that really shows the thing, or null when no emoji fits.
  /// A wrong picture is worse than no picture, so null is a valid answer and
  /// the UI then draws the topic icon instead.
  final String? emoji;

  final List<String> tr;
  final List<String> expl;
  final String example;
  final List<String> exampleTr;

  /// Stable identity used for progress, saved words and the daily shuffle.
  String get id => it;

  bool get isPhrase => type == WordType.phrase;

  String translation(LearnerLanguage lang) => tr[lang.slot];
  String explanation(LearnerLanguage lang) => expl[lang.slot];
  String exampleTranslation(LearnerLanguage lang) => exampleTr[lang.slot];

  /// The headword without its article, used for search and for the quiz text.
  String get bare {
    const List<String> articles = <String>[
      'il ', 'lo ', 'la ', "l'", 'i ', 'gli ', 'le ', 'un ', 'uno ', "un'", 'una ',
    ];
    final String lower = it.toLowerCase();
    for (final String a in articles) {
      if (lower.startsWith(a)) return it.substring(a.length);
    }
    return it;
  }

  @override
  String toString() => 'Word($it)';
}

/// Shorthand used by the data files so each entry stays readable on screen.
Word w(
  String it,
  WordType type,
  String topicId,
  String? emoji,
  List<String> tr,
  List<String> expl,
  String example,
  List<String> exampleTr,
) =>
    Word(
      it: it,
      type: type,
      topicId: topicId,
      emoji: emoji,
      tr: tr,
      expl: expl,
      example: example,
      exampleTr: exampleTr,
    );

const WordType n = WordType.noun;
const WordType v = WordType.verb;
const WordType a = WordType.adjective;
const WordType p = WordType.phrase;
