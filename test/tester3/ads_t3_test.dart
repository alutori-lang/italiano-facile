// Tester 3 — consent, banner placement, interstitial rules, remove-ads.
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/screens/home_shell.dart';
import 'package:simple_flutter_app_651/screens/flashcards_screen.dart';
import 'package:simple_flutter_app_651/screens/paywall_screen.dart';
import 'package:simple_flutter_app_651/screens/quiz_play_screen.dart';
import 'package:simple_flutter_app_651/screens/quiz_result_screen.dart';
import 'package:simple_flutter_app_651/services/ads_service.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/services/quiz_service.dart';
import 'package:simple_flutter_app_651/ui/widgets/banner_ad_slot.dart';

import 't3_harness.dart';

Future<void> pushQuizResult(WidgetTester tester) async {
  const QuizService quiz = QuizService();
  final List<Word> pool = WordRepository.instance.byTopic('fruit');
  final List<QuizQuestion> questions = quiz.build(pool, random: Random(3));
  final QuizResult result = quiz.score(
    questions,
    <bool>[for (final QuizQuestion q in questions) q.isTrue],
  );
  Navigator.of(tester.element(find.byType(HomeShell))).push(
    MaterialPageRoute<void>(
      builder: (_) => QuizResultScreen(
        result: result,
        pool: pool,
        categoryId: 'fruit',
        categoryLabel: 'Frutta',
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.byType(QuizResultScreen), findsOneWidget);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Consent (UMP) before ads', () {
    test('consent ok: MobileAds initialised, ads allowed, interstitial preloaded',
        () async {
      final AdSdkMock sdk = AdSdkMock()..install();
      final AdsService ads = AdsService();
      await ads.start(adsRemoved: false);
      await ads.preloadInterstitial();
      expect(sdk.log, contains('ump:requestConsentInfoUpdate'));
      expect(sdk.count('MobileAds#initialize'), 1);
      expect(ads.shouldShowAds, isTrue);
      expect(sdk.count('loadInterstitialAd'), 1);
    });

    test(
        'MobileAds.initialize waits for the consent info update to finish '
        '(slow network: 500 ms)', () async {
      final AdSdkMock sdk = AdSdkMock(
        consentUpdateDelay: const Duration(milliseconds: 500),
      )..install();
      final AdsService ads = AdsService();
      await ads.start(adsRemoved: false);
      await Future<void>.delayed(const Duration(milliseconds: 700));
      final int done = sdk.log.indexOf('ump:requestConsentInfoUpdate:done');
      final int init = sdk.log.indexOf('MobileAds#initialize');
      expect(done, isNot(-1));
      expect(init, isNot(-1));
      expect(
        done < init,
        isTrue,
        reason: 'ads_service.dart _requestConsentInfoUpdate/_showFormIfRequired '
            'wrap the callback APIs in Future(() {...}) that return '
            'immediately, so start() calls MobileAds.initialize while the '
            'consent request is still in flight. Log: ${sdk.log}',
      );
    });

    test('canRequestAds == false: no MobileAds.initialize, no ad requests',
        () async {
      final AdSdkMock sdk = AdSdkMock(canRequestAds: false)..install();
      final AdsService ads = AdsService();
      await ads.start(adsRemoved: false);
      await ads.preloadInterstitial();
      expect(
        ads.shouldShowAds,
        isFalse,
        reason: 'ads_service.dart never calls '
            'ConsentInformation.instance.canRequestAds(); ads are allowed as '
            'soon as MobileAds.initialize succeeds. Log: ${sdk.log}',
      );
      expect(sdk.count('loadInterstitialAd'), 0);
    });

    test('a buyer: no consent form, no SDK init, no ad request', () async {
      final AdSdkMock sdk = AdSdkMock()..install();
      final AdsService ads = AdsService();
      await ads.start(adsRemoved: true);
      await ads.preloadInterstitial();
      expect(sdk.log.where((String e) => e.startsWith('ump:')), isEmpty);
      expect(sdk.count('MobileAds#initialize'), 0);
      expect(sdk.count('loadInterstitialAd'), 0);
      expect(ads.shouldShowAds, isFalse);
      expect(await ads.loadBanner(390), isNull);
      expect(await ads.maybeShowInterstitial(), isFalse);
    });

    test('MobileAds.initialize failing: no ads, no crash', () async {
      final AdSdkMock sdk = AdSdkMock(initializeFails: true)..install();
      final AdsService ads = AdsService();
      await ads.start(adsRemoved: false);
      expect(ads.shouldShowAds, isFalse);
      expect(ads.consentGathered, isTrue);
      expect(sdk.count('MobileAds#initialize'), 1);
    });

    testWidgets('iOS: ATT is asked after the consent form and before init',
        (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock()..install();
      final AdsService ads = AdsService();
      await tester.runAsync(() => ads.start(adsRemoved: false));
      final int form = sdk.log.indexOf('ump:loadAndShowConsentFormIfRequired');
      final int att = sdk.log.indexOf('att:requestTrackingAuthorization');
      final int init = sdk.log.indexOf('MobileAds#initialize');
      expect(form, isNot(-1));
      expect(att, isNot(-1));
      expect(form < att && att < init, isTrue, reason: '${sdk.log}');
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('Android: no ATT call', (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock()..install();
      final AdsService ads = AdsService();
      await tester.runAsync(() => ads.start(adsRemoved: false));
      expect(sdk.log.where((String e) => e.startsWith('att:')), isEmpty);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });

  group('Banner placement', () {
    testWidgets(
        'free user: ONE shared banner strip on all four tabs (Cerca, Oggi, '
        'Quiz, Argomenti), loaded once, also while a word is spoken; pushed '
        'Settings and Paywall have no strip', (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock();
      await pumpT3App(tester, sdk: sdk);
      expect(sdk.count('MobileAds#initialize'), 1);

      for (final String tab in <String>[
        'tab-search',
        'tab-today',
        'tab-quiz',
        'tab-topics',
      ]) {
        await tapKey(tester, tab);
        expect(find.byKey(const ValueKey<String>('ad-banner-area')),
            findsOneWidget,
            reason: tab);
        expect(find.byKey(const ValueKey<String>('ad-reward-link')),
            findsOneWidget,
            reason: 'reward link under the banner on $tab');
      }
      // Search with a result and a tap on the audio button.
      await tapKey(tester, 'tab-search');
      await tester.enterText(find.byType(TextField).first, 'casa');
      await tester.pumpAndSettle();
      final Finder audio = find.byWidgetPredicate((Widget w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('audio'));
      if (audio.evaluate().isNotEmpty) {
        await tester.tap(audio.first);
        await tester.pumpAndSettle();
      }
      expect(find.byKey(const ValueKey<String>('ad-banner-area')),
          findsOneWidget);
      expect(sdk.count('loadBannerAd'), 1,
          reason: 'one shared banner, not one per tab: ${sdk.log}');

      await openSettings(tester);
      expect(find.byKey(const ValueKey<String>('ad-banner-area')),
          findsNothing,
          reason: 'Settings is a pushed screen without a strip');
      await tapKey(tester, 'settings-remove-ads');
      expect(find.byType(PaywallScreen), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('ad-banner-area')),
          findsNothing,
          reason: 'never an ad on the paywall');
      expect(sdk.count('loadBannerAd'), 1);
    });

    testWidgets('quiz result carries its own banner strip',
        (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock();
      await pumpT3App(tester, sdk: sdk);
      expect(sdk.count('loadBannerAd'), 1, reason: 'shell banner');
      await pushQuizResult(tester);
      expect(
        find.descendant(
          of: find.byType(QuizResultScreen),
          matching: find.byKey(const ValueKey<String>('ad-banner-area')),
        ),
        findsOneWidget,
      );
      expect(sdk.count('loadBannerAd'), 2, reason: 'shell + quiz result');
    });

    testWidgets('no banner strip on the quiz question or flashcard screens',
        (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock();
      await pumpT3App(tester, sdk: sdk);
      await tapKey(tester, 'tab-quiz');
      final Finder fruit =
          find.byKey(const ValueKey<String>('quiz-category:fruit'));
      await tester.scrollUntilVisible(fruit, 200,
          scrollable: find.byType(Scrollable).first);
      await tester.ensureVisible(fruit);
      await tester.pumpAndSettle();
      await tester.tap(fruit);
      await tester.pumpAndSettle();
      expect(find.byType(QuizPlayScreen), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('ad-banner-area')),
          findsNothing,
          reason: 'quiz question screen must have no ad');
      expect(
        find.descendant(
          of: find.byType(QuizPlayScreen),
          matching: find.byType(BannerAdSlot, skipOffstage: false),
          skipOffstage: false,
        ),
        findsNothing,
      );
      final int before = sdk.count('loadBannerAd');
      // Leave the quiz half-way: no interstitial.
      await goBack(tester);
      expect(sdk.count('showAdWithoutView'), 0);

      final List<Word> words =
          WordRepository.instance.byTopic('fruit').take(3).toList();
      Navigator.of(tester.element(find.byType(HomeShell))).push(
        MaterialPageRoute<void>(
          builder: (_) => FlashcardsScreen(words: words, title: 'Frutta'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey<String>('ad-banner-area')),
          findsNothing,
          reason: 'flashcard screen must have no ad');
      expect(
        find.descendant(
          of: find.byType(FlashcardsScreen),
          matching: find.byType(BannerAdSlot, skipOffstage: false),
          skipOffstage: false,
        ),
        findsNothing,
      );
      expect(sdk.count('loadBannerAd'), before,
          reason: 'no banner requested by quiz question / flashcards');
    });

    testWidgets(
        'reward hour: banner and link disappear on the tabs and on quiz '
        'result, no interstitial; they come back when the hour is over',
        (WidgetTester tester) async {
      final T3Clock clock = T3Clock(DateTime(2026, 10, 23, 10));
      final AdSdkMock sdk = AdSdkMock(
        loadedFormats: <String>{'loadInterstitialAd'},
      );
      final T3App app = await pumpT3App(tester, sdk: sdk, clock: clock.call);
      await tapKey(tester, 'tab-topics');
      expect(find.byKey(const ValueKey<String>('ad-reward-link')),
          findsOneWidget);
      final int bannersBefore = sdk.count('loadBannerAd');

      await app.ads.handleUserEarnedReward();
      await tester.pumpAndSettle();
      expect(app.ads.rewardActive, isTrue);
      expect(app.ads.shouldShowAds, isFalse);
      for (final String tab in <String>[
        'tab-search',
        'tab-today',
        'tab-quiz',
        'tab-topics',
      ]) {
        await tapKey(tester, tab);
        expect(find.byKey(const ValueKey<String>('ad-reward-link')),
            findsNothing,
            reason: tab);
        expect(tester.getSize(find.byType(BannerAdSlot)).height, 0,
            reason: tab);
      }
      clock.advance(const Duration(minutes: 30));
      await pushQuizResult(tester);
      expect(sdk.count('loadBannerAd'), bannersBefore,
          reason: 'no banner requested during the reward hour');
      expect(sdk.count('showAdWithoutView'), 0,
          reason: 'no interstitial during the reward hour');
      await goBack(tester);

      // The hour ends (AdsService adds 1 s grace to its timer).
      clock.advance(const Duration(minutes: 31));
      await tester.pump(const Duration(hours: 1, seconds: 2));
      await tester.pumpAndSettle();
      expect(app.ads.rewardActive, isFalse);
      expect(app.ads.shouldShowAds, isTrue);
      expect(sdk.count('loadBannerAd'), greaterThan(bannersBefore),
          reason: 'banner requested again after the hour');
    });

    testWidgets('a buyer gets no banner on Topics or quiz result and no '
        'interstitial', (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock();
      final T3App app = await pumpT3App(
        tester,
        sdk: sdk,
        initialPrefs: const <String, Object>{
          ...kLanguageChosen,
          PrefsService.kAdsRemoved: true,
        },
      );
      expect(app.ads.adsRemoved, isTrue);
      await tapKey(tester, 'tab-topics');
      await pushQuizResult(tester);
      expect(sdk.count('loadBannerAd'), 0);
      expect(sdk.count('loadInterstitialAd'), 0);
      expect(sdk.count('showAdWithoutView'), 0);
    });

    testWidgets('consent refused (canRequestAds false): no banner request',
        (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock(canRequestAds: false);
      await pumpT3App(tester, sdk: sdk);
      await tapKey(tester, 'tab-topics');
      expect(sdk.count('loadBannerAd'), 0,
          reason: 'banner requested although UMP says canRequestAds=false');
    });

    testWidgets(
        'buying remove_ads mid-session stops banners and interstitials '
        'without a restart', (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock();
      final T3App app = await pumpT3App(tester, sdk: sdk);
      await tapKey(tester, 'tab-topics');
      expect(sdk.count('loadBannerAd'), 1);

      await openSettings(tester);
      await tapKey(tester, 'settings-remove-ads');
      await tapKey(tester, 'paywall-buy');
      app.store.emit(<PurchaseDetails>[fakePurchase(PurchaseStatus.purchased)]);
      await tester.pumpAndSettle();
      expect(app.purchases.adsRemoved, isTrue);
      expect(
        app.ads.shouldShowAds,
        isFalse,
        reason: 'a purchase confirmed later on the store stream must turn '
            'the ads off at once (PurchaseService.linkAds)',
      );
      await goBack(tester);
      await tester.pumpAndSettle();
      await goBack(tester);
      await tester.pumpAndSettle();
      await pushQuizResult(tester);
      expect(sdk.count('loadBannerAd'), 1,
          reason: 'a new banner was requested after the purchase');
    });
  });

  group('Interstitial frequency', () {
    final DateTime start = DateTime(2026, 10, 21, 9);

    test('never in the first 3 minutes', () {
      for (final int s in <int>[0, 1, 60, 120, 179]) {
        expect(
          AdsService.interstitialAllowedAt(
            now: start.add(Duration(seconds: s)),
            startedAt: start,
          ),
          isFalse,
          reason: '$s s after launch',
        );
      }
      expect(
        AdsService.interstitialAllowedAt(
          now: start.add(const Duration(minutes: 3)),
          startedAt: start,
        ),
        isTrue,
      );
    });

    test('at most one every 3 minutes', () {
      final DateTime last = start.add(const Duration(minutes: 10));
      expect(
        AdsService.interstitialAllowedAt(
          now: last.add(const Duration(minutes: 2, seconds: 59)),
          startedAt: start,
          lastShown: last,
        ),
        isFalse,
      );
      expect(
        AdsService.interstitialAllowedAt(
          now: last.add(const Duration(minutes: 3)),
          startedAt: start,
          lastShown: last,
        ),
        isTrue,
      );
    });

    test('a clock moved backwards does not allow an early ad', () {
      // now before startedAt (user changed the phone clock): difference is
      // negative -> inMinutes < 3 -> blocked. Good.
      expect(
        AdsService.interstitialAllowedAt(
          now: start.subtract(const Duration(hours: 1)),
          startedAt: start,
        ),
        isFalse,
      );
    });

    testWidgets('a finished quiz in the first 3 minutes shows no interstitial',
        (WidgetTester tester) async {
      final AdSdkMock sdk = AdSdkMock();
      final T3App app = await pumpT3App(tester, sdk: sdk);
      expect(app.ads.shouldShowAds, isTrue);
      expect(app.ads.interstitialAllowed, isFalse);
      await pushQuizResult(tester);
      expect(sdk.count('showAdWithoutView'), 0);
    });

    testWidgets(
        'in-session timing with a moved clock: none in the first 3 min, then '
        'one, then none for 3 min, then one again', (WidgetTester tester) async {
      final T3Clock clock = T3Clock(DateTime(2026, 10, 23, 10));
      final AdSdkMock sdk = AdSdkMock(
        loadedFormats: <String>{'loadInterstitialAd'},
      );
      await pumpT3App(tester, sdk: sdk, clock: clock.call);

      Future<void> finishQuiz() async {
        await pushQuizResult(tester);
        await tester.pumpAndSettle();
        await goBack(tester);
      }

      clock.advance(const Duration(minutes: 2, seconds: 59));
      await finishQuiz();
      expect(sdk.count('showAdWithoutView'), 0, reason: 'quiet 3 minutes');

      clock.advance(const Duration(seconds: 1)); // 3:00 after launch
      await finishQuiz();
      expect(sdk.count('showAdWithoutView'), 1);

      clock.advance(const Duration(minutes: 2, seconds: 59));
      await finishQuiz();
      expect(sdk.count('showAdWithoutView'), 1, reason: '3-minute cap');

      clock.advance(const Duration(minutes: 1));
      await finishQuiz();
      expect(sdk.count('showAdWithoutView'), 2);
    });

    test(
        'interstitial is triggered only from the quiz result and the '
        'flashcard finish; banner strip hosts are the approved ones', () {
      final Set<String> callers = <String>{};
      final Set<String> bannerHosts = <String>{};
      for (final FileSystemEntity f
          in Directory('lib').listSync(recursive: true)) {
        if (f is! File || !f.path.endsWith('.dart')) continue;
        final String src = f.readAsStringSync();
        final String name = f.path.replaceAll('\\', '/');
        if (name.startsWith('lib/services/') || name.contains('/widgets/')) {
          continue;
        }
        if (src.contains('maybeShowInterstitial(')) callers.add(name);
        if (src.contains('AdBannerArea(') ||
            src.contains('WithAdBanner(') ||
            src.contains('BannerAdSlot(')) {
          bannerHosts.add(name);
        }
      }
      expect(callers, <String>{
        'lib/screens/quiz_result_screen.dart',
        'lib/screens/flashcards_screen.dart',
      });
      expect(bannerHosts, <String>{
        'lib/screens/home_shell.dart',
        'lib/screens/topic_detail_screen.dart',
        'lib/screens/word_detail_screen.dart',
        'lib/screens/big_entry_screen.dart',
        'lib/screens/quiz_result_screen.dart',
      });
    });
  });
}
