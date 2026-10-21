// Tester 3 — every setting.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/screens/about_screen.dart';
import 'package:simple_flutter_app_651/screens/paywall_screen.dart';
import 'package:simple_flutter_app_651/screens/privacy_screen.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/services/progress_service.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';

import 't3_harness.dart';

void main() {
  group('Translation language', () {
    testWidgets('first launch: the sheet cannot be dismissed and a choice is saved',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(
        tester,
        initialPrefs: const <String, Object>{},
      );
      expect(find.byKey(const ValueKey<String>('lang:ur')), findsOneWidget);

      // Tapping the barrier must not close it.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey<String>('lang:ur')), findsOneWidget);

      // System back must not close it either.
      final NavigatorState nav = tester.state(find.byType(Navigator).first);
      await nav.maybePop();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey<String>('lang:ur')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey<String>('lang:ur')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey<String>('lang:ur')), findsNothing);
      expect(app.settings.hasChosenLanguage, isTrue);
      expect(app.prefs.getString(PrefsService.kLocale), 'ur');
      expect(
        app.settings.translationLanguage,
        LearnerLanguage.forLocale(const Locale('ur')),
      );
    });

    testWidgets('changed from Settings: row subtitle and prefs update',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openSettings(tester);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('settings-language')),
          matching: find.text(it.langEn),
        ),
        findsOneWidget,
      );
      await tapKey(tester, 'settings-language');
      await tester.tap(find.byKey(const ValueKey<String>('lang:fr')));
      await tester.pumpAndSettle();
      expect(app.prefs.getString(PrefsService.kLocale), 'fr');
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('settings-language')),
          matching: find.text(it.langFr),
        ),
        findsOneWidget,
      );
      // The interface stays Italian.
      expect(find.text(it.settingsTitle), findsWidgets);
    });

    testWidgets('changed from the Search header pill', (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await tapKey(tester, 'search-language');
      await tester.tap(find.byKey(const ValueKey<String>('lang:es_419')));
      await tester.pumpAndSettle();
      expect(app.prefs.getString(PrefsService.kLocale), 'es_419');
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('search-language')),
          matching: find.text(it.langEs419),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the picker from Settings can be dismissed without changing',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openSettings(tester);
      await tapKey(tester, 'settings-language');
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey<String>('lang:ur')), findsNothing);
      expect(app.prefs.getString(PrefsService.kLocale), 'en');
    });
  });

  group('Audio speed', () {
    testWidgets('slow-audio switch toggles and persists', (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openSettings(tester);
      await tapKey(tester, 'settings-slow-audio');
      expect(app.settings.slowAudio, isTrue);
      expect(app.prefs.getBool(PrefsService.kSlowAudio), isTrue);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey<String>('settings-slow-audio')),
          matching: find.text(it.listenSlow),
        ),
        findsOneWidget,
      );
      await tapKey(tester, 'settings-slow-audio');
      expect(app.settings.slowAudio, isFalse);
      expect(app.prefs.getBool(PrefsService.kSlowAudio), isFalse);
    });
  });

  group('Dark mode', () {
    testWidgets('switch changes the theme of the running app and persists',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openSettings(tester);
      final BuildContext ctx =
          tester.element(find.byKey(const ValueKey<String>('settings-dark-mode')));
      expect(Theme.of(ctx).brightness, Brightness.light);
      await tapKey(tester, 'settings-dark-mode');
      expect(app.settings.dark, isTrue);
      expect(app.prefs.getBool(PrefsService.kDark), isTrue);
      final BuildContext ctx2 =
          tester.element(find.byKey(const ValueKey<String>('settings-dark-mode')));
      expect(Theme.of(ctx2).brightness, Brightness.dark);
      await tapKey(tester, 'settings-dark-mode');
      expect(app.settings.dark, isFalse);
    });
  });

  group('Daily reminder', () {
    testWidgets('on: asks permission, schedules at 19:00; off: cancels',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openSettings(tester);
      final ListTile timeRow = tester.widget(
        find.byKey(const ValueKey<String>('settings-reminder-time')),
      );
      expect(timeRow.enabled, isFalse, reason: 'time row disabled while off');

      await tapKey(tester, 'settings-reminder');
      expect(app.settings.reminderOn, isTrue);
      expect(app.notifications.calls, contains('requestPermission'));
      expect(app.notifications.calls, contains('schedule:19:0'));
      expect(app.prefs.getBool(PrefsService.kReminderOn), isTrue);
      expect(find.text('19:00'), findsOneWidget);

      await tapKey(tester, 'settings-reminder');
      expect(app.settings.reminderOn, isFalse);
      expect(app.notifications.calls.last, 'cancel');
      expect(app.prefs.getBool(PrefsService.kReminderOn), isFalse);
    });

    testWidgets('time picker: cancel keeps the time, a new time reschedules',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(
        tester,
        initialPrefs: const <String, Object>{
          ...kLanguageChosen,
          PrefsService.kReminderOn: true,
        },
      );
      await openSettings(tester);
      await tapKey(tester, 'settings-reminder-time');
      expect(find.byType(Dialog), findsOneWidget);
      // Cancel.
      await tester.tap(find.text('Annulla').last);
      await tester.pumpAndSettle();
      expect(app.settings.reminderHour, 19);
      expect(app.notifications.calls.where((String c) => c.startsWith('schedule')),
          isEmpty);

      // Confirm with OK: the reminder is (re)scheduled at the picked time.
      // (Typing a new time into the Material input fields could not be
      // driven reliably from a widget test, so a different time is set
      // through the controller and the row checked.)
      await tapKey(tester, 'settings-reminder-time');
      await tester.tap(find.text('OK').last);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(app.notifications.calls, contains('schedule:19:0'));
      expect(app.settings.reminderOn, isTrue);

      await app.settings.setReminder(
        on: true,
        at: const TimeOfDay(hour: 20, minute: 15),
      );
      await tester.pumpAndSettle();
      expect(app.prefs.getInt(PrefsService.kReminderHour), 20);
      expect(app.prefs.getInt(PrefsService.kReminderMinute), 15);
      expect(find.text('20:15'), findsOneWidget);
    });

    testWidgets('time picker uses the Italian 24-hour clock (no AM/PM)',
        (WidgetTester tester) async {
      await pumpT3App(
        tester,
        initialPrefs: const <String, Object>{
          ...kLanguageChosen,
          PrefsService.kReminderOn: true,
        },
      );
      await openSettings(tester);
      await tapKey(tester, 'settings-reminder-time');
      final List<String> texts = find
          .descendant(of: find.byType(Dialog), matching: find.byType(Text))
          .evaluate()
          .map((Element e) => (e.widget as Text).data ?? '')
          .toList();
      expect(texts.any((String s) => s == 'AM' || s == 'PM'), isFalse,
          reason: 'dialog texts: $texts');
    });
  });

  group('Reset progress', () {
    Future<T3App> pumpWithProgress(WidgetTester tester) async {
      final T3App app = await pumpT3App(
        tester,
        initialPrefs: const <String, Object>{
          ...kLanguageChosen,
          PrefsService.kDark: true,
          PrefsService.kAdsRemoved: true,
          PrefsService.kStreakCount: 4,
          PrefsService.kStreakDay: '2026-10-20',
          PrefsService.kMyWords: <String>['w1', 'w2'],
          'correct_w1': 2,
          'best_fruit': 18,
        },
      );
      return app;
    }

    testWidgets('cancel keeps everything', (WidgetTester tester) async {
      final T3App app = await pumpWithProgress(tester);
      await openSettings(tester);
      await tapKey(tester, 'settings-reset');
      expect(find.text(it.resetProgressConfirm), findsOneWidget);
      await tapKey(tester, 'reset-cancel');
      expect(app.progress.streak, 4);
      expect(app.progress.myWordIds, <String>['w1', 'w2']);
      expect(app.progress.bestScore('fruit'), 18);
      expect(find.byKey(const ValueKey<String>('settings-status')), findsNothing);
    });

    testWidgets('confirm wipes progress, keeps language, dark mode and purchase',
        (WidgetTester tester) async {
      final T3App app = await pumpWithProgress(tester);
      await openSettings(tester);
      await tapKey(tester, 'settings-reset');
      await tapKey(tester, 'reset-confirm');
      expect(app.progress.streak, 0);
      expect(app.progress.bestScore('fruit'), 0);
      expect(app.progress.isLearned('w1'), isFalse);
      expect(find.text(it.resetDone), findsOneWidget);
      // Kept:
      expect(app.prefs.getString(PrefsService.kLocale), 'en');
      expect(app.settings.dark, isTrue);
      expect(app.purchases.adsRemoved, isTrue);
    });

    testWidgets(
        'reset with the reminder on: in-memory settings and saved settings agree '
        '(otherwise the switch shows ON now and OFF after a restart while the '
        'notification stays scheduled)', (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      await openSettings(tester);
      await tapKey(tester, 'settings-reminder');
      expect(app.settings.reminderOn, isTrue);
      await tapKey(tester, 'settings-reset');
      await tapKey(tester, 'reset-confirm');

      final PrefsService restarted = await restartPrefs();
      final SettingsController after = SettingsController(restarted);
      expect(
        after.reminderOn,
        app.settings.reminderOn,
        reason: 'PrefsService.resetProgress removes reminder_on/hour/minute '
            'but SettingsController keeps reminderOn=true in memory and the '
            'notification is never cancelled',
      );
    });
  });

  group('Privacy, about, remove ads rows', () {
    testWidgets('privacy options row asks the SDK for the privacy form',
        (WidgetTester tester) async {
      final T3App app = await pumpT3App(tester);
      final AdSdkMock sdk = app.sdk;
      await openSettings(tester);
      sdk.log.clear();
      await tapKey(tester, 'settings-ads-consent');
      expect(sdk.log, contains('ump:showPrivacyOptionsForm'));
    });

    testWidgets('privacy page opens and states the consent / offline facts',
        (WidgetTester tester) async {
      await pumpT3App(tester);
      await openSettings(tester);
      await tapKey(tester, 'settings-privacy');
      expect(find.byType(PrivacyScreen), findsOneWidget);
      expect(find.text(it.privacyBody), findsOneWidget);
      await goBack(tester);
      await tester.pumpAndSettle();
      expect(find.byType(PrivacyScreen), findsNothing);
    });

    testWidgets('about page opens with app name and version',
        (WidgetTester tester) async {
      await pumpT3App(tester);
      await openSettings(tester);
      await tapKey(tester, 'settings-about');
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text(it.appTitle), findsWidgets);
      expect(find.text('1.0.0'), findsOneWidget);
    });

    testWidgets('remove-ads row shows the store price and opens the paywall',
        (WidgetTester tester) async {
      final FakeStore store = FakeStore()
        ..products = [fakeProduct(price: '4,49 €')];
      await pumpT3App(tester, store: store);
      await openSettings(tester);
      expect(find.text('4,49 €'), findsOneWidget);
      await tapKey(tester, 'settings-remove-ads');
      expect(find.byType(PaywallScreen), findsOneWidget);
    });

    testWidgets('test-ids notice is hidden for a buyer', (WidgetTester tester) async {
      await pumpT3App(
        tester,
        initialPrefs: const <String, Object>{
          ...kLanguageChosen,
          PrefsService.kAdsRemoved: true,
        },
      );
      await openSettings(tester);
      expect(
        find.byKey(const ValueKey<String>('settings-ads-test-notice')),
        findsNothing,
      );
      expect(find.text(it.adsRemoved), findsOneWidget);
    });
  });

  test('ProgressService.dayKey pads month and day', () {
    expect(ProgressService.dayKey(DateTime(2026, 3, 7)), '2026-03-07');
  });
}
