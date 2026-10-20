import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/screens/settings_screen.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';

import '../support/pump_app.dart';

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey<String>('search-settings')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Settings: the screen opens from the Search header and shows '
      'every option', (WidgetTester tester) async {
    await pumpApp(tester);
    await _openSettings(tester);

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
      await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(ValueKey<String>(key)),
      );
      expect(find.byKey(ValueKey<String>(key)), findsOneWidget,
          reason: 'missing $key');
    }
  });

  testWidgets('Settings: the interface language can be changed by hand', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = await pumpApp(tester);
    await _openSettings(tester);

    await tester.tap(find.byKey(const ValueKey<String>('settings-language')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('lang:ur')));
    await tester.pumpAndSettle();

    expect(harness.settings.locale, const Locale('ur'));
    expect(
      harness.prefs.getString('ui_locale'),
      AppLocales.tag(const Locale('ur')),
    );
    // The whole app is now right to left.
    final BuildContext context = tester.element(find.byType(Scaffold).first);
    expect(Directionality.of(context), TextDirection.rtl);
  });

  testWidgets('Settings: dark mode is applied and remembered', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = await pumpApp(tester);
    await _openSettings(tester);

    expect(harness.settings.dark, isFalse);
    await tester.tap(find.byKey(const ValueKey<String>('settings-dark-mode')));
    await tester.pumpAndSettle();

    expect(harness.settings.dark, isTrue);
    expect(harness.prefs.getBool('dark_mode'), isTrue);
    final BuildContext context = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(context).brightness, Brightness.dark);
  });

  testWidgets('Settings: the audio speed switch is remembered', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = await pumpApp(tester);
    await _openSettings(tester);

    await tester.tap(find.byKey(const ValueKey<String>('settings-slow-audio')));
    await tester.pumpAndSettle();
    expect(harness.settings.slowAudio, isTrue);
    expect(harness.prefs.getBool('slow_audio'), isTrue);
  });

  testWidgets('Settings: the daily reminder is off by default and can be '
      'switched on', (WidgetTester tester) async {
    final TestHarness harness = await pumpApp(tester);
    expect(harness.settings.reminderOn, isFalse);

    await _openSettings(tester);
    await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-reminder')),
      );
    await tester.tap(find.byKey(const ValueKey<String>('settings-reminder')));
    await tester.pumpAndSettle();

    expect(harness.settings.reminderOn, isTrue);
    expect(harness.prefs.getBool('reminder_on'), isTrue);
    expect(tester.takeException(), isNull);

    // And off again.
    await tester.tap(find.byKey(const ValueKey<String>('settings-reminder')));
    await tester.pumpAndSettle();
    expect(harness.settings.reminderOn, isFalse);
  });

  testWidgets('Settings: reset progress clears progress but keeps the '
      'purchase', (WidgetTester tester) async {
    final TestHarness harness = await pumpApp(
      tester,
      initialPrefs: <String, Object>{
        'my_words': <String>['il pomodoro'],
        'streak_count': 7,
        'best_fruit': 18,
        'ads_removed': true,
        'correct_la mela': 2,
      },
    );
    expect(harness.progress.myWordIds, contains('il pomodoro'));
    expect(harness.progress.streak, 7);

    await _openSettings(tester);
    await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-reset')),
      );
    await tester.tap(find.byKey(const ValueKey<String>('settings-reset')));
    await tester.pumpAndSettle();

    // Cancelling changes nothing.
    await tester.tap(find.byKey(const ValueKey<String>('reset-cancel')));
    await tester.pumpAndSettle();
    expect(harness.progress.streak, 7);

    await tester.tap(find.byKey(const ValueKey<String>('settings-reset')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('reset-confirm')));
    await tester.pumpAndSettle();

    expect(harness.progress.myWordIds, isEmpty);
    expect(harness.progress.streak, 0);
    expect(harness.progress.bestScore('fruit'), 0);
    expect(harness.progress.isLearned('la mela'), isFalse);
    // The purchase is never lost.
    expect(harness.purchases.adsRemoved, isTrue);
  });

  testWidgets('Settings: the privacy screen opens and shows its text', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await _openSettings(tester);
    await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-privacy')),
      );
    await tester.tap(find.byKey(const ValueKey<String>('settings-privacy')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('This app works offline and has no login'),
      findsOneWidget,
    );
  });

  testWidgets('Settings: the about screen shows the credits and the licences', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await _openSettings(tester);
    await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-about')),
      );
    await tester.tap(find.byKey(const ValueKey<String>('settings-about')));
    await tester.pumpAndSettle();

    expect(find.textContaining('CC BY-SA 4.0'), findsOneWidget);
    expect(find.textContaining('Noto Emoji'), findsOneWidget);
    expect(find.textContaining('words ·'), findsWidgets);
  });

  testWidgets('Settings: the remove-ads screen opens with price and buttons', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await _openSettings(tester);
    await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-remove-ads')),
      );
    await tester.tap(find.byKey(const ValueKey<String>('settings-remove-ads')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('paywall-buy')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('paywall-restore')),
      findsOneWidget,
    );
    expect(find.text('€3.99'), findsOneWidget);
  });

  testWidgets('Settings: a user who already paid sees the ads-removed state', (
    WidgetTester tester,
  ) async {
    await pumpApp(
      tester,
      initialPrefs: <String, Object>{'ads_removed': true},
    );
    await _openSettings(tester);
    await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-remove-ads')),
      );
    await tester.tap(find.byKey(const ValueKey<String>('settings-remove-ads')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('paywall-buy')), findsNothing);
    expect(find.text('Ads removed. Thank you!'), findsWidgets);
  });
}
