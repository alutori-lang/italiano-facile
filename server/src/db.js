'use strict';
const fs = require('node:fs');
const path = require('node:path');
const Database = require('better-sqlite3');

const SCHEMA = `
CREATE TABLE IF NOT EXISTS entries (
  id INTEGER PRIMARY KEY,
  it TEXT NOT NULL,
  it_norm TEXT NOT NULL,
  pos TEXT NOT NULL,
  g TEXT,
  pl TEXT,
  gloss TEXT NOT NULL,
  ex_it TEXT,
  ex_en TEXT,
  tr TEXT NOT NULL,          -- JSON array of the 10 meanings (slot order)
  rom TEXT NOT NULL,         -- JSON {ur, pa, bn, zh}
  src_q TEXT NOT NULL,
  src_lang TEXT NOT NULL,
  model TEXT,
  hits INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL UNIQUE
);
CREATE INDEX IF NOT EXISTS entries_it_norm ON entries(it_norm);

-- lookup keys: (normalized text, language) -> entry. lang 'it' = Italian headword.
CREATE TABLE IF NOT EXISTS keys (
  key TEXT NOT NULL,
  lang TEXT NOT NULL,
  entry_id INTEGER NOT NULL REFERENCES entries(id) ON DELETE CASCADE,
  PRIMARY KEY (key, lang)
) WITHOUT ROWID;
CREATE INDEX IF NOT EXISTS keys_entry ON keys(entry_id);

-- negative cache: queries Gemini refused / marked offensive / that an admin blocked.
CREATE TABLE IF NOT EXISTS rejects (
  key TEXT NOT NULL,
  lang TEXT NOT NULL,
  reason TEXT NOT NULL,      -- not_allowed | not_found
  created_at INTEGER NOT NULL,
  PRIMARY KEY (key, lang)
) WITHOUT ROWID;

-- tombstones so phones can drop entries an admin removed.
CREATE TABLE IF NOT EXISTS removed (
  id INTEGER PRIMARY KEY,
  removed_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS removed_at_idx ON removed(removed_at);
`;

function openDb(file) {
  if (file !== ':memory:') fs.mkdirSync(path.dirname(path.resolve(file)), { recursive: true });
  const db = new Database(file);
  db.pragma('journal_mode = WAL');
  db.pragma('synchronous = NORMAL');
  db.pragma('foreign_keys = ON');
  db.pragma('busy_timeout = 5000');
  db.exec(SCHEMA);
  return makeStore(db);
}

function rowToEntry(r) {
  return {
    id: r.id,
    it: r.it,
    pos: r.pos,
    g: r.g ?? null,
    pl: r.pl ?? null,
    gloss: r.gloss,
    ex_it: r.ex_it ?? null,
    ex_en: r.ex_en ?? null,
    tr: JSON.parse(r.tr),
    rom: JSON.parse(r.rom),
    created_at: r.created_at,
  };
}

function makeStore(db) {
  const q = {
    count: db.prepare('SELECT COUNT(*) AS n FROM entries'),
    byKey: db.prepare('SELECT e.* FROM keys k JOIN entries e ON e.id = k.entry_id WHERE k.key = ? AND k.lang = ?'),
    byItNorm: db.prepare('SELECT * FROM entries WHERE it_norm = ? ORDER BY id LIMIT 1'),
    byId: db.prepare('SELECT * FROM entries WHERE id = ?'),
    hit: db.prepare('UPDATE entries SET hits = hits + 1 WHERE id = ?'),
    lastCreated: db.prepare('SELECT MAX(created_at) AS m FROM entries'),
    insert: db.prepare(`INSERT INTO entries (it, it_norm, pos, g, pl, gloss, ex_it, ex_en, tr, rom, src_q, src_lang, model, created_at)
      VALUES (@it, @it_norm, @pos, @g, @pl, @gloss, @ex_it, @ex_en, @tr, @rom, @src_q, @src_lang, @model, @created_at)`),
    addKey: db.prepare('INSERT OR IGNORE INTO keys (key, lang, entry_id) VALUES (?, ?, ?)'),
    reject: db.prepare('SELECT reason FROM rejects WHERE key = ? AND lang = ?'),
    addReject: db.prepare('INSERT OR REPLACE INTO rejects (key, lang, reason, created_at) VALUES (?, ?, ?, ?)'),
    updates: db.prepare('SELECT * FROM entries WHERE created_at > ? ORDER BY created_at LIMIT ?'),
    removedSince: db.prepare('SELECT id FROM removed WHERE removed_at > ? ORDER BY removed_at LIMIT 5000'),
    recent: db.prepare('SELECT * FROM entries ORDER BY created_at DESC LIMIT ?'),
    del: db.prepare('DELETE FROM entries WHERE id = ?'),
    tomb: db.prepare('INSERT OR REPLACE INTO removed (id, removed_at) VALUES (?, ?)'),
  };

  let lastTs = q.lastCreated.get().m || 0;
  // created_at is strictly increasing so `since` paging never skips an entry.
  const nextTs = () => {
    lastTs = Math.max(Date.now(), lastTs + 1);
    return lastTs;
  };

  const insertTx = db.transaction((e, keys) => {
    const existing = q.byItNorm.get(e.it_norm);
    const id = existing ? existing.id : Number(q.insert.run({ ...e, created_at: nextTs() }).lastInsertRowid);
    for (const [key, lang] of keys) if (key) q.addKey.run(key, lang, id);
    return { row: q.byId.get(id), created: !existing };
  });

  const deleteTx = db.transaction((id, blockKeys) => {
    const row = q.byId.get(id);
    if (!row) return null;
    q.del.run(id);
    q.tomb.run(id, Date.now());
    for (const [key, lang] of blockKeys(row)) if (key) q.addReject.run(key, lang, 'not_allowed', Date.now());
    return row;
  });

  return {
    raw: db,
    count: () => q.count.get().n,
    findByKey(key, lang) {
      const r = key ? q.byKey.get(key, lang) : undefined;
      return r || null;
    },
    hit: (id) => q.hit.run(id),
    getReject(key, lang) {
      const r = q.reject.get(key, lang);
      return r ? r.reason : null;
    },
    addReject: (key, lang, reason) => key && q.addReject.run(key, lang, reason, Date.now()),
    /** Stores an entry (or reuses the one with the same Italian headword) and its keys. */
    insertEntry: (e, keys) => insertTx(e, keys),
    updates(since, limit) {
      return q.updates.all(since, limit);
    },
    removedSince: (since) => q.removedSince.all(since).map((r) => r.id),
    recent: (limit) => q.recent.all(limit),
    deleteEntry: (id, blockKeys) => deleteTx(id, blockKeys),
    close: () => db.close(),
  };
}

module.exports = { openDb, rowToEntry };
