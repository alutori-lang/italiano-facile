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

  testWidgets('Settings: the translation language can be changed by hand '
      'and is remembered', (WidgetTester tester) async {
    final TestHarness harness = await pumpApp(tester);
    await _openSettings(tester);

    await tester.tap(find.byKey(const ValueKey<String>('settings-language')));
    await tester.pumpAndSettle();
    // The sheet offers exactly the ten translation languages.
    for (final Locale locale in AppLocales.primary) {
      expect(
        find.byKey(ValueKey<String>('lang:${AppLocales.tag(locale)}')),
        findsOneWidget,
      );
    }
    expect(find.byKey(const ValueKey<String>('lang:it')), findsNothing);
    expect(find.byKey(const ValueKey<String>('lang:de')), findsNothing);

    await scrollWithinScreen(
      tester,
      BottomSheet,
      find.byKey(const ValueKey<String>('lang:ur')),
    );
    await tester.ensureVisible(find.byKey(const ValueKey<String>('lang:ur')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('lang:ur')));
    await tester.pumpAndSettle();

    expect(harness.settings.locale, const Locale('ur'));
    expect(
      harness.prefs.getString('ui_locale'),
      AppLocales.tag(const Locale('ur')),
    );
    // The interface stays Italian and left to right.
    expect(find.text('Impostazioni'), findsWidgets);
    final BuildContext context = tester.element(find.byType(Scaffold).first);
    expect(Directionality.of(context), TextDirection.ltr);
    expect(Localizations.localeOf(context), const Locale('it'));

    // A restart keeps the choice and shows no first-launch sheet.
    await pumpApp(
      tester,
      initialPrefs: <String, Object>{'ui_locale': 'ur'},
    );
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.text('اردو'), findsOneWidget);
  });

  testWidgets('Settings: the first launch asks for the translation language '
      'and it cannot be skipped', (WidgetTester tester) async {
    final TestHarness harness = await pumpApp(
      tester,
      firstLaunch: true,
      size: const Size(360, 640),
    );
    expect(harness.settings.hasChosenLanguage, isFalse);
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Lingua di traduzione'), findsOneWidget);

    // Tapping outside the sheet does not close it.
    await tester.tapAt(const Offset(180, 10));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);

    // Neither does the system back button.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(harness.settings.hasChosenLanguage, isFalse);

    // Picking a language closes it and saves the choice.
    await scrollWithinScreen(
      tester,
      BottomSheet,
      find.byKey(const ValueKey<String>('lang:fr')),
    );
    await tester.ensureVisible(find.byKey(const ValueKey<String>('lang:fr')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('lang:fr')));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(harness.settings.locale, const Locale('fr'));
    expect(harness.prefs.getString('ui_locale'), 'fr');
    expect(tester.takeException(), isNull);
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
      find.textContaining('Questa app funziona offline e non richiede login'),
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
    expect(find.textContaining('parole ·'), findsWidgets);
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
    expect(find.text('Pubblicità rimossa. Grazie!'), findsWidgets);
  });
}
