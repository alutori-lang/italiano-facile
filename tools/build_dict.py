"""Merges tools/dict_src/*.json into assets/dict/words.json.

Only entries that pass every check in check_dict.py are kept; duplicates
(also of the words built into lib/data) are dropped, first one wins.
Usage: python -I tools/build_dict.py
"""
import glob
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import check_dict  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'tools', 'dict_src')
OUT = os.path.join(ROOT, 'assets', 'dict', 'words.json')


def main():
    sys.stdout.reconfigure(encoding='utf-8')
    seen = set()
    existing = os.path.join(SRC, '_existing.json')
    if os.path.exists(existing):
        for words in json.load(open(existing, encoding='utf-8')).values():
            seen.update(w.lower() for w in words)
    rows, skipped, dups = [], [], 0
    for path in sorted(glob.glob(os.path.join(SRC, '*.json'))):
        if os.path.basename(path).startswith('_'):
            continue
        try:
            data = json.load(open(path, encoding='utf-8'))
        except Exception as ex:  # noqa: BLE001
            skipped.append(f'{os.path.basename(path)}: invalid JSON ({ex})')
            continue
        for i, e in enumerate(data):
            errors = []
            check_dict.check_entry(e, f'{os.path.basename(path)}#{i}', errors)
            if errors:
                skipped.extend(errors)
                continue
            key = e['it'].lower()
            if key in seen:
                dups += 1
                continue
            seen.add(key)
            rows.append([e['it'], e['type'], e['topic'], e['emoji'], e['tr'], e['expl'],
                         e['ex'], e['exTr']])
    order = {t: i for i, t in enumerate([
        'greetings', 'numbers', 'colors', 'time', 'family', 'body', 'health', 'pharmacy',
        'food', 'fruit', 'vegetables', 'drinks', 'cooking', 'shopping', 'money', 'house',
        'kitchen', 'bathroom', 'clothes', 'weather', 'city', 'transport', 'work', 'jobs',
        'offices', 'school', 'animals', 'nature', 'sport', 'feelings', 'verbs',
        'adjectives', 'phrases'])}
    rows.sort(key=lambda r: order.get(r[2], 99))
    with open(OUT, 'w', encoding='utf-8') as f:
        json.dump(rows, f, ensure_ascii=False, separators=(',', ':'))
    for line in skipped:
        print('SKIPPED', line)
    by_type = {}
    for r in rows:
        by_type[r[1]] = by_type.get(r[1], 0) + 1
    print(f'{len(rows)} entries written ({by_type}), {dups} duplicates dropped, '
          f'{len(skipped)} invalid skipped, {os.path.getsize(OUT) // 1024} KB')


if __name__ == '__main__':
    main()
