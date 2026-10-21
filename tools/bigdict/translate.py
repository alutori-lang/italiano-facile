"""Translates the big dictionary with Gemini (multi-key, resumable).

Reads  out/selected.jsonl (first --limit entries, most frequent first)
Writes out/tr/<batch>.json, one file per batch, skipped if it already exists.

Each result: {"w","pos","tr":[10 short meanings],"rom":{"ur","pa","bn","zh"}}
Slot order: en, ur, pa-Arab (Shahmukhi), pa-Guru, bn (Bangladesh), si, zh-Hans, fr, es-ES, es-419.
rom = how people type the meaning in Latin letters (Roman Urdu, Roman Punjabi,
Banglish, pinyin without tones), several spellings separated by "|".

A fast model does each batch; entries whose scripts are mixed up (Gurmukhi
inside Shahmukhi, English inside Bengali...) are redone by a stronger model.

Keys: env GEMINI_API_KEYS="k1,k2" (or GEMINI_API_KEY), or the same names in the
Windows user environment (written by `setx`). Keys are never printed.
Usage: python -I translate.py --limit 100000 [--batch 40] [--workers 3]
"""
import argparse
import json
import os
import random
import re
import sys
import threading
import time
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, 'out', 'tr')
FAST = ['gemini-3.5-flash-lite', 'gemini-3.1-flash-lite', 'gemini-flash-lite-latest']
STRONG = ['gemini-3-flash-preview', 'gemini-3.8-flash', 'gemma-4-31b-it']
# Models whose daily quota ran out on every key: skipped for the rest of the run.
EXHAUSTED = set()

PROMPT = """You translate an Italian dictionary for immigrants living in Italy.
For EACH Italian entry below give the meaning, short (1-4 words, alternatives separated by " / "),
as natives really say it, in these 10 languages IN THIS ORDER:
0 English, 1 Urdu (Urdu script), 2 Punjabi Shahmukhi (Pakistani Punjabi, Arabic script, real Punjabi words),
3 Punjabi Gurmukhi, 4 Bengali (Bangladesh usage: পানি not জল), 5 Sinhala, 6 Chinese Simplified,
7 French, 8 Spanish (Spain), 9 Spanish (Latin America words).
Each language ONLY in its own script: never mix Gurmukhi letters into Shahmukhi, never English words in
Urdu/Punjabi/Bengali/Sinhala/Chinese, Urdu letters ہ ی ک (not Persian/Arabic ه ي ك).
Use the English gloss to pick the right sense; give the most common everyday sense first.
Also give "rom": how people TYPE the Urdu/Punjabi/Bengali/Chinese meaning in Latin letters on WhatsApp
(several common spellings separated by "|", lowercase; zh = pinyin without tones).
Return ONLY a JSON array, one object per entry, same order:
[{"w":"<italian>","tr":["en","ur","pa-Arab","pa-Guru","bn","si","zh","fr","es","es-419"],
  "rom":{"ur":"pyaar|piyar|pyar","pa":"pyaar|piyar","bn":"bhalobasha","zh":"ai"}}]
Entries (italian | part of speech | english gloss):
"""

# Per-slot script rules: (must contain, must never contain).
AR = '؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿'
SCRIPT_RULES = {
    1: (re.compile('[' + AR + ']'), re.compile('[A-Za-zऀ-෿]')),
    2: (re.compile('[' + AR + ']'), re.compile('[A-Za-zऀ-෿]')),
    3: (re.compile('[਀-੿]'), re.compile('[A-Za-z' + AR + 'ऀ-ॿঀ-৿]')),
    4: (re.compile('[ঀ-৿]'), re.compile('[A-Za-z' + AR + '਀-੿]')),
    5: (re.compile('[඀-෿]'), re.compile('[A-Za-z' + AR + 'ঀ-৿]')),
    6: (re.compile('[一-鿿]'), re.compile('[' + AR + 'ऀ-෿]')),
}
# Arabic/Persian he, yeh, kaf instead of the Urdu letters.
PERSIAN_LETTERS = re.compile('[هيك]')


def entry_ok(it):
    tr = it.get('tr') or []
    for slot, (must, never) in SCRIPT_RULES.items():
        if not must.search(tr[slot]) or never.search(tr[slot]):
            return False
    return not PERSIAN_LETTERS.search(tr[1] + tr[2])


def keys():
    raw = os.environ.get('GEMINI_API_KEYS') or os.environ.get('GEMINI_API_KEY') or ''
    if not raw and sys.platform == 'win32':
        import winreg
        try:
            with winreg.OpenKey(winreg.HKEY_CURRENT_USER, 'Environment') as k:
                for name in ('GEMINI_API_KEYS', 'GEMINI_API_KEY'):
                    try:
                        raw = winreg.QueryValueEx(k, name)[0]
                        break
                    except OSError:
                        continue
        except OSError:
            pass
    ks = [k.strip() for k in raw.split(',') if k.strip()]
    if not ks:
        sys.exit('No GEMINI_API_KEYS in the environment')
    return ks


