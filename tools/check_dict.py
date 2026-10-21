"""Checks dictionary JSON files for the Italian Words app.

Usage: python -I tools/check_dict.py <file.json> [...]
       python -I tools/check_dict.py --all      (every tools/dict_src/*.json)
Exit code 1 if any error.
"""
import glob
import json
import os
import re
import sys

TOPICS = {
    'greetings', 'numbers', 'colors', 'time', 'family', 'body', 'health', 'pharmacy', 'food',
    'fruit', 'vegetables', 'drinks', 'cooking', 'shopping', 'money', 'house', 'kitchen',
    'bathroom', 'clothes', 'weather', 'city', 'transport', 'work', 'jobs', 'offices', 'school',
    'animals', 'nature', 'sport', 'feelings', 'verbs', 'adjectives', 'phrases',
}
TYPES = {'n', 'v', 'a', 'p'}
LANGS = ['en', 'ur', 'pa-Arab', 'pa-Guru', 'bn', 'si', 'zh', 'fr', 'es', 'es-419']

ARABIC = re.compile(r'[؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿]')
SCRIPT = {
    1: ARABIC,
    2: ARABIC,
    3: re.compile(r'[਀-੿]'),
    4: re.compile(r'[ঀ-৿]'),
    5: re.compile(r'[඀-෿]'),
    6: re.compile(r'[一-鿿]'),
}
LATIN_LETTER = re.compile(r'[A-Za-z]')
ARTICLES = ('il ', 'lo ', 'la ', "l'", 'i ', 'gli ', 'le ')
VOWELS = 'aeiouàèéìòóù'
BAD_ACCENTS = {
    'perche': 'perché', 'citta': 'città', 'caffe': 'caffè', 'universita': 'università',
    'puo': 'può', 'gia': 'già', 'piu': 'più', 'cosi': 'così', 'lunedi': 'lunedì',
    'martedi': 'martedì', 'mercoledi': 'mercoledì', 'giovedi': 'giovedì', 'venerdi': 'venerdì',
    'societa': 'società', 'eta': 'età', 'te': None, 'e\'': 'è', 'perchè': 'perché',
}


def lo_needed(word):
    w = word.lower()
    return (w[:1] in ('z', 'x', 'y') or w.startswith(('gn', 'ps', 'pn')) or
            (w[:1] == 's' and len(w) > 1 and w[1] not in VOWELS))


