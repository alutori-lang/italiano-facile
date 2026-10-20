import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// What the optional online lookup found.
class OnlineLookupResult {
  const OnlineLookupResult({
    required this.term,
    required this.extract,
    required this.sourceUrl,
  });

  final String term;

  /// A short plain-text definition from the Italian Wiktionary.
  final String extract;
  final String sourceUrl;
}

/// The "Search online" fallback, used only when the offline dictionary has
/// nothing and the user taps the button.
///
/// It calls the public Italian Wiktionary API, which is free and needs no key,
/// and sends nothing but the word the user typed.
class OnlineLookupService {
  OnlineLookupService({http.Client? client}) : _client = client;

  final http.Client? _client;

  bool get configured => AppConfig.onlineLookupConfigured;

  Future<OnlineLookupResult?> lookup(String term) async {
    final String query = term.trim();
    if (query.isEmpty || !configured) return null;
    final http.Client client = _client ?? http.Client();
    try {
      final Uri uri = Uri.parse(AppConfig.wiktionaryBase).replace(
        queryParameters: <String, String>{
          'action': 'query',
          'format': 'json',
          'prop': 'extracts',
          'explaintext': '1',
          'redirects': '1',
          'titles': query,
          'origin': '*',
        },
      );
      final http.Response response =
          await client.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final Object? decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) return null;
      final Object? pages = (decoded['query'] as Map<String, dynamic>?)?['pages'];
      if (pages is! Map<String, dynamic>) return null;
      for (final Object? page in pages.values) {
        if (page is! Map<String, dynamic>) continue;
        if (page.containsKey('missing')) continue;
        final String extract = (page['extract'] as String? ?? '').trim();
        if (extract.isEmpty) continue;
        final String title = page['title'] as String? ?? query;
        return OnlineLookupResult(
          term: title,
          extract: _shorten(extract),
          sourceUrl:
              'https://it.wiktionary.org/wiki/${Uri.encodeComponent(title)}',
        );
      }
      return null;
    } catch (_) {
      // Offline, blocked or timed out: the caller shows the offline notice.
      return null;
    } finally {
      if (_client == null) client.close();
    }
  }

  /// Wiktionary extracts can be very long; keep the first useful lines.
  static String _shorten(String text, {int maxChars = 600}) {
    final String collapsed =
        text.replaceAll(RegExp(r'\n{2,}'), '\n').trim();
    if (collapsed.length <= maxChars) return collapsed;
    final int cut = collapsed.lastIndexOf('.', maxChars);
    return '${collapsed.substring(0, cut > 100 ? cut + 1 : maxChars)}…';
  }
}