def call(key, model, text):
    url = (f'https://generativelanguage.googleapis.com/v1beta/models/{model}'
           ':generateContent')
    body = json.dumps({
        'contents': [{'parts': [{'text': text}]}],
        'generationConfig': {'temperature': 0.2, 'responseMimeType': 'application/json'},
    }).encode()
    req = urllib.request.Request(url, data=body, method='POST', headers={
        'Content-Type': 'application/json', 'x-goog-api-key': key})
    with urllib.request.urlopen(req, timeout=240) as r:
        data = json.loads(r.read())
    return data['candidates'][0]['content']['parts'][0]['text']


def valid(items, batch):
    if not isinstance(items, list) or len(items) != len(batch):
        return False
    for it, src in zip(items, batch):
        if not isinstance(it, dict) or it.get('w', '').strip().lower() != src['w'].lower():
            return False
        tr = it.get('tr')
        if not isinstance(tr, list) or len(tr) != 10 or not all(
                isinstance(s, str) and s.strip() for s in tr):
            return False
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--limit', type=int, default=100000)
    ap.add_argument('--batch', type=int, default=40)
    ap.add_argument('--workers', type=int, default=3)
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    lemmas = []
    for line in open(os.path.join(ROOT, 'out', 'selected.jsonl'), encoding='utf-8'):
        lemmas.append(json.loads(line))
        if len(lemmas) >= a.limit:
            break
    batches = [lemmas[i:i + a.batch] for i in range(0, len(lemmas), a.batch)]
    todo = [i for i in range(len(batches))
            if not os.path.exists(os.path.join(OUT, f'{i:05d}.json'))]
    print(f'{len(batches)} batches, {len(todo)} to do', flush=True)
    ks = keys()
    lock = threading.Lock()
    state = {'done': 0, 'bad': 0, 'dead': set()}

    def ask(entries, models, seed):
        """One validated request, trying keys and models in turn; None on failure."""
        text = PROMPT + '\n'.join(
            f"{x['w']} | {x['pos']} | {'; '.join(x['gl'][:3])[:200]}" for x in entries)
        for model in models:
            if model in EXHAUSTED:
                continue
            live = [k for k in ks if k not in state['dead']] or ks
            over_quota = 0
            for attempt in range(max(3, len(live))):
                key = live[(seed + attempt) % len(live)]
                try:
                    items = json.loads(call(key, model, text))
                    if valid(items, entries):
                        return items
                except urllib.error.HTTPError as e:
                    if e.code in (401, 403):
                        state['dead'].add(key)
                    elif e.code == 429:
                        over_quota += 1
                        if over_quota >= len(live):
                            # Every key is over this model's quota: drop it.
                            EXHAUSTED.add(model)
                            print(f'{model}: quota exhausted, skipping it', flush=True)
                            break
                    elif e.code == 404:
                        EXHAUSTED.add(model)
                        break
                    time.sleep(3)
                except Exception:  # noqa: BLE001 — network/JSON hiccups: retry
                    time.sleep(3)
                time.sleep(random.uniform(0.3, 1.0))
        return None

    def work(wid):
        while True:
            with lock:
                if not todo:
                    return
                bi = todo.pop(0)
            batch = batches[bi]
            items = ask(batch, FAST, bi) or ask(batch, STRONG, bi)
            nbad = 0
            if items is not None:
                for round_ in range(3):
                    bad = [i for i, it in enumerate(items) if not entry_ok(it)]
                    if not bad:
                        break
                    fixed = ask([batch[i] for i in bad], STRONG, bi + round_)
                    if fixed:
                        for i, it in zip(bad, fixed):
                            if entry_ok(it):
                                items[i] = it
                for it, src in zip(items, batch):
                    it['pos'] = src['pos']
                    if not entry_ok(it):
                        it['bad'] = True
                        nbad += 1
                with open(os.path.join(OUT, f'{bi:05d}.json'), 'w', encoding='utf-8') as f:
                    json.dump(items, f, ensure_ascii=False)
            with lock:
                if items is not None:
                    state['done'] += 1
                    state['bad'] += nbad
                    if state['done'] % 25 == 0:
                        print(f"done {state['done']}, left {len(todo)}, "
                              f"still-bad entries {state['bad']}", flush=True)
                else:
                    print(f'batch {bi} failed, will retry next run', flush=True)

    threads = [threading.Thread(target=work, args=(w,)) for w in range(a.workers)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    print('finished', state['done'], 'still-bad', state['bad'], flush=True)


if __name__ == '__main__':
    main()
