"""Picks the entries to translate: frequency-ranked first, then the rest by
how 'dictionary-worthy' they look. Writes out/selected.jsonl.

"denunciarci" style entries (verb + clitic) are not translated: they go to
out/forms_extra.tsv so a search for them leads to the base verb.
Usage: python -I select.py [limit]
"""
import json
import re
import sys

LIMIT = int(sys.argv[1]) if len(sys.argv) > 1 else 100000
SKIP_GLOSS = re.compile(
    r'^(The name of the Latin script letter|A (male|female) given name|A surname'
    r'|A (town|village|comune|city|river)\b)', re.I)
COMPOUND = re.compile(r'^compound of .*?\b([a-zàèéìòù]+(?:are|ere|ire|rre)|[a-zàèéìòù]+) with ',
                      re.I)

ranked, rest, extra_forms = [], [], []
for line in open('out/lemmas.jsonl', encoding='utf-8'):
    x = json.loads(line)
    if x['gl'] and COMPOUND.match(x['gl'][0]):
        extra_forms.append((x['w'].lower(), COMPOUND.match(x['gl'][0]).group(1)))
        continue
    gl = [g for g in x['gl'] if not SKIP_GLOSS.match(g) and not COMPOUND.match(g)]
    if not gl:
        continue
    x['gl'] = gl
    if x['w'][:1].isupper() and x['rank'] > 5000:
        continue  # proper nouns, place names
    (ranked if x['rank'] < 999999 else rest).append(x)
rest.sort(key=lambda x: (-(x['ex'] is not None), -len(x['gl']), len(x['w']), x['w']))
sel = (ranked + rest)[:LIMIT]
with open('out/selected.jsonl', 'w', encoding='utf-8') as f:
    for x in sel:
        f.write(json.dumps(x, ensure_ascii=False) + '\n')
with open('out/forms_extra.tsv', 'w', encoding='utf-8') as f:
    for a, b in extra_forms:
        f.write(a + '\t' + b + '\n')
print(len(extra_forms), 'compound forms; ', len(ranked), 'ranked +',
      len(sel) - len(ranked), 'others =', len(sel))
