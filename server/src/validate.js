'use strict';
// Strict validation of what Gemini returns, before anything reaches the shared database.

const POS = new Set(['noun', 'verb', 'adj', 'adv', 'phrase', 'other']);
const ROM_KEYS = ['ur', 'pa', 'bn', 'zh'];
const MAX = { it: 160, short: 200, ex: 400, tr: 200 };

const RE = {
  latin: /\p{Script=Latin}/u,
  arabic: /\p{Script=Arabic}/u,
  gurmukhi: /\p{Script=Gurmukhi}/u,
  bengali: /\p{Script=Bengali}/u,
  sinhala: /\p{Script=Sinhala}/u,
  han: /\p{Script=Han}/u,
  // letters of scripts that must never appear inside an Arabic-script slot
  notArabicLetters: /[\p{Script=Latin}\p{Script=Gurmukhi}\p{Script=Devanagari}\p{Script=Bengali}]/u,
  control: /[\u0000-\u0008\u000B-\u001F\u007F]/,
  romOk: /^[\p{Script=Latin}\p{M}0-9 '’\-|,.()]+$/u,
};

// Per slot: must contain / must not contain.
const SLOT_RULES = [
  { must: RE.latin },                                   // en
  { must: RE.arabic, not: RE.notArabicLetters },        // ur
  { must: RE.arabic, not: RE.notArabicLetters },        // pa_Arab (Shahmukhi)
  { must: RE.gurmukhi, not: /[\p{Script=Arabic}\p{Script=Latin}]/u }, // pa (Gurmukhi)
  { must: RE.bengali, not: /[\p{Script=Arabic}\p{Script=Latin}]/u },  // bn
  { must: RE.sinhala, not: /[\p{Script=Arabic}\p{Script=Latin}]/u },  // si
  { must: RE.han, not: /[\p{Script=Arabic}\p{Script=Cyrillic}]/u },   // zh
  { must: RE.latin },                                   // fr
  { must: RE.latin },                                   // es
  { must: RE.latin },                                   // es_419
];

function str(v, max, field, errors, { required = false } = {}) {
  if (v === undefined || v === null || v === '') {
    if (required) errors.push(`${field}: missing`);
    return null;
  }
  if (typeof v !== 'string') {
    errors.push(`${field}: not a string`);
    return null;
  }
  const t = v.trim().replace(/\s+/g, ' ');
  if (!t) {
    if (required) errors.push(`${field}: empty`);
    return null;
  }
  if (t.length > max) errors.push(`${field}: too long`);
  if (RE.control.test(t)) errors.push(`${field}: control characters`);
  return t;
}

/**
 * Validates the parsed Gemini JSON.
 * Returns { ok:true, value } | { ok:true, unknown:true } | { ok:false, errors }.
 * `offensive` is always reported so moderation can run even on partial output.
 */
function validateAnswer(obj) {
  const errors = [];
  if (!obj || typeof obj !== 'object' || Array.isArray(obj)) return { ok: false, errors: ['not an object'] };
  const offensive = obj.offensive === true;
  if (typeof obj.offensive !== 'boolean') errors.push('offensive: not a boolean');
  if (obj.unknown === true) return { ok: errors.length === 0, unknown: true, offensive, errors };

  const it = str(obj.it, MAX.it, 'it', errors, { required: true });
  if (it && !RE.latin.test(it)) errors.push('it: not Latin script');
  const pos = typeof obj.pos === 'string' ? obj.pos.trim().toLowerCase() : '';
  if (!POS.has(pos)) errors.push('pos: invalid');
  let g = obj.g;
  if (g === undefined || g === '' || g === 'null') g = null;
  if (g !== null && g !== 'm' && g !== 'f') errors.push('g: invalid');
  const pl = str(obj.pl, MAX.short, 'pl', errors);
  const gloss = str(obj.gloss, MAX.short, 'gloss', errors, { required: true });
  if (gloss && !RE.latin.test(gloss)) errors.push('gloss: not English');
  const exIt = str(obj.ex_it, MAX.ex, 'ex_it', errors);
  const exEn = str(obj.ex_en, MAX.ex, 'ex_en', errors);

  const tr = [];
  if (!Array.isArray(obj.tr) || obj.tr.length !== 10) {
    errors.push('tr: must be an array of 10 strings');
  } else {
    obj.tr.forEach((v, i) => {
      const t = str(v, MAX.tr, `tr[${i}]`, errors, { required: true });
      if (!t) return;
      const rule = SLOT_RULES[i];
      if (!rule.must.test(t)) errors.push(`tr[${i}]: wrong script`);
      if (rule.not && rule.not.test(t)) errors.push(`tr[${i}]: mixed script`);
      tr.push(t);
    });
  }

  // Romanizations are optional extras: invalid ones are dropped, not fatal.
  const rom = {};
  if (obj.rom && typeof obj.rom === 'object' && !Array.isArray(obj.rom)) {
    for (const k of ROM_KEYS) {
      const v = obj.rom[k];
      if (typeof v !== 'string') continue;
      const t = v.trim().replace(/\s*\|\s*/g, '|');
      if (t && t.length <= MAX.short && RE.romOk.test(t)) rom[k] = t;
    }
  }

  if (errors.length) return { ok: false, offensive, errors };
  return {
    ok: true,
    offensive,
    value: { it, pos, g: pos === 'noun' ? g : null, pl, gloss, ex_it: exIt, ex_en: exEn, tr, rom },
  };
}

/** Pulls the first JSON object out of a model reply (handles ```json fences / chatter). */
function parseModelJson(text) {
  if (typeof text !== 'string') return null;
  const start = text.indexOf('{');
  const end = text.lastIndexOf('}');
  if (start < 0 || end <= start) return null;
  try {
    return JSON.parse(text.slice(start, end + 1));
  } catch {
    return null;
  }
}

module.exports = { validateAnswer, parseModelJson, POS };
