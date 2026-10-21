import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_flutter_app_651/app.dart';
import 'package:simple_flutter_app_651/app_scope.dart';
import 'package:simple_flutter_app_651/config/screenshot_screens.dart';
import 'package:simple_flutter_app_651/l10n/app_localizations.dart';
import 'package:simple_flutter_app_651/services/ads_service.dart';
import 'package:simple_flutter_app_651/services/notification_service.dart';
import 'package:simple_flutter_app_651/services/online_lookup_service.dart';
import 'package:simple_flutter_app_651/services/prefs_service.dart';
import 'package:simple_flutter_app_651/services/progress_service.dart';
import 'package:simple_flutter_app_651/services/purchase_service.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';
import 'package:simple_flutter_app_651/services/tts_service.dart';
import 'package:simple_flutter_app_651/ui/theme.dart';

/// Everything a pumped app needs, so a test can read state back.
class TestHarness {
  TestHarness({
    required this.prefs,
    required this.settings,
    required this.progress,
    required this.tts,
    required this.ads,
    required this.purchases,
  });

  final PrefsService prefs;
  final SettingsController settings;
  final ProgressService progress;
  final TtsService tts;
  final AdsService ads;
  final PurchaseService purchases;
}

/// Builds the real app with real services on top of in-memory preferences.
/// No plugin is initialised, so nothing talks to a device.
///
/// The interface is always Italian. [locale] is the TRANSLATION language
/// (stored under `ui_locale`). By default English is pre-selected so the
/// non-dismissible first-launch language sheet does not cover the app.
/// To test the first-launch flow pass `firstLaunch: true` (or an explicit
/// `locale: null`): no translation language is chosen and the sheet opens.
/// A `ui_locale` already present in [initialPrefs] is kept as it is.
Future<TestHarness> pumpApp(
  WidgetTester tester, {
  Map<String, Object> initialPrefs = const <String, Object>{},
  Locale? locale = const Locale('en'),
  bool firstLaunch = false,
  Size size = const Size(390, 844),
  ScreenshotScreen? screenshot,
}) async {
  SharedPreferences.setMockInitialValues(
    Map<String, Object>.from(initialPrefs),
  );
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final PrefsService prefs = await PrefsService.open();
  final SettingsController settings = SettingsController(prefs);
  if (firstLaunch) {
    await settings.setLocale(null);
  } else if (locale != null &&
      !initialPrefs.containsKey(PrefsService.kLocale)) {
    await settings.setLocale(locale);
  }
  final ProgressService progress = ProgressService(prefs);
  final TtsService tts = TtsService();
  final AdsService ads = AdsService();
  final PurchaseService purchases = PurchaseService(prefs);

  await tester.pumpWidget(
    ItalianWordsApp(
      settings: settings,
      progress: progress,
      tts: tts,
      ads: ads,
      purchases: purchases,
      notifications: NotificationService(),
      online: OnlineLookupService(),
      screenshot: screenshot,
    ),
  );
  await tester.pumpAndSettle();

  return TestHarness(
    prefs: prefs,
    settings: settings,
    progress: progress,
    tts: tts,
    ads: ads,
    purchases: purchases,
  );
}

/// Scrolls within the Scrollable that belongs to [screenType] until [finder]
/// is visible.
///
/// Required any time more than one screen could be mounted at once — which,
/// with Flutter's own Navigator, is true from the moment anything has been
/// pushed: a covered route stays built (wrapped in an `Offstage`, see
/// `ModalRoute.maintainState`/`_ModalScopeState`) rather than torn down, so
/// its Scrollable stays findable by type. `WidgetController.scrollUntilVisible`
/// resolves `find.byType(Scrollable)` on its own otherwise, and its own docs
/// say the caller must specify which Scrollable to use whenever more than one
/// exists; this scopes that search to the screen actually being tested.
Future<void> scrollWithinScreen(
  WidgetTester tester,
  Type screenType,
  Finder finder, {
  double delta = 200,
}) {
  return tester.scrollUntilVisible(
    finder,
    delta,
    scrollable: find.descendant(
      of: find.byType(screenType),
      matching: find.byType(Scrollable),
    ),
  );
}

/// Pumps a single screen inside the app's scope, for screens that are not the
/// home shell. The interface is Italian, as in the real app; [translation]
/// is the translation language pre-selected for the screen.
Future<TestHarness> pumpScreen(
  WidgetTester tester,
  Widget Function(BuildContext context) builder, {
  Map<String, Object> initialPrefs = const <String, Object>{},
  Locale translation = const Locale('en'),
  Size size = const Size(390, 844),
}) async {
  SharedPreferences.setMockInitialValues(
    Map<String, Object>.from(initialPrefs),
  );
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final PrefsService prefs = await PrefsService.open();
  final SettingsController settings = SettingsController(prefs);
  if (!initialPrefs.containsKey(PrefsService.kLocale)) {
    await settings.setLocale(translation);
  }
  final ProgressService progress = ProgressService(prefs);
  final TtsService tts = TtsService();
  final AdsService ads = AdsService();
  final PurchaseService purchases = PurchaseService(prefs);

  await tester.pumpWidget(
    AppScope(
      settings: settings,
      progress: progress,
      tts: tts,
      ads: ads,
      purchases: purchases,
      notifications: NotificationService(),
      online: OnlineLookupService(),
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        locale: const Locale('it'),
        supportedLocales: AppLocales.all,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(builder: builder),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return TestHarness(
    prefs: prefs,
    settings: settings,
    progress: progress,
    tts: tts,
    ads: ads,
    purchases: purchases,
  );
}
