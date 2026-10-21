import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/topic.dart';
import 'package:simple_flutter_app_651/models/word.dart';

import '../support/pump_app.dart';

void main() {
  final WordRepository repo = WordRepository.instance;

  test('Topics: about thirty categories are offered, all with real words', () {
    final List<Topic> topics = repo.topicsWithWords;
    expect(topics.length, greaterThanOrEqualTo(30));
    for (final Topic topic in topics) {
      expect(repo.byTopic(topic.id), isNotEmpty);
    }
  });

  test('Topics: the categories do not collapse into one or two colours', () {
    final Set<int> colours =
        kTopics.map((Topic t) => t.accent.toARGB32()).toSet();
    expect(colours.length, greaterThanOrEqualTo(25));
  });

  test('Topics: the counter shown is the real number of words', () {
    for (final Topic topic in repo.topicsWithWords) {
      expect(repo.countInTopic(topic.id), repo.byTopic(topic.id).length);
    }
  });

  testWidgets('Topics: the grid lists the categories', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-topics')));
    await tester.pumpAndSettle();

    expect(find.text('Impara per categoria'), findsOneWidget);
    expect(find.text('Saluti e basi'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('topic:greetings')),
        findsOneWidget);
  });

  testWidgets('Topics: a category screen lists its words and opens a card', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-topics')));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('topic:fruit')),
      200,
    );
    await tester.ensureVisible(find.byKey(const ValueKey<String>('topic:fruit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('topic:fruit')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('topic-flashcards')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('topic-quiz')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('row:la mela')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('row:la mela')));
    await tester.pumpAndSettle();

    expect(find.text('la mela'), findsOneWidget);
    expect(find.textContaining('Plural: "le mele"'), findsOneWidget);
    expect(find.text('Una mela al giorno fa bene.'), findsOneWidget);
  });

  testWidgets('Topics: the flashcards button opens the flashcards', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-topics')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('topic:fruit')),
      200,
    );
    await tester.ensureVisible(find.byKey(const ValueKey<String>('topic:fruit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('topic:fruit')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('topic-flashcards')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('flashcards-pager')),
      findsOneWidget,
    );

    // Hidden before the flip, shown after it.
    expect(find.text('the apple'), findsNothing);
    await tester.tap(find.byKey(const ValueKey<String>('flashcard:0')));
    await tester.pumpAndSettle();
    expect(find.text('the apple'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('flashcards-next')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Topics: the quiz button opens a twenty-question quiz', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-topics')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('topic:fruit')),
      200,
    );
    await tester.ensureVisible(find.byKey(const ValueKey<String>('topic:fruit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('topic:fruit')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('topic-quiz')));
    await tester.pumpAndSettle();
    expect(find.text('Domanda 1 di 20'), findsOneWidget);
  });

  testWidgets('Topics: the learned counter follows two correct answers', (
    WidgetTester tester,
  ) async {
    final List<Word> fruit = repo.byTopic('fruit');
    final TestHarness harness = await pumpApp(tester);

    expect(harness.progress.learnedInTopic(fruit.map((Word w) => w.id)), 0);
    await harness.progress.recordAnswer('la banana', correct: true);
    await harness.progress.recordAnswer('la banana', correct: true);
    expect(harness.progress.learnedInTopic(fruit.map((Word w) => w.id)), 1);
  });

  testWidgets('My words: a saved word appears in My Words with its quiz', (
    WidgetTester tester,
  ) async {
    await pumpApp(
      tester,
      initialPrefs: <String, Object>{
        'my_words': <String>[
          'il pomodoro',
          'la banana',
          'la mela',
          "l'arancia",
        ],
      },
    );

    await tester.tap(find.byKey(const ValueKey<String>('open-my-words')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('row:il pomodoro')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('my-words-quiz')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('my-words-quiz')));
    await tester.pumpAndSettle();
    expect(find.text('Domanda 1 di 4'), findsOneWidget);
  });

  testWidgets('My words: the quiz is unavailable with fewer than four words', (
    WidgetTester tester,
  ) async {
    await pumpApp(
      tester,
      initialPrefs: <String, Object>{
        'my_words': <String>['il pomodoro'],
      },
    );
    await tester.tap(find.byKey(const ValueKey<String>('open-my-words')));
    await tester.pumpAndSettle();

    final Finder button = find.byKey(const ValueKey<String>('my-words-quiz'));
    expect(button, findsOneWidget);
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
  });
}
