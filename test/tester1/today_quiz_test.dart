import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/models/topic.dart';
import 'package:simple_flutter_app_651/screens/quiz_category_screen.dart';
import 'package:simple_flutter_app_651/screens/quiz_play_screen.dart';
import 'package:simple_flutter_app_651/screens/quiz_result_screen.dart';
import 'package:simple_flutter_app_651/screens/settings_screen.dart';
import 'package:simple_flutter_app_651/screens/today_screen.dart';
import 'package:simple_flutter_app_651/services/quiz_service.dart';
import 'package:simple_flutter_app_651/ui/widgets/word_card.dart';

import 't1_support.dart';

Future<void> _openQuizTab(WidgetTester tester) => tapKey(tester, 'tab-quiz');

Future<void> _openCategory(WidgetTester tester, String id) async {
  await scrollTo(tester, QuizCategoryScreen, byKey('quiz-category:$id'));
  await tapKey(tester, 'quiz-category:$id');
}

void main() {
  setUpAll(loadDictionary);
  setUp(installTtsMock);

  for (final T1Config config in kConfigs) {
    testWidgets('T1 today: ten cards, speakers, card tap, swipe, next, '
        'mini-quiz, streak pill ($config)', (WidgetTester tester) async {
      await startApp(tester, config, lang: LearnerLanguage.sinhala);
      await tapKey(tester, 'tab-today');
      expectScreen(TodayScreen);
      expectClean(tester, 'today');
      expect(byKey('today-pager'), findsOneWidget,
          reason: 'Today shows no cards');
      expect(find.text(it.todayProgress(1, 10)), findsOneWidget,
          reason: 'Today does not have exactly ten words');
      expect(find.byType(WordCard), findsWidgets);

      // The speaker on the visible card.
      final WordCard card = tester.widget<WordCard>(find.byType(WordCard).first);
      await tapSpeaker(tester, byKey('audio:${card.word.it}'));
      await tapSpeaker(tester, byKey('audio-slow:${card.word.it}'));
      // Tapping the card body also reads the word.
      final Finder cardText =
          find.text(card.word.translation(LearnerLanguage.sinhala)).first;
      await tester.ensureVisible(cardText);
      await tester.pumpAndSettle();
      ttsCalls.clear();
      await tester.tap(cardText);
      await tester.pumpAndSettle();
      expect(spokenTexts, contains(card.word.it),
          reason: 'tapping the Today card did nothing');
      // Add to my words on the card.
      await scrollTo(tester, TodayScreen, byKey('save:${card.word.id}'));
      await tapKey(tester, 'save:${card.word.id}');
      expect(
        find.descendant(
            of: byKey('save:${card.word.id}'),
            matching: find.text(it.removeFromMyWords)),
        findsOneWidget,
        reason: 'Today "add to my words" did nothing',
      );

      // Swipe to card 2.
      await tester.drag(byKey('today-pager'), Offset(-config.size.width * 0.8, 0));
      await tester.pumpAndSettle();
      expect(find.text(it.todayProgress(2, 10)), findsOneWidget,
          reason: 'swiping the Today card did nothing');
      // Next through to card 10.
      for (int i = 3; i <= 10; i++) {
        await tapKey(tester, 'today-next');
        expect(find.text(it.todayProgress(i, 10)), findsOneWidget,
            reason: 'Today Next did nothing at card ${i - 1}');
        expectClean(tester, 'today card $i');
      }
      expect(byKey('today-next'), findsNothing);
      await tapKey(tester, 'today-mini-quiz');
      expectScreen(QuizPlayScreen, why: 'mini-quiz button did nothing');
      await playQuiz(tester, count: 10, wrong: 1, lang: LearnerLanguage.sinhala);
      expectScreen(QuizResultScreen);
      expect(find.text(it.scoreOutOf(9, 10)), findsOneWidget);
      expect(find.text(it.passed), findsOneWidget);
      await backArrow(tester);
      expectScreen(TodayScreen);

      // Streak pill.
      await tester.tap(byKey('streak-pill'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget,
          reason: 'streak pill did nothing');
      await backArrow(tester);
      expectClean(tester, 'today end');
    });

    testWidgets('T1 quiz: category list, mix of all, 20 right answers, '
        'PROMOSSO, new quiz, back ($config)', (WidgetTester tester) async {
      final TestHarness h = await startApp(tester, config);
      await _openQuizTab(tester);
      expectScreen(QuizCategoryScreen);
      expect(byKey('quiz-category:mix'), findsOneWidget);
      await tapKey(tester, 'quiz-category:mix');
      expectScreen(QuizPlayScreen, why: 'mix category did nothing');
      await tapSpeaker(tester, keyPrefix('audio:'));
      await tapSpeaker(tester, keyPrefix('audio-slow:'));
      await playQuiz(tester, count: 20);
      expectScreen(QuizResultScreen);
      expectClean(tester, 'result');
      expect(find.text(it.scoreOutOf(20, 20)), findsOneWidget);
      expect(find.text(it.passed), findsOneWidget);
      expect(find.text(it.noMistakes), findsOneWidget);
      expect(byKey('repeat-mistakes'), findsNothing);
      expect(h.progress.bestScore('mix'), 20);
      await scrollTo(tester, QuizResultScreen, byKey('new-quiz'));
      await tapKey(tester, 'new-quiz');
      expectScreen(QuizPlayScreen, why: 'new quiz button did nothing');
      expect(find.text(it.quizProgress(1, 20)), findsOneWidget);
      // Leave mid-quiz with the back arrow.
      await answerQuestion(tester, correctly: true);
      await backArrow(tester);
      expectScreen(QuizCategoryScreen);
      expect(find.textContaining(it.bestScoreValue(20, 20)), findsOneWidget,
          reason: 'best score not shown on the category');
    });

    testWidgets('T1 quiz: a category with 3 mistakes is NON PROMOSSO, '
        'mistakes listed, repeat mistakes, new quiz ($config)',
        (WidgetTester tester) async {
      await startApp(tester, config, lang: LearnerLanguage.urdu);
      await _openQuizTab(tester);
      await _openCategory(tester, 'fruit');
      expectScreen(QuizPlayScreen);
      expect(find.text(it.topicFruit), findsWidgets);
      await playQuiz(tester, count: 20, wrong: 3, lang: LearnerLanguage.urdu);
      expectScreen(QuizResultScreen);
      expectClean(tester, 'result fail');
      expect(find.text(it.scoreOutOf(17, 20)), findsOneWidget);
      expect(find.text(it.notPassed), findsOneWidget);
      expect(find.text(it.mistakesCount(3)), findsOneWidget);
      expect(keyPrefix('mistake:'), findsNWidgets(3));
      await tapSpeaker(tester,
          find.descendant(of: keyPrefix('mistake:').first, matching: keyPrefix('audio:')));
      await scrollTo(tester, QuizResultScreen, byKey('repeat-mistakes'));
      await tapKey(tester, 'repeat-mistakes');
      expectScreen(QuizPlayScreen, why: 'repeat mistakes did nothing');
      await playQuiz(tester, count: 3, lang: LearnerLanguage.urdu);
      expect(find.text(it.scoreOutOf(3, 3)), findsOneWidget);
      await scrollTo(tester, QuizResultScreen, byKey('new-quiz'));
      await tapKey(tester, 'new-quiz');
      expect(find.text(it.quizProgress(1, 3)), findsOneWidget,
          reason: 'new quiz after repeat-mistakes');
      await backArrow(tester);
      expectScreen(QuizCategoryScreen);
    });
  }

  testWidgets('T1 quiz: exactly two mistakes still PASSES', (
    WidgetTester tester,
  ) async {
    await startApp(tester, kConfigs[0]);
    await _openQuizTab(tester);
    await _openCategory(tester, 'animals');
    await playQuiz(tester, count: 20, wrong: 2);
    expect(find.text(it.scoreOutOf(18, 20)), findsOneWidget);
    expect(find.text(it.passed), findsOneWidget);
    expect(byKey('repeat-mistakes'), findsOneWidget);
  });

  for (final T1Config config in <T1Config>[kConfigs[0], kConfigs[3]]) {
    testWidgets('T1 quiz: EVERY category tile opens its 20-question quiz '
        '($config)', (WidgetTester tester) async {
      await startApp(tester, config);
      await _openQuizTab(tester);
      final List<Topic> topics = WordRepository.instance.topicsWithWords;
      expect(topics, isNotEmpty);
      final List<String> problems = <String>[];
      for (final Topic topic in topics) {
        final int count = WordRepository.instance.countInTopic(topic.id);
        await _openCategory(tester, topic.id);
        expectClean(tester, 'quiz category ${topic.id}');
        if (count >= QuizService.minWordsForQuiz) {
          if (find.byType(QuizPlayScreen).evaluate().isEmpty) {
            problems.add('${topic.id}: tap did nothing');
            continue;
          }
          if (find.text(it.quizProgress(1, 20)).evaluate().isEmpty) {
            problems.add('${topic.id}: not 20 questions');
          }
          await backArrow(tester);
        } else {
          if (find.byType(QuizPlayScreen).evaluate().isNotEmpty) {
            problems.add('${topic.id}: <4 words but quiz opened');
            await backArrow(tester);
          }
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n'));
    });
  }
}
