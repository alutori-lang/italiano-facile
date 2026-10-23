import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// Thin typed wrapper around shared_preferences. Everything the app remembers
/// lives here, on the phone only — there is no account and no server.
class PrefsService {
  PrefsService(this._prefs);

  final SharedPreferences _prefs;

  static Future<PrefsService> open() async =>
      PrefsService(await SharedPreferences.getInstance());

  // ----------------------------------------------------------------- keys
  static const String kLocale = 'ui_locale';
  static const String kDark = 'dark_mode';
  static const String kSlowAudio = 'slow_audio';
  static const String kReminderOn = 'reminder_on';
  static const String kReminderHour = 'reminder_hour';
  static const String kReminderMinute = 'reminder_minute';
  static const String kPersonalId = 'personal_id';
  static const String kSeenWords = 'seen_words';
  static const String kMyWords = 'my_words';
  static const String kRecentSearches = 'recent_searches';
  static const String kStreakCount = 'streak_count';
  static const String kStreakDay = 'streak_day';
  static const String kTodayIds = 'today_ids';
  static const String kTodayDay = 'today_day';
  static const String kTodaySeen = 'today_seen';
  static const String kAdsRemoved = 'ads_removed';

  /// How many times the app has been started (ads: no app open ad in the
  /// very first session).
  static const String kAdsLaunches = 'ads_launches';

  /// When the last app open ad was shown (milliseconds since epoch).
  static const String kAppOpenLast = 'ads_app_open_last';

  /// "1 hour without ads" reward: when it ends (milliseconds since epoch).
  static const String kNoAdsUntil = 'ads_no_ads_until';
  static const String kCorrectPrefix = 'correct_';
  static const String kBestPrefix = 'best_';

  // ------------------------------------------------------------- generic
  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool getBool(String key, {bool fallback = false}) =>
      _prefs.getBool(key) ?? fallback;
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  int getInt(String key, {int fallback = 0}) => _prefs.getInt(key) ?? fallback;
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  List<String> getStringList(String key) =>
      _prefs.getStringList(key) ?? const <String>[];
  Future<void> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  Future<void> remove(String key) => _prefs.remove(key);

  /// The stable random id created at first launch. It makes the ten words of
  /// the day different for every user, without any account.
  String personalId() {
    final String? existing = _prefs.getString(kPersonalId);
    if (existing != null && existing.isNotEmpty) return existing;
    final Random random = Random.secure();
    final String fresh = List<String>.generate(
      16,
      (int _) => random.nextInt(16).toRadixString(16),
    ).join();
    _prefs.setString(kPersonalId, fresh);
    return fresh;
  }

  /// Wipes progress but keeps the translation language, the reminder, the dark-mode choice and
  /// the purchase, which must never be lost.
  Future<void> resetProgress() async {
    final Set<String> keep = <String>{
      kLocale,
      kDark,
      kSlowAudio,
      kAdsRemoved,
      kAdsLaunches,
      kAppOpenLast,
      kNoAdsUntil,
      kPersonalId,
      // The daily reminder is a setting, not progress: wiping it here would
      // turn the switch off on disk while the notification keeps firing.
      kReminderOn,
      kReminderHour,
      kReminderMinute,
    };
    for (final String key in _prefs.getKeys().toList()) {
      if (!keep.contains(key)) await _prefs.remove(key);
    }
  }
}
