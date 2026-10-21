import 'dart:ui' show Locale, TextDirection;

/// The ten languages the dictionary itself is translated into, in the fixed
/// order used by every translation list in lib/data. Never reorder this: the
/// word data is positional.
enum LearnerLanguage {
  english(0, 'en'),
  urdu(1, 'ur'),
  punjabiShahmukhi(2, 'pa_Arab'),
  punjabiGurmukhi(3, 'pa'),
  bengali(4, 'bn'),
  sinhala(5, 'si'),
  chineseSimplified(6, 'zh'),
  french(7, 'fr'),
  spanishSpain(8, 'es'),
  spanishLatAm(9, 'es_419');

  const LearnerLanguage(this.slot, this.tag);

  /// Position inside the translation lists of every dictionary entry.
  final int slot;

  /// The matching interface-language tag.
  final String tag;

  static const int count = 10;

  /// Right-to-left scripts among the ten.
  bool get isRtl =>
      this == LearnerLanguage.urdu || this == LearnerLanguage.punjabiShahmukhi;

  /// Direction of text written in this language (the app itself is LTR).
  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  /// Which dictionary language to use for a given interface locale.
  /// Interface languages outside the ten fall back to English, which is also
  /// the fallback for an unknown locale.
  static LearnerLanguage forLocale(Locale locale) {
    final String lang = locale.languageCode.toLowerCase();
    final String? script = locale.scriptCode;
    final String? country = locale.countryCode?.toUpperCase();
    switch (lang) {
      case 'ur':
        return LearnerLanguage.urdu;
      case 'pa':
        return script == 'Arab'
            ? LearnerLanguage.punjabiShahmukhi
            : LearnerLanguage.punjabiGurmukhi;
      case 'bn':
        return LearnerLanguage.bengali;
      case 'si':
        return LearnerLanguage.sinhala;
      case 'zh':
        return LearnerLanguage.chineseSimplified;
      case 'fr':
        return LearnerLanguage.french;
      case 'es':
        return (country != null && country != 'ES')
            ? LearnerLanguage.spanishLatAm
            : LearnerLanguage.spanishSpain;
      default:
        return LearnerLanguage.english;
    }
  }
}
