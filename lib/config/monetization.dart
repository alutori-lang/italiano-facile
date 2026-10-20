import 'package:flutter/foundation.dart';

/// The one and only purchase in the app: remove ads, once, forever.
class Monetization {
  const Monetization._();

  /// Plain (Android / Google Play) product id.
  static const String removeAdsId = 'remove_ads';

  /// On the App Store a product id must be unique across the whole developer
  /// account, so the iOS id is prefixed with the pubspec package name.
  static const String _iosPrefix = 'simple_flutter_app_651_';

  static String get removeAdsProductId =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? '$_iosPrefix$removeAdsId'
          : removeAdsId;

  static Set<String> get productIds => {removeAdsProductId};

  /// Fallback price label shown only while the store price is still loading.
  static const String removeAdsFallbackPrice = '€3.99';
}
