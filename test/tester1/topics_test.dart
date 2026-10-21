import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/models/topic.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/screens/flashcards_screen.dart';
import 'package:simple_flutter_app_651/screens/quiz_play_screen.dart';
import 'package:simple_flutter_app_651/screens/quiz_result_screen.dart';
import 'package:simple_flutter_app_651/screens/topic_detail_screen.dart';
import 'package:simple_flutter_app_651/screens/topics_screen.dart';
import 'package:simple_flutter_app_651/screens/word_detail_screen.dart';
import 'package:simple_flutter_app_651/services/quiz_service.dart';

import 't1_support.dart';

Future<void> _openTopic(WidgetTester tester, Topic topic) async {
  await scrollTo(tester, TopicsScreen, byKey('topic:${topic.id}'), delta: 150);
  await tapKey(tester, 'topic:${topic.id}');
}

/// A few topics to go deep into: first, middle, last and the smallest one
/// that still has flashcards.
List<Topic> _sample() {
  final WordRepository repo = WordRepository.instance;
  final List<Topic> all = repo.topicsWithWords;
  final List<Topic> withQuiz = all
      .where((Topic t) => repo.countInTopic(t.id) >= QuizService.minWordsForQuiz)
      .toList()
    ..sort((Topic a, Topic b) =>
        repo.countInTopic(a.id).compareTo(repo.countInTopic(b.id)));
  return <Topic>{
    all.first,
    all[all.length ~/ 2],
    all.last,
    withQuiz.first,
  }.toList();
}

