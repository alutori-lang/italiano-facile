# Italian Words — server del dizionario condiviso

Quando un utente cerca una parola che il dizionario offline dell'app non ha, l'app chiama
questo server. Il server chiede a Gemini, controlla la risposta, la salva in un database
**condiviso** (SQLite, `data/words.db`) e da quel momento tutti i telefoni la scaricano con
`/v1/updates`, così funziona offline per tutti.

- Node.js 20+ (sul VPS: Node 22 LTS), Express, better-sqlite3. Nessun'altra dipendenza.
- `src/norm.js` è la copia esatta di `norm()` / `romkey()` di `dictdata/scripts/build_bigdb.py`
  (test di parità con `test/fixtures/norm_cases.json`).
- Parolacce e insulti non vengono mai salvati: flag `offensive` di Gemini **più** la lista
  locale `src/blocklist.txt` (si può modificare; poi `pm2 reload`).

## API (per l'app)

| Metodo | Percorso | Note |
|---|---|---|
| GET | `/health` | `{ok:true, entries:N}` |
| POST | `/v1/lookup` | body `{"q":"tomato","lang":"en"}` — `q` max 120 caratteri, `lang` = `en ur pa_Arab pa bn si zh fr es es_419` |
| GET | `/v1/updates?since=<ms>&limit=<≤5000>` | `{entries:[…], next:<ms>, more:bool, removed:[id…]}` |
| GET | `/v1/admin/recent?limit=50` | `Authorization: Bearer <ADMIN_TOKEN>` |
| DELETE | `/v1/admin/entry/:id[?block=1]` | toglie una voce sbagliata; `block=1` blocca anche la ricerca che l'ha creata |

Voce restituita (lookup e updates):
```json
{"id":12,"it":"il pomodoro","pos":"noun","g":"m","pl":"i pomodori","gloss":"tomato",
 "ex_it":"Compro un chilo di pomodori.","ex_en":"I buy a kilo of tomatoes.",
 "tr":["tomato","ٹماٹر","ٹماٹر","ਟਮਾਟਰ","টমেটো","තක්කාලි","番茄","tomate","tomate","jitomate"],
 "rom":{"ur":"tamatar","pa":"tamatar","bn":"tometo","zh":"fanqie|xihongshi"},
 "created_at":1792000000000,"cached":false}
```
`tr` è nell'ordine degli slot di `LearnerLanguage` (0..9). Nel `big.db` dell'app `tr` è unito con
U+001F e `rom` è lo stesso JSON.

Risposte d'errore: `400 bad_q / bad_lang / bad_json`, `413 too_large` (body > 2 KB),
`404 not_found` (parola inesistente), `422 not_allowed` (offensiva), `429 rate_limited`
(header `Retry-After`; 30 lookup/minuto e 1000/giorno per IP), `502 upstream_invalid`
(Gemini ha risposto male con tutti i modelli), `503 upstream_unavailable` / `busy`.

Sincronizzazione nell'app: salvare `next` e richiamare `/v1/updates?since=<next>` finché
`more` è `true`; cancellare in locale gli id presenti in `removed`.
Timeout consigliato lato app per `/v1/lookup`: 60 secondi (il server si ferma a 50).

## Prova in locale (Windows)

```powershell
cd C:\FlutterCursor\workspaces\uzpapjixpmij\projects\simple_flutter_app_651\server
npm install
npm test            # Gemini è finto nei test, nessuna chiamata in rete
copy .env.example .env   # poi metti le chiavi vere in .env
npm start           # http://127.0.0.1:3100/health
```

## Deploy di domani sul VPS Contabo (Ubuntu, root via SSH)

Serve: l'IP del VPS e la password di root (o la chiave SSH).
**Consigliato un nome a dominio** (es. `api.tuodominio.it`, record DNS **A** → IP del VPS):
Android accetta solo `https://`, e il certificato gratuito Let's Encrypt richiede un nome.
Senza dominio si può usare `<IP-con-trattini>.sslip.io` (es. `5-189-10-20.sslip.io`), che punta
già all'IP.

### 1. Sul PC (PowerShell), prepara il pacchetto
```powershell
cd C:\FlutterCursor\workspaces\uzpapjixpmij\projects\simple_flutter_app_651
git archive --format=tar.gz -o $env:TEMP\iw-server.tgz HEAD:server
scp $env:TEMP\iw-server.tgz root@IP_DEL_VPS:/root/
```
(Il pacchetto contiene solo i file del commit: niente `node_modules`, niente `.env`, niente `data/`.)

