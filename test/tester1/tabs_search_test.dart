import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/screens/my_words_screen.dart';
import 'package:simple_flutter_app_651/screens/quiz_category_screen.dart';
import 'package:simple_flutter_app_651/screens/quiz_play_screen.dart';
import 'package:simple_flutter_app_651/screens/search_screen.dart';
import 'package:simple_flutter_app_651/screens/settings_screen.dart';
import 'package:simple_flutter_app_651/screens/today_screen.dart';
import 'package:simple_flutter_app_651/screens/topics_screen.dart';
import 'package:simple_flutter_app_651/screens/word_detail_screen.dart';

import 't1_support.dart';

Future<void> _type(WidgetTester tester, String query) async {
  await tester.enterText(byKey('search-field'), query);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadDictionary);
  setUp(installTtsMock);

  for (final T1Config config in <T1Config>[kConfigs[0], kConfigs[3]]) {
    testWidgets('T1 speaker: with no Italian voice the install guide opens '
        'and its close button works ($config)', (WidgetTester tester) async {
      installTtsMock(hasItalian: false);
      await startApp(tester, config);
      await _type(tester, 'pomodoro');
      await tapSpeaker(tester, byKey('audio:il pomodoro'));
      expectClean(tester, 'voice help');
    });
  }

  for (final T1Config config in kConfigs) {
    testWidgets('T1 tabs: every tab opens, shows Italian content, no overflow '
        '($config)', (WidgetTester tester) async {
      await startApp(tester, config);
      expect(Theme.of(tester.element(byKey('bottom-nav'))).brightness,
          config.dark ? Brightness.dark : Brightness.light);
      final Map<String, Type> tabs = <String, Type>{
        'tab-today': TodayScreen,
        'tab-quiz': QuizCategoryScreen,
        'tab-topics': TopicsScreen,
        'tab-search': SearchScreen,
      };
      final Map<String, String> titles = <String, String>{
        'tab-today': it.todayTitle,
        'tab-quiz': it.tabQuiz,
        'tab-topics': it.tabTopics,
        'tab-search': it.tabSearch,
      };
      for (final MapEntry<String, Type> tab in tabs.entries) {
        await tapKey(tester, tab.key);
        expectClean(tester, tab.key);
        expectScreen(tab.value, why: '${tab.key} did not switch the tab');
        expect(
          find.descendant(
              of: find.byType(tab.value), matching: find.text(titles[tab.key]!)),
          findsWidgets,
          reason: '${tab.key} header not in Italian',
        );
      }
      // Tapping the active tab again is harmless.
      await tapKey(tester, 'tab-search');
      expectScreen(SearchScreen);
    });

    testWidgets('T1 header: settings icon opens Settings and its back arrow '
        'returns ($config)', (WidgetTester tester) async {
      await startApp(tester, config);
      await tapKey(tester, 'search-settings');
      expectScreen(SettingsScreen);
      expectClean(tester, 'settings from header');
      await backArrow(tester);
      expect(find.byType(SettingsScreen), findsNothing);
      expectScreen(SearchScreen);
    });

    testWidgets('T1 search: Italian query, card, detail, speakers ($config)',
        (WidgetTester tester) async {
      await startApp(tester, config, lang: LearnerLanguage.french);
      await _type(tester, 'pomodoro');
      expectClean(tester, 'search pomodoro');
      expect(find.text('il pomodoro'), findsWidgets);
      expect(find.text('la tomate'), findsWidgets);
      // Speakers on the card (normal + slow).
      await tapSpeaker(tester, byKey('audio:il pomodoro'));
      await tapSpeaker(tester, byKey('audio-slow:il pomodoro'));
      // Card -> detail.
      await tester.ensureVisible(find.text('il pomodoro').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('il pomodoro').first);
      await tester.pumpAndSettle();
      expectScreen(WordDetailScreen, why: 'tapping the result card did nothing');
      expectClean(tester, 'word detail');
      await tapSpeaker(
        tester,
        find.descendant(
            of: find.byType(WordDetailScreen),
            matching: byKey('audio:il pomodoro')),
      );
      await backArrow(tester);
      expectScreen(SearchScreen);
      // Clear button.
      await tapKey(tester, 'search-clear');
      expect(find.text(it.myWords.toUpperCase()), findsOneWidget,
          reason: 'clear button did not empty the search');
      expectClean(tester, 'clear');
    });

    testWidgets('T1 search: query in the chosen language and typo/accents '
        '($config)', (WidgetTester tester) async {
      await startApp(tester, config, lang: LearnerLanguage.bengali);
      await _type(tester, 'টমেটো');
      expect(find.text('il pomodoro'), findsWidgets,
          reason: 'Bengali query did not find il pomodoro');
      await _type(tester, 'citta');
      expect(find.text('la città'), findsWidgets);
      await _type(tester, 'pomodroo');
      expect(find.text('il pomodoro'), findsWidgets);
      expectClean(tester, 'search variants');
    });

    testWidgets('T1 search: no result shows suggestions that open ($config)',
        (WidgetTester tester) async {
      await startApp(tester, config);
      await _type(tester, 'pomodorzz');
      expect(find.text(it.noResults), findsOneWidget);
      expect(find.text(it.didYouMean), findsOneWidget,
          reason: 'no "did you mean" suggestions');
      final Finder suggestion = keyPrefix('row:');
      expect(suggestion, findsWidgets);
      await tester.tap(suggestion.first);
      await tester.pumpAndSettle();
      expectScreen(WordDetailScreen, why: 'suggestion row did nothing');
      await backArrow(tester);
      // Speaker on a suggestion row.
      await tapSpeaker(
        tester,
        find.descendant(of: keyPrefix('row:').first, matching: keyPrefix('audio:')),
      );
      // Nonsense: still a clean empty state.
      await _type(tester, 'qqqqxxxxzzzzwwww');
      expect(find.text(it.noResults), findsOneWidget);
      expectClean(tester, 'no results');
    });

    testWidgets('T1 search: recent searches chip, clear recents ($config)',
        (WidgetTester tester) async {
      await startApp(tester, config);
      await _type(tester, 'banana');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await tapKey(tester, 'search-clear');
      expect(byKey('recent:banana'), findsOneWidget,
          reason: 'submitted search not remembered');
      await tapKey(tester, 'recent:banana');
      expect(find.text('la banana'), findsWidgets,
          reason: 'recent chip did nothing');
      await tapKey(tester, 'search-clear');
      await tapKey(tester, 'clear-recents');
      expect(byKey('recent:banana'), findsNothing,
          reason: 'clear recents did nothing');
      expectClean(tester, 'recents');
    });

    testWidgets('T1 search: add to my words, My words screen, its quiz '
        '($config)', (WidgetTester tester) async {
      final TestHarness h = await startApp(tester, config);
      // Empty My words first.
      await tapKey(tester, 'open-my-words');
      expectScreen(MyWordsScreen);
      expect(find.text(it.myWordsEmpty), findsOneWidget);
      await backArrow(tester);

      const List<String> queries = <String>['pomodoro', 'banana', 'mela', 'pane'];
      const List<String> ids = <String>['il pomodoro', 'la banana', 'la mela', 'il pane'];
      for (int i = 0; i < queries.length; i++) {
        await _type(tester, queries[i]);
        final Finder save = byKey('save:${ids[i]}');
        await scrollTo(tester, SearchScreen, save);
        await tester.tap(save);
        await tester.pumpAndSettle();
        expect(h.progress.isSaved(ids[i]), isTrue,
            reason: 'Add to my words did nothing for ${ids[i]}');
        expect(
          find.descendant(of: save, matching: find.text(it.removeFromMyWords)),
          findsOneWidget,
          reason: 'button label did not change after saving',
        );
        if (i == 0) {
          // My words with one word: quiz disabled.
          await tapKey(tester, 'search-clear');
          expect(byKey('row:il pomodoro'), findsOneWidget,
              reason: 'saved word not listed under Search');
          await tapKey(tester, 'open-my-words');
          expect(find.text(it.quizNotEnoughWords), findsOneWidget);
          final FilledButton quiz =
              tester.widget<FilledButton>(byKey('my-words-quiz'));
          expect(quiz.onPressed, isNull);
          await backArrow(tester);
        }
      }
      await tapKey(tester, 'search-clear');
      await tapKey(tester, 'open-my-words');
      expectScreen(MyWordsScreen);
      expectClean(tester, 'my words');
      for (final String id in ids) {
        expect(byKey('row:$id'), findsOneWidget, reason: '$id not in My words');
      }
      // Row -> detail -> remove -> back: the list updates.
      await tapKey(tester, 'row:la mela');
      expectScreen(WordDetailScreen);
      await tapKey(tester, 'save:la mela');
      expect(h.progress.isSaved('la mela'), isFalse);
      await backArrow(tester);
      expect(byKey('row:la mela'), findsNothing,
          reason: 'My words list did not update after removing');
      // Speaker in a My words row.
      await tapSpeaker(tester, byKey('audio:la banana'));
      // Re-add a 4th word through the list? Not possible: so add via search.
      await backArrow(tester);
      await _type(tester, 'mela');
      await tester.ensureVisible(byKey('save:la mela'));
      await tester.pumpAndSettle();
      await tapKey(tester, 'save:la mela');
      await tapKey(tester, 'search-clear');
      await tapKey(tester, 'open-my-words');
      await tapKey(tester, 'my-words-quiz');
      expectScreen(QuizPlayScreen, why: 'My words quiz did not open');
      await playQuiz(tester, count: 4);
      expect(find.text(it.scoreOutOf(4, 4)), findsOneWidget);
      expectClean(tester, 'my words quiz');
      await backArrow(tester);
      expectScreen(MyWordsScreen);
    });
  }
}
