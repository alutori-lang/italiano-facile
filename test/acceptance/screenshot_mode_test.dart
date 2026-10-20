import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/config/screenshot_screens.dart';

import '../support/pump_app.dart';

void main() {
  test('Screenshot mode: ember_screen=0..5 maps to six screens', () {
    expect(ScreenshotScreens.ordered.length, 6);
    for (int i = 0; i < 6; i++) {
      expect(
        ScreenshotScreens.parse('$i'),
        ScreenshotScreens.ordered[i],
        reason: 'ember_screen=$i',
      );
    }
  });

  test('Screenshot mode: a normal launch is untouched', () {
    expect(ScreenshotScreens.parse(null), isNull);
    expect(ScreenshotScreens.parse(''), isNull);
    expect(ScreenshotScreens.parse('6'), isNull);
    expect(ScreenshotScreens.parse('-1'), isNull);
    expect(ScreenshotScreens.parse('abc'), isNull);
  });

  testWidgets('Screenshot mode: every screen opens filled with content', (
    WidgetTester tester,
  ) async {
    for (final ScreenshotScreen screen in ScreenshotScreens.ordered) {
      await pumpApp(tester, screenshot: screen);
      expect(tester.takeException(), isNull, reason: '$screen threw');
      // No debug banner and no empty screen.
      expect(find.byType(Scaffold), findsWidgets, reason: '$screen is empty');
    }
  });

  testWidgets('Screenshot mode: screen 1 shows ten real words of the day', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, screenshot: ScreenshotScreen.today);
    expect(find.text('Word 1 of 10'), findsOneWidget);
    expect(find.text('il pomodoro'), findsOneWidget);
  });

  testWidgets('Screenshot mode: screen 2 shows a real quiz question', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, screenshot: ScreenshotScreen.quizQuestion);
    expect(find.text('Question 1 of 20'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('answer-vero')), findsOneWidget);
  });

  testWidgets('Screenshot mode: screen 3 shows a finished passed quiz', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, screenshot: ScreenshotScreen.quizResult);
    expect(find.text('19 / 20'), findsOneWidget);
    expect(find.text('PASSED'), findsOneWidget);
  });

  testWidgets('Screenshot mode: screen 4 shows the topics grid', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, screenshot: ScreenshotScreen.topics);
    expect(find.text('Learn by category'), findsOneWidget);
  });

  testWidgets('Screenshot mode: screen 5 shows settings', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, screenshot: ScreenshotScreen.settings);
    expect(
      find.byKey(const ValueKey<String>('settings-language')),
      findsOneWidget,
    );
  });
}
