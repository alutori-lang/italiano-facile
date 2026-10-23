// Tester 3 harness: fakes for the store, the ad SDK channels, notifications
// and the network, plus an app pump that lets every service be injected and
// a "restart" that rebuilds the services from the same saved preferences.
//
// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart'
    show instanceManager;
import 'package:google_mobile_ads/src/ump/user_messaging_codec.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_app_651/app.dart';
import 'package:simple_flutter_app_651/l10n/app_localizations.dart';
import 'package:simple_flutter_app_651/services/ads_service.dart';
import 'package:simple_flutter_app_651/services/notification_service.dart';
import 'package:simple_flutter_app_651/services/online_lookup_service.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/services/progress_service.dart';
import 'package:simple_flutter_app_651/services/purchase_service.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';
import 'package:simple_flutter_app_651/services/tts_service.dart';

/// The interface is always Italian.
final AppLocalizations it = lookupAppLocalizations(const Locale('it'));

/// Saved state that skips the first-launch language sheet.
const Map<String, Object> kLanguageChosen = <String, Object>{
  PrefsService.kLocale: 'en',
};

// ===================================================================== store

ProductDetails fakeProduct({String price = '3,99 €'}) => ProductDetails(
      id: 'remove_ads',
      title: 'Remove ads',
      description: 'Remove ads forever',
      price: price,
      rawPrice: 3.99,
      currencyCode: 'EUR',
    );

PurchaseDetails fakePurchase(
  PurchaseStatus status, {
  String productId = 'remove_ads',
  bool pendingComplete = true,
}) {
  final PurchaseDetails details = PurchaseDetails(
    purchaseID: 'GPA.1234',
    productID: productId,
    verificationData: PurchaseVerificationData(
      localVerificationData: 'local',
      serverVerificationData: 'server',
      source: 'fake',
    ),
    transactionDate: '1760000000000',
    status: status,
  );
  details.pendingCompletePurchase = pendingComplete;
  if (status == PurchaseStatus.error) {
    details.error = IAPError(
      source: 'fake',
      code: 'purchase_error',
      message: 'Card declined',
    );
  }
  return details;
}

