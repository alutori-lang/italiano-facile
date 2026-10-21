'use strict';
// Port of norm() / romkey() from dictdata/scripts/build_bigdb.py.
// This is the CONTRACT shared with the Python builder and the Dart side
// (lib/services/text_norm.dart): test/fixtures/norm_cases.json is the parity test.

const LATIN_MARKS = /[̀-ͯ]/g;
const ARABIC_MARKS = /[ً-ٰٟۖ-ۭـ]/g;
const PUNCT = /[\s.,!?¿¡;:"“”«»()\[\]{}…\-–—/\\|*_~^`'’‘؟،۔।॥。，！？：；、]+/g;
const ACCENTED = new Set('àáâäãåèéêëìíîïòóôöõùúûüçñ');
const ARABIC_UNIFY = {
  'ي': 'ی', 'ى': 'ی', 'ئ': 'ی', 'ك': 'ک',
  'ه': 'ہ', 'ۂ': 'ہ', 'ة': 'ہ',
  'أ': 'ا', 'إ': 'ا', 'آ': 'ا', 'ٱ': 'ا',
  'ؤ': 'و',
};

/** Generic search key: lower case, no Latin accents, unified Arabic letters,
 *  no Arabic diacritics, punctuation -> single spaces, trimmed. */
function norm(input) {
  const s = String(input ?? '').toLowerCase().normalize('NFC');
  let out = '';
  for (const ch of s) {
    let c = ch;
    if ((c >= 'a' && c <= 'z') || ACCENTED.has(c)) {
      c = c.normalize('NFD').replace(LATIN_MARKS, '');
    }
    out += ARABIC_UNIFY[c] ?? c;
  }
  out = out.replace(ARABIC_MARKS, '').replace(PUNCT, ' ');
  return out.split(/\s+/).filter(Boolean).join(' ');
}

/** Loose key for words typed in Latin letters (Roman Urdu/Punjabi, Banglish, pinyin). */
function romkey(input) {
  const s = norm(input).replace(/[^a-z ]/g, '');
  const words = [];
  for (let w of s.split(/\s+/)) {
    if (!w) continue;
    w = w.replaceAll('ee', 'i').replaceAll('oo', 'u').replaceAll('ou', 'u');
    w = w.replaceAll('ph', 'f').replaceAll('w', 'v').replaceAll('q', 'k').replaceAll('o', 'u');
    w = w.replace(/iy(?=[aeiu])/g, 'i');
    w = w.replace(/(?<=[bcdfgjklmnprstvxz])y(?=[aeiu])/g, 'i');
    w = w.replace(/(?<=[bcdfgjklmnprstvxz])h/g, '');
    w = w.replace(/h$/, '');
    w = w.replace(/y$/, 'i');
    w = w.replace(/(.)\1+/g, '$1');
    if (w) words.push(w);
  }
  return words.join('');
}

/** True when the text is written only with Latin letters (Roman Urdu, pinyin, ...). */
function isLatin(s) {
  return /\p{Script=Latin}/u.test(s) && !/[^\p{Script=Latin}\p{Script=Common}\p{M}]/u.test(s);
}

module.exports = { norm, romkey, isLatin };