def check_entry(e, where, errors):
    def err(msg):
        errors.append(f'{where}: {e.get("it", "?")!r}: {msg}')

    keys = {'it', 'type', 'topic', 'emoji', 'tr', 'expl', 'ex', 'exTr'}
    if set(e) != keys:
        err(f'keys must be exactly {sorted(keys)}, got {sorted(e)}')
        return
    it, typ = e['it'], e['type']
    if not isinstance(it, str) or not it.strip() or it != it.strip() or '  ' in it:
        err('bad "it"')
        return
    if '’' in it or '’' in e['ex']:
        err("use straight apostrophe ' not ’")
    if typ not in TYPES:
        err(f'bad type {typ}')
    if e['topic'] not in TOPICS:
        err(f'bad topic {e["topic"]}')
    if e['emoji'] is not None and (not isinstance(e['emoji'], str) or not e['emoji'].strip()
                                   or len(e['emoji']) > 12 or LATIN_LETTER.search(e['emoji'])):
        err('emoji must be one emoji or null')
    for field in ('tr', 'expl', 'exTr'):
        vals = e[field]
        if not isinstance(vals, list) or len(vals) != 10:
            err(f'{field} must have 10 strings')
            continue
        for i, s in enumerate(vals):
            if not isinstance(s, str) or not s.strip():
                err(f'{field}[{LANGS[i]}] empty')
                continue
            if s.strip().upper() in ('N/A', 'TODO', '?', '-'):
                err(f'{field}[{LANGS[i]}] placeholder')
            rx = SCRIPT.get(i)
            if rx is not None:
                if not rx.search(s):
                    err(f'{field}[{LANGS[i]}] not in the right script: {s!r}')
                # Brand names and acronyms (WhatsApp, Wi-Fi, IBAN) may stay Latin.
                if field == 'tr' and re.search(r'(?<![A-Za-z])[a-z]', s):
                    err(f'{field}[{LANGS[i]}] contains Latin letters: {s!r}')
                # Lower-case Latin words (Italian leaking into another script).
                # Upper-case acronyms such as IBAN, SPID, INPS are allowed.
                # Explanations may quote Italian forms on purpose; translated
                # examples may not (quoted or bracketed text is allowed).
                bare = re.sub(r'"[^"]*"|“[^”]*”|«[^»]*»|\([^)]*\)', '', s)
                if field == 'exTr' and i != 6 and re.search(r'\b[a-zà-ù]{3,}', bare):
                    err(f'{field}[{LANGS[i]}] has a lower-case Latin word: {s!r}')
            if i in (1, 2, 3, 4, 5) and re.search(r'[‎‏‪-‮]', s):
                err(f'{field}[{LANGS[i]}] has a stray direction control character')
            if i in (1, 2) and re.search(r'[਀-੿ऀ-ॿ]', s):
                err(f'{field}[{LANGS[i]}] has Indic letters in Arabic-script slot')
        if field != 'tr' and vals[0].strip() and sum(1 for s in vals[1:7] if s == vals[0]) > 0:
            err(f'{field}: English copied into another language')
    if not isinstance(e['ex'], str) or len(e['ex'].strip()) < 3:
        err('ex missing')
    low = it.lower()
    if typ == 'n':
        if not low.startswith(ARTICLES):
            err('noun without definite article')
        else:
            art, rest = (("l'", low[2:]) if low.startswith("l'") else low.split(' ', 1))
            art = art.strip()
            if art == "l'" and rest[:1] not in VOWELS and rest[:1] != 'h':
                err("l' before a consonant")
            if art in ('il', 'la', 'lo') and rest[:1] in VOWELS:
                err(f'"{art}" before a vowel: use l\'')
            if art == 'il' and lo_needed(rest):
                err('"il" where "lo" is needed')
            if art == 'lo' and not lo_needed(rest):
                err('"lo" where "il" is needed')
            if art == 'i' and (rest[:1] in VOWELS or lo_needed(rest)):
                err('"i" where "gli" is needed')
            if art == 'gli' and not (rest[:1] in VOWELS or lo_needed(rest)):
                err('"gli" where "i" is needed')
    if typ == 'v' and not re.search(r'(are|ere|ire|rre|arsi|ersi|irsi|rsi)\b', low.split(' ')[0]):
        err('verb not in the infinitive')
    for wrd in re.findall(r"[a-zà-ù']+", (it + ' ' + e['ex']).lower()):
        if wrd in BAD_ACCENTS and BAD_ACCENTS[wrd]:
            err(f'accent: "{wrd}" should be "{BAD_ACCENTS[wrd]}"')


def main(argv):
    sys.stdout.reconfigure(encoding='utf-8')
    root = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'dict_src')
    files = sorted(glob.glob(os.path.join(root, '*.json'))) if argv == ['--all'] else argv
    files = [f for f in files if not os.path.basename(f).startswith('_')]
    errors, seen, total = [], {}, 0
    existing_path = os.path.join(root, '_existing.json')
    if os.path.exists(existing_path):
        for words in json.load(open(existing_path, encoding='utf-8')).values():
            for w in words:
                seen[w.lower()] = '(already in the app)'
    for f in files:
        try:
            data = json.load(open(f, encoding='utf-8'))
        except Exception as ex:  # noqa: BLE001
            errors.append(f'{f}: invalid JSON: {ex}')
            continue
        if not isinstance(data, list):
            errors.append(f'{f}: top level must be a list')
            continue
        for i, e in enumerate(data):
            total += 1
            where = f'{os.path.basename(f)}#{i}'
            if not isinstance(e, dict):
                errors.append(f'{where}: not an object')
                continue
            check_entry(e, where, errors)
            key = str(e.get('it', '')).lower()
            if key in seen:
                errors.append(f'{where}: duplicate {e.get("it")!r} (also in {seen[key]})')
            else:
                seen[key] = os.path.basename(f)
    for line in errors:
        print(line)
    print(f'{total} entries in {len(files)} files, {len(errors)} errors')
    return 1 if errors else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
