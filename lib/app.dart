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
      locale: scope.settings.locale,
      supportedLocales: AppLocales.all,
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (
        List<Locale>? devices,
        Iterable<Locale> supported,
      ) {
        for (final Locale device in devices ?? const <Locale>[]) {
          final Locale resolved = AppLocales.resolve(device, supported);
          if (resolved.languageCode == device.languageCode) return resolved;
        }
        return const Locale('en');
      },
      // Flutter's own direction lookup only ever checks the language code
      // (see AppLocales.isRtl), so it does not know that Punjabi written in
      // the Shahmukhi script is right to left even though plain Punjabi is
      // not. This builder sits just inside MaterialApp's own Directionality
      // and replaces it with one driven by the full locale, script included,
      // for every screen in the app.
      builder: (BuildContext context, Widget? child) {
        final Locale active = Localizations.localeOf(context);
        return Directionality(
          textDirection:
              AppLocales.isRtl(active) ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: screenshot != null
          ? ScreenshotHost(screen: screenshot!)
          : const HomeShell(),
    );
  }
}
