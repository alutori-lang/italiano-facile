/// Central place for every externally supplied value.
///
/// Everything defaults to empty / test values so the app always runs. Nothing
/// here is invented: when a value is missing the related feature either falls
/// back to a safe offline behaviour or shows a clear notice in the app.
class AppConfig {
  const AppConfig._();

  /// Shown in the store listing and the About screen.
  static const String appName = 'Italiano Facile per Stranieri';
  static const String appVersion = '1.0.0';
  static const String packageName = 'dev.fluttercursor.app.simple_flutter_app_651';

  /// Support address shown in About / privacy. Empty = hidden.
  static const String supportEmail = '';

  /// Public privacy-policy URL once the owner has published one. Empty = the
  /// in-app privacy screen is used alone.
  static const String privacyPolicyUrl = '';

  /// Language used for text-to-speech. The learning language never changes.
  static const String ttsLanguage = 'it-IT';

  /// Free Wiktionary REST endpoint used by the optional "Search online"
  /// fallback. No API key exists for this service and none is needed.
  static const String wiktionaryBase = 'https://it.wiktionary.org/w/api.php';

  /// True when the optional online lookup may be attempted at all.
  static bool get onlineLookupConfigured => wiktionaryBase.isNotEmpty;
}
