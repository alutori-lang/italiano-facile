#!/usr/bin/env bash
# Italian Words server - one-shot, idempotent setup for a fresh Ubuntu VPS (run as root).
#
#   cd /opt/italian-words/server && bash deploy/setup.sh
#   DOMAIN=api.example.com CERTBOT_EMAIL=you@example.com bash deploy/setup.sh   # + HTTPS
#
# Safe to run again after every code update: it reinstalls deps and reloads the app.
set -euo pipefail

APP_USER="${APP_USER:-iwords}"
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_HOME="/home/${APP_USER}"
NODE_MAJOR="${NODE_MAJOR:-22}"
DOMAIN="${DOMAIN:-}"
CERTBOT_EMAIL="${CERTBOT_EMAIL:-}"
PORT_IN_ENV=3100

say() { printf '\n\033[1;32m==> %s\033[0m\n' "$*"; }

[ "$(id -u)" -eq 0 ] || { echo "Run as root (sudo bash deploy/setup.sh)"; exit 1; }
[ -f "${APP_DIR}/package.json" ] || { echo "package.json not found in ${APP_DIR}"; exit 1; }

say "System packages"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y ca-certificates curl gnupg build-essential python3 \
  nginx ufw sqlite3 certbot python3-certbot-nginx openssl

say "Node.js ${NODE_MAJOR}.x (NodeSource)"
need_node=1
if command -v node >/dev/null 2>&1; then
  have="$(node -p 'process.versions.node.split(".")[0]')"
  [ "${have}" -ge 20 ] && need_node=0
fi
if [ "${need_node}" -eq 1 ]; then
  curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -
  apt-get install -y nodejs
fi
node -v
command -v pm2 >/dev/null 2>&1 || npm install -g pm2@latest

say "Firewall (OpenSSH, 80, 443)"
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
ufw status | head -n 8

say "User ${APP_USER}"
if ! id -u "${APP_USER}" >/dev/null 2>&1; then
  useradd --system --create-home --home-dir "${APP_HOME}" --shell /usr/sbin/nologin "${APP_USER}"
fi

say "Config (.env)"
if [ ! -f "${APP_DIR}/.env" ]; then
  cp "${APP_DIR}/.env.example" "${APP_DIR}/.env"
  token="$(openssl rand -hex 24)"
  sed -i "s/^ADMIN_TOKEN=.*/ADMIN_TOKEN=${token}/" "${APP_DIR}/.env"
  sed -i "s/^GEMINI_API_KEYS=.*/GEMINI_API_KEYS=/" "${APP_DIR}/.env"
  echo "Created .env with a new ADMIN_TOKEN (see: grep ADMIN_TOKEN ${APP_DIR}/.env)"
fi
if [ -n "${GEMINI_API_KEYS:-}" ]; then
  sed -i "s|^GEMINI_API_KEYS=.*|GEMINI_API_KEYS=${GEMINI_API_KEYS}|" "${APP_DIR}/.env"
fi
port="$(grep -E '^PORT=' "${APP_DIR}/.env" | cut -d= -f2 || true)"
PORT_IN_ENV="${port:-3100}"
mkdir -p "${APP_DIR}/data"
chown -R "${APP_USER}:${APP_USER}" "${APP_DIR}"
chmod 600 "${APP_DIR}/.env"
chmod 700 "${APP_DIR}/data"

say "npm dependencies"
cd "${APP_DIR}"
if [ -f package-lock.json ]; then
  sudo -u "${APP_USER}" -H npm ci --omit=dev --no-audit --no-fund
else
  sudo -u "${APP_USER}" -H npm install --omit=dev --no-audit --no-fund
fi

say "pm2 (process + start at boot)"
sudo -u "${APP_USER}" -H pm2 startOrReload "${APP_DIR}/ecosystem.config.cjs" --update-env
sudo -u "${APP_USER}" -H pm2 save
if [ ! -f "/etc/systemd/system/pm2-${APP_USER}.service" ]; then
  env PATH="$PATH:/usr/bin" pm2 startup systemd -u "${APP_USER}" --hp "${APP_HOME}"
fi
systemctl enable "pm2-${APP_USER}" >/dev/null 2>&1 || true
# log rotation for pm2 logs (idempotent)
sudo -u "${APP_USER}" -H pm2 describe pm2-logrotate >/dev/null 2>&1 || sudo -u "${APP_USER}" -H pm2 install pm2-logrotate || true

say "nginx"
site=/etc/nginx/sites-available/italian-words
if [ ! -f "${site}" ] || ! grep -qiE "managed by certbot|ssl_certificate" "${site}"; then
  # (never overwrite a file certbot already edited for HTTPS)
  cp "${APP_DIR}/deploy/nginx.conf" "${site}"
  sed -i "s/127\.0\.0\.1:3100/127.0.0.1:${PORT_IN_ENV}/" "${site}"
  if [ -n "${DOMAIN}" ]; then sed -i "s/server_name _;/server_name ${DOMAIN};/" "${site}"; fi
fi
ln -sf "${site}" /etc/nginx/sites-enabled/italian-words
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl enable nginx >/dev/null 2>&1
systemctl reload nginx || systemctl restart nginx

if [ -n "${DOMAIN}" ] && [ -n "${CERTBOT_EMAIL}" ]; then
  say "HTTPS certificate for ${DOMAIN}"
  certbot --nginx -d "${DOMAIN}" -m "${CERTBOT_EMAIL}" --agree-tos --non-interactive \
    --redirect --keep-until-expiring
fi

say "Health check"
ok=0
for _ in 1 2 3 4 5 6 7 8 9 10; do
  if curl -fsS "http://127.0.0.1:${PORT_IN_ENV}/health"; then ok=1; break; fi
  sleep 1
done
echo
[ "${ok}" -eq 1 ] || { echo "Server not answering: sudo -u ${APP_USER} -H pm2 logs italian-words"; exit 1; }
curl -fsS "http://127.0.0.1/health" -H "Host: ${DOMAIN:-localhost}" >/dev/null && echo "nginx -> node OK"

if ! grep -qE '^GEMINI_API_KEYS=.+' "${APP_DIR}/.env"; then
  echo
  echo "!! GEMINI_API_KEYS is empty: edit ${APP_DIR}/.env, then run:"
  echo "   sudo -u ${APP_USER} -H pm2 reload italian-words --update-env"
fi
say "Done"
