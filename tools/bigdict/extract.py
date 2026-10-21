"""Extracts Italian lemmas + inflected forms from the kaikki.org Wiktionary dump.

Output:
  out/lemmas.jsonl  one lemma per line:
     {"w","pos","g"(gender m/f/mf/None),"pl","gl":[english glosses],"ex":example|None,"rank"}
  out/forms.tsv     inflected_form <TAB> lemma  (for "andavamo" -> "andare")
Usage: python -I extract.py <kaikki-it.jsonl.gz> <out_dir> <it_50k.txt>
"""
import gzip
import json
import os
import re
import sys

KEEP_POS = {'noun', 'verb', 'adj', 'adv', 'prep', 'conj', 'pron', 'intj', 'num',
            'det', 'phrase', 'prep_phrase', 'article', 'particle'}
SKIP_TAGS = {'form-of', 'alt-of', 'abbreviation', 'misspelling', 'obsolete',
             'archaic', 'rare', 'dated'}


def gender(e):
    tags = set()
    for ht in e.get('head_templates') or []:
        args = ht.get('args') or {}
        g = str(args.get('1', '')) + str(args.get('g', ''))
        if 'mf' in g or 'm-f' in g or 'm/f' in g:
            return 'mf'
        if g.startswith('m'):
            tags.add('m')
        if g.startswith('f'):
            tags.add('f')
    if tags == {'m'}:
        return 'm'
    if tags == {'f'}:
        return 'f'
    if tags == {'m', 'f'}:
        return 'mf'
    return None


def main(src, out, freq_path):
    rank = {}
    for i, line in enumerate(open(freq_path, encoding='utf-8')):
        w = line.split(' ')[0].strip().lower()
        rank.setdefault(w, i + 1)
    lemmas = {}
    forms = {}
    with gzip.open(src, 'rt', encoding='utf-8') as f:
        for line in f:
            e = json.loads(line)
            if e.get('lang_code') != 'it':
                continue
            pos = e.get('pos')
            word = e.get('word', '').strip()
            if not word or pos not in KEEP_POS:
                continue
            senses = e.get('senses') or []
            # Pure form-of entries ("andavamo: first-person plural imperfect of
            # andare") only feed the form -> lemma table.
            form_of = [s for s in senses if 'form_of' in s]
            if form_of and len(form_of) == len(senses):
                for s in form_of:
                    for fo in s['form_of']:
                        lw = fo.get('word', '').strip()
                        if lw:
                            forms.setdefault(word.lower(), set()).add(lw)
                continue
            glosses, ex = [], None
            for s in senses:
                tags = set(s.get('tags') or [])
                if tags & SKIP_TAGS or 'form_of' in s:
                    continue
                for g in s.get('glosses') or []:
                    g = re.sub(r'\s+', ' ', g).strip()
                    if g and g not in glosses:
                        glosses.append(g)
                if ex is None:
                    for x in s.get('examples') or []:
                        t = (x.get('text') or '').strip()
                        if 8 <= len(t) <= 120 and x.get('english'):
                            ex = {'it': t, 'en': x['english'].strip()}
                            break
            if not glosses:
                continue
            pl = None
            for fm in e.get('forms') or []:
                if 'plural' in (fm.get('tags') or []) and pos == 'noun' and not pl:
                    pl = fm.get('form')
                f2 = (fm.get('form') or '').strip().lower()
                if f2 and f2 != word.lower() and ' ' not in f2 and len(f2) < 30:
                    forms.setdefault(f2, set()).add(word)
            key = (word, pos)
            cur = lemmas.get(key)
            if cur:
                for g in glosses:
                    if g not in cur['gl']:
                        cur['gl'].append(g)
                continue
            lemmas[key] = {
                'w': word, 'pos': pos, 'g': gender(e) if pos == 'noun' else None,
                'pl': pl, 'gl': glosses[:6], 'ex': ex,
                'rank': rank.get(word.lower(), 999999),
            }
    os.makedirs(out, exist_ok=True)
    items = sorted(lemmas.values(), key=lambda x: (x['rank'], x['w']))
    with open(os.path.join(out, 'lemmas.jsonl'), 'w', encoding='utf-8') as fo:
        for it in items:
            it['gl'] = it['gl'][:6]
            fo.write(json.dumps(it, ensure_ascii=False) + '\n')
    with open(os.path.join(out, 'forms.tsv'), 'w', encoding='utf-8') as fo:
        for form, ls in sorted(forms.items()):
            for l in sorted(ls):
                fo.write(f'{form}\t{l}\n')
    ranked = sum(1 for x in items if x['rank'] < 999999)
    print(f'lemmas {len(items)} (in frequency list: {ranked}), forms {len(forms)}')
    by = {}
    for x in items:
        by[x['pos']] = by.get(x['pos'], 0) + 1
    print(by)


if __name__ == '__main__':
    main(*sys.argv[1:4])
