"""Second pass: re-translates only the entries marked "bad" (mixed-up scripts)
in out/tr/*.json, in small groups, and writes the fixed ones back in place.
Usage: python -I fix_bad.py [--group 10] [--workers 8]
"""
import argparse
import glob
import json
import os
import sys
import threading

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import translate as t  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--group', type=int, default=10)
    ap.add_argument('--workers', type=int, default=8)
    a = ap.parse_args()
    sel = {}
    for line in open(os.path.join(ROOT, 'out', 'selected.jsonl'), encoding='utf-8'):
        x = json.loads(line)
        sel[(x['w'], x['pos'])] = x
    files = sorted(glob.glob(os.path.join(ROOT, 'out', 'tr', '*.json')))
    jobs = []  # (file, index, source entry)
    for f in files:
        for i, it in enumerate(json.load(open(f, encoding='utf-8'))):
            if it.get('bad') and (it['w'], it['pos']) in sel:
                jobs.append((f, i, sel[(it['w'], it['pos'])]))
    groups = [jobs[i:i + a.group] for i in range(0, len(jobs), a.group)]
    print(f'{len(jobs)} bad entries in {len(groups)} groups', flush=True)
    ks = t.keys()
    lock = threading.Lock()
    fixed = {'n': 0}
    file_locks = {f: threading.Lock() for f in files}

    def ask(entries, seed):
        text = t.PROMPT + '\n'.join(
            f"{x['w']} | {x['pos']} | {'; '.join(x['gl'][:3])[:200]}" for x in entries)
        for model in t.FAST + t.STRONG:
            if model in t.EXHAUSTED:
                continue
            for attempt in range(len(ks)):
                try:
                    items = json.loads(t.call(ks[(seed + attempt) % len(ks)], model, text))
                    if t.valid(items, entries):
                        return items
                except Exception:  # noqa: BLE001
                    continue
        return None

    def work():
        while True:
            with lock:
                if not groups:
                    return
                g = groups.pop()
            for round_ in range(3):
                todo = [j for j in g if j is not None]
                if not todo:
                    break
                items = ask([j[2] for j in todo], len(groups) + round_)
                if not items:
                    continue
                for j, it in zip(todo, items):
                    if not t.entry_ok(it):
                        continue
                    f, i, src = j
                    it['pos'] = src['pos']
                    with file_locks[f]:
                        data = json.load(open(f, encoding='utf-8'))
                        data[i] = it
                        with open(f, 'w', encoding='utf-8') as fo:
                            json.dump(data, fo, ensure_ascii=False)
                    g[g.index(j)] = None
                    with lock:
                        fixed['n'] += 1
            with lock:
                if fixed['n'] and fixed['n'] % 100 < a.group:
                    print(f"fixed {fixed['n']}, groups left {len(groups)}", flush=True)

    th = [threading.Thread(target=work) for _ in range(a.workers)]
    for x in th:
        x.start()
    for x in th:
        x.join()
    print('fixed', fixed['n'], 'of', len(jobs), flush=True)


if __name__ == '__main__':
    main()
