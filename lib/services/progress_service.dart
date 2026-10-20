import 'package:flutter/foundation.dart';

import 'prefs_service.dart';

/// Streak, saved words, learned counters, best quiz scores and recent
/// searches. All local, all kept across restarts.
class ProgressService extends ChangeNotifier {
  ProgressService(this._prefs);

  final PrefsService _prefs;

  /// "2026-10-19" for a given moment, in the phone's own time zone.
  static String dayKey(DateTime when) {
    final String month = when.month.toString().padLeft(2, '0');
    final String day = when.day.toString().padLeft(2, '0');
    return '${when.year}-$month-$day';
  }

  String get personalId => _prefs.personalId();

  // ------------------------------------------------------------- my words
  List<String> get myWordIds => _prefs.getStringList(PrefsService.kMyWords);

  bool isSaved(String id) => myWordIds.contains(id);

  Future<void> toggleSaved(String id) async {
    final List<String> ids = myWordIds.toList();
    if (ids.remove(id)) {
      await _prefs.setStringList(PrefsService.kMyWords, ids);
    } else {
      ids.insert(0, id);
      await _prefs.setStringList(PrefsService.kMyWords, ids);
    }
    notifyListeners();
  }

  // ------------------------------------------------------ recent searches
  List<String> get recentSearches =>
      _prefs.getStringList(PrefsService.kRecentSearches);

  Future<void> addRecentSearch(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final List<String> list = recentSearches.toList()
      ..removeWhere((String e) => e.toLowerCase() == trimmed.toLowerCase());
    list.insert(0, trimmed);
    await _prefs.setStringList(
      PrefsService.kRecentSearches,
      list.take(10).toList(),
    );
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    await _prefs.remove(PrefsService.kRecentSearches);
    notifyListeners();
  }

  // ----------------------------------------------------------- seen words
  /// Words already shown in "Today". A word never comes back until every
  /// word has been seen once.
  Set<String> get seenWordIds =>
      _prefs.getStringList(PrefsService.kSeenWords).toSet();

  Future<void> markSeen(Iterable<String> ids) async {
    final Set<String> seen = seenWordIds..addAll(ids);
    await _prefs.setStringList(PrefsService.kSeenWords, seen.toList());
    notifyListeners();
  }

  Future<void> clearSeen() async {
    await _prefs.remove(PrefsService.kSeenWords);
    notifyListeners();
  }

  // --------------------------------------------------------------- streak
  int get streak => _prefs.getInt(PrefsService.kStreakCount);
  String? get streakDay => _prefs.getString(PrefsService.kStreakDay);

  /// Called when the user opens Today. Adds one if yesterday was the last
  /// day, restarts at one after a gap, does nothing twice in a day.
  Future<void> touchStreak(DateTime now) async {
    final String today = dayKey(now);
    final String? last = streakDay;
    if (last == today) return;
    final String yesterday = dayKey(now.subtract(const Duration(days: 1)));
    final int next = last == yesterday ? streak + 1 : 1;
    await _prefs.setInt(PrefsService.kStreakCount, next);
    await _prefs.setString(PrefsService.kStreakDay, today);
    notifyListeners();
  }

  // --------------------------------------------------- learned / quizzes
  int correctCount(String wordId) =>
      _prefs.getInt('${PrefsService.kCorrectPrefix}$wordId');

  /// A word counts as learned after two correct quiz answers.
  bool isLearned(String wordId) => correctCount(wordId) >= 2;

  Future<void> recordAnswer(String wordId, {required bool correct}) async {
    if (!correct) return;
    await _prefs.setInt(
      '${PrefsService.kCorrectPrefix}$wordId',
      correctCount(wordId) + 1,
    );
    notifyListeners();
  }

  int learnedInTopic(Iterable<String> wordIds) =>
      wordIds.where(isLearned).length;

  int bestScore(String categoryId) =>
      _prefs.getInt('${PrefsService.kBestPrefix}$categoryId');

  Future<void> saveBestScore(String categoryId, int score) async {
    if (score <= bestScore(categoryId)) return;
    await _prefs.setInt('${PrefsService.kBestPrefix}$categoryId', score);
    notifyListeners();
  }

  // -------------------------------------------------------------- today
  List<String> todayIdsFor(String day) =>
      _prefs.getString(PrefsService.kTodayDay) == day
          ? _prefs.getStringList(PrefsService.kTodayIds)
          : const <String>[];

  Future<void> storeToday(String day, List<String> ids) async {
    await _prefs.setString(PrefsService.kTodayDay, day);
    await _prefs.setStringList(PrefsService.kTodayIds, ids);
    notifyListeners();
  }

  int get todaySeenIndex => _prefs.getInt(PrefsService.kTodaySeen);

  Future<void> setTodaySeenIndex(int index) async {
    if (index <= todaySeenIndex) return;
    await _prefs.setInt(PrefsService.kTodaySeen, index);
    notifyListeners();
  }

  // --------------------------------------------------------------- reset
  Future<void> reset() async {
    await _prefs.resetProgress();
    notifyListeners();
  }
}
