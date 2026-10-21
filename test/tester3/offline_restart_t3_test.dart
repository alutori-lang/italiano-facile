// Tester 3 — offline behaviour and restart persistence.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:simple_flutter_app_651/screens/paywall_screen.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/services/progress_service.dart';
import 'package:simple_flutter_app_651/services/purchase_service.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';

import 't3_harness.dart';

Future<void> searchFor(WidgetTester tester, String text) async {
  await tapKey(tester, 'tab-search');
  await tester.enterText(find.byType(TextField).first, text);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

void main() {
  group('Offline', () {
    testWidgets('with every request failing, every tab and screen still works',
        (WidgetTester tester) async {
      final FakeStore store = FakeStore()..available = false;
      await pumpT3App(tester, store: store);
      for (final String tab in <String>[
        'tab-search',
        'tab-today',
        'tab-quiz',
        'tab-topics',
      ]) {
        await tapKey(tester, tab);
        expect(tester.takeException(), isNull, reason: tab);
      }
      // Open a topic and a word.
      await tapKey(tester, 'tab-topics');
      final Finder anyTile = find.byWidgetPredicate((Widget w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('topic:'));
      if (anyTile.evaluate().isNotEmpty) {
        await tester.tap(anyTile.first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await goBack(tester);
        await tester.pumpAndSettle();
      }
      // Offline search of a known word.
      await searchFor(tester, 'casa');
      expect(find.text(it.noResults), findsNothing);
      // Settings + paywall without a store.
      await openSettings(tester);
      await tapKey(tester, 'settings-remove-ads');
      expect(find.byType(PaywallScreen), findsOneWidget);
      await tapKey(tester, 'paywall-restore');
      expect(tester.takeException(), isNull);
    });

    testWidgets('"Search online" offline: friendly notice, button usable again',
        (WidgetTester tester) async {
      await pumpT3App(tester);
      await searchFor(tester, 'zqxwvkjh');
      expect(find.text(it.noResults), findsOneWidget);
      await tapKey(tester, 'search-online');
      expect(find.text(it.offlineNotice), findsOneWidget);
      final OutlinedButton button = tester.widget(
        find.byKey(const ValueKey<String>('search-online')),
      );
      expect(button.onPressed, isNotNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('"Search online" server error (500): offline notice',
        (WidgetTester tester) async {
      await pumpT3App(
        tester,
        httpClient: MockClient((http.Request _) async =>
            http.Response('boom', 500)),
      );
      await searchFor(tester, 'zqxwvkjh');
      await tapKey(tester, 'search-online');
      expect(find.text(it.offlineNotice), findsOneWidget);
    });

    testWidgets('"Search online" that never answers times out (8 s)',
        (WidgetTester tester) async {
      await pumpT3App(
        tester,
        httpClient: MockClient(
          (http.Request _) => Completer<http.Response>().future,
        ),
      );
      await searchFor(tester, 'zqxwvkjh');
      final Finder button = find.byKey(const ValueKey<String>('search-online'));
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
      expect(find.text(it.searchingOnline), findsOneWidget);
      await tester.pump(const Duration(seconds: 9));
      await tester.pumpAndSettle();
      expect(find.text(it.offlineNotice), findsOneWidget);
    });

    testWidgets('"Search online" success shows the Wiktionary card and sends '
        'only the typed word', (WidgetTester tester) async {
      Uri? sent;
      await pumpT3App(
        tester,
        httpClient: MockClient((http.Request req) async {
          sent = req.url;
          return http.Response.bytes(
            utf8.encode(jsonEncode(<String, Object>{
              'query': <String, Object>{
                'pages': <String, Object>{
                  '1': <String, Object>{
                    'title': 'zqxwvkjh',
                    'extract': 'Parola di prova.',
                  },
                },
              },
            })),
            200,
          );
        }),
      );
      await searchFor(tester, 'zqxwvkjh');
      await tapKey(tester, 'search-online');
      expect(find.text('Parola di prova.'), findsOneWidget);
      expect(find.text(it.onlineResultTitle.toUpperCase()), findsOneWidget);
      expect(sent, isNotNull);
      expect(sent!.host, 'it.wiktionary.org');
      expect(sent!.queryParameters['titles'], 'zqxwvkjh');
      expect(
        sent!.queryParameters.keys.toSet(),
        <String>{
          'action', 'format', 'prop', 'explaintext', 'redirects', 'titles',
          'origin',
        },
      );
    });
  });

  group('Restart keeps everything', () {
    testWidgets('progress, streak, my words, settings, language and purchase',
        (WidgetTester tester) async {
      final FakeStore store = FakeStore();
      final T3App app = await pumpT3App(tester, store: store);

      await app.progress.toggleSaved('w_casa');
      await app.progress.toggleSaved('w_pane');
      await app.progress.touchStreak(DateTime(2026, 10, 20, 9));
      await app.progress.touchStreak(DateTime(2026, 10, 21, 9));
      await app.progress.recordAnswer('w_casa', correct: true);
      await app.progress.recordAnswer('w_casa', correct: true);
      await app.progress.saveBestScore('fruit', 19);
      await app.progress.addRecentSearch('casa');
      await app.settings.setDark(true);
      await app.settings.setSlowAudio(true);
      await app.settings.setReminder(
        on: true,
        at: const TimeOfDay(hour: 8, minute: 30),
      );
      await app.settings.setLocale(const Locale('ur'));
      await app.purchases.buyRemoveAds();
      store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.purchased)]);
      await tester.pumpAndSettle();
      expect(app.purchases.adsRemoved, isTrue);
      final String personal = app.progress.personalId;

      // ---- kill the app and start again
      final PrefsService prefs = await restartPrefs();
      final SettingsController settings = SettingsController(prefs);
      final ProgressService progress = ProgressService(prefs);
      final PurchaseService purchases =
          PurchaseService(prefs, iap: FakeStore()..available = false);
      await purchases.init();

      expect(progress.myWordIds, <String>['w_pane', 'w_casa']);
      expect(progress.streak, 2);
      expect(progress.streakDay, '2026-10-21');
      expect(progress.isLearned('w_casa'), isTrue);
      expect(progress.bestScore('fruit'), 19);
      expect(progress.recentSearches, <String>['casa']);
      expect(progress.personalId, personal);
      expect(settings.dark, isTrue);
      expect(settings.slowAudio, isTrue);
      expect(settings.reminderOn, isTrue);
      expect(settings.reminderHour, 8);
      expect(settings.reminderMinute, 30);
      expect(settings.locale, const Locale('ur'));
      expect(settings.hasChosenLanguage, isTrue);
      expect(purchases.adsRemoved, isTrue,
          reason: 'purchase kept offline, without asking the store');

      // Streak continues the day after the restart.
      await progress.touchStreak(DateTime(2026, 10, 22, 9));
      expect(progress.streak, 3);
    });

    testWidgets('restarted app: no first-launch sheet, dark theme, buyer '
        'state shown, no ads', (WidgetTester tester) async {
      final T3App app = await pumpT3App(
        tester,
        initialPrefs: const <String, Object>{
          PrefsService.kLocale: 'bn',
          PrefsService.kDark: true,
          PrefsService.kAdsRemoved: true,
        },
      );
      expect(find.byKey(const ValueKey<String>('lang:bn')), findsNothing);
      expect(app.ads.shouldShowAds, isFalse);
      await openSettings(tester);
      final BuildContext ctx = tester
          .element(find.byKey(const ValueKey<String>('settings-dark-mode')));
      expect(Theme.of(ctx).brightness, Brightness.dark);
      expect(find.text(it.langBn), findsOneWidget);
      expect(find.text(it.adsRemoved), findsOneWidget);
      expect(app.sdk.count('MobileAds#initialize'), 0);
    });

    test('a streak gap restarts at 1, same day does not double count',
        () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final PrefsService prefs = await restartPrefs();
      final ProgressService p = ProgressService(prefs);
      await p.reset();
      await p.touchStreak(DateTime(2026, 10, 1));
      await p.touchStreak(DateTime(2026, 10, 1, 23));
      expect(p.streak, 1);
      await p.touchStreak(DateTime(2026, 10, 5));
      expect(p.streak, 1);
    });
  });
}
