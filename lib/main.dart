import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/screenshot_screens.dart';
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

  runApp(
    ItalianWordsApp(
      settings: settings,
      progress: progress,
      tts: tts,
      ads: ads,
      purchases: purchases,
      notifications: notifications,
      online: online,
      screenshot: screenshot,
    ),
  );

  // Everything below happens after the first frame, so startup stays fast
  // and the app is usable offline straight away.
  await tts.init();
  await purchases.init();
  ads.adsRemoved = purchases.adsRemoved;
  if (screenshot == null) {
    await ads.start(adsRemoved: purchases.adsRemoved);
    await ads.preloadInterstitial();
    await notifications.init();
  }
}
