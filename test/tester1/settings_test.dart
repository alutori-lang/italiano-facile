import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/screens/about_screen.dart';
import 'package:simple_flutter_app_651/screens/paywall_screen.dart';
import 'package:simple_flutter_app_651/screens/privacy_screen.dart';
import 'package:simple_flutter_app_651/screens/search_screen.dart';
import 'package:simple_flutter_app_651/screens/settings_screen.dart';

import 't1_support.dart';

Future<void> _open(WidgetTester tester) async {
  await tapKey(tester, 'search-settings');
  expectScreen(SettingsScreen);
}

Future<void> _row(WidgetTester tester, String key) async {
  await scrollTo(tester, SettingsScreen, byKey(key));
  await tapKey(tester, key);
}

void main() {
  setUpAll(loadDictionary);
  setUp(installTtsMock);

  for (final T1Config config in kConfigs) {
    testWidgets('T1 settings: every row is there, in Italian ($config)',
        (WidgetTester tester) async {
      await startApp(tester, config);
      await _open(tester);
      expectClean(tester, 'settings');
      expect(find.text(it.interfaceLanguage), findsOneWidget,
          reason: 'row must read "Lingua di traduzione"');
      for (final String key in <String>[
        'settings-language',
        'settings-slow-audio',
        'settings-dark-mode',
        'settings-reminder',
        'settings-reminder-time',
        'settings-remove-ads',
        'settings-restore',
        'settings-ads-consent',
        'settings-privacy',
        'settings-about',
        'settings-reset',
      ]) {
        await scrollTo(tester, SettingsScreen, byKey(key));
        expect(byKey(key), findsOneWidget, reason: 'missing $key');
      }
      expectClean(tester, 'settings rows');
    });

    testWidgets('T1 settings: translation language row changes the language '
        '($config)', (WidgetTester tester) async {
      final TestHarness h = await startApp(tester, config);
      await _open(tester);
      await _row(tester, 'settings-language');
      expect(find.byType(BottomSheet), findsOneWidget,
          reason: 'language row did nothing');
      final Finder option = byKey('lang:${tagFor(LearnerLanguage.punjabiShahmukhi)}');
      await tester.scrollUntilVisible(option, 80,
          scrollable: find.descendant(
              of: find.byType(BottomSheet), matching: find.byType(Scrollable)));
      await tester.ensureVisible(option);
      await tester.pumpAndSettle();
      await tester.tap(option);
      await tester.pumpAndSettle();
      expect(h.settings.translationLanguage, LearnerLanguage.punjabiShahmukhi);
      final String label =
          languageLabel(it, localeFor(LearnerLanguage.punjabiShahmukhi));
      expect(
        find.descendant(of: byKey('settings-language'), matching: find.text(label)),
        findsOneWidget,
        reason: 'settings subtitle did not follow the choice',
      );
      // Interface still Italian and LTR.
      expect(find.text(it.settingsTitle), findsWidgets);
      expect(Directionality.of(tester.element(find.byType(SettingsScreen))),
          TextDirection.ltr);
      await backArrow(tester);
      expect(
        find.descendant(of: byKey('search-language'), matching: find.text(label)),
        findsOneWidget,
        reason: 'Search pill did not follow the Settings choice',
      );
    });

    testWidgets('T1 settings: slow audio, dark mode switches ($config)',
        (WidgetTester tester) async {
      final TestHarness h = await startApp(tester, config);
      await _open(tester);
      final bool slow0 = h.settings.slowAudio;
      await _row(tester, 'settings-slow-audio');
      expect(h.settings.slowAudio, !slow0, reason: 'slow-audio switch dead');
      expect(find.descendant(
              of: byKey('settings-slow-audio'), matching: find.text(it.listenSlow)),
          findsOneWidget);
      final bool dark0 = h.settings.dark;
      await _row(tester, 'settings-dark-mode');
      expectClean(tester, 'theme switch');
      expect(h.settings.dark, !dark0, reason: 'dark-mode switch dead');
      expect(Theme.of(tester.element(find.byType(SettingsScreen))).brightness,
          dark0 ? Brightness.light : Brightness.dark);
      await _row(tester, 'settings-dark-mode');
      expect(h.settings.dark, dark0);
      // Slow audio makes the normal speaker slow too.
      await backArrow(tester);
      await tester.enterText(byKey('search-field'), 'pomodoro');
      await tester.pumpAndSettle();
      await tapSpeaker(tester, byKey('audio:il pomodoro'));
      expect(ttsCalls.where((c) => c.method == 'setSpeechRate').last.arguments,
          0.25, reason: 'slow-audio setting ignored by the speaker');
    });

    testWidgets('T1 settings: reminder switch and time picker ($config)',
        (WidgetTester tester) async {
      final TestHarness h = await startApp(tester, config);
      await _open(tester);
      final ListTile timeOff =
          tester.widget<ListTile>(byKey('settings-reminder-time'));
      expect(timeOff.onTap, isNull, reason: 'time row active while off');
      await _row(tester, 'settings-reminder');
      expectClean(tester, 'reminder on');
      expect(h.settings.reminderOn, isTrue, reason: 'reminder switch dead');
      await _row(tester, 'settings-reminder-time');
      expect(find.byType(Dialog), findsOneWidget,
          reason: 'reminder time row did nothing');
      expectClean(tester, 'time picker');
      // Confirm the picker (last button = OK).
      final Finder buttons = find.descendant(
          of: find.byType(Dialog), matching: find.byType(TextButton));
      await tester.tap(buttons.last);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing, reason: 'time picker OK dead');
      expect(h.settings.reminderOn, isTrue);
      await _row(tester, 'settings-reminder');
      expect(h.settings.reminderOn, isFalse);
      expectClean(tester, 'reminder off');
    });

    testWidgets('T1 settings: remove ads -> paywall buy/restore/back, '
        'restore row, consent row ($config)', (WidgetTester tester) async {
      await startApp(tester, config);
      await _open(tester);
      await _row(tester, 'settings-remove-ads');
      expectScreen(PaywallScreen, why: 'remove-ads row did nothing');
      expectClean(tester, 'paywall');
      expect(find.text('€3.99'), findsWidgets);
      await tapKey(tester, 'paywall-buy');
      expect(find.text(it.storeUnavailable), findsOneWidget,
          reason: 'Buy with no store gives no feedback');
      await scrollTo(tester, PaywallScreen, byKey('paywall-restore'));
      await tapKey(tester, 'paywall-restore');
      await settleReal(tester);
      // The plugin's restorePurchases() never answers in the test VM after
      // the first call, so this is reported, not failed (needs a device).
      if (byKey('paywall-status').evaluate().isEmpty) {
        // ignore: avoid_print
        print('T1 WARN ($config): paywall Restore gave no feedback — '
            'restorePurchases() did not return (no timeout in '
            'PurchaseService.restore)');
      }
      expectClean(tester, 'paywall buttons');
      await backArrow(tester);
      expectScreen(SettingsScreen, why: 'paywall back arrow did nothing');

      await _row(tester, 'settings-restore');
      await settleReal(tester);
      if (byKey('settings-status').evaluate().isEmpty) {
        // ignore: avoid_print
        print('T1 WARN ($config): Settings Restore gave no feedback — store '
            'did not answer');
      } else {
        await scrollTo(tester, SettingsScreen, byKey('settings-status-close'));
        await tapKey(tester, 'settings-status-close');
        expect(byKey('settings-status'), findsNothing,
            reason: 'status close button dead');
      }

      await _row(tester, 'settings-ads-consent');
      expectClean(tester, 'ads consent');
    });

    testWidgets('T1 settings: privacy and about open with text, back arrows '
        '($config)', (WidgetTester tester) async {
      await startApp(tester, config);
      await _open(tester);
      await _row(tester, 'settings-privacy');
      expectScreen(PrivacyScreen);
      expect(find.text(it.privacyBody), findsOneWidget);
      expectClean(tester, 'privacy');
      await backArrow(tester);
      await _row(tester, 'settings-about');
      expectScreen(AboutScreen);
      await scrollTo(tester, AboutScreen, find.text(it.creditsBody));
      expect(find.text(it.creditsBody), findsOneWidget);
      expectClean(tester, 'about');
      await backArrow(tester);
      expectScreen(SettingsScreen);
      await backArrow(tester);
      expectScreen(SearchScreen);
    });

    testWidgets('T1 settings: reset cancel and confirm ($config)',
        (WidgetTester tester) async {
      final TestHarness h = await startApp(tester, config, prefs: <String, Object>{
        'my_words': <String>['il pomodoro'],
        'streak_count': 4,
      });
      await _open(tester);
      await _row(tester, 'settings-reset');
      expect(find.byType(AlertDialog), findsOneWidget, reason: 'reset dead');
      expectClean(tester, 'reset dialog');
      await tapKey(tester, 'reset-cancel');
      expect(find.byType(AlertDialog), findsNothing);
      expect(h.progress.streak, 4);
      await _row(tester, 'settings-reset');
      await tapKey(tester, 'reset-confirm');
      expect(h.progress.myWordIds, isEmpty);
      expect(h.progress.streak, 0);
      expect(onScreen(tester, find.text(it.resetDone)), isTrue,
          reason: 'reset done, but the "Progressi azzerati" confirmation is '
              'not visible (it is added at the top of the list, off screen)');
      // The translation language survives a reset.
      expect(h.settings.hasChosenLanguage, isTrue);
    });
  }
}