### 2. Sul VPS
```bash
ssh root@IP_DEL_VPS
mkdir -p /opt/italian-words/server
tar -xzf /root/iw-server.tgz -C /opt/italian-words/server
cd /opt/italian-words/server
DOMAIN=api.tuodominio.it CERTBOT_EMAIL=alutori@gmail.com bash deploy/setup.sh
```
Lo script (si può rilanciare quante volte si vuole) installa Node 22 (NodeSource), nginx,
ufw (apre solo OpenSSH/80/443), certbot; crea l'utente `iwords`; crea `.env` con un
`ADMIN_TOKEN` casuale; installa le dipendenze; avvia il server con pm2 e lo fa ripartire
al riavvio del VPS; configura nginx e, se `DOMAIN` e `CERTBOT_EMAIL` sono dati, il
certificato HTTPS con redirect da http.
Se il DNS non punta ancora al VPS, lancialo senza `DOMAIN`/`CERTBOT_EMAIL`, e quando il
DNS è pronto rilancia con le due variabili.

### 3. Metti le chiavi Gemini
```bash
nano /opt/italian-words/server/.env        # GEMINI_API_KEYS=chiave1,chiave2,chiave3
sudo -u iwords -H pm2 reload italian-words
grep ADMIN_TOKEN /opt/italian-words/server/.env   # copialo in un posto sicuro
```

### 4. Verifica
```bash
curl https://api.tuodominio.it/health
curl -X POST https://api.tuodominio.it/v1/lookup -H 'content-type: application/json' \
     -d '{"q":"pyaar","lang":"ur"}'
curl "https://api.tuodominio.it/v1/updates?since=0&limit=5"
cd /opt/italian-words/server && sudo -u iwords -H npm test    # facoltativo: test sul VPS
sudo -u iwords -H pm2 logs italian-words --lines 50              # log (mai le chiavi)
```
Poi nell'app si imposta l'indirizzo base `https://api.tuodominio.it`.

### Aggiornare il codice in futuro
Ripeti il punto 1, poi sul VPS:
```bash
tar -xzf /root/iw-server.tgz -C /opt/italian-words/server
cd /opt/italian-words/server && bash deploy/setup.sh
```
`.env` e `data/words.db` non vengono toccati.

### Backup del database (consigliato)
```bash
mkdir -p /root/backup
crontab -e
# aggiungi:
15 3 * * * sqlite3 /opt/italian-words/server/data/words.db ".backup '/root/backup/words-$(date +\%u).db'"
```
(7 copie a rotazione, una per giorno della settimana.)

### Togliere una voce sbagliata
```bash
T=$(grep ^ADMIN_TOKEN= /opt/italian-words/server/.env | cut -d= -f2)
curl -H "Authorization: Bearer $T" "https://api.tuodominio.it/v1/admin/recent?limit=20"
curl -X DELETE -H "Authorization: Bearer $T" "https://api.tuodominio.it/v1/admin/entry/123?block=1"
```
I telefoni la cancellano al prossimo `/v1/updates` (campo `removed`).

## Configurazione (`.env`)

Vedi `.env.example`: `GEMINI_API_KEYS` (separate da virgola, a rotazione; su 429 passa alla
chiave successiva), `GEMINI_MODELS` (default
`gemini-3.5-flash-lite,gemini-3-flash-preview,gemma-4-31b-it`; su 429/5xx/timeout/risposta non
valida passa al modello successivo), `GEMINI_TIMEOUT_MS` (30 s per chiamata),
`GEMINI_TOTAL_MS` (50 s per lookup), `GEMINI_DAILY_MAX` (tetto chiamate al giorno),
`ADMIN_TOKEN`, `RATE_LOOKUP_PER_MIN`, `RATE_LOOKUP_PER_DAY`.
Un solo processo pm2 (SQLite + limiti in memoria): non aumentare `instances`.

## File

- `src/server.js` avvio · `src/app.js` rotte · `src/db.js` schema SQLite · `src/gemini.js` prompt
  e rotazione chiavi/modelli · `src/validate.js` controlli severi (10 traduzioni, script giusti)
  · `src/moderation.js` + `src/blocklist.txt` · `src/ratelimit.js` · `src/norm.js` · `src/langs.js`
- `deploy/setup.sh`, `deploy/nginx.conf`, `ecosystem.config.cjs` (pm2), `.env.example`
- `test/*.test.js` (node:test)
