'use strict';
const crypto = require('node:crypto');
const express = require('express');
const { norm, romkey, isLatin } = require('./norm');
const { TAGS, ROM_LANGS } = require('./langs');
const { rowToEntry } = require('./db');
const { makeModerator } = require('./moderation');
const { makeRateLimiter } = require('./ratelimit');
const { UpstreamError } = require('./gemini');

const MAX_Q = 120;
const ARTICLES = new Set(['il', 'lo', 'la', 'i', 'gli', 'le', 'l', 'un', 'uno', 'una']);

/** "il pomodoro" -> "pomodoro", "l acqua" -> "acqua" (already normalized). */
function withoutArticle(n) {
  const parts = n.split(' ');
  return parts.length > 1 && ARTICLES.has(parts[0]) ? parts.slice(1).join(' ') : null;
}

/** "eat / to eat; dine" -> ["eat", "to eat", "dine"] (normalized, also without "to "). */
function variants(text) {
  const out = new Set();
  for (const part of String(text).split(/\s*[/;,]\s*/)) {
    const clean = part.replace(/\([^)]*\)/g, '').trim();
    const n = norm(clean);
    if (!n) continue;
    out.add(n);
    if (n.startsWith('to ')) out.add(n.slice(3));
  }
  return [...out];
}

/** All (key, lang) rows that should point to a stored entry. */
function keysFor(value, q, lang, qLang) {
  const keys = [];
  const nIt = norm(value.it);
  keys.push([nIt, 'it']);
  const bare = withoutArticle(nIt);
  if (bare) keys.push([bare, 'it']);
  const nq = norm(q);
  keys.push([nq, qLang === 'it' ? 'it' : lang]);
  if (qLang !== 'it' && isLatin(q)) keys.push(['~' + romkey(q), lang]);
  value.tr.forEach((t, i) => {
    for (const v of variants(t)) keys.push([v, TAGS[i]]);
  });
  for (const [k, langs] of Object.entries(ROM_LANGS)) {
    const r = value.rom[k];
    if (!r) continue;
    for (const spelling of r.split('|')) {
      const rk = romkey(spelling);
      if (rk) for (const l of langs) keys.push(['~' + rk, l]);
    }
  }
  return keys.filter(([k]) => k && k !== '~');
}

function safeEqual(a, b) {
  const ha = crypto.createHash('sha256').update(String(a)).digest();
  const hb = crypto.createHash('sha256').update(String(b)).digest();
  return crypto.timingSafeEqual(ha, hb);
}

/**
 * Builds the Express app.
 * deps: { store (db.openDb), gemini (makeGemini), config (readConfig), log }
 */