void main() {
  setUpAll(loadDictionary);
  setUp(installTtsMock);

  test('T1 topics: every topic has real words once the JSON is loaded', () {
    final WordRepository repo = WordRepository.instance;
    final List<String> empty = kTopics
        .where((Topic t) => repo.countInTopic(t.id) == 0)
        .map((Topic t) => t.id)
        .toList();
    final List<String> tooSmall = repo.topicsWithWords
        .where((Topic t) => repo.countInTopic(t.id) < QuizService.minWordsForQuiz)
        .map((Topic t) => '${t.id}(${repo.countInTopic(t.id)})')
        .toList();
    // Reported, not fatal for empty topics (they are hidden from the grid).
    // ignore: avoid_print
    print('T1 topics: ${repo.topicsWithWords.length}/${kTopics.length} topics '
        'have words; empty: $empty; without quiz: $tooSmall; '
        'total entries ${repo.all.length}');
    expect(tooSmall, isEmpty,
        reason: 'topics shown with too few words for a quiz: $tooSmall');
  });

  for (final T1Config config in kConfigs) {
    testWidgets('T1 topics: EVERY topic opens with its words, word count and '
        'buttons, and its back arrow returns ($config)',
        (WidgetTester tester) async {
      await startApp(tester, config);
      await tapKey(tester, 'tab-topics');
      expectScreen(TopicsScreen);
      final WordRepository repo = WordRepository.instance;
      final List<String> problems = <String>[];
      for (final Topic topic in repo.topicsWithWords) {
        await _openTopic(tester, topic);
        final Object? error = tester.takeException();
        if (error != null) problems.add('${topic.id}: $error');
        if (find.byType(TopicDetailScreen).evaluate().isEmpty) {
          problems.add('${topic.id}: tile tap did nothing');
          continue;
        }
        final List<Word> words = repo.byTopic(topic.id);
        if (find.text(topic.label(it)).evaluate().isEmpty) {
          problems.add('${topic.id}: no Italian title');
        }
        if (find
            .textContaining(it.nWords(words.length))
            .evaluate()
            .isEmpty) {
          problems.add('${topic.id}: word count missing');
        }
        if (keyPrefix('row:').evaluate().isEmpty) {
          problems.add('${topic.id}: empty word list');
        }
        final bool quizOn = tester
                .widget<FilledButton>(byKey('topic-quiz'))
                .onPressed !=
            null;
        if (quizOn != (words.length >= QuizService.minWordsForQuiz)) {
          problems.add('${topic.id}: quiz button state wrong');
        }
        if (tester.widget<OutlinedButton>(byKey('topic-flashcards')).onPressed ==
            null) {
          problems.add('${topic.id}: flashcards disabled');
        }
        await backArrow(tester);
        if (find.byType(TopicDetailScreen).evaluate().isNotEmpty) {
          problems.add('${topic.id}: back arrow did nothing');
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n'));
      expectClean(tester, 'topics sweep');
    });

    testWidgets('T1 topics: word row, its speaker and the word card from '
        'several topics ($config)', (WidgetTester tester) async {
      await startApp(tester, config, lang: LearnerLanguage.punjabiGurmukhi);
      await tapKey(tester, 'tab-topics');
      for (final Topic topic in _sample()) {
        await _openTopic(tester, topic);
        final Word first = WordRepository.instance.byTopic(topic.id).first;
        expect(find.text(first.translation(LearnerLanguage.punjabiGurmukhi)),
            findsWidgets,
            reason: '${topic.id}: row translation not in Gurmukhi');
        await tapSpeaker(tester,
            find.descendant(of: byKey('row:${first.id}'), matching: byKey('audio:${first.it}')));
        await tapKey(tester, 'row:${first.id}');
        expectScreen(WordDetailScreen, why: '${topic.id}: row tap did nothing');
        expectClean(tester, '${topic.id} word card');
        await backArrow(tester);
        await backArrow(tester);
      }
    });

    testWidgets('T1 topics: flashcards flip, speak, next and finish from '
        'several topics ($config)', (WidgetTester tester) async {
      await startApp(tester, config, lang: LearnerLanguage.chineseSimplified);
      await tapKey(tester, 'tab-topics');
      for (final Topic topic in _sample()) {
        final List<Word> words = WordRepository.instance.byTopic(topic.id);
        await _openTopic(tester, topic);
        await tapKey(tester, 'topic-flashcards');
        expectScreen(FlashcardsScreen, why: '${topic.id}: flashcards button');
        expectClean(tester, '${topic.id} flashcards');
        final Word w0 = words.first;
        final String tr = w0.translation(LearnerLanguage.chineseSimplified);
        expect(find.text(tr), findsNothing, reason: 'translation shown before flip');
        await tapKey(tester, 'flashcard:0');
        expect(find.text(tr), findsWidgets, reason: '${topic.id}: flip did nothing');
        await tapKey(tester, 'flashcard:0');
        expect(find.text(tr), findsNothing, reason: '${topic.id}: flip back did nothing');
        await tapSpeaker(tester,
            find.descendant(of: find.byType(FlashcardsScreen), matching: byKey('audio:${w0.it}')));
        if (words.length > 1) {
          await tapKey(tester, 'flashcards-next');
          expect(find.text(it.todayProgress(2, words.length)), findsOneWidget,
              reason: '${topic.id}: flashcards next did nothing');
        }
        expectClean(tester, '${topic.id} flashcards next');
        await backArrow(tester);
        expectScreen(TopicDetailScreen);
        await backArrow(tester);
      }
    });
  }

  testWidgets('T1 topics: flashcards of the smallest topic run to the end and '
      'Fatto closes them', (WidgetTester tester) async {
    await startApp(tester, kConfigs[0]);
    await tapKey(tester, 'tab-topics');
    final WordRepository repo = WordRepository.instance;
    final List<Topic> topics = repo.topicsWithWords.toList()
      ..sort((Topic a, Topic b) =>
          repo.countInTopic(a.id).compareTo(repo.countInTopic(b.id)));
    final Topic small = topics.first;
    final int n = repo.countInTopic(small.id);
    await _openTopic(tester, small);
    await tapKey(tester, 'topic-flashcards');
    for (int i = 1; i < n; i++) {
      await tapKey(tester, 'flashcards-next');
    }
    expect(find.text(it.todayProgress(n, n)), findsOneWidget);
    expect(find.text(it.done), findsOneWidget);
    await tapKey(tester, 'flashcards-next');
    expect(find.byType(FlashcardsScreen), findsNothing,
        reason: 'Fatto on the last flashcard did nothing');
    expectScreen(TopicDetailScreen);
  });

  for (final T1Config config in <T1Config>[kConfigs[1], kConfigs[2]]) {
    testWidgets('T1 topics: Quiz 20 from two topics, answered to the end '
        '($config)', (WidgetTester tester) async {
      await startApp(tester, config);
      await tapKey(tester, 'tab-topics');
      final List<Topic> sample = _sample();
      for (final Topic topic in <Topic>[sample.first, sample.last]) {
        await _openTopic(tester, topic);
        await tapKey(tester, 'topic-quiz');
        expectScreen(QuizPlayScreen, why: '${topic.id}: Quiz 20 did nothing');
        await playQuiz(tester, count: 20, wrong: 5);
        expectScreen(QuizResultScreen);
        expect(find.text(it.notPassed), findsOneWidget);
        expectClean(tester, '${topic.id} topic quiz');
        await backArrow(tester);
        expectScreen(TopicDetailScreen);
        await backArrow(tester);
      }
    });
  }
}
