// pm2 start ecosystem.config.cjs  (settings come from server/.env, read by src/config.js)
module.exports = {
  apps: [
    {
      name: 'italian-words',
      script: 'src/server.js',
      cwd: __dirname,
      instances: 1, // SQLite + in-memory rate limits: keep ONE process
      exec_mode: 'fork',
      max_memory_restart: '300M',
      time: true,
      env: { NODE_ENV: 'production' },
    },
  ],
};
