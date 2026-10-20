import 'package:flutter/foundation.dart';

/// AdMob identifiers.
///
/// The defaults are Google's official TEST ids, so the app works correctly
/// before real ids exist. Replace them with the real ones from the AdMob
/// console (and in android/app/src/main/AndroidManifest.xml and
/// ios/Runner/Info.plist) when they are available.
class AdsConfig {
  const AdsConfig._();

  // ---- App ids (also written in the Android manifest / iOS Info.plist) ----
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458002511';

  // ---- Banner ----
  static const String androidBanner = 'ca-app-pub-3940256099942544/9214589741';
  static const String iosBanner = 'ca-app-pub-3940256099942544/2435281174';

  // ---- Interstitial ----
  static const String androidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitial = 'ca-app-pub-3940256099942544/4411468910';

  /// Google's official test ids all start with this publisher id.
  static const String _testPublisher = 'ca-app-pub-3940256099942544';

  static bool get usingTestIds => androidBanner.startsWith(_testPublisher);

  static String get bannerUnitId =>
      defaultTargetPlatform == TargetPlatform.iOS ? iosBanner : androidBanner;

  static String get interstitialUnitId => defaultTargetPlatform == TargetPlatform.iOS
      ? iosInterstitial
      : androidInterstitial;

  static String get appId =>
      defaultTargetPlatform == TargetPlatform.iOS ? iosAppId : androidAppId;

  /// Interstitials are never shown in the first [coldStartQuietMinutes]
  /// minutes after launch, and never more often than [minMinutesBetween].
  static const int coldStartQuietMinutes = 3;
  static const int minMinutesBetween = 3;
}
