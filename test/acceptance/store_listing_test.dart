import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/config/app_config.dart';
import 'package:simple_flutter_app_651/config/monetization.dart';

Map<String, Object?> _json(String path) {
  final File file = File(path);
  expect(file.existsSync(), isTrue, reason: 'missing $path');
  return jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
}

void main() {
  const List<String> tags = <String>[
    'en', 'it', 'es', 'es-419', 'pt-BR', 'fr', 'de', 'hi', 'ar', 'id', 'ru',
    'ur', 'pa-Arab', 'pa', 'bn', 'si', 'zh',
  ];

  test('Store page: the Play listing has a title and both descriptions in '
      'every language', () {
    final Map<String, Object?> listing = _json('store/listing.json');
    expect(listing['packageName'], AppConfig.packageName);
    final Map<String, Object?> listings =
        listing['listings']! as Map<String, Object?>;
    for (final String tag in tags) {
      expect(listings.containsKey(tag), isTrue, reason: 'missing $tag');
      final Map<String, Object?> entry = listings[tag]! as Map<String, Object?>;
      final String title = entry['title']! as String;
      final String short = entry['shortDescription']! as String;
      final String full = entry['fullDescription']! as String;
      expect(title, AppConfig.appName);
      expect(title.length, lessThanOrEqualTo(30));
      expect(short.trim(), isNotEmpty, reason: '$tag short');
      // Google Play caps the short description at 80 characters.
      expect(short.length, lessThanOrEqualTo(80), reason: '$tag short is long');
      expect(full.length, greaterThan(300), reason: '$tag full is too short');
      expect(full.length, lessThanOrEqualTo(4000), reason: '$tag full is long');
    }
  });

  test('Store page: the Play listing declares the one purchase honestly', () {
    final Map<String, Object?> listing = _json('store/listing.json');
    expect(listing['containsAds'], isTrue);
    expect(listing['inAppPurchases'], isTrue);
    final List<Object?> products = listing['products']! as List<Object?>;
    expect(products.length, 1);
    final Map<String, Object?> product = products.first! as Map<String, Object?>;
    expect(product['id'], Monetization.removeAdsId);
    expect(product['price'], '3.99');
    expect(product['currency'], 'EUR');
  });

  test('Store page: the Apple listing has every language and the iOS id', () {
    final Map<String, Object?> apple = _json('store/apple_listing.json');
    expect(apple['bundleId'], AppConfig.packageName);
    final Map<String, Object?> locales =
        apple['localizations']! as Map<String, Object?>;
    for (final String tag in tags) {
      expect(locales.containsKey(tag), isTrue, reason: 'missing $tag');
      final Map<String, Object?> entry = locales[tag]! as Map<String, Object?>;
      expect((entry['name']! as String).length, lessThanOrEqualTo(30));
      // The App Store subtitle is capped at 30 characters, so the short text
      // doubles as the subtitle only where it fits; it must never be empty.
      expect((entry['subtitle']! as String).trim(), isNotEmpty);
      expect((entry['description']! as String).length, greaterThan(300));
    }
    final List<Object?> iaps = apple['inAppPurchases']! as List<Object?>;
    expect(iaps.length, 1);
    final Map<String, Object?> iap = iaps.first! as Map<String, Object?>;
    // On the App Store the id must be unique across the whole account.
    expect(iap['productId'], 'simple_flutter_app_651_remove_ads');
  });

  test('Store page: a publishable privacy policy exists', () {
    final File page = File('store/privacy-policy.html');
    expect(page.existsSync(), isTrue);
    final String html = page.readAsStringSync();
    expect(html, contains('Privacy Policy'));
    expect(html, contains('AdMob'));
    expect(html, contains('Wiktionary'));
    expect(html, contains('13'));
  });

  test('Store page: the acceptance list covers every promised feature', () {
    final File list = File('test/ACCEPTANCE.md');
    expect(list.existsSync(), isTrue);
    final String text = list.readAsStringSync();
    for (final String heading in <String>[
      '## Word data',
      '## Search',
      '## Today',
      '## Quiz',
      '## Topics',
      '## My words',
      '## Settings',
      '## Languages',
      '## Ads and purchase',
      '## Audio',
      '## Screenshot mode',
    ]) {
      expect(text, contains(heading), reason: 'ACCEPTANCE.md lost $heading');
    }
  });
}
