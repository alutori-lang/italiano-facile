'use strict';
const fs = require('node:fs');
const path = require('node:path');
const { norm } = require('./norm');

function loadBlocklist(file = path.join(__dirname, 'blocklist.txt')) {
  const lines = fs.readFileSync(file, 'utf8').split(/\r?\n/);
  const words = new Set();
  const phrases = [];
  for (const line of lines) {
    const t = line.trim();
    if (!t || t.startsWith('#')) continue;
    const n = norm(t);
    if (!n) continue;
    if (n.includes(' ')) {
      phrases.push(n);
      words.add(n.replaceAll(' ', '')); // "porco dio" also catches "porcodio"
    } else words.add(n);
  }
  return { words, phrases };
}

function makeModerator(list = loadBlocklist()) {
  /** True if any of the texts contains a blocked word or phrase. */
  return function isBlocked(...texts) {
    for (const t of texts) {
      if (typeof t !== 'string' || !t) continue;
      const n = norm(t);
      if (!n) continue;
      const tokens = n.split(' ');
      if (tokens.some((w) => list.words.has(w))) return true;
      if (list.words.has(n.replaceAll(' ', ''))) return true;
      const padded = ` ${n} `;
      if (list.phrases.some((p) => padded.includes(` ${p} `))) return true;
    }
    return false;
  };
}

module.exports = { loadBlocklist, makeModerator };
