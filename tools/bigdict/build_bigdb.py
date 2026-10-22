"""Builds the offline big dictionary (SQLite) for the Italian Words app.

Inputs (in dictdata/out):  selected.jsonl, tr/*.json, forms.tsv, forms_extra.tsv
Output: <app>/assets/dict/big.db  and  <app>/test/fixtures/norm_cases.json

Schema
  meta(k TEXT PRIMARY KEY, v TEXT)                  -- version, counts
  entries(id INTEGER PRIMARY KEY, it TEXT, it_norm TEXT, pos TEXT, g TEXT, pl TEXT,
          gloss TEXT, ex_it TEXT, ex_en TEXT, tr TEXT, rom TEXT, rank INTEGER)
      tr  = the 10 meanings joined with U+001F (slot order of LearnerLanguage)
      rom = JSON {"ur": "...|...", "pa": ..., "bn": ..., "zh": ...}
  forms(form TEXT, entry_id INTEGER)                -- "andavamo" -> andare (normalized form)
  keys(...) is NOT shipped (it would triple the size): the app builds it on the
  phone for the chosen language only, with the same norm()/romkey()/variants():
      slot 0..9 = translation of that language (normalized with norm())
      slot 11 = Roman Urdu, 12 = Roman Punjabi, 14 = Banglish, 16 = pinyin  (romkey())
  indexes on entries(it_norm), forms(form), keys(key)

The normalization below is the CONTRACT with the Dart side (lib/services/text_norm.dart):
any change here must be mirrored there; test/fixtures/norm_cases.json is the parity test.
Usage: python -I build_bigdb.py <dictdata_dir> <app_dir>
"""
import glob
import hashlib
import json
import os
import re
import sqlite3
import sys
import unicodedata

SEP = '\u001f'
ROM_SLOT = {'ur': 11, 'pa': 12, 'bn': 14, 'zh': 16}

LATIN_MARKS = re.compile(r'[̀-ͯ]')
ARABIC_MARKS = re.compile(r'[ً-ٰٟۖ-ۭـ]')
PUNCT = re.compile(r'[\s.,!?¿¡;:"“”«»()\[\]{}…\-–—/\\|*_~^`\'’‘؟،۔।॥。，！？：；、]+')
ARABIC_UNIFY = str.maketrans({
    'ي': 'ی', 'ى': 'ی', 'ئ': 'ی', 'ك': 'ک', 'ه': 'ہ', 'ۂ': 'ہ', 'ة': 'ہ',
    'أ': 'ا', 'إ': 'ا', 'آ': 'ا', 'ٱ': 'ا', 'ؤ': 'و',
})


def norm(s):
    """Generic search key: lower case, no Latin accents, unified Arabic letters,
    no Arabic diacritics, punctuation turned into single spaces, trimmed.
    Indic/Sinhala vowel signs are KEPT (they are letters there)."""
    s = unicodedata.normalize('NFC', s.lower())
    out = []
    for ch in s:
        if 'a' <= ch <= 'z' or ch in 'àáâäãåèéêëìíîïòóôöõùúûüçñ':
            ch = LATIN_MARKS.sub('', unicodedata.normalize('NFD', ch))
        out.append(ch)
    s = ''.join(out).translate(ARABIC_UNIFY)
    s = ARABIC_MARKS.sub('', s)
    s = PUNCT.sub(' ', s)
    return ' '.join(s.split())


def romkey(s):
    """Loose key for words typed in Latin letters (Roman Urdu/Punjabi, Banglish,
    pinyin): spelling variants collapse to the same key
    (pyaar/piyar/pyar -> pyar, khana/khaana/kana -> kana, mohabbat/muhabat -> muhabat)."""
    s = norm(s)
    s = re.sub(r'[^a-z ]', '', s)
    words = []
    for w in s.split():
        w = w.replace('ee', 'i').replace('oo', 'u').replace('ou', 'u')
        w = w.replace('ph', 'f').replace('w', 'v').replace('q', 'k').replace('o', 'u')
        w = re.sub(r'iy(?=[aeiu])', 'i', w)              # piyar -> piar
        w = re.sub(r'(?<=[bcdfgjklmnprstvxz])y(?=[aeiu])', 'i', w)  # pyar -> piar
        w = re.sub(r'(?<=[bcdfgjklmnprstvxz])h', '', w)  # bh->b, kh->k, th->t ...
        w = re.sub(r'h$', '', w)
        w = re.sub(r'y$', 'i', w)
        w = re.sub(r'(.)\1+', r'\1', w)
        if w:
            words.append(w)
    # Spaces are dropped: "fan qie" and "fanqie", "is waqt" and "iswaqt" match.
    return ''.join(words)