function createApp({ store, gemini, config, log = console.log }) {
  const app = express();
  const isBlocked = makeModerator();
  const lookupLimiter = makeRateLimiter({ perMinute: config.rate.lookupPerMinute, perDay: config.rate.lookupPerDay, name: 'lookup' });
  const updatesLimiter = makeRateLimiter({ perMinute: config.rate.updatesPerMinute, perDay: config.rate.updatesPerDay, name: 'updates' });
  const inflight = new Map();
  const budget = { day: new Date().toISOString().slice(0, 10), used: 0 };

  app.disable('x-powered-by');
  app.set('trust proxy', config.trustProxy);
  app.set('json spaces', 0);

  // Basic security headers (helmet-like) + request log without bodies/keys.
  app.use((req, res, next) => {
    res.set({
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'Referrer-Policy': 'no-referrer',
      'Content-Security-Policy': "default-src 'none'; frame-ancestors 'none'",
      'Cross-Origin-Resource-Policy': 'same-origin',
      'Cache-Control': 'no-store',
    });
    const t0 = Date.now();
    res.on('finish', () => {
      if (config.quiet) return;
      log(`${new Date().toISOString()} ${req.ip} ${req.method} ${req.path} ${res.statusCode} ${Date.now() - t0}ms`);
    });
    next();
  });
  app.use(express.json({ limit: '2kb' }));

  app.get('/health', (req, res) => res.json({ ok: true, entries: store.count() }));

  // ---------- lookup ----------
  function cached(nq, q, lang) {
    const tries = [[nq, lang], [nq, 'it']];
    if (isLatin(q)) tries.push(['~' + romkey(q), lang]);
    for (const [k, l] of tries) {
      const row = store.findByKey(k, l);
      if (row) return row;
    }
    return null;
  }

  function spendBudget() {
    const today = new Date().toISOString().slice(0, 10);
    if (budget.day !== today) { budget.day = today; budget.used = 0; }
    if (budget.used >= config.gemini.dailyMax) return false;
    budget.used++;
    return true;
  }

  async function resolveMiss(q, nq, lang) {
    if (!spendBudget()) return { status: 503, body: { error: 'busy' } };
    let ans;
    try {
      ans = await gemini.ask(q, lang);
    } catch (e) {
      if (e instanceof UpstreamError && e.code === 'invalid') return { status: 502, body: { error: 'upstream_invalid' } };
      log(`lookup upstream error: ${e.message}`);
      return { status: 503, body: { error: 'upstream_unavailable' } };
    }
    const { result, model, raw } = ans;
    const v = result.value;
    if (result.offensive || (v && isBlocked(v.it, v.gloss, v.pl, v.ex_it, v.ex_en, v.tr[0]))) {
      store.addReject(nq, lang, 'not_allowed');
      return { status: 422, body: { error: 'not_allowed' } };
    }
    if (result.unknown) {
      store.addReject(nq, lang, 'not_found');
      return { status: 404, body: { error: 'not_found' } };
    }
    const qLang = raw && raw.q_lang === 'it' ? 'it' : lang;
    const { row } = store.insertEntry(
      {
        it: v.it, it_norm: norm(v.it), pos: v.pos, g: v.g, pl: v.pl, gloss: v.gloss,
        ex_it: v.ex_it, ex_en: v.ex_en, tr: JSON.stringify(v.tr), rom: JSON.stringify(v.rom),
        src_q: q, src_lang: lang, model,
      },
      keysFor(v, q, lang, qLang),
    );
    return { status: 200, body: { ...rowToEntry(row), cached: false } };
  }

  app.post('/v1/lookup', lookupLimiter, async (req, res, next) => {
    try {
      const body = req.body || {};
      const lang = body.lang;
      const q = typeof body.q === 'string' ? body.q.trim().replace(/\s+/g, ' ') : '';
      if (!TAGS.includes(lang)) return res.status(400).json({ error: 'bad_lang' });
      if (!q || [...q].length > MAX_Q) return res.status(400).json({ error: 'bad_q' });
      const nq = norm(q);
      if (!nq) return res.status(400).json({ error: 'bad_q' });
      if (isBlocked(q)) return res.status(422).json({ error: 'not_allowed' });

      const row = cached(nq, q, lang);
      if (row) {
        store.hit(row.id);
        return res.json({ ...rowToEntry(row), cached: true });
      }
      const rej = store.getReject(nq, lang);
      if (rej === 'not_allowed') return res.status(422).json({ error: 'not_allowed' });
      if (rej === 'not_found') return res.status(404).json({ error: 'not_found' });

      // Identical concurrent misses share one Gemini call.
      const flightKey = `${lang}\u0000${nq}`;
      let p = inflight.get(flightKey);
      if (!p) {
        p = resolveMiss(q, nq, lang).finally(() => inflight.delete(flightKey));
        inflight.set(flightKey, p);
      }
      const out = await p;
      return res.status(out.status).json(out.body);
    } catch (e) {
      next(e);
    }
  });

  // ---------- updates ----------
  app.get('/v1/updates', updatesLimiter, (req, res) => {
    const since = Math.max(0, parseInt(req.query.since, 10) || 0);
    let limit = parseInt(req.query.limit, 10) || 1000;
    limit = Math.min(Math.max(limit, 1), 5000);
    const rows = store.updates(since, limit);
    const entries = rows.map(rowToEntry);
    res.json({
      entries,
      next: entries.length ? entries[entries.length - 1].created_at : since,
      more: entries.length === limit,
      removed: store.removedSince(since),
    });
  });

  // ---------- admin ----------
  function admin(req, res, next) {
    const m = /^Bearer\s+(.+)$/.exec(req.get('authorization') || '');
    if (!config.adminToken || config.adminToken.length < 16 || !m || !safeEqual(m[1].trim(), config.adminToken)) {
      return res.status(401).json({ error: 'unauthorized' });
    }
    next();
  }

  app.get('/v1/admin/recent', admin, (req, res) => {
    const limit = Math.min(Math.max(parseInt(req.query.limit, 10) || 50, 1), 500);
    res.json({
      entries: store.recent(limit).map((r) => ({ ...rowToEntry(r), src_q: r.src_q, src_lang: r.src_lang, hits: r.hits, model: r.model })),
    });
  });

  app.delete('/v1/admin/entry/:id', admin, (req, res) => {
    const id = parseInt(req.params.id, 10);
    if (!Number.isInteger(id) || id <= 0) return res.status(400).json({ error: 'bad_id' });
    const block = req.query.block === '1' || req.query.block === 'true';
    // With ?block=1 the query that produced the entry is blocked so it is not regenerated.
    const row = store.deleteEntry(id, (r) => (block ? [[norm(r.src_q), r.src_lang]] : []));
    if (!row) return res.status(404).json({ error: 'not_found' });
    res.json({ ok: true, id, it: row.it, blocked: block });
  });

  app.use((req, res) => res.status(404).json({ error: 'no_route' }));

  // eslint-disable-next-line no-unused-vars
  app.use((err, req, res, next) => {
    if (err.type === 'entity.too.large') return res.status(413).json({ error: 'too_large' });
    if (err.type === 'entity.parse.failed') return res.status(400).json({ error: 'bad_json' });
    log(`error: ${err.message}`);
    res.status(500).json({ error: 'server_error' });
  });

  app.locals.limiters = [lookupLimiter, updatesLimiter];
  return app;
}

module.exports = { createApp, keysFor, variants, withoutArticle };
