import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_scope.dart';
import 'config/screenshot_screens.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_shell.dart';
import 'screens/screenshot_host.dart';
import 'services/ads_service.dart';
import 'services/notification_service.dart';
import 'services/online_lookup_service.dart';
import 'services/progress_service.dart';
import 'services/purchase_service.dart';
import 'services/settings_controller.dart';
import 'services/tts_service.dart';
import 'ui/theme.dart';

class ItalianWordsApp extends StatelessWidget {
  const ItalianWordsApp({
    super.key,
    required this.settings,
    required this.progress,
    required this.tts,
    required this.ads,
    required this.purchases,
    required this.notifications,
    required this.online,
    this.screenshot,
  });

  final SettingsController settings;
  final ProgressService progress;
  final TtsService tts;
  final AdsService ads;
  final PurchaseService purchases;
  final NotificationService notifications;
  final OnlineLookupService online;

  /// Non-null only for the web screenshot mode.
  final ScreenshotScreen? screenshot;

  @override
  Widget build(BuildContext context) {
    purchases.linkAds(ads);
    return AppScope(
      settings: settings,
      progress: progress,
      tts: tts,
      ads: ads,
      purchases: purchases,
      notifications: notifications,
      online: online,
      child: _Root(screenshot: screenshot),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root({this.screenshot});

  final ScreenshotScreen? screenshot;

  @override
  Widget build(BuildContext context) {
    final AppScope scope = AppScope.of(context);
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: scope.settings.themeMode,
      // The whole interface is in Italian, always: the learner's own
      // language is used only for word translations (see
      // SettingsController.translationLanguage).
      locale: const Locale('it'),
      supportedLocales: AppLocales.all,
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: screenshot != null
          ? ScreenshotHost(screen: screenshot!)
          : const HomeShell(),
    );
  }
}
