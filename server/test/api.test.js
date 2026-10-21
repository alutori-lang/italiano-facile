'use strict';
const test = require('node:test');
const assert = require('node:assert');
const { GOOD, reply, startServer } = require('./helpers');
const { makeModerator } = require('../src/moderation');

const ADMIN = { authorization: 'Bearer test-admin-token-1234567890' };

test('health', async (t) => {
  const s = await startServer();
  t.after(s.close);
  const r = await s.api('GET', '/health');
  assert.deepStrictEqual(r.body, { ok: true, entries: 0 });
  assert.strictEqual(r.headers.get('x-content-type-options'), 'nosniff');
  assert.strictEqual(r.headers.get('x-powered-by'), null);
});

test('lookup miss -> Gemini -> stored, then served from cache', async (t) => {
  const s = await startServer();
  t.after(s.close);
  const r1 = await s.api('POST', '/v1/lookup', { q: 'Tomato', lang: 'en' });
  assert.strictEqual(r1.status, 200, JSON.stringify(r1.body));
  assert.strictEqual(r1.body.it, 'il pomodoro');
  assert.strictEqual(r1.body.cached, false);
  assert.strictEqual(r1.body.tr.length, 10);
  assert.strictEqual(s.fetchImpl.calls.length, 1);
  // key in the header, never in the URL
  assert.ok(!s.fetchImpl.calls[0].url.includes('k1') && !s.fetchImpl.calls[0].url.includes('key='));
  assert.ok(['k1', 'k2'].includes(s.fetchImpl.calls[0].key));
  // gemini-* models ask for JSON output
  assert.strictEqual(s.fetchImpl.calls[0].body.generationConfig.responseMimeType, 'application/json');

  const row = s.store.raw.prepare('SELECT * FROM entries').get();
  assert.strictEqual(row.src_q, 'Tomato');
  assert.strictEqual(row.src_lang, 'en');
  assert.ok(row.created_at > 0);

  // same query (different case/punctuation) -> cache, no new Gemini call
  const r2 = await s.api('POST', '/v1/lookup', { q: 'tomato!', lang: 'en' });
  assert.strictEqual(r2.status, 200);
  assert.strictEqual(r2.body.cached, true);
  assert.strictEqual(r2.body.id, r1.body.id);
  // Italian headword with or without the article
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'pomodoro', lang: 'ur' })).body.cached, true);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'Il Pomodoro', lang: 'bn' })).body.cached, true);
  // translation keys per language
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'ٹماٹر', lang: 'ur' })).body.cached, true);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: '西红柿', lang: 'zh' })).body.cached, true);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'jitomate', lang: 'es_419' })).body.cached, true);
  // Roman Urdu spelling variants (romkey)
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'tamaatar', lang: 'ur' })).body.cached, true);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'tamatar', lang: 'pa_Arab' })).body.cached, true);
  assert.strictEqual(s.fetchImpl.calls.length, 1);
  assert.strictEqual(s.store.raw.prepare('SELECT hits FROM entries').get().hits, 8);
});

test('same Italian headword from a new query reuses the entry', async (t) => {
  const s = await startServer({ script: [reply({ ...GOOD, q_lang: 'fr', tr: GOOD.tr })] });
  t.after(s.close);
  const a = await s.api('POST', '/v1/lookup', { q: 'tomates rouges', lang: 'fr' });
  const b = await s.api('POST', '/v1/lookup', { q: 'tomaat', lang: 'en' });
  assert.strictEqual(a.status, 200);
  assert.strictEqual(b.body.id, a.body.id);
  assert.strictEqual(s.store.count(), 1);
});

test('offensive: Gemini flag -> 422, not stored, negative-cached', async (t) => {
  const s = await startServer({ script: [reply({ ...GOOD, it: 'lo scemo', gloss: 'fool', offensive: true })] });
  t.after(s.close);
  const r = await s.api('POST', '/v1/lookup', { q: 'some insult', lang: 'en' });
  assert.strictEqual(r.status, 422);
  assert.deepStrictEqual(r.body, { error: 'not_allowed' });
  assert.strictEqual(s.store.count(), 0);
  const again = await s.api('POST', '/v1/lookup', { q: 'some insult', lang: 'en' });
  assert.strictEqual(again.status, 422);
  assert.strictEqual(s.fetchImpl.calls.length, 1);
});

