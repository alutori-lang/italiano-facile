import 'package:unorm_dart/unorm_dart.dart' as unorm;

/// The normalization CONTRACT shared with the dictionary builder
/// (dictdata/scripts/build_bigdb.py: norm(), romkey(), variants()).
///
/// The big dictionary's reverse index is built on the phone with these
/// functions, and every query goes through them too, so the Dart and Python
/// sides must agree character for character. test/fixtures/norm_cases.json,
/// written by the Python script, is the parity test (test/bigdict).
class TextNorm {
  const TextNorm._();

  /// Python's `str.isspace()` set, which is what `\s` and `str.split()` mean
  /// there. Dart's `\s` differs (no U+001C–U+001F / U+0085, adds U+FEFF), so
  /// it is spelled out.
  static const String _ws = r'\t\n\x0B\x0C\r\x1C-\x1F \x85\xA0 '
      r' -     　';

  static final RegExp _arabicMarks = RegExp('[ً-ٰٟۖ-ۭـ]');
  static final RegExp _punct = RegExp(
    '[$_ws'
    r'.,!?¿¡;:"“”«»()\[\]{}…\-–—/\\|*_~^`'
    "'’‘؟،۔।॥。，！？：；、]+",
  );
  static final RegExp _spaces = RegExp('[$_ws]+');

  /// The accented Latin letters norm() folds (NFD + drop the marks).
  static const Map<String, String> _latinFold = <String, String>{
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ä': 'a',
    'ã': 'a',
    'å': 'a',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'ö': 'o',
    'õ': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    'ç': 'c',
    'ñ': 'n',
  };

  static const Map<String, String> _arabicUnify = <String, String>{
    'ي': 'ی',
    'ى': 'ی',
    'ئ': 'ی',
    'ك': 'ک',
    'ه': 'ہ',
    'ۂ': 'ہ',
    'ة': 'ہ',
    'أ': 'ا',
    'إ': 'ا',
    'آ': 'ا',
    'ٱ': 'ا',
    'ؤ': 'و',
  };

  /// Generic search key: lower case, no Latin accents, unified Arabic
  /// letters, no Arabic diacritics, punctuation turned into single spaces,
  /// trimmed. Indic/Sinhala vowel signs are kept (they are letters there).
  static String norm(String input) {
    final String s = unorm.nfc(input.toLowerCase());
    final StringBuffer out = StringBuffer();
    for (final int rune in s.runes) {
      final String ch = String.fromCharCode(rune);
      out.write(_latinFold[ch] ?? _arabicUnify[ch] ?? ch);
    }
    String r = out.toString().replaceAll(_arabicMarks, '');
    r = r.replaceAll(_punct, ' ');
    return _pyStrip(r.replaceAll(_spaces, ' '));
  }

  static final RegExp _notLatin = RegExp('[^a-z ]');
  static final RegExp _iyVowel = RegExp('iy(?=[aeiu])');
  static final RegExp _consY = RegExp('(?<=[bcdfgjklmnprstvxz])y(?=[aeiu])');
  static final RegExp _consH = RegExp('(?<=[bcdfgjklmnprstvxz])h');
  static final RegExp _finalH = RegExp(r'h$');
  static final RegExp _finalY = RegExp(r'y$');
  static final RegExp _doubled = RegExp(r'(.)\1+');

  /// Loose key for words typed in Latin letters (Roman Urdu/Punjabi,
  /// Banglish, pinyin): spelling variants collapse to the same key
  /// (pyaar/piyar/pyar → piar, khana/khaana/kana → kana).
  static String romkey(String input) {
    final String s = norm(input).replaceAll(_notLatin, '');
    final StringBuffer out = StringBuffer();
    for (final String word in s.split(' ')) {
      if (word.isEmpty) continue;
      String w = word
          .replaceAll('ee', 'i')
          .replaceAll('oo', 'u')
          .replaceAll('ou', 'u')
          .replaceAll('ph', 'f')
          .replaceAll('w', 'v')
          .replaceAll('q', 'k')
          .replaceAll('o', 'u');
      w = w.replaceAll(_iyVowel, 'i');
      w = w.replaceAll(_consY, 'i');
      w = w.replaceAll(_consH, '');
      w = w.replaceAll(_finalH, '');
      w = w.replaceAll(_finalY, 'i');
      w = w.replaceAllMapped(_doubled, (Match m) => m[1]!);
      // Spaces are dropped: "fan qie" and "fanqie" match.
      out.write(w);
    }
    return out.toString();
  }

  static final RegExp _variantSplit =
      RegExp('[$_ws]*/[$_ws]*|[$_ws]*;[$_ws]*|[$_ws]*,[$_ws]*');
  static final RegExp _parens = RegExp(r'\([^)]*\)');

  /// 'nice / friendly' → ['nice', 'friendly']; also drops '(…)' notes and
  /// offers the verb without 'to '.
  static List<String> variants(String meaning) {
    final List<String> out = <String>[];
    for (final String raw in meaning.split(_variantSplit)) {
      final String part = _pyStrip(raw.replaceAll(_parens, ''));
      if (part.isEmpty) continue;
      out.add(part);
      if (part.toLowerCase().startsWith('to ')) out.add(part.substring(3));
    }
    return out;
  }

  /// True when the text has at least one Latin letter (Italian, English,
  /// Roman Urdu, pinyin…).
  static bool hasLatin(String s) => _anyLatin.hasMatch(s);
  static final RegExp _anyLatin = RegExp('[A-Za-zÀ-ɏ]');

  static final RegExp _edges = RegExp('^[$_ws]+|[$_ws]+\$');
  static String _pyStrip(String s) => s.replaceAll(_edges, '');
}
