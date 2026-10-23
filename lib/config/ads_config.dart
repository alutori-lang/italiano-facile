import 'package:flutter/foundation.dart';

/// The ad formats the app uses.
enum AdFormat { banner, interstitial, appOpen, rewarded }

/// AdMob identifiers.
///
/// Release builds use the REAL ids of the AdMob account
/// (publisher pub-9396424020196768). Debug builds (`kDebugMode`, i.e.
/// `flutter run` and every test) automatically use Google's official TEST
/// ad units, so the owner never taps his own real ads while trying the app.
///
/// The app ids are written in android/app/src/main/AndroidManifest.xml and
/// ios/Runner/Info.plist too; they are always the real ones (Google allows
/// test ad units with a real app id).
class AdsConfig {
  const AdsConfig._();

  // ---------------------------------------------------------------- real ids
  static const String androidAppId = 'ca-app-pub-9396424020196768~5781867681';
  static const String iosAppId = 'ca-app-pub-9396424020196768~6384502911';

  static const String androidBannerReal =
      'ca-app-pub-9396424020196768/9358772739';
  static const String androidInterstitialReal =
      'ca-app-pub-9396424020196768/3747353400';
  static const String androidAppOpenReal =
      'ca-app-pub-9396424020196768/3994765416';
  static const String androidRewardedReal =
      'ca-app-pub-9396424020196768/7303455036';

  static const String iosBannerReal = 'ca-app-pub-9396424020196768/3611622038';
  static const String iosInterstitialReal =
      'ca-app-pub-9396424020196768/4485720005';
  static const String iosAppOpenReal = 'ca-app-pub-9396424020196768/8672377026';
  static const String iosRewardedReal =
      'ca-app-pub-9396424020196768/3423211932';

  // ----------------------------------------------- Google's official test ids
  static const String testPublisher = 'ca-app-pub-3940256099942544';

  static const String androidBannerTest =
      'ca-app-pub-3940256099942544/9214589741';
  static const String androidInterstitialTest =
      'ca-app-pub-3940256099942544/1033173712';
  static const String androidAppOpenTest =
      'ca-app-pub-3940256099942544/9257395921';
  static const String androidRewardedTest =
      'ca-app-pub-3940256099942544/5224354917';

  static const String iosBannerTest = 'ca-app-pub-3940256099942544/2435281174';
  static const String iosInterstitialTest =
      'ca-app-pub-3940256099942544/4411468910';
  static const String iosAppOpenTest = 'ca-app-pub-3940256099942544/5575463023';
  static const String iosRewardedTest =
      'ca-app-pub-3940256099942544/1712485313';

  /// True in debug builds: test ad units are used automatically.
  static bool get usingTestIds => kDebugMode;

  /// The ad unit for [format] on [platform]; [test] picks Google's test unit.
  /// Pure, so both the debug and the release choice can be checked.
  static String unitIdFor(
    AdFormat format, {
    required TargetPlatform platform,
    required bool test,
  }) {
    final bool ios = platform == TargetPlatform.iOS;
    switch (format) {
      case AdFormat.banner:
        return ios
            ? (test ? iosBannerTest : iosBannerReal)
            : (test ? androidBannerTest : androidBannerReal);
      case AdFormat.interstitial:
        return ios
            ? (test ? iosInterstitialTest : iosInterstitialReal)
            : (test ? androidInterstitialTest : androidInterstitialReal);
      case AdFormat.appOpen:
        return ios
            ? (test ? iosAppOpenTest : iosAppOpenReal)
            : (test ? androidAppOpenTest : androidAppOpenReal);
      case AdFormat.rewarded:
        return ios
            ? (test ? iosRewardedTest : iosRewardedReal)
            : (test ? androidRewardedTest : androidRewardedReal);
    }
  }

  static String _unit(AdFormat format) => unitIdFor(
        format,
        platform: defaultTargetPlatform,
        test: usingTestIds,
      );

  static String get bannerUnitId => _unit(AdFormat.banner);
  static String get interstitialUnitId => _unit(AdFormat.interstitial);
  static String get appOpenUnitId => _unit(AdFormat.appOpen);
  static String get rewardedUnitId => _unit(AdFormat.rewarded);

  static String get appId =>
      defaultTargetPlatform == TargetPlatform.iOS ? iosAppId : androidAppId;

  // ----------------------------------------------------------- interstitial
  /// Interstitials are never shown in the first [coldStartQuietMinutes]
  /// minutes after launch, and never more often than [minMinutesBetween].
  static const int coldStartQuietMinutes = 3;
  static const int minMinutesBetween = 3;

  // --------------------------------------------------------------- app open
  /// At most one app open ad every [appOpenMinGap].
  static const Duration appOpenMinGap = Duration(hours: 4);

  /// A preloaded app open ad is thrown away after this long (Google's limit).
  static const Duration appOpenAdExpiry = Duration(hours: 4);

  /// No app open ad within this long of another full-screen ad.
  static const Duration afterFullScreenQuiet = Duration(minutes: 1);

  /// How long the cold start waits for an app open ad to load.
  static const Duration appOpenLoadTimeout = Duration(seconds: 5);

  // --------------------------------------------------------------- rewarded
  /// What one rewarded video buys: this long without any ad.
  static const Duration rewardNoAdsDuration = Duration(hours: 1);
}