test('offensive: local blocklist on the query -> 422 without calling Gemini', async (t) => {
  const s = await startServer();
  t.after(s.close);
  for (const q of ['Vaffanculo!', 'stronzo', 'you are a bitch', 'bhenchod', 'porco dio', 'PORCODIO', 'حرامی']) {
    const r = await s.api('POST', '/v1/lookup', { q, lang: 'ur' });
    assert.strictEqual(r.status, 422, q);
  }
  assert.strictEqual(s.fetchImpl.calls.length, 0);
});

test('offensive: blocklist on the answer even if Gemini says it is fine', async (t) => {
  const s = await startServer({ script: [reply({ ...GOOD, it: 'lo stronzo', gloss: 'jerk', offensive: false })] });
  t.after(s.close);
  const r = await s.api('POST', '/v1/lookup', { q: 'innocent looking', lang: 'en' });
  assert.strictEqual(r.status, 422);
  assert.strictEqual(s.store.count(), 0);
});

test('blocklist does not catch innocent words', () => {
  const isBlocked = makeModerator();
  for (const w of ['il cane', 'la casa', 'cazzuola', 'bastare', 'mi scusi', 'grazie mille', 'kutta', 'negro', 'Dio']) {
    assert.ok(!isBlocked(w), w);
  }
});

test('validation failures: bad request input', async (t) => {
  const s = await startServer();
  t.after(s.close);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'casa', lang: 'de' })).status, 400);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: '', lang: 'en' })).status, 400);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: '?!...', lang: 'en' })).status, 400);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'a'.repeat(121), lang: 'en' })).status, 400);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 5, lang: 'en' })).status, 400);
  assert.strictEqual((await s.api('POST', '/v1/lookup', '{bad json')).status, 400);
  const big = await s.api('POST', '/v1/lookup', { q: 'x', lang: 'en', pad: 'y'.repeat(3000) });
  assert.strictEqual(big.status, 413);
  assert.strictEqual(s.fetchImpl.calls.length, 0);
});

test('validation failures: invalid Gemini output falls back to next model, then 502', async (t) => {
  const badScript = { ...GOOD, tr: GOOD.tr.map((x, i) => (i === 3 ? 'tamatar' : x)) }; // Gurmukhi slot in Latin
  const s = await startServer({ script: [reply(badScript), reply('not json at all'), reply({ ...GOOD, tr: GOOD.tr.slice(0, 9) })] });
  t.after(s.close);
  const r = await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' });
  assert.strictEqual(r.status, 502);
  assert.deepStrictEqual(r.body, { error: 'upstream_invalid' });
  assert.strictEqual(s.fetchImpl.calls.length, 3); // one per model
  assert.strictEqual(s.store.count(), 0);
  // gemma models get no responseMimeType
  assert.strictEqual(s.fetchImpl.calls[2].body.generationConfig.responseMimeType, undefined);
  assert.ok(s.fetchImpl.calls[2].url.includes('/gemma-c:generateContent'));
});

test('Gemini 429 -> next key, 5xx -> next, then success', async (t) => {
  const s = await startServer({ script: [reply({}, 429), reply({}, 503), reply(GOOD)] });
  t.after(s.close);
  const r = await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' });
  assert.strictEqual(r.status, 200);
  const keys = s.fetchImpl.calls.map((c) => c.key);
  assert.notStrictEqual(keys[0], keys[1]); // rotated after 429
  assert.ok(s.fetchImpl.calls[2].url.includes('/gemini-b:'));
});

test('Gemini timeout / all down -> 503 upstream_unavailable', async (t) => {
  const hang = (url, init) => new Promise((resolve, reject) => {
    init.signal.addEventListener('abort', () => reject(Object.assign(new Error('aborted'), { name: 'AbortError' })));
  });
  const s = await startServer({ script: [hang] });
  t.after(s.close);
  const r = await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' });
  assert.strictEqual(r.status, 503);
  assert.deepStrictEqual(r.body, { error: 'upstream_unavailable' });
});

test('unknown words -> 404 and negative cache', async (t) => {
  const s = await startServer({ script: [reply({ unknown: true, offensive: false })] });
  t.after(s.close);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'qwzxkj', lang: 'en' })).status, 404);
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'qwzxkj', lang: 'en' })).status, 404);
  assert.strictEqual(s.fetchImpl.calls.length, 1);
});

