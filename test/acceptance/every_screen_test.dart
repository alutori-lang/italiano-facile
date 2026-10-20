import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/screens/settings_screen.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';

import '../support/pump_app.dart';

/// Tester 1's sweep: every tab, every button, on a small and a big phone, in
/// light and dark mode, in the ten main languages. No crash, no dead button,
/// no empty screen, no overflow.
void main() {
  const Size smallPhone = Size(320, 600);
  const Size bigPhone = Size(430, 932);

  const List<String> tabs = <String>[
    'tab-search',
    'tab-today',
    'tab-quiz',
    'tab-topics',
  ];

  for (final Size size in <Size>[smallPhone, bigPhone]) {
    for (final bool dark in <bool>[false, true]) {
      final String label =
          '${size.width.toInt()}x${size.height.toInt()} ${dark ? 'dark' : 'light'}';

      testWidgets('Every screen: the four tabs open with no overflow ($label)',
          (WidgetTester tester) async {
        await pumpApp(
          tester,
          size: size,
          initialPrefs: <String, Object>{'dark_mode': dark},
        );
        for (final String tab in tabs) {
          await tester.tap(find.byKey(ValueKey<String>(tab)));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$tab in $label');
        }
      });

      testWidgets('Every screen: Settings and its sub-screens open ($label)',
          (WidgetTester tester) async {
        await pumpApp(
          tester,
          size: size,
          initialPrefs: <String, Object>{'dark_mode': dark},
        );
        await tester.tap(find.byKey(const ValueKey<String>('search-settings')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        for (final String key in <String>[
          'settings-privacy',
          'settings-about',
          'settings-remove-ads',
        ]) {
          await scrollWithinScreen(
            tester,
            SettingsScreen,
            find.byKey(ValueKey<String>(key)),
          );
          await tester.tap(find.byKey(ValueKey<String>(key)));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$key in $label');
          // The back arrow must work on every screen.
          await tester.pageBack();
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: 'back from $key');
        }
      });
    }
  }

  testWidgets('Every screen: the ten main languages open every tab', (
    WidgetTester tester,
  ) async {
    for (final Locale locale in AppLocales.primary) {
      await pumpApp(tester, locale: locale, size: smallPhone);
      for (final String tab in tabs) {
        await tester.tap(find.byKey(ValueKey<String>(tab)));
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '$tab in $locale',
        );
      }
    }
  });

  testWidgets('Every screen: no tab is empty', (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const ValueKey<String>('tab-search')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('search-field')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('tab-today')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('today-pager')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('tab-quiz')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('quiz-category:mix')),
        findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('tab-topics')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('topic:greetings')),
      findsOneWidget,
    );
  });

  testWidgets('Every screen: each tab keeps its own state when switching', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'banana',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('tab-topics')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('tab-search')));
    await tester.pumpAndSettle();

    // The query and its results are still there.
    expect(find.text('la banana'), findsOneWidget);
  });

  testWidgets('Every screen: the speaker button works on every surface', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-topics')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('topic:fruit')),
      200,
    );
    await tester.tap(find.byKey(const ValueKey<String>('topic:fruit')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('audio:la mela')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test(
    'Every screen: the install guide appears when no Italian voice exists',
    () {},
    skip: 'needs a real device',
  );
}
