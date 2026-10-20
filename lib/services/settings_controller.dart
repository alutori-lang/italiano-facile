import 'package:flutter/material.dart';

import '../models/learner_language.dart';
import 'prefs_service.dart';

/// Every supported interface locale.
///
/// The first ten are the languages the dictionary itself is translated into
/// (the ones the app was designed for). The rest are also fully translated
/// interfaces; their word translations fall back to English.
class AppLocales {
  const AppLocales._();

  static const List<Locale> primary = <Locale>[
    Locale('en'),
    Locale('ur'),
    Locale.fromSubtags(languageCode: 'pa', scriptCode: 'Arab'),
    Locale('pa'),
    Locale('bn'),
    Locale('si'),
    Locale('zh'),
    Locale('fr'),
    Locale('es', 'ES'),
    Locale('es', '419'),
  ];

  static const List<Locale> secondary = <Locale>[
    Locale('it'),
    Locale('pt'),
    Locale('de'),
    Locale('hi'),
    Locale('ar'),
    Locale('id'),
    Locale('ru'),
  ];

  static const List<Locale> all = <Locale>[...primary, ...secondary];

  /// True for a locale the app must lay out right to left.
  ///
  /// Flutter's own [GlobalWidgetsLocalizations] only ever looks at
  /// [Locale.languageCode] (ar, fa, he, ps, sd, ur) when it picks the
  /// ambient [Directionality] — it has no idea that Punjabi written in the
  /// Shahmukhi (Arabic) script is also right to left, because plain Punjabi
  /// (Gurmukhi) is not. Any locale carrying the Arabic script is RTL
  /// regardless of its language, so that case is checked explicitly; see
  /// where this is used to override the app-wide [Directionality] in
  /// `app.dart`.
  static bool isRtl(Locale locale) {
    if (locale.scriptCode == 'Arab') return true;
    const Set<String> rtlLanguageCodes = <String>{
      'ar', 'ur', 'fa', 'he', 'ps', 'sd',
    };
    return rtlLanguageCodes.contains(locale.languageCode);
  }

  /// Stable string form used in shared_preferences.
  static String tag(Locale locale) {
    final StringBuffer out = StringBuffer(locale.languageCode);
    if (locale.scriptCode != null) out.write('_${locale.scriptCode}');
    if (locale.countryCode != null) out.write('_${locale.countryCode}');
    return out.toString();
  }

  static Locale? fromTag(String? tag) {
    if (tag == null || tag.isEmpty) return null;
    for (final Locale locale in all) {
      if (AppLocales.tag(locale) == tag) return locale;
    }
    return null;
  }

  /// Picks the closest supported locale for the phone's own language, falling
  /// back to English when there is no match at all.
  static Locale resolve(Locale? device, Iterable<Locale> supported) {
    if (device == null) return const Locale('en');
    for (final Locale locale in supported) {
      if (locale.languageCode == device.languageCode &&
          locale.scriptCode == device.scriptCode &&
          locale.countryCode == device.countryCode) {
        return locale;
      }
    }
    // Spanish from anywhere outside Spain gets the Latin-American wording.
    if (device.languageCode == 'es') {
      return device.countryCode == null || device.countryCode == 'ES'
          ? const Locale('es', 'ES')
          : const Locale('es', '419');
    }
    if (device.languageCode == 'pa') {
      return device.scriptCode == 'Arab'
          ? Locale.fromSubtags(languageCode: 'pa', scriptCode: 'Arab')
          : const Locale('pa');
    }
    for (final Locale locale in supported) {
      if (locale.languageCode == device.languageCode) return locale;
    }
    return const Locale('en');
  }
}

/// Holds the user's choices and notifies the app when they change.
class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs) {
    _locale = AppLocales.fromTag(_prefs.getString(PrefsService.kLocale));
    _dark = _prefs.getBool(PrefsService.kDark);
    _slowAudio = _prefs.getBool(PrefsService.kSlowAudio);
    _reminderOn = _prefs.getBool(PrefsService.kReminderOn);
    _reminderHour = _prefs.getInt(PrefsService.kReminderHour, fallback: 19);
    _reminderMinute = _prefs.getInt(PrefsService.kReminderMinute);
  }

  final PrefsService _prefs;

  Locale? _locale;
  bool _dark = false;
  bool _slowAudio = false;
  bool _reminderOn = false;
  int _reminderHour = 19;
  int _reminderMinute = 0;

  /// null means "follow the phone".
  Locale? get locale => _locale;
  bool get dark => _dark;
  bool get slowAudio => _slowAudio;
  bool get reminderOn => _reminderOn;
  int get reminderHour => _reminderHour;
  int get reminderMinute => _reminderMinute;
  TimeOfDay get reminderTime =>
      TimeOfDay(hour: _reminderHour, minute: _reminderMinute);

  ThemeMode get themeMode => _dark ? ThemeMode.dark : ThemeMode.light;

  /// The dictionary language that matches the active interface locale.
  LearnerLanguage learnerLanguage(Locale active) =>
      LearnerLanguage.forLocale(active);

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    if (locale == null) {
      await _prefs.remove(PrefsService.kLocale);
    } else {
      await _prefs.setString(PrefsService.kLocale, AppLocales.tag(locale));
    }
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _dark = value;
    await _prefs.setBool(PrefsService.kDark, value);
    notifyListeners();
  }

  Future<void> setSlowAudio(bool value) async {
    _slowAudio = value;
    await _prefs.setBool(PrefsService.kSlowAudio, value);
    notifyListeners();
  }

  Future<void> setReminder({required bool on, TimeOfDay? at}) async {
    _reminderOn = on;
    if (at != null) {
      _reminderHour = at.hour;
      _reminderMinute = at.minute;
    }
    await _prefs.setBool(PrefsService.kReminderOn, on);
    await _prefs.setInt(PrefsService.kReminderHour, _reminderHour);
    await _prefs.setInt(PrefsService.kReminderMinute, _reminderMinute);
    notifyListeners();
  }
}
