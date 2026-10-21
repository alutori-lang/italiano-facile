import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';

import '../support/pump_app.dart';

// The interface is ALWAYS Italian; the user picks ONE translation language
// (one of ten) that word translations are shown in.

Map<String, Object?> _arb(String tag) {
  final File file = File('lib/l10n/app_$tag.arb');
  expect(file.existsSync(), isTrue, reason: 'missing ${file.path}');
  return jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
}

/// The interface locale standing for a translation language (same order).
Locale _localeFor(LearnerLanguage lang) => AppLocales.primary[lang.index];

Future<void> _searchPomodoro(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const ValueKey<String>('search-field')),
    'pomodoro',
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await WordRepository.load();
  });

  test('Languages: the Italian interface file has every key, with no empty '
      'value and every placeholder', () {
    final Map<String, Object?> reference = _arb('en');
    final Map<String, Object?> italian = _arb('it');
    final RegExp placeholder = RegExp(r'\{(\w+)\}');
    final List<String> keys = reference.keys
        .where((String k) => !k.startsWith('@'))
        .toList(growable: false);
    expect(keys.length, greaterThan(120));
    for (final String key in keys) {
      expect(italian.containsKey(key), isTrue, reason: 'it is missing "$key"');
      final Object? value = italian[key];
      expect(value, isA<String>(), reason: 'it/$key is not a string');
      expect((value! as String).trim(), isNotEmpty, reason: 'it/$key empty');
      final Set<String> want = placeholder
          .allMatches(reference[key]! as String)
          .map((RegExpMatch m) => m.group(1)!)
          .toSet();
      final Set<String> got = placeholder
          .allMatches(value as String)
          .map((RegExpMatch m) => m.group(1)!)
          .toSet();
      expect(got, want, reason: 'it/$key lost a placeholder');
    }
  });

  test('Languages: the ten dictionary languages map to the right locale', () {
    expect(
      LearnerLanguage.forLocale(const Locale('en')),
      LearnerLanguage.english,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('ur')),
      LearnerLanguage.urdu,
    );
    expect(
      LearnerLanguage.forLocale(
        const Locale.fromSubtags(languageCode: 'pa', scriptCode: 'Arab'),
      ),
      LearnerLanguage.punjabiShahmukhi,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('pa')),
      LearnerLanguage.punjabiGurmukhi,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('bn')),
      LearnerLanguage.bengali,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('si')),
      LearnerLanguage.sinhala,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('zh')),
      LearnerLanguage.chineseSimplified,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('fr')),
      LearnerLanguage.french,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('es', 'ES')),
      LearnerLanguage.spanishSpain,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('es', '419')),
      LearnerLanguage.spanishLatAm,
    );
    expect(AppLocales.primary.length, 10);
    for (final LearnerLanguage lang in LearnerLanguage.values) {
      expect(LearnerLanguage.forLocale(_localeFor(lang)), lang);
    }
  });

  testWidgets('Languages: the interface stays Italian and left to right for '
      'every translation language', (WidgetTester tester) async {
    for (final LearnerLanguage lang in LearnerLanguage.values) {
      await pumpApp(tester, locale: _localeFor(lang));
      expect(tester.takeException(), isNull, reason: '$lang threw');
      // Italian tab labels, whatever the translation language.
      expect(find.text('Cerca'), findsWidgets, reason: '$lang');
      expect(find.text('Oggi'), findsOneWidget, reason: '$lang');
      expect(find.text('Argomenti'), findsOneWidget, reason: '$lang');
      expect(find.byKey(const ValueKey<String>('search-field')),
          findsOneWidget);
      final BuildContext context = tester.element(
        find.byKey(const ValueKey<String>('bottom-nav')),
      );
      expect(Localizations.localeOf(context), const Locale('it'),
          reason: '$lang changed the interface language');
      expect(Directionality.of(context), TextDirection.ltr,
          reason: '$lang flipped the app layout');
    }
  });

  testWidgets('Languages: Urdu and Shahmukhi translations render right to '
      'left while the app stays left to right', (WidgetTester tester) async {
    final Word pomodoro = WordRepository.instance.byId('il pomodoro')!;
    for (final LearnerLanguage lang in LearnerLanguage.values) {
      await pumpApp(tester, locale: _localeFor(lang));
      await _searchPomodoro(tester);
      final Finder translation = find.text(pomodoro.translation(lang));
      expect(translation, findsWidgets, reason: '$lang translation missing');
      final Text text = tester.widget<Text>(translation.first);
      expect(
        text.textDirection,
        lang.isRtl ? TextDirection.rtl : TextDirection.ltr,
        reason: '$lang translation has the wrong direction',
      );
      final BuildContext context = tester.element(
        find.byKey(const ValueKey<String>('bottom-nav')),
      );
      expect(Directionality.of(context), TextDirection.ltr,
          reason: '$lang flipped the app layout');
    }
    expect(LearnerLanguage.urdu.isRtl, isTrue);
    expect(LearnerLanguage.punjabiShahmukhi.isRtl, isTrue);
  });

  testWidgets('Languages: word translations follow the chosen translation '
      'language', (WidgetTester tester) async {
    final TestHarness harness =
        await pumpApp(tester, locale: const Locale('zh'));
    await _searchPomodoro(tester);
    expect(find.text('il pomodoro'), findsOneWidget);
    expect(find.text('番茄'), findsOneWidget);

    // Change the translation language from the Search header pill.
    await tester.tap(find.byKey(const ValueKey<String>('search-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('lang:ur')));
    await tester.pumpAndSettle();

    expect(harness.settings.locale, const Locale('ur'));
    expect(harness.prefs.getString('ui_locale'), 'ur');
    expect(find.text('ٹماٹر'), findsOneWidget);
    expect(find.text('番茄'), findsNothing);
    // The interface did not change language.
    expect(find.text('Cerca'), findsWidgets);
    expect(find.text('Argomenti'), findsOneWidget);
  });

  testWidgets('Languages: Latin-American Spanish uses its own words', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, locale: const Locale('es', '419'));
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'macchina',
    );
    await tester.pumpAndSettle();
    expect(find.text('el carro'), findsOneWidget);

    await pumpApp(tester, locale: const Locale('es', 'ES'));
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'macchina',
    );
    await tester.pumpAndSettle();
    expect(find.text('el coche'), findsOneWidget);
  });
}