/// A fake Google Play / App Store. Purchases come back through
/// [purchaseStream], exactly like the real plugin.
class FakeStore implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> controller =
      StreamController<List<PurchaseDetails>>.broadcast();

  bool available = true;
  bool throwOnAvailable = false;
  List<ProductDetails> products = <ProductDetails>[fakeProduct()];
  bool throwOnBuy = false;
  bool throwOnRestore = false;

  /// What the store answers to a restore. Empty = nothing bought before.
  List<PurchaseDetails> restoreReply = <PurchaseDetails>[];

  /// How long the store takes to answer a restore (a real store is slow).
  Duration restoreDelay = Duration.zero;

  final List<String> calls = <String>[];
  final List<PurchaseDetails> completed = <PurchaseDetails>[];

  void emit(List<PurchaseDetails> purchases) => controller.add(purchases);

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => controller.stream;

  @override
  Future<bool> isAvailable() async {
    calls.add('isAvailable');
    if (throwOnAvailable) {
      throw PlatformException(code: 'unavailable');
    }
    return available;
  }

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async {
    calls.add('query:${identifiers.join(',')}');
    return ProductDetailsResponse(
      productDetails: products,
      notFoundIDs: products.isEmpty ? identifiers.toList() : <String>[],
    );
  }

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    calls.add('buyNonConsumable:${purchaseParam.productDetails.id}');
    if (throwOnBuy) {
      throw PlatformException(code: 'BillingResponse.developerError');
    }
    return true;
  }

  @override
  Future<bool> buyConsumable({
    required PurchaseParam purchaseParam,
    bool autoConsume = true,
  }) async {
    calls.add('buyConsumable:${purchaseParam.productDetails.id}');
    return true;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    calls.add('complete:${purchase.status.name}');
    completed.add(purchase);
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    calls.add('restore');
    if (throwOnRestore) throw PlatformException(code: 'restore_failed');
    final List<PurchaseDetails> reply = restoreReply;
    if (reply.isEmpty) return;
    if (restoreDelay == Duration.zero) {
      emit(reply);
    } else {
      Timer(restoreDelay, () => emit(reply));
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ============================================================= notifications

class FakeNotifications extends NotificationService {
  final List<String> calls = <String>[];
  int? scheduledHour;
  int? scheduledMinute;

  @override
  Future<void> init() async => calls.add('init');

  @override
  Future<bool> requestPermission() async {
    calls.add('requestPermission');
    return true;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    calls.add('schedule:$hour:$minute');
    scheduledHour = hour;
    scheduledMinute = minute;
  }

  @override
  Future<void> cancel() async {
    calls.add('cancel');
    scheduledHour = null;
    scheduledMinute = null;
  }
}

// ================================================================ ad SDK mock

/// Mocks the AdMob, UMP and ATT platform channels and records every call, in
/// order, so tests can check what the app asked the SDK to do.
class AdSdkMock {
  AdSdkMock({
    this.canRequestAds = true,
    this.consentUpdateDelay = Duration.zero,
    this.initializeFails = false,
    this.loadedFormats = const <String>{},
  });

  /// Load methods ('loadInterstitialAd', 'loadRewardedAd', 'loadAppOpenAd')
  /// that answer "ad loaded" like the SDK does when an ad is available.
  Set<String> loadedFormats;
  final Map<int, String> _formatOf = <int, String>{};

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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(channel.name, data, (ByteData? _) {});
  }

  /// What UMP says after the consent flow.
  bool canRequestAds;

  /// How long requestConsentInfoUpdate takes to answer (a real device needs a
  /// network round trip).
  Duration consentUpdateDelay;

  bool initializeFails;

  final List<String> log = <String>[];

  static final MethodChannel _ump = MethodChannel(
    'plugins.flutter.io/google_mobile_ads/ump',
    StandardMethodCodec(UserMessagingCodec()),
  );
  static const MethodChannel _att = MethodChannel('app_tracking_transparency');

  int count(String method) => log.where((String e) => e == method).length;

  void install() {
    final TestDefaultBinaryMessenger messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(instanceManager.channel,
        (MethodCall call) async {
      log.add(call.method);
      switch (call.method) {
        case 'MobileAds#initialize':
          if (initializeFails) throw PlatformException(code: 'init');
          return InitializationStatus(<String, AdapterStatus>{});
        case 'AdSize#getAnchoredAdaptiveBannerAdSize':
          return 60;
        case 'loadInterstitialAd':
        case 'loadRewardedAd':
        case 'loadAppOpenAd':
          final Object? args = call.arguments;
          final int? adId =
              args is Map ? (args['adId'] as num?)?.toInt() : null;
          if (adId != null) {
            _formatOf[adId] = call.method;
            if (loadedFormats.contains(call.method)) {
              scheduleMicrotask(() => _event(adId, 'onAdLoaded'));
            }
          }
          return null;
        case 'showAdWithoutView':
          final Object? args = call.arguments;
          final int? adId =
              args is Map ? (args['adId'] as num?)?.toInt() : null;
          if (adId != null) {
            scheduleMicrotask(() {
              _event(adId, 'onAdShowedFullScreenContent');
              _event(adId, 'onAdDismissedFullScreenContent');
            });
          }
          return null;
        default:
          return null;
      }
    });
    messenger.setMockMethodCallHandler(_ump, (MethodCall call) async {
      final String name = call.method.split('#').last;
      log.add('ump:$name');
      switch (call.method) {
        case 'ConsentInformation#requestConsentInfoUpdate':
          if (consentUpdateDelay != Duration.zero) {
            await Future<void>.delayed(consentUpdateDelay);
          }
          log.add('ump:requestConsentInfoUpdate:done');
          return null;
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
    messenger.setMockMethodCallHandler(_att, (MethodCall call) async {
      log.add('att:${call.method}');
      if (call.method == 'getTrackingAuthorizationStatus') return 0;
      if (call.method == 'requestTrackingAuthorization') return 3;
      return null;
    });
    addTearDown(uninstall);
  }

  void uninstall() {
    final TestDefaultBinaryMessenger messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(instanceManager.channel, null);
    messenger.setMockMethodCallHandler(_ump, null);
    messenger.setMockMethodCallHandler(_att, null);
  }
}

// =================================================================== network

/// A client for which every request fails as if the phone were offline.
http.Client offlineClient() => MockClient((http.Request _) async {
      throw const SocketExceptionLike('Failed host lookup: it.wiktionary.org');
    });

class SocketExceptionLike implements Exception {
  const SocketExceptionLike(this.message);
  final String message;
  @override
  String toString() => 'SocketException: $message';
}

// ======================================================================= app

class T3App {
  T3App({
    required this.prefs,
    required this.settings,
    required this.progress,
    required this.tts,
    required this.ads,
    required this.purchases,
    required this.notifications,
    required this.online,
    required this.store,
    required this.sdk,
  });

  final PrefsService prefs;
  final SettingsController settings;
  final ProgressService progress;
  final TtsService tts;
  final AdsService ads;
  final PurchaseService purchases;
  final FakeNotifications notifications;
  final OnlineLookupService online;
  final FakeStore store;
  final AdSdkMock sdk;
}

/// Pumps the real app with injectable fakes. When [startServices] is true it
/// runs the same post-first-frame startup as main.dart (purchases.init, then
/// ads.start, then preloadInterstitial).
Future<T3App> pumpT3App(
  WidgetTester tester, {
  Map<String, Object> initialPrefs = kLanguageChosen,
  FakeStore? store,
  AdSdkMock? sdk,
  DateTime Function()? clock,
  http.Client? httpClient,
  bool startServices = true,
  bool keepPrefs = false,
  Size size = const Size(390, 844),
}) async {
  if (!keepPrefs) {
    SharedPreferences.resetStatic();
    SharedPreferences.setMockInitialValues(
      Map<String, Object>.from(initialPrefs),
    );
  }
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final FakeStore theStore = store ?? FakeStore();
  // The ad SDK channels are always mocked: without them the UMP plugin's
  // fire-and-forget calls throw MissingPluginException outside any try.
  final AdSdkMock theSdk = (sdk ?? AdSdkMock())..install();
  final PrefsService prefs = await PrefsService.open();
  final SettingsController settings = SettingsController(prefs);
  final ProgressService progress = ProgressService(prefs);
  final TtsService tts = TtsService();
  // Built as main.dart builds it (prefs: launch count, reward hour).
  final AdsService ads = AdsService(prefs: prefs, clock: clock);
  addTearDown(ads.dispose);
  final PurchaseService purchases = PurchaseService(prefs, iap: theStore);
  final FakeNotifications notifications = FakeNotifications();
  final OnlineLookupService online =
      OnlineLookupService(client: httpClient ?? offlineClient());

  await tester.pumpWidget(
    ItalianWordsApp(
      settings: settings,
      progress: progress,
      tts: tts,
      ads: ads,
      purchases: purchases,
      notifications: notifications,
      online: online,
    ),
  );
  await tester.pump();

  if (startServices) {
    // AdsService wraps the UMP calls in `Future(() {...})`, i.e. zero-length
    // timers, which only run when the fake clock moves: drive it with pumps
    // instead of awaiting directly (that would hang forever).
    bool done = false;
    Object? failure;
    () async {
      await purchases.init();
      ads.adsRemoved = purchases.adsRemoved;
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
    expect(done, isTrue, reason: 'app startup did not finish');
  }
  await tester.pumpAndSettle();

  return T3App(
    prefs: prefs,
    settings: settings,
    progress: progress,
    tts: tts,
    ads: ads,
    purchases: purchases,
    notifications: notifications,
    online: online,
    store: theStore,
    sdk: theSdk,
  );
}

/// Snapshot of everything saved on the "phone", to start the app again.
Future<Map<String, Object>> savedPrefs() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final Map<String, Object> out = <String, Object>{};
  for (final String key in sp.getKeys()) {
    final Object? value = sp.get(key);
    if (value is List) {
      out[key] = value.cast<String>().toList();
    } else if (value != null) {
      out[key] = value;
    }
  }
  return out;
}

/// Simulates killing the app and starting it again: a brand new
/// SharedPreferences instance loaded from what was saved, and brand new
/// services built on top of it.
Future<PrefsService> restartPrefs() async {
  final Map<String, Object> saved = await savedPrefs();
  SharedPreferences.resetStatic();
  SharedPreferences.setMockInitialValues(saved);
  return PrefsService.open();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  final Finder finder = find.byKey(ValueKey<String>(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> openSettings(WidgetTester tester) async {
  await tapKey(tester, 'tab-search');
  await tapKey(tester, 'search-settings');
}

/// Lets the binding run a real platform-dependent override safely.
void withPlatform(TargetPlatform platform) {
  debugDefaultTargetPlatformOverride = platform;
  addTearDown(() => debugDefaultTargetPlatformOverride = null);
}

/// Taps the AppBar back arrow. (WidgetTester.pageBack looks for the English
/// tooltip "Back"; the interface is Italian.)
Future<void> goBack(WidgetTester tester) async {
  await tester.tap(find.byType(BackButton).last);
  await tester.pumpAndSettle();
}

/// A clock the test moves by hand.
class T3Clock {
  T3Clock(this.now);
  DateTime now;
  DateTime call() => now;
  void advance(Duration d) => now = now.add(d);
}
