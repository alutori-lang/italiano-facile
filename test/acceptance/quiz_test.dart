import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/screens/quiz_play_screen.dart';
import 'package:simple_flutter_app_651/services/quiz_service.dart';

import '../support/pump_app.dart';

const QuizService _quiz = QuizService();

void main() {
  final WordRepository repo = WordRepository.instance;

  // A wrong answer reads the right word aloud; fake the phone's TTS engine so
  // the call returns as it does on a device.
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized()
        .defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_tts'),
          (MethodCall call) async =>
              call.method == 'isLanguageAvailable' ? true : 1,
        );
  });

  test('Quiz: a quiz always has exactly twenty questions', () {
    for (int seed = 0; seed < 25; seed++) {
      final List<QuizQuestion> questions =
          _quiz.build(repo.all, random: Random(seed));
      expect(questions.length, QuizService.questionsPerQuiz);
    }
    // Also for a single small category.
    final List<QuizQuestion> fruit =
        _quiz.build(repo.byTopic('fruit'), random: Random(1));
    expect(fruit.length, 20);
  });

  test('Quiz: about half the answers are true and half false', () {
    for (int seed = 0; seed < 25; seed++) {
      final List<QuizQuestion> questions =
          _quiz.build(repo.all, random: Random(seed));
      final int trueCount =
          questions.where((QuizQuestion q) => q.isTrue).length;
      expect(trueCount, 10, reason: 'seed $seed');
    }
  });

  test('Quiz: a false question uses a decoy from the same topic', () {
    for (int seed = 0; seed < 25; seed++) {
      final List<QuizQuestion> questions =
          _quiz.build(repo.byTopic('fruit'), random: Random(seed));
      for (final QuizQuestion question in questions) {
        if (question.isTrue) continue;
        expect(
          question.shownWord.topicId,
          question.pictureWord.topicId,
          reason: 'seed $seed: decoy from another topic',
        );
        expect(question.shownWord.id, isNot(question.pictureWord.id));
      }
    }
  });

  test('Quiz: a false question in a mixed quiz still uses the same topic', () {
    final List<QuizQuestion> questions =
        _quiz.build(repo.all, random: Random(11));
    for (final QuizQuestion question in questions.where(
      (QuizQuestion q) => !q.isTrue,
    )) {
      expect(question.shownWord.topicId, question.pictureWord.topicId);
    }
  });

  test('Quiz: PASSED only with two mistakes or fewer', () {
    final List<QuizQuestion> questions =
        _quiz.build(repo.all, random: Random(5));

    List<bool> answersWith(int mistakes) => <bool>[
          for (int i = 0; i < questions.length; i++)
            i < mistakes ? !questions[i].isTrue : questions[i].isTrue,
        ];

    expect(_quiz.score(questions, answersWith(0)).passed, isTrue);
    expect(_quiz.score(questions, answersWith(2)).passed, isTrue);
    expect(_quiz.score(questions, answersWith(3)).passed, isFalse);
    expect(_quiz.score(questions, answersWith(3)).correct, 17);
    expect(_quiz.score(questions, answersWith(3)).mistakes.length, 3);
  });

  test('Quiz: a category with too few words offers no quiz', () {
    expect(_quiz.build(<Word>[]), isEmpty);
    expect(_quiz.build(<Word>[repo.all.first]), isEmpty);
  });

  test('Quiz: scoring reports the right answer for each mistake', () {
    final List<QuizQuestion> questions =
        _quiz.build(repo.byTopic('vegetables'), random: Random(9));
    final QuizResult result = _quiz.score(
      questions,
      <bool>[for (final QuizQuestion q in questions) !q.isTrue],
    );
    expect(result.correct, 0);
    expect(result.mistakes.length, 20);
    for (final QuizQuestion mistake in result.mistakes) {
      expect(mistake.correction.id, mistake.pictureWord.id);
      expect(mistake.correction.topicId, 'vegetables');
    }
  });

  testWidgets('Quiz: the category list opens a twenty-question quiz',
      (WidgetTester tester) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-quiz')));
    await tester.pumpAndSettle();

    expect(find.text('Mix di tutto'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('quiz-category:fruit')),
      200,
    );
    await tester.ensureVisible(find.byKey(const ValueKey<String>('quiz-category:fruit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('quiz-category:fruit')));
    await tester.pumpAndSettle();

    expect(find.text('Domanda 1 di 20'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('answer-vero')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('answer-falso')), findsOneWidget);
  });

  testWidgets('Quiz: answering shows feedback and then the next question',
      (WidgetTester tester) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-quiz')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('quiz-category:fruit')),
      200,
    );
    await tester.ensureVisible(find.byKey(const ValueKey<String>('quiz-category:fruit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('quiz-category:fruit')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('answer-vero')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('quiz-feedback')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('quiz-next')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('quiz-next')));
    await tester.pumpAndSettle();
    expect(find.text('Domanda 2 di 20'), findsOneWidget);
  });

  testWidgets('Quiz: the result screen shows score, mistakes and both buttons',
      (WidgetTester tester) async {
    final List<Word> fruit = repo.byTopic('fruit');
    final List<QuizQuestion> questions =
        _quiz.build(fruit, count: 20, random: Random(4));

    await pumpScreen(
      tester,
      (BuildContext context) => QuizPlayScreen(
        pool: fruit,
        categoryId: 'fruit',
        categoryLabel: 'Fruit',
        fixedQuestions: questions,
      ),
    );

    // Answer every question wrongly, so the mistake list is long and the
    // result must be NOT PASSED.
    for (int i = 0; i < questions.length; i++) {
      final String key = questions[i].isTrue ? 'answer-falso' : 'answer-vero';
      await tester.tap(find.byKey(ValueKey<String>(key)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey<String>('quiz-next')));
      await tester.pumpAndSettle();
    }

    expect(find.text('0 / 20'), findsOneWidget);
    expect(find.text('NON PROMOSSO'), findsOneWidget);
    expect(find.text('20 errori'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('repeat-mistakes')),
      300,
    );
    expect(
      find.byKey(const ValueKey<String>('repeat-mistakes')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('new-quiz')), findsOneWidget);
  });

  testWidgets('Quiz: a perfect run passes and the best score is saved',
      (WidgetTester tester) async {
    final List<Word> fruit = repo.byTopic('fruit');
    final List<QuizQuestion> questions =
        _quiz.build(fruit, count: 20, random: Random(6));

    final TestHarness harness = await pumpScreen(
      tester,
      (BuildContext context) => QuizPlayScreen(
        pool: fruit,
        categoryId: 'fruit',
        categoryLabel: 'Fruit',
        fixedQuestions: questions,
      ),
    );

    for (int i = 0; i < questions.length; i++) {
      final String key = questions[i].isTrue ? 'answer-vero' : 'answer-falso';
      await tester.tap(find.byKey(ValueKey<String>(key)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey<String>('quiz-next')));
      await tester.pumpAndSettle();
    }

    expect(find.text('20 / 20'), findsOneWidget);
    expect(find.text('PROMOSSO'), findsOneWidget);
    expect(find.text('Nessun errore. Perfetto!'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('new-quiz')),
      300,
    );
    expect(find.byKey(const ValueKey<String>('new-quiz')), findsOneWidget);
    expect(harness.progress.bestScore('fruit'), 20);
  });

  testWidgets('Quiz: a word is learned after two correct answers',
      (WidgetTester tester) async {
    final TestHarness harness = await pumpApp(tester);
    expect(harness.progress.isLearned('la mela'), isFalse);
    await harness.progress.recordAnswer('la mela', correct: true);
    expect(harness.progress.isLearned('la mela'), isFalse);
    await harness.progress.recordAnswer('la mela', correct: true);
    expect(harness.progress.isLearned('la mela'), isTrue);
    // A wrong answer never counts towards learning.
    await harness.progress.recordAnswer('la pera', correct: false);
    expect(harness.progress.correctCount('la pera'), 0);
  });
}
