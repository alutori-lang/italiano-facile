import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../config/ads_config.dart';
import '../l10n/app_localizations.dart';
import '../models/learner_language.dart';
import '../services/settings_controller.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';
import 'about_screen.dart';
import 'paywall_screen.dart';
import 'privacy_screen.dart';

/// Translation language, audio speed, reminder, dark mode, reset, remove ads,
/// restore purchases, privacy and about.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// Confirmation after a reset or a restore, shown in the page itself. A
  /// toast would vanish after a few seconds, which is no good for a message
  /// that says progress has just been deleted.
  String? _status;

  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _showStatus(String message) {
    if (!mounted) return;
    setState(() => _status = message);
    // The strip sits at the top of the list; on a short phone the user has
    // scrolled down to the button they tapped, so bring the message into view.
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final AppScope scope = AppScope.of(context);
    final SettingsController settings = scope.settings;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(t.settingsTitle)),
      body: SafeArea(
        // Four compact cards that fit on one screen: every setting is one tap
        // away, with no hunting through a long scroll.
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(
            AppSpace.l,
            AppSpace.s,
            AppSpace.l,
            AppSpace.xl,
          ),
          children: <Widget>[
            if (_status != null)
              _StatusStrip(
                message: _status!,
                onDismiss: () => setState(() => _status = null),
              ),
            _SettingsCard(
              children: <Widget>[
                ListTile(
                  key: const ValueKey<String>('settings-language'),
                  dense: true,
                  leading: const Icon(Icons.translate_rounded),
                  title: Text(t.interfaceLanguage),
                  subtitle: Text(translationLanguageLabel(t, settings)),
                  trailing: const MirroredIcon(Icons.chevron_right_rounded),
                  onTap: () => showTranslationLanguagePicker(context),
                ),
                SwitchListTile(
                  key: const ValueKey<String>('settings-slow-audio'),
                  dense: true,
                  value: settings.slowAudio,
                  onChanged: settings.setSlowAudio,
                  title: Text(t.audioSpeed),
                  subtitle: Text(settings.slowAudio ? t.listenSlow : t.listen),
                  secondary: const Icon(Icons.record_voice_over_rounded),
                ),
                SwitchListTile(
                  key: const ValueKey<String>('settings-dark-mode'),
                  dense: true,
                  value: settings.dark,
                  onChanged: settings.setDark,
                  title: Text(t.darkMode),
                  secondary: const Icon(Icons.dark_mode_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.m),
            _SettingsCard(
              children: <Widget>[
                SwitchListTile(
                  key: const ValueKey<String>('settings-reminder'),
                  dense: true,
                  value: settings.reminderOn,
                  onChanged: (bool value) => _toggleReminder(context, value),
                  title: Text(t.dailyReminder),
                  secondary: const Icon(Icons.notifications_rounded),
                ),
                ListTile(
                  key: const ValueKey<String>('settings-reminder-time'),
                  dense: true,
                  enabled: settings.reminderOn,
                  leading: const Icon(Icons.schedule_rounded),
                  title: Text(t.reminderTime),
                  subtitle: Text(_formatTime(settings)),
                  trailing: const MirroredIcon(Icons.chevron_right_rounded),
                  onTap: settings.reminderOn ? () => _pickTime(context) : null,
                ),
              ],
            ),
            const SizedBox(height: AppSpace.m),
            if (AdsConfig.usingTestIds && !scope.purchases.adsRemoved)
              _TestAdsNotice(message: t.adsTestIdsNotice),
            _SettingsCard(
              children: <Widget>[
                ListTile(
                  key: const ValueKey<String>('settings-remove-ads'),
                  dense: true,
                  leading: const Icon(Icons.block_rounded),
                  title: Text(t.removeAds),
                  subtitle: Text(
                    scope.purchases.adsRemoved
                        ? t.adsRemoved
                        : scope.purchases.removeAdsPrice,
                  ),
                  trailing: const MirroredIcon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PaywallScreen(),
                    ),
                  ),
                ),
                ListTile(
                  key: const ValueKey<String>('settings-restore'),
                  dense: true,
                  leading: const Icon(Icons.restore_rounded),
                  title: Text(t.restorePurchases),
                  onTap: () => _restore(context),
                ),
                ListTile(
                  key: const ValueKey<String>('settings-ads-consent'),
                  dense: true,
                  leading: const Icon(Icons.privacy_tip_rounded),
                  title: Text(t.adsConsentChange),
                  onTap: scope.ads.showPrivacyOptions,
                ),
              ],
            ),
            const SizedBox(height: AppSpace.m),
            _SettingsCard(
              children: <Widget>[
                ListTile(
                  key: const ValueKey<String>('settings-privacy'),
                  dense: true,
                  leading: const Icon(Icons.shield_rounded),
                  title: Text(t.privacy),
                  trailing: const MirroredIcon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PrivacyScreen(),
                    ),
                  ),
                ),
                ListTile(
                  key: const ValueKey<String>('settings-about'),
                  dense: true,
                  leading: const Icon(Icons.info_rounded),
                  title: Text(t.about),
                  trailing: const MirroredIcon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AboutScreen(),
                    ),
                  ),
                ),
                ListTile(
                  key: const ValueKey<String>('settings-reset'),
                  dense: true,
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.wrong,
                  ),
                  title: Text(t.resetProgress),
                  onTap: () => _confirmReset(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(SettingsController settings) {
    final String hour = settings.reminderHour.toString().padLeft(2, '0');
    final String minute = settings.reminderMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _toggleReminder(BuildContext context, bool value) async {
    final AppScope scope = AppScope.of(context);
    final AppLocalizations t = AppLocalizations.of(context);
    if (!value) {
      await scope.settings.setReminder(on: false);
      await scope.notifications.cancel();
      return;
    }
    await scope.notifications.requestPermission();
    await scope.settings.setReminder(on: true);
    await scope.notifications.scheduleDaily(
      hour: scope.settings.reminderHour,
      minute: scope.settings.reminderMinute,
      title: t.todayTitle,
      body: t.reminderBody,
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final AppScope scope = AppScope.of(context);
    final AppLocalizations t = AppLocalizations.of(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: scope.settings.reminderTime,
    );
    if (picked == null) return;
    await scope.settings.setReminder(on: true, at: picked);
    await scope.notifications.scheduleDaily(
      hour: picked.hour,
      minute: picked.minute,
      title: t.todayTitle,
      body: t.reminderBody,
    );
  }

  Future<void> _restore(BuildContext context) async {
    final AppScope scope = AppScope.of(context);
    final AppLocalizations t = AppLocalizations.of(context);
    if (!scope.purchases.supportedOnThisPlatform) {
      _showStatus(t.webPurchaseNotice);
      return;
    }
    await scope.purchases.restore();
    scope.ads.adsRemoved = scope.purchases.adsRemoved;
    _showStatus(
      scope.purchases.adsRemoved ? t.adsRemoved : t.nothingToRestore,
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final AppScope scope = AppScope.of(context);
    final AppLocalizations t = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(t.resetProgress),
        content: Text(t.resetProgressConfirm),
        actions: <Widget>[
          TextButton(
            key: const ValueKey<String>('reset-cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.cancel),
          ),
          FilledButton(
            key: const ValueKey<String>('reset-confirm'),
            // The app-wide style makes buttons full width, which inside a
            // dialog's action bar would push the pair off the edge.
            style: FilledButton.styleFrom(
              minimumSize: const Size(96, 44),
              backgroundColor: AppColors.wrong,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await scope.progress.reset();
    _showStatus(t.resetDone);
  }
}

/// The interface locale that stands for [settings.translationLanguage].
Locale _translationLocale(SettingsController settings) =>
    AppLocales.primary.firstWhere(
      (Locale l) =>
          LearnerLanguage.forLocale(l) == settings.translationLanguage,
      orElse: () => AppLocales.primary.first,
    );

/// The name of the chosen translation language, in that language itself.
String translationLanguageLabel(
  AppLocalizations t,
  SettingsController settings,
) =>
    languageLabel(t, _translationLocale(settings));

/// Lets the user pick the one language that word translations are shown in.
/// At first launch it is not dismissible, so a choice is always made.
Future<void> showTranslationLanguagePicker(
  BuildContext context, {
  bool firstLaunch = false,
}) async {
  final AppLocalizations t = AppLocalizations.of(context);
  final SettingsController settings = AppScope.of(context).settings;
  final String current = AppLocales.tag(_translationLocale(settings));
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: !firstLaunch,
    isDismissible: !firstLaunch,
    enableDrag: !firstLaunch,
    isScrollControlled: true,
    builder: (BuildContext sheetContext) {
      // At first launch even the system back button must not skip the
      // choice: the sheet closes only when a language is picked.
      return PopScope(
        canPop: !firstLaunch,
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.xl,
                  AppSpace.l,
                  AppSpace.xl,
                  AppSpace.s,
                ),
                child: Text(
                  t.interfaceLanguage,
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.xl,
                  0,
                  AppSpace.xl,
                  AppSpace.m,
                ),
                child: Text(
                  t.languageNoteWordTranslations,
                  style: Theme.of(sheetContext).textTheme.bodySmall,
                ),
              ),
              for (final Locale locale in AppLocales.primary)
                _LanguageOption(
                  locale: locale,
                  label: languageLabel(t, locale),
                  selected: !firstLaunch && AppLocales.tag(locale) == current,
                  onTap: () {
                    settings.setLocale(locale);
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}

/// The name of each language, written in that language itself.
String languageLabel(AppLocalizations t, Locale locale) {
  final String tag = AppLocales.tag(locale);
  switch (tag) {
    case 'en':
      return t.langEn;
    case 'ur':
      return t.langUr;
    case 'pa_Arab':
      return t.langPaArab;
    case 'pa':
      return t.langPa;
    case 'bn':
      return t.langBn;
    case 'si':
      return t.langSi;
    case 'zh':
      return t.langZh;
    case 'fr':
      return t.langFr;
    case 'es_ES':
      return t.langEs;
    case 'es_419':
      return t.langEs419;
    case 'it':
      return t.langIt;
    case 'pt':
      return t.langPt;
    case 'de':
      return t.langDe;
    case 'hi':
      return t.langHi;
    case 'ar':
      return t.langAr;
    case 'id':
      return t.langId;
    case 'ru':
      return t.langRu;
    default:
      return tag;
  }
}

/// A card of settings rows with hairlines between them.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0) rows.add(Divider(height: 1, color: context.border));
      rows.add(children[i]);
    }
    return Card(child: Column(children: rows));
  }
}

/// Shown only while the ads still use Google's test ids, so the owner can see
/// at a glance that the real ones are still missing.
class _TestAdsNotice extends StatelessWidget {
  const _TestAdsNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s),
      child: Container(
        key: const ValueKey<String>('settings-ads-test-notice'),
        padding: const EdgeInsets.all(AppSpace.m),
        decoration: BoxDecoration(
          color: AppColors.italianRed
              .withValues(alpha: context.isDark ? 0.22 : 0.08),
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(
            color: AppColors.italianRed.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: AppColors.italianRed,
            ),
            const SizedBox(width: AppSpace.s),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.texts.bodySmall?.copyWith(color: context.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One row in the language picker.
class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.locale,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Locale locale;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey<String>('lang:${AppLocales.tag(locale)}'),
      title: Text(label),
      leading: Icon(
        selected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_unchecked_rounded,
        color: selected ? AppColors.italianRed : context.muted,
      ),
      onTap: onTap,
    );
  }
}

/// An inline confirmation strip, dismissed by the user rather than by a timer.
class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.m),
      child: Container(
        key: const ValueKey<String>('settings-status'),
        padding: const EdgeInsetsDirectional.only(
          start: AppSpace.m,
          top: AppSpace.s,
          bottom: AppSpace.s,
          end: AppSpace.s,
        ),
        decoration: BoxDecoration(
          color: AppColors.correct.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(color: AppColors.correct.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.check_circle_rounded,
              size: 20,
              color: AppColors.correct,
            ),
            const SizedBox(width: AppSpace.s),
            Expanded(
              child: Text(
                message,
                style: context.texts.bodySmall?.copyWith(color: context.ink),
              ),
            ),
            IconButton(
              key: const ValueKey<String>('settings-status-close'),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: onDismiss,
            ),
          ],
        ),
      ),
    );
  }
}
