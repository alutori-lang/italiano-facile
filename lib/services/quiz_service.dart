import 'dart:math';

import '../models/word.dart';

/// One true/false question: a picture belonging to [pictureWord] shown next to
/// [shownWord]. When the two are the same the right answer is VERO.
class QuizQuestion {
  const QuizQuestion({
    required this.pictureWord,
    required this.shownWord,
  });

  /// The entry the picture and the correct answer come from.
  final Word pictureWord;

  /// The Italian word printed under the picture — the same entry on a true
  /// question, a same-category decoy on a false one.
  final Word shownWord;

  bool get isTrue => pictureWord.id == shownWord.id;

  /// The word the user should have seen when the answer was FALSO.
  Word get correction => pictureWord;
}

/// The result of one finished quiz.
class QuizResult {
  const QuizResult({
    required this.total,
    required this.correct,
    required this.mistakes,
  });

  final int total;
  final int correct;

  /// Questions the user got wrong, in the order they were asked.
  final List<QuizQuestion> mistakes;

  int get wrong => total - correct;

  /// Like the Italian driving-licence test: at most two mistakes.
  bool get passed => wrong <= QuizService.maxMistakesToPass;
}

class QuizService {
  const QuizService();

  static const int questionsPerQuiz = 20;
  static const int maxMistakesToPass = 2;

  /// Fewer than this many words in a category and tricky same-category decoys
  /// are impossible, so the category offers no quiz.
  static const int minWordsForQuiz = 4;

  /// Builds a quiz. About half the questions are true; the false ones always
  /// take their decoy from the same topic as the picture, so they are tricky
  /// rather than obvious.
  ///
  /// [pool] is the set of words to ask about (one category, "mix of all", the
  /// words of the day, or My Words). [random] is injectable so tests can pin
  /// the sequence.
  List<QuizQuestion> build(
    List<Word> pool, {
    int count = questionsPerQuiz,
    Random? random,
  }) {
    if (pool.length < 2) return const <QuizQuestion>[];
    final Random rng = random ?? Random();

    // Decoys come from the same topic; fall back to the whole pool for a
    // topic that has only one entry in this quiz.
    final Map<String, List<Word>> byTopic = <String, List<Word>>{};
    for (final Word word in pool) {
      byTopic.putIfAbsent(word.topicId, () => <Word>[]).add(word);
    }

    final List<Word> subjects = <Word>[];
    final List<Word> shuffled = pool.toList()..shuffle(rng);
    while (subjects.length < count) {
      if (shuffled.isEmpty) shuffled.addAll(pool.toList()..shuffle(rng));
      subjects.add(shuffled.removeAt(0));
      if (subjects.length >= count) break;
    }

    final int trueCount = count ~/ 2;
    final List<bool> truth = <bool>[
      ...List<bool>.filled(trueCount, true),
      ...List<bool>.filled(count - trueCount, false),
    ]..shuffle(rng);

    final List<QuizQuestion> questions = <QuizQuestion>[];
    for (int i = 0; i < count; i++) {
      final Word subject = subjects[i];
      if (truth[i]) {
        questions.add(QuizQuestion(pictureWord: subject, shownWord: subject));
        continue;
      }
      final Word? decoy = _pickDecoy(subject, byTopic, pool, rng);
      questions.add(
        QuizQuestion(
          pictureWord: subject,
          shownWord: decoy ?? subject,
        ),
      );
    }
    return questions;
  }

  Word? _pickDecoy(
    Word subject,
    Map<String, List<Word>> byTopic,
    List<Word> pool,
    Random rng,
  ) {
    final List<Word> sameTopic = (byTopic[subject.topicId] ?? const <Word>[])
        .where((Word w) => w.id != subject.id)
        .toList();
    if (sameTopic.isNotEmpty) {
      return sameTopic[rng.nextInt(sameTopic.length)];
    }
    final List<Word> others =
        pool.where((Word w) => w.id != subject.id).toList();
    if (others.isEmpty) return null;
    return others[rng.nextInt(others.length)];
  }

  /// Did the user answer this question correctly?
  bool isAnswerCorrect(QuizQuestion question, bool answeredTrue) =>
      question.isTrue == answeredTrue;

  QuizResult score(List<QuizQuestion> questions, List<bool> answers) {
    final List<QuizQuestion> mistakes = <QuizQuestion>[];
    int correct = 0;
    for (int i = 0; i < questions.length && i < answers.length; i++) {
      if (isAnswerCorrect(questions[i], answers[i])) {
        correct++;
      } else {
        mistakes.add(questions[i]);
      }
    }
    return QuizResult(
      total: questions.length,
      correct: correct,
      mistakes: mistakes,
    );
  }
}