def variants(meaning):
    """'nice / friendly' -> ['nice', 'friendly']; also drops '(…)' notes and 'to ' for verbs."""
    out = []
    for part in re.split(r'\s*/\s*|\s*;\s*|\s*,\s*', meaning):
        part = re.sub(r'\([^)]*\)', '', part).strip()
        if not part:
            continue
        out.append(part)
        if part.lower().startswith('to '):
            out.append(part[3:])
    return out


CASES = [
    'Città', 'perché', 'PIÙ', 'ventitré', 'l\'acqua', 'pomodoro!', 'andavamo',
    'پیار', 'پیار!', 'كتاب', 'سُوَال', 'ہفتہ', 'آدمی', 'ਪਿਆਰ', 'ভালোবাসা', 'পানি।', 'ආදරය', '番茄，',
    'Très bien', 'niño', '¿Dónde?',
]
ROM_CASES = ['pyaar', 'piyar', 'pyar', 'Khana', 'khaana', 'kana', 'mohabbat', 'muhabat',
             'bhai', 'Bhaai', 'dawai', 'dawaee', 'shukriya', 'shukria', 'ghar', 'gar',
             'bhalobasha', 'bhalobasa', 'xihongshi', 'fan qie', 'kaam', 'kam', 'paani', 'pani']
VARIANT_CASES = ['nice / likable / funny', 'to go', 'house; home, family', 'casa (edificio) / hogar',
                 'خوش اخلاق / پیارا', '去 / 走', 'to be (located)', ' / ', 'talib e ilm | student']


