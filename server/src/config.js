'use strict';
const path = require('node:path');
const fs = require('node:fs');

/** Loads server/.env (if present) without overriding variables already set. */
function loadDotEnv(file = path.join(__dirname, '..', '.env')) {
  if (!fs.existsSync(file)) return;
  for (const line of fs.readFileSync(file, 'utf8').split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$/);
    if (!m || line.trim().startsWith('#')) continue;
    let v = m[2];
    if ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'"))) v = v.slice(1, -1);
    if (process.env[m[1]] === undefined) process.env[m[1]] = v;
  }
}

const list = (v, def) => String(v ?? def).split(',').map((s) => s.trim()).filter(Boolean);
const int = (v, def) => {
  const n = parseInt(v, 10);
  return Number.isFinite(n) && n > 0 ? n : def;
};

function readConfig(env = process.env) {
  return {
    port: int(env.PORT, 3100),
    host: env.HOST || '127.0.0.1',
    dbFile: env.DB_FILE || path.join(__dirname, '..', 'data', 'words.db'),
    trustProxy: env.TRUST_PROXY || 'loopback',
    adminToken: env.ADMIN_TOKEN || '',
    gemini: {
      keys: list(env.GEMINI_API_KEYS, ''),
      models: list(env.GEMINI_MODELS, 'gemini-3.5-flash-lite,gemini-3-flash-preview,gemma-4-31b-it'),
      timeoutMs: int(env.GEMINI_TIMEOUT_MS, 30000),
      maxAttempts: int(env.GEMINI_MAX_ATTEMPTS, 6),
      totalMs: int(env.GEMINI_TOTAL_MS, 50000),
      dailyMax: int(env.GEMINI_DAILY_MAX, 5000),
    },
    rate: {
      lookupPerMinute: int(env.RATE_LOOKUP_PER_MIN, 30),
      lookupPerDay: int(env.RATE_LOOKUP_PER_DAY, 1000),
      updatesPerMinute: int(env.RATE_UPDATES_PER_MIN, 60),
      updatesPerDay: int(env.RATE_UPDATES_PER_DAY, 5000),
    },
  };
}

module.exports = { loadDotEnv, readConfig };
