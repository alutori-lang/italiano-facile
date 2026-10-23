// Fakes for the ad tests: the AdMob / UMP / ATT platform channels, with the
// ability to answer as the real SDK would (ad loaded, video watched, ...),
// a settable clock, and an app pump that runs the real startup.
//
// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart'
    show instanceManager;
import 'package:google_mobile_ads/src/ump/user_messaging_codec.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_app_651/app.dart';
import 'package:simple_flutter_app_651/services/ads_service.dart';
import 'package:simple_flutter_app_651/services/notification_service.dart';
import 'package:simple_flutter_app_651/services/online_lookup_service.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/services/progress_service.dart';
import 'package:simple_flutter_app_651/services/purchase_service.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';
import 'package:simple_flutter_app_651/services/tts_service.dart';

/// Saved state that skips the first-launch language sheet.
const Map<String, Object> kChosen = <String, Object>{
  PrefsService.kLocale: 'en',
};

/// A clock the test moves by hand.
class FakeClock {
  FakeClock(this.now);
  DateTime now;
  DateTime call() => now;
  void advance(Duration d) => now = now.add(d);
}

/// What the fake rewarded video does when it is shown.
enum VideoScript { watchedToTheEnd, closedEarly }

/// Mocks the ad SDK channels and records every call in order.
class FakeAdSdk {
  FakeAdSdk({
    this.canRequestAds = true,
    this.loadedFormats = const <String>{},
    this.video = VideoScript.watchedToTheEnd,
  });

  bool canRequestAds;

  /// Load methods ('loadRewardedAd', 'loadAppOpenAd', 'loadInterstitialAd')
  /// that answer "ad loaded", as the SDK does when an ad is available.
  Set<String> loadedFormats;

  VideoScript video;

  final List<String> log = <String>[];
  final List<MethodCall> calls = <MethodCall>[];
  final Map<int, String> _formatOf = <int, String>{};

  static final MethodChannel _ump = MethodChannel(
    'plugins.flutter.io/google_mobile_ads/ump',
    StandardMethodCodec(UserMessagingCodec()),
  );
  static const MethodChannel _att = MethodChannel('app_tracking_transparency');

  int count(String method) => log.where((String e) => e == method).length;

  TestDefaultBinaryMessenger get _messenger =>
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  /// Sends an ad event from the "platform" to the plugin.
  void _event(int adId, String eventName, [Map<String, Object?>? extra]) {
    final MethodChannel channel = instanceManager.channel;
    final ByteData data = channel.codec.encodeMethodCall(
      MethodCall('onAdEvent', <dynamic, dynamic>{
        'adId': adId,
        'eventName': eventName,
        ...?extra,
      }),
    );
    _messenger.handlePlatformMessage(channel.name, data, (ByteData? _) {});
  }

  void install() {
    _messenger.setMockMethodCallHandler(instanceManager.channel,
        (MethodCall call) async {
      log.add(call.method);
      calls.add(call);
      final Object? args = call.arguments;
      final int? adId = args is Map ? (args['adId'] as num?)?.toInt() : null;
      switch (call.method) {
        case 'MobileAds#initialize':
          return InitializationStatus(<String, AdapterStatus>{});
        case 'AdSize#getAnchoredAdaptiveBannerAdSize':
          return 60;
        case 'loadRewardedAd':
        case 'loadAppOpenAd':
        case 'loadInterstitialAd':
          if (adId != null) {
            _formatOf[adId] = call.method;
            if (loadedFormats.contains(call.method)) {
              scheduleMicrotask(() => _event(adId, 'onAdLoaded'));
            }
          }
          return null;
        case 'showAdWithoutView':
          if (adId != null) {
            final bool rewarded = _formatOf[adId] == 'loadRewardedAd';
            scheduleMicrotask(() {
              _event(adId, 'onAdShowedFullScreenContent');
              if (rewarded && video == VideoScript.watchedToTheEnd) {
                _event(adId, 'onRewardedAdUserEarnedReward', <String, Object?>{
                  'rewardItem': RewardItem(1, 'ora'),
                });
              }
              _event(adId, 'onAdDismissedFullScreenContent');
            });
          }
          return null;
        default:
          return null;
      }
    });
    _messenger.setMockMethodCallHandler(_ump, (MethodCall call) async {
      log.add('ump:${call.method.split('#').last}');
      switch (call.method) {
        case 'ConsentInformation#canRequestAds':
          return canRequestAds;
        case 'ConsentInformation#getConsentStatus':
          return canRequestAds ? 3 : 1;
        case 'ConsentInformation#getPrivacyOptionsRequirementStatus':
          return 1;
        case 'ConsentInformation#isConsentFormAvailable':
          return true;
        default:
          return null;
      }
    });
    _messenger.setMockMethodCallHandler(_att, (MethodCall call) async {
      if (call.method == 'getTrackingAuthorizationStatus') return 0;
      if (call.method == 'requestTrackingAuthorization') return 3;
      return null;
    });
    addTearDown(uninstall);
  }

  void uninstall() {
    _messenger.setMockMethodCallHandler(instanceManager.channel, null);
    _messenger.setMockMethodCallHandler(_ump, null);
    _messenger.setMockMethodCallHandler(_att, null);
  }
}

/// Lets queued microtasks and zero-length timers run in a plain `test`.
Future<void> settle() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

class AdsApp {
  AdsApp(this.prefs, this.ads, this.purchases);
  final PrefsService prefs;
  final AdsService ads;
  final PurchaseService purchases;
}

/// Pumps the real app and runs the same ad startup as main.dart.
Future<AdsApp> pumpAdsApp(
  WidgetTester tester, {
  required FakeAdSdk sdk,
  Map<String, Object> initialPrefs = kChosen,
  FakeClock? clock,
}) async {
  SharedPreferences.resetStatic();
  SharedPreferences.setMockInitialValues(
      Map<String, Object>.from(initialPrefs));
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  sdk.install();

  final PrefsService prefs = await PrefsService.open();
  final SettingsController settings = SettingsController(prefs);
  final AdsService ads = AdsService(prefs: prefs, clock: clock?.call);
  addTearDown(ads.dispose);
  final PurchaseService purchases = PurchaseService(prefs);

  await tester.pumpWidget(
    ItalianWordsApp(
      settings: settings,
      progress: ProgressService(prefs),
      tts: TtsService(),
      ads: ads,
      purchases: purchases,
      notifications: NotificationService(),
      online: OnlineLookupService(),
    ),
  );
  await tester.pump();

  bool done = false;
  Object? failure;
  () async {
    await ads.start(adsRemoved: purchases.adsRemoved);
    await ads.preloadInterstitial();
  }()
      .then((_) => done = true, onError: (Object e) {
    failure = e;
    done = true;
  });
  for (int i = 0; i < 200 && !done; i++) {
    await tester.pump(const Duration(milliseconds: 10));
  }
  if (failure != null) throw failure!;
  expect(done, isTrue, reason: 'ad startup did not finish');
  await tester.pumpAndSettle();
  return AdsApp(prefs, ads, purchases);
}

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey<String>(key)));
  await tester.pumpAndSettle();
}
