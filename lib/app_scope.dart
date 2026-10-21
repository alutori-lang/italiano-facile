import 'package:flutter/widgets.dart';

import 'models/learner_language.dart';
import 'services/ads_service.dart';
import 'services/notification_service.dart';
import 'services/online_lookup_service.dart';
import 'services/progress_service.dart';
import 'services/purchase_service.dart';
import 'services/settings_controller.dart';
import 'services/tts_service.dart';

/// Gives every screen the services it needs, without a third-party DI package.
class AppScope extends InheritedNotifier<Listenable> {
  AppScope({
    super.key,
    required this.settings,
    required this.progress,
    required this.tts,
    required this.ads,
    required this.purchases,
    required this.notifications,
    required this.online,
    required super.child,
  }) : super(
          notifier: Listenable.merge(<Listenable>[
            settings,
            progress,
            tts,
            ads,
            purchases,
          ]),
        );

  final SettingsController settings;
  final ProgressService progress;
  final TtsService tts;
  final AdsService ads;
  final PurchaseService purchases;
  final NotificationService notifications;
  final OnlineLookupService online;

  static AppScope of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this widget');
    return scope!;
  }

  /// The language the user picked for word translations.
  static LearnerLanguage languageOf(BuildContext context) =>
      of(context).settings.translationLanguage;
}
