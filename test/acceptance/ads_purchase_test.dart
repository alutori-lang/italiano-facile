import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/config/ads_config.dart';
import 'package:simple_flutter_app_651/screens/settings_screen.dart';
import 'package:simple_flutter_app_651/config/monetization.dart';
import 'package:simple_flutter_app_651/services/ads_service.dart';
import 'package:simple_flutter_app_651/ui/widgets/banner_ad_slot.dart';

import '../support/pump_app.dart';

void main() {
  test('Ads: Google test ad ids are used until real ones are configured', () {
    expect(AdsConfig.usingTestIds, isTrue);
    expect(AdsConfig.androidBanner, startsWith('ca-app-pub-3940256099942544'));
    expect(
      AdsConfig.androidInterstitial,
      startsWith('ca-app-pub-3940256099942544'),
    );
    expect(AdsConfig.androidAppId, startsWith('ca-app-pub-3940256099942544'));
    expect(AdsConfig.iosAppId, startsWith('ca-app-pub-3940256099942544'));
  });

  test('Ads: the app id in the config matches the Android manifest', () {
    final String manifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(manifest, contains('com.google.android.gms.ads.APPLICATION_ID'));
    expect(manifest, contains(AdsConfig.androidAppId));
  });

  test('Ads: the app id in the config matches the iOS Info.plist', () {
    final String plist = File('ios/Runner/Info.plist').readAsStringSync();
    expect(plist, contains('GADApplicationIdentifier'));
    expect(plist, contains(AdsConfig.iosAppId));
    // Apple rejects an app that declares tracking without asking.
    expect(plist, contains('NSUserTrackingUsageDescription'));
  });

  test('Ads: an interstitial is never shown in the first three minutes', () {
    final DateTime start = DateTime(2026, 10, 20, 9);
    expect(
      AdsService.interstitialAllowedAt(
        now: start,
        startedAt: start,
      ),
      isFalse,
    );
    expect(
      AdsService.interstitialAllowedAt(
        now: start.add(const Duration(minutes: 2, seconds: 59)),
        startedAt: start,
      ),
      isFalse,
    );
    expect(
      AdsService.interstitialAllowedAt(
        now: start.add(const Duration(minutes: 3)),
        startedAt: start,
      ),
      isTrue,
    );
  });

  test('Ads: an interstitial is never shown twice within three minutes', () {
    final DateTime start = DateTime(2026, 10, 20, 9);
    final DateTime shown = start.add(const Duration(minutes: 5));
    expect(
      AdsService.interstitialAllowedAt(
        now: shown.add(const Duration(minutes: 1)),
        startedAt: start,
        lastShown: shown,
      ),
      isFalse,
    );
    expect(
      AdsService.interstitialAllowedAt(
        now: shown.add(const Duration(minutes: 2, seconds: 59)),
        startedAt: start,
        lastShown: shown,
      ),
      isFalse,
    );
    expect(
      AdsService.interstitialAllowedAt(
        now: shown.add(const Duration(minutes: 3)),
        startedAt: start,
        lastShown: shown,
      ),
      isTrue,
    );
  });

  test('Ads: nothing is requested before consent and initialisation', () {
    final AdsService ads = AdsService();
    expect(ads.initialized, isFalse);
    expect(ads.consentGathered, isFalse);
    expect(ads.adsAllowed, isFalse);
    expect(ads.shouldShowAds, isFalse);
    expect(ads.interstitialAllowed, isFalse);
  });

  test('Ads: a user who bought remove_ads never sees an ad', () {
    final AdsService ads = AdsService()..adsRemoved = true;
    expect(ads.shouldShowAds, isFalse);
    expect(ads.interstitialAllowed, isFalse);
  });

  testWidgets('Ads: the banner slot renders nothing when ads are not allowed', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('tab-topics')));
    await tester.pumpAndSettle();

    expect(find.byType(BannerAdSlot), findsOneWidget);
    // No ad means an empty, zero-height slot — never a broken box.
    expect(
      tester.getSize(find.byType(BannerAdSlot)).height,
      0,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ads: Settings says setup is needed while test ids are used', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('search-settings')));
    await tester.pumpAndSettle();
    await scrollWithinScreen(
      tester,
      SettingsScreen,
      find.byKey(const ValueKey<String>('settings-ads-test-notice')),
    );
    expect(
      find.byKey(const ValueKey<String>('settings-ads-test-notice')),
      findsOneWidget,
    );
    expect(
      find.textContaining('la pubblicità usa ancora gli id di test di Google'),
      findsOneWidget,
    );
  });

  testWidgets('Ads: a paying user is not shown the setup notice', (
    WidgetTester tester,
  ) async {
    await pumpApp(
      tester,
      initialPrefs: <String, Object>{'ads_removed': true},
    );
    await tester.tap(find.byKey(const ValueKey<String>('search-settings')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('settings-ads-test-notice')),
      findsNothing,
    );
  });

  test('Purchase: the product id is plain on Android and prefixed on iOS', () {
    expect(Monetization.removeAdsId, 'remove_ads');
    final TargetPlatform? original = debugDefaultTargetPlatformOverride;
    addTearDown(() => debugDefaultTargetPlatformOverride = original);

    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(Monetization.removeAdsProductId, 'remove_ads');

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(
      Monetization.removeAdsProductId,
      'simple_flutter_app_651_remove_ads',
    );
  });

  test('Purchase: the product id set holds exactly one product', () {
    expect(Monetization.productIds.length, 1);
    expect(Monetization.removeAdsFallbackPrice, '€3.99');
  });

  testWidgets('Purchase: the entitlement survives a restart', (
    WidgetTester tester,
  ) async {
    final TestHarness first = await pumpApp(tester);
    expect(first.purchases.adsRemoved, isFalse);

    // What the store callback writes.
    await first.prefs.setBool('ads_removed', true);
    expect(first.purchases.adsRemoved, isTrue);

    final TestHarness second = await pumpApp(
      tester,
      initialPrefs: <String, Object>{'ads_removed': true},
    );
    expect(second.purchases.adsRemoved, isTrue);
    second.ads.adsRemoved = second.purchases.adsRemoved;
    expect(second.ads.shouldShowAds, isFalse);
  });

  testWidgets('Purchase: buying without a store shows a clear error', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey<String>('search-settings')));
    await tester.pumpAndSettle();
    await scrollWithinScreen(
      tester,
      SettingsScreen,
      find.byKey(const ValueKey<String>('settings-remove-ads')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('settings-remove-ads')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('paywall-buy')));
    await tester.pumpAndSettle();

    expect(
      find.text('Lo store non è disponibile in questo momento.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  test(
    'Purchase: buying remove_ads in the store sandbox removes the ads',
    () {},
    skip: 'needs a real device',
  );

  test(
    'Purchase: restore purchases brings the entitlement back on a new phone',
    () {},
    skip: 'needs a real device',
  );

  test(
    'Ads: the UMP consent form appears before any ad is loaded in the EU',
    () {},
    skip: 'needs a real device',
  );

  test(
    'Ads: the iOS App Tracking Transparency prompt appears before initialize',
    () {},
    skip: 'needs a real device',
  );
}

