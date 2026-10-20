import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';

import '../support/pump_app.dart';

Map<String, Object?> _arb(String tag) {
  final File file = File('lib/l10n/app_$tag.arb');
  expect(file.existsSync(), isTrue, reason: 'missing ${file.path}');
  return jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
}

void main() {
  const List<String> tags = <String>[
    'en', 'it', 'es', 'es_419', 'pt', 'fr', 'de', 'hi', 'ar', 'id', 'ru',
    'ur', 'pa_Arab', 'pa', 'bn', 'si', 'zh',
  ];

  test('Languages: every locale file has every key, with no empty value', () {
    final Map<String, Object?> english = _arb('en');
    final List<String> keys = english.keys
        .where((String k) => !k.startsWith('@'))
        .toList(growable: false);
    expect(keys.length, greaterThan(120));

    for (final String tag in tags) {
      final Map<String, Object?> file = _arb(tag);
      for (final String key in keys) {
        expect(file.containsKey(key), isTrue,
            reason: '$tag is missing "$key"');
        final Object? value = file[key];
        expect(value, isA<String>(), reason: '$tag/$key is not a string');
        expect((value! as String).trim(), isNotEmpty,
            reason: '$tag/$key is empty');
      }
    }
  });

  test('Languages: placeholders are kept in every translation', () {
    final Map<String, Object?> english = _arb('en');
    final RegExp placeholder = RegExp(r'\{(\w+)\}');
    final Map<String, Set<String>> expected = <String, Set<String>>{};
    for (final String key in english.keys.where((String k) => !k.startsWith('@'))) {
      final Set<String> names = placeholder
          .allMatches(english[key]! as String)
          .map((RegExpMatch m) => m.group(1)!)
          .toSet();
      if (names.isNotEmpty) expected[key] = names;
    }
    expect(expected, isNotEmpty);

    for (final String tag in tags) {
      final Map<String, Object?> file = _arb(tag);
      for (final MapEntry<String, Set<String>> entry in expected.entries) {
        final Set<String> found = placeholder
            .allMatches(file[entry.key]! as String)
            .map((RegExpMatch m) => m.group(1)!)
            .toSet();
        expect(found, entry.value,
            reason: '$tag/${entry.key} lost a placeholder');
      }
    }
  });

  test('Languages: no translation is left as the English original', () {
    // A handful of strings are deliberately identical everywhere (the brand
    // name, VERO/FALSO, the quiz label). Everything else must be translated.
    const Set<String> shared = <String>{
      'appTitle', 'vero', 'falso', 'quiz20', 'scoreOutOf',
      'langEn', 'langUr', 'langPaArab', 'langPa', 'langBn', 'langSi',
      'langZh', 'langFr', 'langEs', 'langEs419', 'langIt', 'langPt',
      'langDe', 'langHi', 'langAr', 'langId', 'langRu',
    };
    final Map<String, Object?> english = _arb('en');
    for (final String tag in <String>['ur', 'bn', 'si', 'zh', 'ar', 'ru']) {
      final Map<String, Object?> file = _arb(tag);
      int identical = 0;
      for (final String key
          in english.keys.where((String k) => !k.startsWith('@'))) {
        if (shared.contains(key)) continue;
        if (file[key] == english[key]) identical++;
      }
      expect(identical, 0, reason: '$tag has $identical untranslated strings');
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
    expect(
      LearnerLanguage.forLocale(const Locale('es', 'MX')),
      LearnerLanguage.spanishLatAm,
    );
    // Anything outside the ten falls back to English.
    expect(
      LearnerLanguage.forLocale(const Locale('ru')),
      LearnerLanguage.english,
    );
    expect(
      LearnerLanguage.forLocale(const Locale('xx')),
      LearnerLanguage.english,
    );
  });

  test('Languages: an unsupported phone language opens the app in English', () {
    expect(
      AppLocales.resolve(const Locale('sw'), AppLocales.all),
      const Locale('en'),
    );
    expect(
      AppLocales.resolve(const Locale('ur'), AppLocales.all),
      const Locale('ur'),
    );
    expect(
      AppLocales.resolve(const Locale('es', 'AR'), AppLocales.all),
      const Locale('es', '419'),
    );
  });

  testWidgets('Languages: every interface language renders the four tabs', (
    WidgetTester tester,
  ) async {
    for (final Locale locale in AppLocales.all) {
      await pumpApp(tester, locale: locale);
      expect(tester.takeException(), isNull, reason: '$locale threw');
      expect(find.byKey(const ValueKey<String>('bottom-nav')), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('search-field')),
        findsOneWidget,
        reason: '$locale has no search field',
      );
      expect(
        find.byKey(const ValueKey<String>('tab-topics')),
        findsOneWidget,
        reason: '$locale has no Topics tab',
      );
    }
  });

  testWidgets('Languages: Urdu and Shahmukhi lay the app out right to left', (
    WidgetTester tester,
  ) async {
    for (final Locale locale in <Locale>[
      const Locale('ur'),
      const Locale.fromSubtags(languageCode: 'pa', scriptCode: 'Arab'),
      const Locale('ar'),
    ]) {
      await pumpApp(tester, locale: locale);
      final BuildContext context = tester.element(
        find.byKey(const ValueKey<String>('bottom-nav')),
      );
      expect(
        Directionality.of(context),
        TextDirection.rtl,
        reason: '$locale is not right to left',
      );
    }

    // And the ten-language set that is not RTL stays left to right.
    await pumpApp(tester, locale: const Locale('bn'));
    final BuildContext context = tester.element(
      find.byKey(const ValueKey<String>('bottom-nav')),
    );
    expect(Directionality.of(context), TextDirection.ltr);
  });

  testWidgets('Languages: word translations follow the interface language', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, locale: const Locale('zh'));
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'pomodoro',
    );
    await tester.pumpAndSettle();
    expect(find.text('il pomodoro'), findsOneWidget);
    expect(find.text('番茄'), findsOneWidget);

    await pumpApp(tester, locale: const Locale('ur'));
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      'pomodoro',
    );
    await tester.pumpAndSettle();
    expect(find.text('ٹماٹر'), findsOneWidget);
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