def main(data_dir, app_dir):
    sel = {}
    for line in open(os.path.join(data_dir, 'out', 'selected.jsonl'), encoding='utf-8'):
        x = json.loads(line)
        sel[(x['w'], x['pos'])] = x
    db_path = os.path.join(app_dir, 'assets', 'dict', 'big.db')
    tmp = db_path + '.tmp'
    if os.path.exists(tmp):
        os.remove(tmp)
    con = sqlite3.connect(tmp)
    con.executescript('''
      PRAGMA journal_mode=OFF; PRAGMA synchronous=OFF; PRAGMA page_size=4096;
      CREATE TABLE meta(k TEXT PRIMARY KEY, v TEXT);
      CREATE TABLE entries(id INTEGER PRIMARY KEY, it TEXT NOT NULL, it_norm TEXT NOT NULL,
        pos TEXT, g TEXT, pl TEXT, gloss TEXT, ex_it TEXT, ex_en TEXT,
        tr TEXT NOT NULL, rom TEXT, rank INTEGER);
      CREATE TABLE forms(form TEXT NOT NULL, entry_id INTEGER NOT NULL);
    ''')
    by_word = {}
    n_entries = n_keys = 0
    for path in sorted(glob.glob(os.path.join(data_dir, 'out', 'tr', '*.json'))):
        for it in json.load(open(path, encoding='utf-8')):
            if it.get('bad'):
                continue  # mixed-up scripts: not shipped until fixed
            src = sel.get((it['w'], it['pos']))
            if not src:
                continue
            tr = [t.strip() for t in it['tr']]
            rom = it.get('rom') or {}
            cur = con.execute(
                'INSERT INTO entries(it,it_norm,pos,g,pl,gloss,ex_it,ex_en,tr,rom,rank)'
                ' VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                (src['w'], norm(src['w']), src['pos'], src.get('g'), src.get('pl'),
                 '; '.join(src['gl'][:3]),
                 (src.get('ex') or {}).get('it'), (src.get('ex') or {}).get('en'),
                 SEP.join(tr), json.dumps(rom, ensure_ascii=False), src.get('rank')))
            eid = cur.lastrowid
            n_entries += 1
            by_word.setdefault(src['w'].lower(), []).append(eid)
            rows = set()
            for slot, meaning in enumerate(tr):
                for v in variants(meaning):
                    k = norm(v)
                    if k:
                        rows.add((k, slot))
            for lang, slot in ROM_SLOT.items():
                for v in str(rom.get(lang, '')).split('|'):
                    k = romkey(v)
                    if k:
                        rows.add((k, slot))
            n_keys += len(rows)
    # Everyday phrases by situation (gen_phrases.py): shipped as pos "phrase";
    # their English translation doubles as the gloss.
    seen_ph = set()
    for path in sorted(glob.glob(os.path.join(data_dir, 'out', 'ph', '*.json'))):
        for it in json.load(open(path, encoding='utf-8')):
            w = it['w'].strip()
            k = norm(w)
            if not k or k in seen_ph:
                continue
            seen_ph.add(k)
            tr = [t.strip() for t in it['tr']]
            rom = it.get('rom') or {}
            con.execute(
                'INSERT INTO entries(it,it_norm,pos,g,pl,gloss,ex_it,ex_en,tr,rom,rank)'
                ' VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                (w, k, 'phrase', None, None, tr[0], None, None,
                 SEP.join(tr), json.dumps(rom, ensure_ascii=False), 500000))
            n_entries += 1
    n_forms = 0
    seen = set()
    for fname in ('forms.tsv', 'forms_extra.tsv'):
        p = os.path.join(data_dir, 'out', fname)
        if not os.path.exists(p):
            continue
        for line in open(p, encoding='utf-8'):
            form, _, lemma = line.rstrip('\n').partition('\t')
            for eid in by_word.get(lemma.lower(), []):
                key = (norm(form), eid)
                if key[0] and key not in seen:
                    seen.add(key)
                    n_forms += 1
            # inserted below in one go
    con.executemany('INSERT INTO forms VALUES(?,?)', sorted(seen))
    con.executescript('''
      CREATE INDEX entries_it ON entries(it_norm);
      CREATE INDEX forms_form ON forms(form);
    ''')
    # Content hash: any change to any shipped row (or to the forms) changes the
    # version, so phones re-copy big.db (the app compares it with big_version.txt).
    h = hashlib.sha1()
    for row in con.execute('SELECT it, pos, g, pl, gloss, ex_it, ex_en, tr, rom, rank'
                           ' FROM entries ORDER BY id'):
        h.update(json.dumps(row, ensure_ascii=False).encode('utf-8'))
        h.update(b'\n')
    for row in sorted(seen):
        h.update(f'{row[0]}\t{row[1]}\n'.encode('utf-8'))
    meta = {'version': h.hexdigest()[:12], 'entries': str(n_entries), 'keys': str(n_keys),
            'forms': str(n_forms)}
    con.executemany('INSERT INTO meta VALUES(?,?)', meta.items())
    con.commit()
    con.execute('VACUUM')
    con.close()
    os.replace(tmp, db_path)
    fx = os.path.join(app_dir, 'test', 'fixtures')
    os.makedirs(fx, exist_ok=True)
    with open(os.path.join(fx, 'norm_cases.json'), 'w', encoding='utf-8') as f:
        json.dump({'norm': {c: norm(c) for c in CASES},
                   'romkey': {c: romkey(c) for c in ROM_CASES},
                   'variants': {c: variants(c) for c in VARIANT_CASES}}, f, ensure_ascii=False, indent=1)
    # Tiny side file: the app compares it with the copy on the phone and
    # re-copies big.db only when the bundled dictionary really changed.
    with open(os.path.join(app_dir, 'assets', 'dict', 'big_version.txt'), 'w', encoding='utf-8') as f:
        f.write(meta['version'])
    print(meta, f'{os.path.getsize(db_path) // 1024} KB')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
