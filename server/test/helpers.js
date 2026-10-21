'use strict';
const { openDb } = require('../src/db');
const { makeGemini } = require('../src/gemini');
const { createApp } = require('../src/app');
const { readConfig } = require('../src/config');

const GOOD = {
  q_lang: 'en',
  it: 'il pomodoro',
  pos: 'noun',
  g: 'm',
  pl: 'i pomodori',
  gloss: 'tomato',
  ex_it: 'Compro un chilo di pomodori.',
  ex_en: 'I buy a kilo of tomatoes.',
  tr: ['tomato', 'ٹماٹر', 'ٹماٹر', 'ਟਮਾਟਰ', 'টমেটো', 'තක්කාලි', '番茄 / 西红柿', 'tomate', 'tomate', 'jitomate / tomate'],
  rom: { ur: 'tamatar|timatar', pa: 'tamatar', bn: 'tometo', zh: 'fanqie|xihongshi' },
  offensive: false,
};

/** A Gemini HTTP reply with `obj` as the model text. */
function reply(obj, status = 200) {
  const text = typeof obj === 'string' ? obj : JSON.stringify(obj);
  return {
    ok: status >= 200 && status < 300,
    status,
    json: async () => ({ candidates: [{ content: { parts: [{ text }] } }] }),
  };
}

/** fetch mock: `script` is an array of replies (or functions) consumed in order; the last one repeats. */
function fakeFetch(script) {
  const calls = [];
  const fn = async (url, init) => {
    calls.push({ url, key: init.headers['x-goog-api-key'], body: JSON.parse(init.body) });
    const next = script.length > 1 ? script.shift() : script[0];
    if (!next) throw new Error('no scripted reply');
    return typeof next === 'function' ? next(url, init) : next;
  };
  fn.calls = calls;
  return fn;
}

async function startServer({ script = [reply(GOOD)], env = {} } = {}) {
  const config = readConfig({
    GEMINI_API_KEYS: 'k1,k2',
    GEMINI_MODELS: 'gemini-a,gemini-b,gemma-c',
    ADMIN_TOKEN: 'test-admin-token-1234567890',
    ...env,
  });
  config.quiet = true;
  const store = openDb(':memory:');
  const fetchImpl = fakeFetch(script);
  const gemini = makeGemini({ ...config.gemini, fetchImpl, timeoutMs: 200 });
  const app = createApp({ store, gemini, config, log: () => {} });
  const server = await new Promise((resolve) => {
    const s = app.listen(0, '127.0.0.1', () => resolve(s));
  });
  const base = `http://127.0.0.1:${server.address().port}`;
  const api = async (method, path, body, headers = {}) => {
    const res = await fetch(base + path, {
      method,
      headers: { ...(body !== undefined ? { 'content-type': 'application/json' } : {}), ...headers },
      body: body === undefined ? undefined : typeof body === 'string' ? body : JSON.stringify(body),
    });
    let json = null;
    try { json = await res.json(); } catch { /* not json */ }
    return { status: res.status, body: json, headers: res.headers };
  };
  const close = async () => {
    app.locals.limiters.forEach((l) => l.stop());
    await new Promise((r) => server.close(r));
    store.close();
  };
  return { api, close, store, fetchImpl, config };
}

module.exports = { GOOD, reply, fakeFetch, startServer };
