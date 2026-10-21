import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/screenshot_screens.dart';
import 'data/big_dictionary.dart';
import 'data/word_repository.dart';
import 'services/ads_service.dart';
import 'services/notification_service.dart';
import 'services/online_lookup_service.dart';
import 'services/prefs_service.dart';
import 'services/progress_service.dart';
import 'services/purchase_service.dart';
import 'services/settings_controller.dart';
import 'services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final PrefsService prefs = await PrefsService.open();
  await WordRepository.load();
  final SettingsController settings = SettingsController(prefs);
  final ProgressService progress = ProgressService(prefs);
  final TtsService tts = TtsService();
  final AdsService ads = AdsService();
  final PurchaseService purchases = PurchaseService(prefs);
  final NotificationService notifications = NotificationService();
  final OnlineLookupService online = OnlineLookupService();

  // Screenshot mode: on the web only, ?ember_screen=N opens one screen
  // directly. A normal launch is untouched.
  final ScreenshotScreen? screenshot = kIsWeb
      ? ScreenshotScreens.parse(Uri.base.queryParameters['ember_screen'])
      : null;

  // The big offline dictionary (sqflite): not on the web, where the
  // screenshot mode runs.
  final BigDictionary? big = kIsWeb ? null : BigDictionary();

  runApp(
    ItalianWordsApp(
      settings: settings,
      progress: progress,
      tts: tts,
      ads: ads,
      purchases: purchases,
      notifications: notifications,
      online: online,
      big: big,
      screenshot: screenshot,
    ),
  );

  // Everything below happens after the first frame, so startup stays fast
  // and the app is usable offline straight away.
  if (big != null) {
    // Copy on first launch, then index the chosen language in the
    // background; re-index when the user picks another language.
    unawaited(_startBigDictionary(big, settings));
  }
  await tts.init();
  await purchases.init();
  ads.adsRemoved = purchases.adsRemoved;

  if (screenshot == null) {
    await ads.start(adsRemoved: purchases.adsRemoved);
    await ads.preloadInterstitial();
    await notifications.init();
  }
}

/// Opens the big dictionary (copying it on first launch), indexes the chosen
/// language, follows later language changes and fetches server updates.
/// Never throws: the curated app works without it.
Future<void> _startBigDictionary(
  BigDictionary big,
  SettingsController settings,
) async {
  await big.start(settings.translationLanguage);
  settings.addListener(() {
    big.useLanguage(settings.translationLanguage);
  });
  await big.syncUpdates();
}
