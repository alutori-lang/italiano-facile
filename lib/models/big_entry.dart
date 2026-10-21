import 'dart:convert';

import 'learner_language.dart';

/// One entry of the big offline dictionary (assets/dict/big.db), or of the
/// words the app later learned from the word server.
///
/// Unlike the curated [Word]s these have no picture and no hand-written
/// explanation: just the Italian word, its part of speech, the meaning in the
/// ten languages and, sometimes, a Wiktionary example.
class BigEntry {
  const BigEntry({
    required this.id,
    required this.it,
    required this.pos,
    this.g,
    this.pl,
    this.gloss,
    this.exIt,
    this.exEn,
    required this.tr,
    this.rom = const <String, String>{},
    this.rank,
  });

  /// Positive: row of big.db. Negative: row of the local "learned" table
  /// (id = -learned.id), so the two never collide in the reverse index.
  final int id;
  final String it;

  /// Wiktionary part of speech: noun, verb, adj, adv, pron, prep, …
  final String pos;

  /// Gender of nouns: 'm', 'f', 'mf' or null.
  final String? g;
  final String? pl;

  /// Short English gloss.
  final String? gloss;
  final String? exIt;
  final String? exEn;

  /// The ten meanings, in [LearnerLanguage] slot order.
  final List<String> tr;

  /// Latin-letter spellings: {"ur": "pyaar|piyar", "pa": ..., "bn": ..., "zh": ...}.
  final Map<String, String> rom;

  /// Frequency rank (1 = most common), null when unknown.
  final int? rank;

  static const String separator = '\u001f';

  bool get learned => id < 0;
  bool get isNoun => pos == 'noun';

  String translation(LearnerLanguage lang) =>
      lang.slot < tr.length ? tr[lang.slot] : '';

  /// The Italian word with its definite article for nouns, by the same rules
  /// the curated words use: "il pomodoro", "lo zio", "l'amore", "la casa".
  String get headword {
    final String? article = articleFor(it, isNoun ? g : null);
    if (article == null) return it;
    return article.endsWith("'") ? '$article$it' : '$article $it';
  }

  /// Definite article for [word] with gender [g] ('m', 'f', 'mf'), or null.
  static String? articleFor(String word, String? g) {
    if (g == null || word.isEmpty) return null;
    final String w = word.toLowerCase();
    // Proper names ("Roma") take no article in a dictionary line.
    if (word[0] != w[0]) return null;
    const String vowels = 'aeiouàèéìíòóù';
    final bool semiVowelI = w.length > 1 &&
        w[0] == 'i' &&
        vowels.contains(w[1]); // "iena", "iato": la iena, lo iato
    final bool vowel = !semiVowelI &&
        (vowels.contains(w[0]) ||
            (w[0] == 'h' && w.length > 1 && vowels.contains(w[1])));
    final bool lo = semiVowelI ||
        w.startsWith('z') ||
        w.startsWith('x') ||
        w.startsWith('y') ||
        w.startsWith('gn') ||
        w.startsWith('ps') ||
        w.startsWith('pn') ||
        (w.length > 1 && w[0] == 's' && !vowels.contains(w[1]));
    final String masc = vowel ? "l'" : (lo ? 'lo' : 'il');
    final String fem = vowel ? "l'" : 'la';
    switch (g) {
      case 'm':
        return masc;
      case 'f':
        return fem;
      case 'mf':
        return vowel ? "l'" : '$masc/$fem';
    }
    return null;
  }

  factory BigEntry.fromRow(Map<String, Object?> row, {bool learned = false}) {
    final int rawId = row['id']! as int;
    return BigEntry(
      id: learned ? -rawId : rawId,
      it: row['it']! as String,
      pos: (row['pos'] as String?) ?? '',
      g: _blank(row['g']),
      pl: _blank(row['pl']),
      gloss: _blank(row['gloss']),
      exIt: _blank(row['ex_it']),
      exEn: _blank(row['ex_en']),
      tr: ((row['tr'] as String?) ?? '').split(separator),
      rom: decodeRom(row['rom'] as String?),
      rank: row['rank'] as int?,
    );
  }

  /// Parses the server's JSON entry ({it,pos,g,pl,gloss,ex_it,ex_en,tr,rom}).
  /// Returns null when it is not a usable entry.
  static BigEntry? fromJson(Object? json, {int id = 0}) {
    if (json is! Map) return null;
    final Object? it = json['it'];
    final Object? tr = json['tr'];
    if (it is! String || it.trim().isEmpty || tr is! List) return null;
    final List<String> meanings = List<String>.generate(
      LearnerLanguage.count,
      (int i) => i < tr.length ? '${tr[i] ?? ''}'.trim() : '',
    );
    final Map<String, String> rom = <String, String>{};
    final Object? r = json['rom'];
    if (r is Map) {
      r.forEach((Object? k, Object? v) {
        if (k is String && v != null) rom[k] = '$v';
      });
    }
    return BigEntry(
      id: id,
      // The server writes nouns with their article ("il pomodoro"); the
      // entry keeps the bare word, [headword] puts the article back.
      it: (json['pos'] == 'noun') ? stripArticle(it.trim()) : it.trim(),
      pos: (json['pos'] as String?) ?? '',
      g: _blank(json['g']),
      pl: _blank(json['pl']),
      gloss: _blank(json['gloss']),
      exIt: _blank(json['ex_it']),
      exEn: _blank(json['ex_en']),
      tr: meanings,
      rom: rom,
      rank: json['rank'] is int ? json['rank'] as int : null,
    );
  }

  /// "il pomodoro" → "pomodoro", "l'acqua" → "acqua", "lo/la …" too.
  static String stripArticle(String word) {
    final RegExpMatch? m = _article.firstMatch(word);
    if (m == null) return word;
    final String rest = word.substring(m.end).trim();
    return rest.isEmpty ? word : rest;
  }

  static final RegExp _article = RegExp(
    r"^(?:(?:il|lo|la|i|gli|le)(?:/(?:il|lo|la))?\s+|l['’])",
    caseSensitive: false,
  );

  static Map<String, String> decodeRom(String? raw) {
    if (raw == null || raw.isEmpty) return const <String, String>{};
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map) return const <String, String>{};
      return <String, String>{
        for (final MapEntry<dynamic, dynamic> e in decoded.entries)
          if (e.key is String && e.value != null) e.key as String: '${e.value}',
      };
    } catch (_) {
      return const <String, String>{};
    }
  }

  static String? _blank(Object? v) {
    if (v is! String) return null;
    final String s = v.trim();
    return s.isEmpty ? null : s;
  }

  @override
  String toString() => 'BigEntry($id $it/$pos)';
}
