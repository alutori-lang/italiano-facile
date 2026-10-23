// Ad rules: the debug test ids, the "1 hour without ads" reward, the app
// open ad frequency rules, and the shared banner on the four tabs.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_app_651/config/ads_config.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/screens/flashcards_screen.dart';
import 'package:simple_flutter_app_651/screens/home_shell.dart';
import 'package:simple_flutter_app_651/screens/quiz_play_screen.dart';
import 'package:simple_flutter_app_651/screens/settings_screen.dart';
import 'package:simple_flutter_app_651/screens/topic_detail_screen.dart';
import 'package:simple_flutter_app_651/services/ads_service.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/ui/widgets/ad_banner_area.dart';
import 'package:simple_flutter_app_651/ui/widgets/banner_ad_slot.dart';

import '../support/pump_app.dart' show scrollWithinScreen;
import 'ads_fakes.dart';

const String _testPub = 'ca-app-pub-3940256099942544/';
const String _realPub = 'ca-app-pub-9396424020196768/';

Future<PrefsService> _prefs([Map<String, Object> values = const {}]) async {
  SharedPreferences.resetStatic();
  SharedPreferences.setMockInitialValues(Map<String, Object>.from(values));
  return PrefsService.open();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => WordRepository.load());

  // ------------------------------------------------------------ test ids
  group('Debug builds use Google test ids', () {
    test('tests run in debug: every format resolves to a test unit', () {
      expect(kDebugMode, isTrue);
      expect(AdsConfig.usingTestIds, isTrue);
      for (final String id in <String>[
        AdsConfig.bannerUnitId,
        AdsConfig.interstitialUnitId,
        AdsConfig.appOpenUnitId,
        AdsConfig.rewardedUnitId,
      ]) {
        expect(id, startsWith(_testPub));
      }
    });

    test('release ids are the real AdMob units, platform by platform', () {
      String real(AdFormat f, TargetPlatform p) =>
          AdsConfig.unitIdFor(f, platform: p, test: false);
      const TargetPlatform a = TargetPlatform.android;
      const TargetPlatform i = TargetPlatform.iOS;
      expect(real(AdFormat.banner, a), '${_realPub}9358772739');
      expect(real(AdFormat.interstitial, a), '${_realPub}3747353400');
      expect(real(AdFormat.appOpen, a), '${_realPub}3994765416');
      expect(real(AdFormat.rewarded, a), '${_realPub}7303455036');
      expect(real(AdFormat.banner, i), '${_realPub}3611622038');
      expect(real(AdFormat.interstitial, i), '${_realPub}4485720005');
      expect(real(AdFormat.appOpen, i), '${_realPub}8672377026');
      expect(real(AdFormat.rewarded, i), '${_realPub}3423211932');
      for (final AdFormat f in AdFormat.values) {
        for (final TargetPlatform p in <TargetPlatform>[a, i]) {
          expect(
            AdsConfig.unitIdFor(f, platform: p, test: true),
            startsWith(_testPub),
          );
        }
      }
    });

    testWidgets('the banner request itself carries the test unit id',
        (WidgetTester tester) async {
      final FakeAdSdk sdk = FakeAdSdk();
      await pumpAdsApp(tester, sdk: sdk);
      final MethodCall load =
          sdk.calls.firstWhere((MethodCall c) => c.method == 'loadBannerAd');
      expect((load.arguments as Map)['adUnitId'], AdsConfig.androidBannerTest);
    });

    testWidgets('Settings shows the test-ids notice while test ids are used',
        (WidgetTester tester) async {
      await pumpAdsApp(tester, sdk: FakeAdSdk());
      await tapKey(tester, 'search-settings');
      await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-ads-test-notice')),
      );
      expect(
        find.byKey(const ValueKey<String>('settings-ads-test-notice')),
        findsOneWidget,
      );
    });
  });

  // ------------------------------------------------------------- reward
  group('Rewarded "1 ora senza pubblicità"', () {
    test(
        'a video watched to the end gives one hour without any ad, saved '
        'across a restart, and the ads come back after the hour', () async {
      final FakeAdSdk sdk = FakeAdSdk(loadedFormats: <String>{'loadRewardedAd'})
        ..install();
      final PrefsService prefs = await _prefs();
      final FakeClock clock = FakeClock(DateTime(2026, 10, 23, 10));
      final AdsService ads = AdsService(prefs: prefs, clock: clock.call);
      addTearDown(ads.dispose);
      await ads.start(adsRemoved: false);
      expect(ads.shouldShowAds, isTrue);
      expect(ads.rewardOfferAvailable, isTrue);

      await ads.preloadRewarded();
      await settle();
      expect(sdk.count('loadRewardedAd'), 1);

      expect(await ads.showRewardedForNoAds(), RewardOutcome.earned);
      await settle();
      expect(ads.rewardActive, isTrue);
      expect(ads.noAdsRemaining, const Duration(hours: 1));
      expect(ads.shouldShowAds, isFalse);
      expect(ads.interstitialAllowed, isFalse);
      expect(ads.rewardOfferAvailable, isFalse);
      expect(await ads.loadBanner(390), isNull);
      expect(
        prefs.getInt(PrefsService.kNoAdsUntil),
        DateTime(2026, 10, 23, 11).millisecondsSinceEpoch,
      );

      // A restart inside the hour keeps the ads off.
      final AdsService restarted = AdsService(prefs: prefs, clock: clock.call);
      addTearDown(restarted.dispose);
      expect(restarted.rewardActive, isTrue);

      clock.advance(const Duration(minutes: 59));
      expect(ads.rewardActive, isTrue);
      expect(ads.shouldShowAds, isFalse);
      clock.advance(const Duration(minutes: 1, seconds: 1));
      expect(ads.rewardActive, isFalse);
      expect(ads.shouldShowAds, isTrue);
      expect(ads.noAdsRemaining, Duration.zero);
    });

    test(
        'a video closed early gives nothing (only onUserEarnedReward '
        'grants the hour)', () async {
      FakeAdSdk(
        loadedFormats: <String>{'loadRewardedAd'},
        video: VideoScript.closedEarly,
      ).install();
      final PrefsService prefs = await _prefs();
      final AdsService ads = AdsService(prefs: prefs);
      addTearDown(ads.dispose);
      await ads.start(adsRemoved: false);
      await ads.preloadRewarded();
      await settle();
      expect(await ads.showRewardedForNoAds(), RewardOutcome.dismissed);
      await settle();
      expect(ads.rewardActive, isFalse);
      expect(ads.shouldShowAds, isTrue);
      expect(prefs.getInt(PrefsService.kNoAdsUntil), 0);
    });

    test('no video loaded: "not available", nothing granted', () async {
      FakeAdSdk().install();
      final AdsService ads = AdsService(prefs: await _prefs());
      addTearDown(ads.dispose);
      await ads.start(adsRemoved: false);
      expect(await ads.showRewardedForNoAds(), RewardOutcome.notAvailable);
      expect(ads.rewardActive, isFalse);
    });

    test('a buyer is never offered the video', () async {
      final FakeAdSdk sdk = FakeAdSdk(loadedFormats: <String>{'loadRewardedAd'})
        ..install();
      final AdsService ads = AdsService(prefs: await _prefs());
      addTearDown(ads.dispose);
      await ads.start(adsRemoved: true);
      await ads.preloadRewarded();
      expect(ads.rewardOfferAvailable, isFalse);
      expect(await ads.showRewardedForNoAds(), RewardOutcome.notAvailable);
      expect(sdk.count('loadRewardedAd'), 0);
    });

    test('the hour is granted only inside onUserEarnedReward', () {
      final String src =
          File('lib/services/ads_service.dart').readAsStringSync();
      final List<int> calls = RegExp(r'handleUserEarnedReward\(\)\s*;')
          .allMatches(src)
          .map((RegExpMatch m) => m.start)
          .toList();
      expect(calls.length, 1, reason: 'exactly one caller');
      final String before = src.substring(
          (calls.single - 200).clamp(0, src.length), calls.single);
      expect(before, contains('onUserEarnedReward:'));
    });

    testWidgets(
        'the link under the banner: Italian message when no video '
        'is ready', (WidgetTester tester) async {
      await pumpAdsApp(tester, sdk: FakeAdSdk());
      expect(
          find.byKey(const ValueKey<String>('ad-reward-link')), findsOneWidget);
      expect(
        find.text('Togli la pubblicità per 1 ora (guarda un video)'),
        findsOneWidget,
      );
      await tapKey(tester, 'ad-reward-link');
      expect(find.text('Video non disponibile, riprova più tardi'),
          findsOneWidget);
    });

    testWidgets(
        'while the hour runs: no banner, no link, Settings shows '
        'the time left; after the hour the banner comes back',
        (WidgetTester tester) async {
      final FakeClock clock = FakeClock(DateTime(2026, 10, 23, 10));
      final FakeAdSdk sdk = FakeAdSdk();
      final AdsApp app = await pumpAdsApp(tester, sdk: sdk, clock: clock);
      expect(sdk.count('loadBannerAd'), 1);

      await app.ads.handleUserEarnedReward();
      await tester.pumpAndSettle();
      expect(
          find.byKey(const ValueKey<String>('ad-reward-link')), findsNothing);

      await tapKey(tester, 'search-settings');
      await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-reward-no-ads')),
      );
      expect(find.text('Ancora 60 min senza pubblicità'), findsOneWidget);
      expect(find.text('Pubblicità spenta'), findsOneWidget);
      Navigator.of(tester.element(find.byType(SettingsScreen))).pop();
      await tester.pumpAndSettle();

      clock.advance(const Duration(hours: 1, seconds: 2));
      await tester.pump(const Duration(hours: 1, seconds: 2));
      await tester.pumpAndSettle();
      expect(app.ads.rewardActive, isFalse);
      expect(sdk.count('loadBannerAd'), 2, reason: 'banner reloaded');
      expect(
          find.byKey(const ValueKey<String>('ad-reward-link')), findsOneWidget);
    });

    testWidgets('Settings offers the video to a free user', (
      WidgetTester tester,
    ) async {
      await pumpAdsApp(tester, sdk: FakeAdSdk());
      await tapKey(tester, 'search-settings');
      await scrollWithinScreen(
        tester,
        SettingsScreen,
        find.byKey(const ValueKey<String>('settings-reward-no-ads')),
      );
      expect(find.text('1 ora senza pubblicità'), findsOneWidget);
      await tapKey(tester, 'settings-reward-no-ads');
      expect(find.text('Video non disponibile, riprova più tardi'),
          findsOneWidget);
    });
  });

  // ------------------------------------------------------------ app open
  group('App open ad', () {
    final DateTime t0 = DateTime(2026, 10, 23, 9);

    test('frequency rules', () {
      bool ok({
        int launches = 5,
        DateTime? last,
        DateTime? fullScreen,
        bool showing = false,
        bool firstUi = false,
        DateTime? now,
      }) =>
          AdsService.appOpenAllowedAt(
            now: now ?? t0,
            launchCount: launches,
            lastShown: last,
            lastFullScreen: fullScreen,
            fullScreenShowing: showing,
            firstLaunchUi: firstUi,
          );

      expect(ok(), isTrue);
      // Never in the very first session ever.
      expect(ok(launches: 0), isFalse);
      expect(ok(launches: 1), isFalse);
      expect(ok(launches: 2), isTrue);
      // Never while the first-launch language picker is needed.
      expect(ok(firstUi: true), isFalse);
      // At most once every 4 hours.
      expect(ok(last: t0.subtract(const Duration(hours: 3, minutes: 59))),
          isFalse);
      expect(ok(last: t0.subtract(const Duration(hours: 4))), isTrue);
      // Never right after another full-screen ad, nor during one.
      expect(ok(fullScreen: t0.subtract(const Duration(seconds: 20))), isFalse);
      expect(ok(fullScreen: t0.subtract(const Duration(minutes: 2))), isTrue);
      expect(ok(showing: true), isFalse);
    });

    test('a preloaded app open ad expires after 4 hours', () {
      expect(
        AdsService.appOpenAdFresh(
          loadedAt: t0,
          now: t0.add(const Duration(hours: 3, minutes: 59)),
        ),
        isTrue,
      );
      expect(
        AdsService.appOpenAdFresh(
          loadedAt: t0,
          now: t0.add(const Duration(hours: 4)),
        ),
        isFalse,
      );
    });

    test('first launch ever: nothing is even loaded', () async {
      final FakeAdSdk sdk = FakeAdSdk(loadedFormats: <String>{'loadAppOpenAd'})
        ..install();
      final AdsService ads = AdsService(prefs: await _prefs());
      addTearDown(ads.dispose);
      await ads.start(adsRemoved: false);
      expect(ads.launchCount, 1);
      expect(await ads.showAppOpenOnColdStart(), isFalse);
      expect(sdk.count('loadAppOpenAd'), 0);
    });

    test(
        'later cold starts: shown, then not again for 4 hours, and only '
        'once per launch', () async {
      final FakeAdSdk sdk = FakeAdSdk(loadedFormats: <String>{'loadAppOpenAd'})
        ..install();
      final PrefsService prefs =
          await _prefs(<String, Object>{PrefsService.kAdsLaunches: 1});
      final FakeClock clock = FakeClock(t0);

      final AdsService second = AdsService(prefs: prefs, clock: clock.call);
      addTearDown(second.dispose);
      await second.start(adsRemoved: false);
      expect(await second.showAppOpenOnColdStart(), isTrue);
      expect(sdk.count('showAdWithoutView'), 1);
      expect(
          prefs.getInt(PrefsService.kAppOpenLast), t0.millisecondsSinceEpoch);
      // Cold start only: a second call in the same launch does nothing.
      expect(await second.showAppOpenOnColdStart(), isFalse);

      clock.advance(const Duration(hours: 1));
      final AdsService third = AdsService(prefs: prefs, clock: clock.call);
      addTearDown(third.dispose);
      await third.start(adsRemoved: false);
      expect(await third.showAppOpenOnColdStart(), isFalse);
      expect(sdk.count('showAdWithoutView'), 1);

      clock.advance(const Duration(hours: 3, minutes: 1));
      final AdsService fourth = AdsService(prefs: prefs, clock: clock.call);
      addTearDown(fourth.dispose);
      await fourth.start(adsRemoved: false);
      expect(await fourth.showAppOpenOnColdStart(), isTrue);
      expect(sdk.count('showAdWithoutView'), 2);
    });

    test(
        'no app open ad for a buyer, during the reward hour, or with the '
        'language picker open', () async {
      final FakeAdSdk sdk = FakeAdSdk(loadedFormats: <String>{'loadAppOpenAd'})
        ..install();
      final PrefsService prefs =
          await _prefs(<String, Object>{PrefsService.kAdsLaunches: 3});

      final AdsService buyer = AdsService(prefs: prefs);
      addTearDown(buyer.dispose);
      await buyer.start(adsRemoved: true);
      expect(await buyer.showAppOpenOnColdStart(), isFalse);

      final AdsService rewarded = AdsService(prefs: prefs);
      addTearDown(rewarded.dispose);
      await rewarded.start(adsRemoved: false);
      await rewarded.handleUserEarnedReward();
      expect(await rewarded.showAppOpenOnColdStart(), isFalse);
      await prefs.remove(PrefsService.kNoAdsUntil);

      final AdsService picker = AdsService(prefs: prefs);
      addTearDown(picker.dispose);
      await picker.start(adsRemoved: false);
      expect(await picker.showAppOpenOnColdStart(firstLaunchUi: true), isFalse);

      expect(sdk.count('loadAppOpenAd'), 0);
    });
  });

  // -------------------------------------------------------------- banner
  group('Shared banner', () {
    const List<String> tabs = <String>[
      'tab-search',
      'tab-today',
      'tab-quiz',
      'tab-topics',
    ];

    testWidgets(
        'free user: one shared banner on all four tabs, above the '
        'bottom bar, loaded once', (WidgetTester tester) async {
      final FakeAdSdk sdk = FakeAdSdk();
      await pumpAdsApp(tester, sdk: sdk);
      for (final String tab in tabs) {
        await tapKey(tester, tab);
        expect(find.byType(BannerAdSlot), findsOneWidget, reason: tab);
        expect(find.byKey(const ValueKey<String>('ad-reward-link')),
            findsOneWidget,
            reason: tab);
        // The strip sits above the bottom navigation bar.
        expect(
          tester.getBottomLeft(find.byType(AdBannerArea)).dy,
          lessThanOrEqualTo(
            tester
                .getTopLeft(find.byKey(const ValueKey<String>('bottom-nav')))
                .dy,
          ),
        );
        expect(tester.takeException(), isNull, reason: tab);
      }
      expect(sdk.count('loadBannerAd'), 1, reason: 'one shared banner');
    });

    testWidgets('buyer: no banner request and no link on any tab',
        (WidgetTester tester) async {
      final FakeAdSdk sdk = FakeAdSdk();
      await pumpAdsApp(
        tester,
        sdk: sdk,
        initialPrefs: const <String, Object>{
          ...kChosen,
          PrefsService.kAdsRemoved: true,
        },
      );
      for (final String tab in tabs) {
        await tapKey(tester, tab);
        expect(
            find.byKey(const ValueKey<String>('ad-reward-link')), findsNothing,
            reason: tab);
        expect(tester.getSize(find.byType(BannerAdSlot)).height, 0);
      }
      expect(sdk.count('loadBannerAd'), 0);
      expect(sdk.count('loadRewardedAd'), 0);
    });

    testWidgets('detail screens carry the strip; a quiz question never does',
        (WidgetTester tester) async {
      await pumpAdsApp(tester, sdk: FakeAdSdk());
      await tapKey(tester, 'tab-topics');
      final String topicId = WordRepository.instance.topicsWithWords.first.id;
      await tapKey(tester, 'topic:$topicId');
      expect(
        find.descendant(
          of: find.byType(TopicDetailScreen),
          matching: find.byType(AdBannerArea),
        ),
        findsOneWidget,
      );

      final List<Word> pool = WordRepository.instance.byTopic(topicId);
      Navigator.of(tester.element(find.byType(TopicDetailScreen))).push(
        MaterialPageRoute<void>(
          builder: (_) => QuizPlayScreen(
            pool: pool,
            categoryId: topicId,
            categoryLabel: 'x',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(QuizPlayScreen),
          matching: find.byType(AdBannerArea),
        ),
        findsNothing,
      );
    });
  });

  // -------------------------------------------------------- interstitial
  group('Interstitial after a flashcard deck', () {
    testWidgets(
        'finishing a deck after the quiet minutes shows one; the '
        'cap is shared', (WidgetTester tester) async {
      final FakeClock clock = FakeClock(DateTime(2026, 10, 23, 10));
      final FakeAdSdk sdk =
          FakeAdSdk(loadedFormats: <String>{'loadInterstitialAd'});
      final AdsApp app = await pumpAdsApp(tester, sdk: sdk, clock: clock);
      await tester.pumpAndSettle();
      clock.advance(const Duration(minutes: 4));
      expect(app.ads.interstitialAllowed, isTrue);

      Future<void> runDeck() async {
        final List<Word> words =
            WordRepository.instance.byTopic('fruit').take(2).toList();
        Navigator.of(tester.element(find.byType(HomeShell))).push(
          MaterialPageRoute<void>(
            builder: (_) => FlashcardsScreen(words: words, title: 'Frutta'),
          ),
        );
        await tester.pumpAndSettle();
        await tapKey(tester, 'flashcards-next');
        await tapKey(tester, 'flashcards-next');
        expect(find.byType(FlashcardsScreen), findsNothing);
      }

      await runDeck();
      expect(sdk.count('showAdWithoutView'), 1);
      // A second deck right away: blocked by the shared 3-minute cap.
      await runDeck();
      expect(sdk.count('showAdWithoutView'), 1);
    });
  });
}
