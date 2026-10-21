import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_app_651/app_scope.dart';
import 'package:simple_flutter_app_651/data/big_dictionary.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/l10n/app_localizations.dart';
import 'package:simple_flutter_app_651/models/big_entry.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/screens/big_entry_screen.dart';
import 'package:simple_flutter_app_651/screens/search_screen.dart';
import 'package:simple_flutter_app_651/services/ads_service.dart';
import 'package:simple_flutter_app_651/services/notification_service.dart';
import 'package:simple_flutter_app_651/services/online_lookup_service.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/services/progress_service.dart';
import 'package:simple_flutter_app_651/services/purchase_service.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';
import 'package:simple_flutter_app_651/services/text_norm.dart';
import 'package:simple_flutter_app_651/services/tts_service.dart';
import 'package:simple_flutter_app_651/ui/theme.dart';
import 'package:simple_flutter_app_651/ui/widgets/big_entry_card.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'big_support.dart';

late Directory _dir;
late BigDictionary _big;

Future<void> _pumpSearch(
  WidgetTester tester,
  Locale translation, {
  BigDictionary? big,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final PrefsService prefs = await PrefsService.open();
  final SettingsController settings = SettingsController(prefs);
  await settings.setLocale(translation);
  await tester.pumpWidget(
    AppScope(
      settings: settings,
      progress: ProgressService(prefs),
      tts: TtsService(),
      ads: AdsService(),
      purchases: PurchaseService(prefs),
      notifications: NotificationService(),
      online: OnlineLookupService(),
      big: big ?? _big,
      child: MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('it'),
        supportedLocales: AppLocales.all,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(body: SearchScreen()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Types [text] and lets the (real, file-based) database answer.
Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(
    find.byKey(const ValueKey<String>('search-field')),
    text,
  );
  await tester.pump();
  for (int i = 0; i < 5; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  sqfliteFfiInit();

  setUpAll(() async {
    await WordRepository.load();
    _dir = await Directory.systemTemp.createTemp('bigdict_widget');
    _big = makeBigDictionary(
      _dir,
      factory: databaseFactoryFfiNoIsolate,
      useIsolate: false,
    );
    await _big.start(LearnerLanguage.urdu);
    await _big.useLanguage(LearnerLanguage.punjabiShahmukhi);
    expect(_big.ready, isTrue);
  });

  tearDownAll(() async {
    await _big.close();
    try {
      await _dir.delete(recursive: true);
    } catch (_) {}
  });

  /// A word of the big dictionary that has no curated card (so the big card
  /// is what Search shows), with an Urdu meaning.
  Future<BigEntry> pickBigOnly() async {
    final Set<String> curated = <String>{
      for (final Word w in WordRepository.instance.all) TextNorm.norm(w.bare),
    };
    for (final String w in <String>[
      'simpatico',
      'zio',
      'uomo',
      'studente',
      'sport',
      'passata',
      'casa',
    ]) {
      if (curated.contains(w)) continue;
      final List<BigHit> hits = await _big.lookup(w, LearnerLanguage.urdu);
      if (hits.isNotEmpty && hits.first.entry.it == w) return hits.first.entry;
    }
    throw StateError('no big-only word in the current big.db');
  }

  testWidgets(
      'Search shows a big-dictionary card with the Urdu meaning, '
      'and its detail', (WidgetTester tester) async {
    final BigEntry entry = (await tester.runAsync(pickBigOnly))!;
    // ignore: avoid_print
    print('widget test word: ${entry.headword} → '
        '${entry.translation(LearnerLanguage.urdu)}');
    await _pumpSearch(tester, const Locale('ur'));
    await _type(tester, entry.it);

    final Finder card = find.byKey(ValueKey<String>('big:${entry.id}'));
    // Curated cards (pictures, explanations) come first; scroll to it.
    await tester.scrollUntilVisible(card, 300,
        scrollable: find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ));
    expect(card, findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text(entry.headword)),
      findsOneWidget,
    );
    final Finder meaning = find.descendant(
      of: card,
      matching: find.text(entry.translation(LearnerLanguage.urdu)),
    );
    expect(meaning, findsOneWidget);
    expect(
      tester.widget<Text>(meaning).textDirection,
      TextDirection.rtl,
      reason: 'Urdu meanings are right to left',
    );
    expect(find.text('Nessuna parola trovata'), findsNothing);

    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(BigEntryScreen), findsOneWidget);
    expect(find.text('Grande dizionario'), findsOneWidget);
    if (entry.gloss != null) {
      expect(find.text('In inglese: ${entry.gloss}'), findsOneWidget);
    }
    if (entry.pl != null) {
      expect(find.text('Plurale: ${entry.pl}'), findsOneWidget);
    }
    expect(find.text('Dal grande dizionario (Wiktionary)'), findsOneWidget);
  });

  testWidgets('Search: a conjugated form shows the word (andavamo → andare)',
      (WidgetTester tester) async {
    await _pumpSearch(tester, const Locale('ur'));
    await _type(tester, 'andavamo');
    // andare is a curated word too: then its curated card (with picture)
    // is shown, otherwise the big card.
    expect(
      find.text('andare').evaluate().isNotEmpty ||
          find.byType(BigEntryCard).evaluate().isNotEmpty,
      isTrue,
    );
    expect(find.text('Nessuna parola trovata'), findsNothing);
  });

  testWidgets('Search: Roman Punjabi "piyar" answers with amore',
      (WidgetTester tester) async {
    await _pumpSearch(
      tester,
      const Locale.fromSubtags(languageCode: 'pa', scriptCode: 'Arab'),
    );
    await _type(tester, 'piyar');
    expect(find.textContaining('amore'), findsWidgets);
  });

  testWidgets(
      'Search: nothing on the phone → "Sto cercando online…", then the '
      'server answers (422 → word cannot be added)',
      (WidgetTester tester) async {
    final Completer<http.Response> answer = Completer<http.Response>();
    final BigDictionary online = (await tester.runAsync(() async {
      final BigDictionary d = makeBigDictionary(
        _dir,
        factory: databaseFactoryFfiNoIsolate,
        useIsolate: false,
        baseUrl: 'https://words.test',
        client: MockClient((http.Request req) {
          expect(req.url.path, '/v1/lookup');
          return answer.future;
        }),
      );
      await d.start(LearnerLanguage.urdu);
      return d;
    }))!;
    await _pumpSearch(tester, const Locale('ur'), big: online);
    await _type(tester, 'zzqqparolaccia');
    expect(find.text('Nessuna parola trovata'), findsOneWidget);
    // The server is asked once the user stops typing (700 ms).
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byKey(const ValueKey<String>('big-online-searching')),
        findsOneWidget);
    expect(find.text('Sto cercando online…'), findsOneWidget);
    expect(find.text('Nessuna parola trovata'), findsNothing);
    answer.complete(http.Response(
        jsonEncode(<String, String>{'error': 'not_allowed'}), 422));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const ValueKey<String>('big-online-searching')),
        findsNothing);
    expect(find.text('Questa parola non si può aggiungere al dizionario.'),
        findsOneWidget);
    await tester.runAsync(online.close);
  });
}
