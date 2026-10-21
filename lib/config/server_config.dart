/// The shared word server (server/ in this repo, see server/README.md).
///
/// While [baseUrl] is empty the whole feature is off and the app makes NO
/// network call for it. When it is set:
///  * a word found nowhere on the phone is asked to
///    `POST {baseUrl}/v1/lookup` with `{"q": ..., "lang": <LearnerLanguage.tag>}`
///    → 200 entry JSON, 404 not a word, 422 `{"error":"not_allowed"}`;
///    the answer is saved on the phone ("learned" words);
///  * at start-up `GET {baseUrl}/v1/updates?since=<ms>&limit=<n>` →
///    `{entries, next, more, removed}` brings new words page by page and
///    deletes the removed ones.
/// Network failures never break the search.
class ServerConfig {
  const ServerConfig._();

  /// e.g. 'https://api.example.org' (https, no trailing slash). Empty = off.
  static const String baseUrl = '';

  static bool get enabled => baseUrl.isNotEmpty;

  /// A lookup may ask Gemini: the server gives up after 50 s.
  static const Duration lookupTimeout = Duration(seconds: 60);

  /// One page of updates.
  static const Duration updatesTimeout = Duration(seconds: 20);
}
