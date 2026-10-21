'use strict';
// Tiny in-memory per-IP limiter: a per-minute and a per-day fixed window.

function makeRateLimiter({ perMinute, perDay, name = 'rl', now = () => Date.now() }) {
  const buckets = new Map(); // ip -> { m, mStart, d, dStart }
  const MIN = 60_000;
  const DAY = 86_400_000;

  const sweep = setInterval(() => {
    const t = now();
    for (const [ip, b] of buckets) if (t - b.dStart > DAY) buckets.delete(ip);
  }, 10 * MIN);
  sweep.unref();

  function middleware(req, res, next) {
    const ip = req.ip || req.socket.remoteAddress || 'unknown';
    const t = now();
    let b = buckets.get(ip);
    if (!b) {
      b = { m: 0, mStart: t, d: 0, dStart: t };
      buckets.set(ip, b);
    }
    if (t - b.mStart >= MIN) { b.m = 0; b.mStart = t; }
    if (t - b.dStart >= DAY) { b.d = 0; b.dStart = t; }
    if (b.m >= perMinute || b.d >= perDay) {
      const retry = b.d >= perDay ? b.dStart + DAY - t : b.mStart + MIN - t;
      const sec = Math.max(1, Math.ceil(retry / 1000));
      res.set('Retry-After', String(sec));
      return res.status(429).json({ error: 'rate_limited', retry_after: sec, scope: name });
    }
    b.m++;
    b.d++;
    next();
  }

  middleware.reset = () => buckets.clear();
  middleware.stop = () => clearInterval(sweep);
  return middleware;
}

module.exports = { makeRateLimiter };
