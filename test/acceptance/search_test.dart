import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/services/search_service.dart';

import '../support/pump_app.dart';

const SearchService _search = SearchService();

List<String> _ids(String query, [LearnerLanguage lang = LearnerLanguage.english]) =>
    _search.search(query, lang).map((SearchHit h) => h.word.id).toList();

void main() {
  test('Search: typing Italian finds the word', () {
    expect(_ids('pomodoro').first, 'il pomodoro');
    expect(_ids('il pomodoro').first, 'il pomodoro');
  });

  test('Search: typing English finds the Italian word', () {
    expect(_ids('tomato'), contains('il pomodoro'));
    expect(_ids('bus stop'), contains("la fermata dell'autobus"));
    expect(_ids('to speak'), contains('parlare'));
  });

  test('Search: typing Urdu, Bengali or Chinese finds the Italian word', () {
    expect(_ids('ٹماٹر', LearnerLanguage.urdu), contains('il pomodoro'));
    expect(_ids('টমেটো', LearnerLanguage.bengali), contains('il pomodoro'));
    expect(
      _ids('番茄', LearnerLanguage.chineseSimplified),
      contains('il pomodoro'),
    );
    expect(_ids('තක්කාලි', LearnerLanguage.sinhala), contains('il pomodoro'));
    expect(
      _ids('ਟਮਾਟਰ', LearnerLanguage.punjabiGurmukhi),
      contains('il pomodoro'),
    );
  });

  test('Search: a user can type in a language that is not their own', () {
    // A Bengali interface user typing the English word still finds it.
    expect(_ids('tomato', LearnerLanguage.bengali), contains('il pomodoro'));
  });

  test('Search: accents and capitals are ignored', () {
    expect(_ids('citta'), contains('la città'));
    expect(_ids('CITTÀ'), contains('la città'));
    expect(_ids('caffe'), contains('il caffè'));
    expect(_ids('lunedi'), contains('lunedì'));
  });

  test('Search: a small typo still finds the word', () {
    expect(_ids('pomodroo'), contains('il pomodoro'));
    expect(_ids('bannana'), contains('la banana'));
    expect(_ids('farmacia '), contains('la farmacia'));
  });

  test('Search: a conjugated verb finds the infinitive', () {
    expect(_ids('parlo'), contains('parlare'));
    expect(_ids('parli'), contains('parlare'));
    expect(_ids('lavoro'), contains('lavorare'));
    expect(_ids('mangiamo'), contains('mangiare'));
  });

  test('Search: phrases are searched too', () {
    expect(_ids('quanto costa'), contains('Quanto costa?'));
    expect(_ids('mal di testa'), contains('Ho mal di testa.'));
  });

  test('Search: nothing found gives did-you-mean suggestions', () {
    expect(_ids('zzzzqqq'), isEmpty);
    final List<Word> suggestions =
        _search.suggestions('pomodorzz', LearnerLanguage.english);
    expect(suggestions, isNotEmpty);
    expect(
      suggestions.map((Word w) => w.id),
      contains('il pomodoro'),
    );
  });

  testWidgets('Search: the screen shows results while typing', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'pomodoro',
    );
    await tester.pumpAndSettle();

    expect(find.text('il pomodoro'), findsOneWidget);
    expect(find.text('the tomato'), findsOneWidget);
  });

  testWidgets('Search: the result card has every required part', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'pomodoro',
    );
    await tester.pumpAndSettle();

    // Italian word, translation, explanation, example and its translation.
    expect(find.text('il pomodoro'), findsOneWidget);
    expect(find.text('the tomato'), findsOneWidget);
    expect(
      find.textContaining('Plural: "i pomodori"'),
      findsOneWidget,
    );
    expect(
      find.text('Vorrei un chilo di pomodori rossi.'),
      findsOneWidget,
    );
    expect(
      find.text('I would like a kilo of red tomatoes.'),
      findsOneWidget,
    );
    // Speaker buttons at normal and slow speed.
    expect(
      find.byKey(const ValueKey<String>('audio:il pomodoro')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('audio-slow:il pomodoro')),
      findsOneWidget,
    );
    // The add button.
    expect(
      find.byKey(const ValueKey<String>('save:il pomodoro')),
      findsOneWidget,
    );
  });

  testWidgets('Search: tapping Add to my words saves it and shows it later', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = await pumpApp(tester);
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'pomodoro',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('save:il pomodoro')));
    await tester.pumpAndSettle();

    expect(harness.progress.myWordIds, contains('il pomodoro'));
    expect(harness.progress.isSaved('il pomodoro'), isTrue);
  });

  testWidgets('Search: the last searches are saved and tappable', (
    WidgetTester tester,
  ) async {
    final TestHarness harness = await pumpApp(tester);
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'banana',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(harness.progress.recentSearches, contains('banana'));

    // Clearing the field brings the idle screen back, with the recent chip.
    await tester.tap(find.byKey(const ValueKey<String>('search-clear')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('recent:banana')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('recent:banana')));
    await tester.pumpAndSettle();
    expect(find.text('la banana'), findsOneWidget);
  });

  testWidgets('Search: nothing found shows the empty state and suggestions', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'pomodorzz',
    );
    await tester.pumpAndSettle();

    expect(find.text('No word found'), findsOneWidget);
    expect(find.text('Did you mean…?'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('search-online')),
      findsOneWidget,
    );
  });

  testWidgets('Search: the speaker button never crashes without a voice', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'pomodoro',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('audio:il pomodoro')));
    await tester.pumpAndSettle();
    // With no engine the app shows the install guide instead of failing.
    expect(tester.takeException(), isNull);
  });

  test(
    'Search: online lookup returns a Wiktionary definition',
    () {},
    skip: 'needs a real device',
  );
}
