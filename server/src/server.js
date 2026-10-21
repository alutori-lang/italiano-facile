'use strict';
const { loadDotEnv, readConfig } = require('./config');

loadDotEnv();
const config = readConfig();
const { openDb } = require('./db');
const { makeGemini } = require('./gemini');
const { createApp } = require('./app');

const store = openDb(config.dbFile);
const gemini = makeGemini({ ...config.gemini, log: (m) => console.log(m) });
const app = createApp({ store, gemini, config });

if (!config.gemini.keys.length) console.warn('WARNING: GEMINI_API_KEYS is empty, lookups of new words will fail (503).');
if (!config.adminToken) console.warn('WARNING: ADMIN_TOKEN is empty, admin endpoints are disabled.');

const server = app.listen(config.port, config.host, () => {
  console.log(`italian-words server on http://${config.host}:${config.port} (${store.count()} entries, ${config.gemini.keys.length} Gemini keys, models: ${config.gemini.models.join(', ')})`);
});

function shutdown(sig) {
  console.log(`${sig}: shutting down`);
  server.close(() => {
    store.close();
    process.exit(0);
  });
  setTimeout(() => process.exit(1), 10000).unref();
}
process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
