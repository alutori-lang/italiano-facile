import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/services/daily_words_service.dart';
import 'package:simple_flutter_app_651/services/progress_service.dart';

import '../support/pump_app.dart';

const DailyWordsService _daily = DailyWordsService();

List<String> _pick(String personalId, String day, {Set<String>? seen}) => _daily
    .pick(
      all: WordRepository.instance.all,
      seen: seen ?? <String>{},
      personalId: personalId,
      dayKey: day,
    )
    .map((Word w) => w.id)
    .toList();

void main() {
  test('Today: exactly ten words are chosen for a day', () {
    expect(_pick('marco', '2026-10-20').length, 10);
    expect(_pick('sara', '2026-10-20').length, 10);
  });

  test('Today: two different users get different words on the same date', () {
    final List<String> marco = _pick('marco-id-1111', '2026-10-20');
    final List<String> sara = _pick('sara-id-2222', '2026-10-20');
    expect(marco, isNot(sara));
    // Not just reordered: the sets themselves differ.
    expect(marco.toSet(), isNot(sara.toSet()));
  });

  test('Today: the same user gets the same ten words twice on one date', () {
    expect(
      _pick('marco-id-1111', '2026-10-20'),
      _pick('marco-id-1111', '2026-10-20'),
    );
  });

  test('Today: the same user gets different words the next day', () {
    final List<String> today = _pick('marco-id-1111', '2026-10-20');
    final List<String> tomorrow = _pick('marco-id-1111', '2026-10-21');
    expect(today.toSet(), isNot(tomorrow.toSet()));
  });

  test('Today: the daily mix is about four nouns, three verbs, two '
      'adjectives and one phrase', () {
    final List<Word> words = _daily.pick(
      all: WordRepository.instance.all,
      seen: <String>{},
      personalId: 'mix-check',
      dayKey: '2026-10-20',
    );
    int count(WordType type) =>
        words.where((Word w) => w.type == type).length;
    expect(count(WordType.noun), 4);
    expect(count(WordType.verb), 3);
    expect(count(WordType.adjective), 2);
    expect(count(WordType.phrase), 1);
  });

  test('Today: a word does not come back until all words have been seen', () {
    final Set<String> seen = <String>{};
    final Set<String> everShown = <String>{};
    // Walk through enough days to use up a large part of the dictionary.
    for (int day = 1; day <= 15; day++) {
      final List<String> ids = _pick(
        'repeat-check',
        '2026-11-${day.toString().padLeft(2, '0')}',
        seen: seen,
      );
      for (final String id in ids) {
        expect(everShown.contains(id), isFalse,
            reason: '$id came back on day $day before the pool was used up');
        everShown.add(id);
      }
      seen.addAll(ids);
    }
    expect(everShown.length, 150);
  });

  test('Today: the shuffle seed depends on both the id and the date', () {
    expect(
      DailyWordsService.seedFor('a', '2026-10-20'),
      isNot(DailyWordsService.seedFor('b', '2026-10-20')),
    );
    expect(
      DailyWordsService.seedFor('a', '2026-10-20'),
      isNot(DailyWordsService.seedFor('a', '2026-10-21')),
    );
    expect(
      DailyWordsService.seedFor('a', '2026-10-20'),
      DailyWordsService.seedFor('a', '2026-10-20'),
    );
  });

  testWidgets('Today: the streak counts one more day after a consecutive day',
      (WidgetTester tester) async {
    final TestHarness harness = await pumpApp(tester);
    final ProgressService progress = harness.progress;
    final DateTime day1 = DateTime(2026, 10, 18);

    await progress.touchStreak(day1);
    expect(progress.streak, 1);

    // Same day again: unchanged.
    await progress.touchStreak(day1);
    expect(progress.streak, 1);

    await progress.touchStreak(day1.add(const Duration(days: 1)));
    expect(progress.streak, 2);

    // A gap restarts the streak at one.
    await progress.touchStreak(day1.add(const Duration(days: 5)));
    expect(progress.streak, 1);
  });

  testWidgets('Today: the screen shows the cards, the streak and the quiz CTA',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const ValueKey<String>('tab-today')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('today-pager')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('streak-pill')), findsOneWidget);
    expect(find.text("Today's words"), findsOneWidget);
    expect(find.text('Word 1 of 10'), findsOneWidget);
    // Before the last card the button moves on rather than starting the quiz.
    expect(find.byKey(const ValueKey<String>('today-next')), findsOneWidget);
  });

  testWidgets('Today: tapping next moves through the ten cards to the quiz',
      (WidgetTester tester) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-today')));
    await tester.pumpAndSettle();

    for (int i = 0; i < 9; i++) {
      await tester.tap(find.byKey(const ValueKey<String>('today-next')));
      await tester.pumpAndSettle();
    }
    expect(find.text('Word 10 of 10'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('today-mini-quiz')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey<String>('today-mini-quiz')));
    await tester.pumpAndSettle();
    expect(find.text('Question 1 of 10'), findsOneWidget);
  });

  testWidgets('Today: the ten words survive a restart on the same day',
      (WidgetTester tester) async {
    final TestHarness first = await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-today')));
    await tester.pumpAndSettle();

    final String day = ProgressService.dayKey(DateTime.now());
    final List<String> stored = first.progress.todayIdsFor(day);
    expect(stored.length, 10);

    // Reopening with the same stored preferences keeps the same ten words.
    final Map<String, Object> saved = <String, Object>{
      PrefsKeys.todayDay: day,
      PrefsKeys.todayIds: stored,
      PrefsKeys.personalId: first.progress.personalId,
    };
    final TestHarness second = await pumpApp(tester, initialPrefs: saved);
    expect(second.progress.todayIdsFor(day), stored);
  });
}

/// The few preference keys this test writes directly.
class PrefsKeys {
  const PrefsKeys._();
  static const String todayDay = 'today_day';
  static const String todayIds = 'today_ids';
  static const String personalId = 'personal_id';
}