test('updates paging', async (t) => {
  const words = ['uno', 'due', 'tre', 'quattro', 'cinque'];
  const script = words.map((w) => reply({ ...GOOD, it: `il ${w}`, gloss: w, tr: GOOD.tr.map((x, i) => (i === 0 ? w : i >= 7 ? `${x} ${w}` : x)) }));
  const s = await startServer({ script });
  t.after(s.close);
  for (const w of words) assert.strictEqual((await s.api('POST', '/v1/lookup', { q: `${w} x`, lang: 'en' })).status, 200);

  let since = 0;
  const seen = [];
  for (let page = 0; page < 10; page++) {
    const r = await s.api('GET', `/v1/updates?since=${since}&limit=2`);
    assert.strictEqual(r.status, 200);
    seen.push(...r.body.entries.map((e) => e.it));
    if (!r.body.entries.length) break;
    since = r.body.next;
  }
  assert.deepStrictEqual(seen, words.map((w) => `il ${w}`));
  const last = await s.api('GET', `/v1/updates?since=${since}`);
  assert.deepStrictEqual(last.body.entries, []);
  assert.strictEqual(last.body.next, since);
  // limit is capped at 5000
  assert.strictEqual((await s.api('GET', '/v1/updates?limit=999999')).body.entries.length, 5);
});

test('rate limit per IP', async (t) => {
  const s = await startServer({ env: { RATE_LOOKUP_PER_MIN: '3' } });
  t.after(s.close);
  for (let i = 0; i < 3; i++) assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' })).status, 200);
  const r = await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' });
  assert.strictEqual(r.status, 429);
  assert.strictEqual(r.body.error, 'rate_limited');
  assert.ok(Number(r.headers.get('retry-after')) >= 1);
  // updates have their own bucket
  assert.strictEqual((await s.api('GET', '/v1/updates')).status, 200);
});

test('daily rate limit per IP', async (t) => {
  const s = await startServer({ env: { RATE_LOOKUP_PER_DAY: '2' } });
  t.after(s.close);
  await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' });
  await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' });
  const r = await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' });
  assert.strictEqual(r.status, 429);
  assert.ok(Number(r.headers.get('retry-after')) > 60);
});

test('admin: auth, recent, delete with tombstone and block', async (t) => {
  const s = await startServer();
  t.after(s.close);
  const e = (await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' })).body;
  assert.strictEqual((await s.api('GET', '/v1/admin/recent')).status, 401);
  assert.strictEqual((await s.api('GET', '/v1/admin/recent', undefined, { authorization: 'Bearer wrong' })).status, 401);
  const rec = await s.api('GET', '/v1/admin/recent', undefined, ADMIN);
  assert.strictEqual(rec.status, 200);
  assert.strictEqual(rec.body.entries[0].src_q, 'tomato');

  assert.strictEqual((await s.api('DELETE', `/v1/admin/entry/${e.id}`)).status, 401);
  const del = await s.api('DELETE', `/v1/admin/entry/${e.id}?block=1`, undefined, ADMIN);
  assert.strictEqual(del.status, 200);
  assert.strictEqual(s.store.count(), 0);
  assert.strictEqual(s.store.raw.prepare('SELECT COUNT(*) n FROM keys').get().n, 0);
  assert.strictEqual((await s.api('DELETE', `/v1/admin/entry/${e.id}`, undefined, ADMIN)).status, 404);
  // phones learn about the removal
  const up = await s.api('GET', '/v1/updates?since=0');
  assert.deepStrictEqual(up.body.removed, [e.id]);
  // blocked query is not regenerated
  assert.strictEqual((await s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' })).status, 422);
  assert.strictEqual(s.fetchImpl.calls.length, 1);
});

test('admin disabled without a token', async (t) => {
  const s = await startServer({ env: { ADMIN_TOKEN: '' } });
  t.after(s.close);
  assert.strictEqual((await s.api('GET', '/v1/admin/recent', undefined, { authorization: 'Bearer ' })).status, 401);
});

test('concurrent identical misses share one Gemini call', async (t) => {
  const slow = () => new Promise((r) => setTimeout(() => r(reply(GOOD)), 50));
  const s = await startServer({ script: [slow] });
  t.after(s.close);
  const rs = await Promise.all([1, 2, 3].map(() => s.api('POST', '/v1/lookup', { q: 'tomato', lang: 'en' })));
  assert.ok(rs.every((r) => r.status === 200));
  assert.strictEqual(s.fetchImpl.calls.length, 1);
});
