'use strict';
// Slot order of LearnerLanguage in the app (lib/models/learner_language.dart).

const LANGS = [
  { tag: 'en', name: 'English', script: 'Latin' },
  { tag: 'ur', name: 'Urdu (Pakistan), in Urdu/Arabic script', script: 'Arabic' },
  { tag: 'pa_Arab', name: 'Punjabi (Pakistan), in Shahmukhi/Arabic script', script: 'Arabic' },
  { tag: 'pa', name: 'Punjabi (India), in Gurmukhi script', script: 'Gurmukhi' },
  { tag: 'bn', name: 'Bengali as used in Bangladesh, in Bengali script', script: 'Bengali' },
  { tag: 'si', name: 'Sinhala, in Sinhala script', script: 'Sinhala' },
  { tag: 'zh', name: 'Chinese, Simplified characters', script: 'Han' },
  { tag: 'fr', name: 'French', script: 'Latin' },
  { tag: 'es', name: 'Spanish (Spain)', script: 'Latin' },
  { tag: 'es_419', name: 'Spanish (Latin America)', script: 'Latin' },
];

const TAGS = LANGS.map((l) => l.tag);
const SLOT = Object.fromEntries(TAGS.map((t, i) => [t, i]));

// Romanization keys -> languages whose users type in Latin letters.
const ROM_LANGS = { ur: ['ur'], pa: ['pa', 'pa_Arab'], bn: ['bn'], zh: ['zh'] };

module.exports = { LANGS, TAGS, SLOT, ROM_LANGS };
