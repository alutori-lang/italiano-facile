/// Screens reachable with ?ember_screen=N on the web build, in order of how
/// well they represent the app. Normal launches ignore all of this.
enum ScreenshotScreen {
  search,
  today,
  quizQuestion,
  quizResult,
  topics,
  settings,
}

class ScreenshotScreens {
  const ScreenshotScreens._();

  static const List<ScreenshotScreen> ordered = <ScreenshotScreen>[
    ScreenshotScreen.search, // 0 — home / main feature
    ScreenshotScreen.today, // 1 — daily words
    ScreenshotScreen.quizQuestion, // 2 — the quiz in action
    ScreenshotScreen.quizResult, // 3 — passed result
    ScreenshotScreen.topics, // 4 — category grid
    ScreenshotScreen.settings, // 5 — settings / premium
  ];

  /// Parses the query parameter. Returns null for a normal launch.
  static ScreenshotScreen? parse(String? raw) {
    if (raw == null) return null;
    final int? n = int.tryParse(raw.trim());
    if (n == null || n < 0 || n >= ordered.length) return null;
    return ordered[n];
  }
}
