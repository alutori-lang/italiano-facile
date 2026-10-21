/// The PatronApp-style word server that will teach the app new words.
///
/// The server does not exist yet: while [baseUrl] is empty the whole feature
/// is off and the app makes NO network call for it. When it is set:
///  * a word found nowhere on the phone is asked to
///    `POST {baseUrl}/v1/lookup` with `{"q": ..., "lang": <LearnerLanguage.tag>}`
///    and the answer is saved on the phone ("learned" words);
///  * at start-up `GET {baseUrl}/v1/updates?since=<last>` brings corrections
///    and new words.
/// Network failures never break the search.
class ServerConfig {
  const ServerConfig._();

  /// e.g. 'https://words.example.org' (no trailing slash). Empty = off.
  static const String baseUrl = '';

  static bool get enabled => baseUrl.isNotEmpty;

  /// How long one request may take before it is given up.
  static const Duration timeout = Duration(seconds: 8);
}
