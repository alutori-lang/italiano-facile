import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/screens/search_screen.dart';
import 'package:simple_flutter_app_651/screens/settings_screen.dart';

import 't1_support.dart';

Finder get _sheet => find.byType(BottomSheet);

Future<void> _chooseInSheet(WidgetTester tester, LearnerLanguage lang) async {
  final Finder option = byKey('lang:${tagFor(lang)}');
  await tester.scrollUntilVisible(
    option,
    80,
    scrollable: find.descendant(of: _sheet, matching: find.byType(Scrollable)),
  );
  await tester.ensureVisible(option);
  await tester.pumpAndSettle();
  await tester.tap(option);
  await tester.pumpAndSettle();
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(byKey('search-field'), query);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadDictionary);
  setUp(installTtsMock);

  test('T1 dictionary: the JSON dictionary loads in tests', () {
    expect(jsonDictionaryLoaded, isTrue,
        reason: 'assets/dict/words.json did not load '
            '(built-in only: $builtInWordCount words)');
  });

  for (final T1Config config in <T1Config>[kConfigs[0], kConfigs[3]]) {
    testWidgets('T1 first launch: the language sheet shows, lists the ten '
        'languages and cannot be dismissed by tapping outside ($config)',
        (WidgetTester tester) async {
      final TestHarness h = await startApp(tester, config, lang: null);
      expectClean(tester, 'first launch');
      expect(_sheet, findsOneWidget, reason: 'no first-launch language sheet');
      expect(find.descendant(of: _sheet, matching: find.text(it.interfaceLanguage)),
          findsOneWidget,
          reason: 'sheet title must be "Lingua di traduzione"');
      for (final LearnerLanguage lang in LearnerLanguage.values) {
        await tester.scrollUntilVisible(
          byKey('lang:${tagFor(lang)}'),
          80,
          scrollable:
              find.descendant(of: _sheet, matching: find.byType(Scrollable)),
        );
        expect(byKey('lang:${tagFor(lang)}'), findsOneWidget);
      }
      // No interface-language menu: only the ten translation languages.
      expect(keyPrefix('lang:'), findsNWidgets(10));
      // Tap outside, on the barrier.
      await tester.tapAt(Offset(config.size.width / 2, 8));
      await tester.pumpAndSettle();
      expect(_sheet, findsOneWidget, reason: 'first-launch sheet was dismissed');
      expect(h.settings.hasChosenLanguage, isFalse);
      expectClean(tester, 'first launch sheet');
    });
  }

  testWidgets('T1 first launch: the Android back button does not skip the '
      'language choice', (WidgetTester tester) async {
    final TestHarness h = await startApp(tester, kConfigs[0], lang: null);
    expect(_sheet, findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(_sheet, findsOneWidget,
        reason: 'system back closed the non-dismissible first-launch sheet '
            'without a language being chosen');
    expect(h.settings.hasChosenLanguage, isFalse);
  });

  // Every language, chosen from the first-launch sheet, on the small phone
  // (light) and on the big phone (dark).
  for (final T1Config config in <T1Config>[kConfigs[0], kConfigs[3]]) {
    for (final LearnerLanguage lang in LearnerLanguage.values) {
      testWidgets('T1 language ${lang.name}: chosen at first launch, '
          'translations show only in it, interface stays Italian ($config)',
          (WidgetTester tester) async {
        final TestHarness h = await startApp(tester, config, lang: null);
        await _chooseInSheet(tester, lang);
        expect(_sheet, findsNothing, reason: 'sheet did not close on choice');
        expect(h.settings.hasChosenLanguage, isTrue);
        expect(h.settings.translationLanguage, lang);
        expect(h.prefs.getString('ui_locale'), tagFor(lang));

        // Interface is Italian.
        expect(find.text(it.tabSearch), findsWidgets);
        expect(find.text(it.tabToday), findsOneWidget);
        expect(find.text(it.tabTopics), findsOneWidget);
        expect(
          Directionality.of(tester.element(byKey('bottom-nav'))),
          TextDirection.ltr,
          reason: 'interface must stay Italian / left to right',
        );
        // The pill shows the chosen language.
        final String label = languageLabel(it, localeFor(lang));
        expect(
          find.descendant(of: byKey('search-language'), matching: find.text(label)),
          findsOneWidget,
          reason: 'language pill does not show $label',
        );

        // Italian query -> translation in the chosen language/script.
        final Word tomato = WordRepository.instance.byId('il pomodoro')!;
        await _search(tester, 'pomodoro');
        expectClean(tester, 'search pomodoro in ${lang.name}');
        expect(find.text('il pomodoro'), findsWidgets);
        final Finder tr = find.text(tomato.translation(lang));
        expect(tr, findsWidgets,
            reason: 'translation "${tomato.translation(lang)}" missing');
        expect(find.text(tomato.explanation(lang)), findsWidgets,
            reason: 'explanation not in ${lang.name}');
        expect(find.text(tomato.exampleTranslation(lang)), findsWidgets,
            reason: 'example translation not in ${lang.name}');
        if (lang != LearnerLanguage.english) {
          expect(find.text(tomato.translation(LearnerLanguage.english)),
              findsNothing,
              reason: 'English shown although ${lang.name} was chosen');
        }
        expect(tester.widget<Text>(tr.first).textDirection,
            lang.isRtl ? TextDirection.rtl : TextDirection.ltr,
            reason: 'wrong text direction for ${lang.name}');
        if (lang == LearnerLanguage.spanishLatAm) {
          await _search(tester, 'macchina');
          expect(find.text('el carro'), findsWidgets);
        }
        if (lang == LearnerLanguage.spanishSpain) {
          await _search(tester, 'macchina');
          expect(find.text('el coche'), findsWidgets);
        }

        // Query typed in the chosen language finds the Italian word.
        await _search(tester,
            lang == LearnerLanguage.english ? 'tomato' : tomato.translation(lang));
        expect(find.text('il pomodoro'), findsWidgets,
            reason: 'query "${tomato.translation(lang)}" did not find il pomodoro');
        expectClean(tester, 'search in ${lang.name}');
      });
    }
  }

  for (final T1Config config in kConfigs) {
    testWidgets('T1 language pill: the Search header pill changes the '
        'translation language ($config)', (WidgetTester tester) async {
      final TestHarness h = await startApp(tester, config);
      await tapKey(tester, 'search-language');
      expect(_sheet, findsOneWidget, reason: 'language pill did nothing');
      await _chooseInSheet(tester, LearnerLanguage.urdu);
      expect(h.settings.translationLanguage, LearnerLanguage.urdu);
      expect(
        find.descendant(
          of: byKey('search-language'),
          matching: find.text(languageLabel(it, localeFor(LearnerLanguage.urdu))),
        ),
        findsOneWidget,
      );
      await _search(tester, 'pomodoro');
      expect(find.text('ٹماٹر'), findsWidgets);
      // Pill again: the sheet is dismissible now (system back; on the small
      // phone the sheet is full height, so there is no barrier to tap).
      await tapKey(tester, 'search-language');
      expect(_sheet, findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(_sheet, findsNothing, reason: 'sheet cannot be closed later');
      expect(find.byType(SearchScreen), findsOneWidget);
      expectClean(tester, 'language pill');
    });
  }
}
