"""Generates everyday Italian PHRASES by real-life situation, translated into the
10 app languages (same format and validation as translate.py).

Writes out/ph/<NNN>.json (one file per situation request), skipped if present.
Each item: {"w": "<Italian sentence>", "pos": "phrase", "topic": "<topic id>",
            "tr": [10], "rom": {...}, "en_gloss": "..."}
Usage: NO_STRONG=1 python -I gen_phrases.py [--workers 12] [--per 40]
"""
import argparse
import json
import os
import sys
import threading

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import translate as t  # noqa: E402  (keys, call, entry_ok, FAST, STRONG)

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, 'out', 'ph')

# (topic id used by the app, situation described for the model)
SITUATIONS = [
    ('health', 'at the family doctor (medico di base): describing symptoms'),
    ('health', 'at the hospital emergency room (pronto soccorso)'),
    ('health', 'booking a medical visit at the CUP / by phone'),
    ('health', 'at the dentist'), ('health', 'pregnancy and the gynaecologist'),
    ('health', 'with a child at the paediatrician'), ('health', 'blood tests and results'),
    ('pharmacy', 'at the pharmacy asking for medicine'), ('pharmacy', 'explaining allergies and dosage'),
    ('offices', 'at the questura for the residence permit (permesso di soggiorno)'),
    ('offices', 'at the post office sending the kit for the permit'),
    ('offices', 'at the comune / anagrafe for residence and documents'),
    ('offices', 'at the CAF or patronato (ISEE, 730, assegno unico)'),
    ('offices', 'at the prefettura: family reunification and citizenship'),
    ('offices', 'at INPS: unemployment benefit NASpI'), ('offices', 'asking for an appointment and waiting in line'),
    ('offices', 'filling in a form and signing documents'),
    ('work', 'job interview'), ('work', 'first day at work'), ('work', 'talking with the boss about hours and shifts'),
    ('work', 'asking about salary, payslip and contract'), ('work', 'safety at work and injuries'),
    ('work', 'calling in sick and asking for holidays'), ('work', 'in a warehouse / logistics'),
    ('work', 'in a restaurant kitchen'), ('work', 'on a building site'), ('work', 'working as a caregiver (badante)'),
    ('work', 'working in the fields (agriculture)'), ('work', 'cleaning job'), ('work', 'looking for a job'),
    ('house', 'looking for a flat to rent'), ('house', 'with the landlord: rent, deposit, contract'),
    ('house', 'something is broken at home (plumber, electrician)'), ('house', 'with neighbours in the building'),
    ('house', 'bills: electricity, gas, water, internet'), ('house', 'cleaning and housework'),
    ('shopping', 'at the supermarket'), ('shopping', 'at the market buying fruit and vegetables'),
    ('shopping', 'at the butcher / halal butcher'), ('shopping', 'buying clothes and shoes'),
    ('shopping', 'returning or exchanging an item'), ('shopping', 'buying a phone or SIM card'),
    ('shopping', 'online orders and deliveries'),
    ('money', 'at the bank: opening an account'), ('money', 'sending money home'), ('money', 'paying with card or cash'),
    ('money', 'problems with a card or payment'), ('money', 'at the post office paying a bill'),
    ('transport', 'taking the bus and buying tickets'), ('transport', 'at the train station'),
    ('transport', 'asking for directions in the street'), ('transport', 'taking a taxi'),
    ('transport', 'driving: police check, fines, accident'), ('transport', 'converting the driving licence'),
    ('transport', 'at the airport'), ('city', 'around town: places and opening hours'),
    ('city', 'at the bar ordering coffee'), ('food', 'at the restaurant / pizzeria'),
    ('food', 'religious and dietary needs (halal, no pork, vegetarian, Ramadan)'),
    ('cooking', 'cooking at home and recipes'), ('school', 'enrolling children at school'),
    ('school', 'talking with the teacher'), ('school', 'Italian course for adults (CPIA)'),
    ('school', 'helping children with homework'), ('family', 'talking about your family'),
    ('family', 'children and babies'), ('family', 'weddings, births and funerals'),
    ('greetings', 'meeting someone for the first time'), ('greetings', 'polite expressions every day'),
    ('greetings', 'saying goodbye and best wishes'), ('feelings', 'expressing feelings and emotions'),
    ('feelings', 'apologising and thanking'), ('phrases', 'when you do not understand Italian'),
    ('phrases', 'asking for help'), ('phrases', 'emergencies: police, fire, ambulance'),
    ('phrases', 'on the phone'), ('phrases', 'messages on WhatsApp with Italians'),
    ('phrases', 'making plans with friends'), ('phrases', 'agreeing and disagreeing politely'),
    ('phrases', 'small talk with colleagues'), ('phrases', 'complaining politely'),
    ('time', 'dates, times and appointments'), ('weather', 'talking about the weather'),
    ('sport', 'sport and free time (cricket, football, gym)'), ('nature', 'a day at the sea or in the mountains'),
    ('animals', 'pets and the vet'), ('clothes', 'sizes and fitting clothes'),
    ('bathroom', 'personal hygiene and the bathroom'), ('kitchen', 'in the kitchen at home'),
    ('jobs', 'talking about your job and profession'), ('body', 'pain in parts of the body'),
    ('numbers', 'prices, quantities and phone numbers'), ('colors', 'describing things and colours'),
    ('verbs', 'daily routine (wake up, eat, work, sleep)'), ('adjectives', 'describing people and things'),
    ('offices', 'police report (denuncia) after a theft'), ('offices', 'lawyer and court basics'),
    ('offices', 'tax code (codice fiscale) and health card (tessera sanitaria)'),
    ('offices', 'SPID, PEC and online public services'), ('house', 'moving house'),
    ('work', 'self-employed: partita IVA and invoices'), ('work', 'payslip problems and trade union'),
    ('health', 'mental health and stress'), ('health', 'pharmacy night service and first aid'),
    ('phrases', 'religion and holidays (Eid, Christmas, Diwali)'), ('phrases', 'at the mosque, church or temple'),
    ('phrases', 'invitations to dinner and visiting a home'), ('phrases', 'compliments and congratulations'),
    ('phrases', 'travelling to your home country and back'), ('phrases', 'at the hotel'),
    ('school', 'university and recognition of foreign diplomas'), ('family', 'children\'s sports and activities'),
    ('city', 'at the barber or hairdresser'), ('city', 'at the laundry and tailor'),
    ('shopping', 'at the hardware store'), ('transport', 'buying a used car or scooter'),
]

PROMPT = """You create an Italian phrasebook for immigrants living in Italy.
Write {n} DIFFERENT, short (3-12 words), natural, everyday Italian sentences that a foreigner really needs in
this situation: {situation}. Correct Italian with accents and apostrophes; mix questions and answers;
use "Lei" with officials/doctors/shop staff and "tu" with friends/colleagues; no names of real companies.
For EACH sentence give its translation in these 10 languages IN THIS ORDER:
0 English, 1 Urdu (Urdu script), 2 Punjabi Shahmukhi (Pakistani Punjabi, Arabic script, real Punjabi words),
3 Punjabi Gurmukhi, 4 Bengali (Bangladesh usage: পানি not জল), 5 Sinhala, 6 Chinese Simplified,
7 French, 8 Spanish (Spain), 9 Spanish (Latin America).
Each language ONLY in its own script (no English words inside Urdu/Punjabi/Bengali/Sinhala/Chinese,
no Gurmukhi letters in Shahmukhi, Urdu letters ہ ی ک).
Also "rom": how people TYPE the Urdu/Punjabi/Bengali/Chinese sentence in Latin letters on WhatsApp
(lowercase; zh = pinyin without tones).
Return ONLY a JSON array:
[{{"w":"<Italian sentence>","tr":["en","ur","pa-Arab","pa-Guru","bn","si","zh","fr","es","es-419"],
  "rom":{{"ur":"...","pa":"...","bn":"...","zh":"..."}}}}]"""


def valid_items(items, n_min):
    if not isinstance(items, list) or len(items) < n_min:
        return []
    out = []
    for it in items:
        if not isinstance(it, dict):
            continue
        w = str(it.get('w', '')).strip()
        tr = it.get('tr')
        if not (3 <= len(w) <= 140) or not isinstance(tr, list) or len(tr) != 10:
            continue
        if not all(isinstance(s, str) and s.strip() for s in tr):
            continue
        if t.entry_ok(it):
            out.append(it)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--workers', type=int, default=12)
    ap.add_argument('--per', type=int, default=20)
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    ROUNDS = 4
    def fname(i, r):
        return os.path.join(OUT, f'{i:03d}.json' if r == 0 else f'{i:03d}_{r}.json')
    todo = [(i, r) for r in range(ROUNDS) for i in range(len(SITUATIONS))
            if not os.path.exists(fname(i, r))]
    print(f'{len(SITUATIONS)} situations x {ROUNDS} rounds, {len(todo)} to do', flush=True)
    ks = t.keys()
    lock = threading.Lock()
    models = t.FAST if os.environ.get('NO_STRONG') else t.FAST + t.STRONG

    def work():
        while True:
            with lock:
                if not todo:
                    return
                i, r = todo.pop(0)
            topic, situation = SITUATIONS[i]
            text = PROMPT.format(n=a.per, situation=situation)
            if r > 0:
                # Later rounds: other moments of the same situation, no repeats.
                seen = []
                for rr in range(ROUNDS):
                    if os.path.exists(fname(i, rr)):
                        seen += [x['w'] for x in json.load(open(fname(i, rr), encoding='utf-8'))]
                text += (chr(10) + 'Round %d: cover OTHER moments of this situation. '
                         'Do NOT repeat any of these: ' % r) + ' | '.join(seen[:80])
            good = []
            for attempt in range(len(models) * len(ks)):
                model = models[attempt // len(ks)]
                if model in t.EXHAUSTED:
                    continue
                try:
                    items = json.loads(t.call(ks[(i + attempt) % len(ks)], model, text))
                    good = valid_items(items, a.per // 2)
                    if len(good) >= a.per // 2:
                        break
                except Exception:  # noqa: BLE001 — quota/network/JSON: next key/model
                    continue
            if len(good) >= a.per // 2:
                for it in good:
                    it['pos'] = 'phrase'
                    it['topic'] = topic
                with open(fname(i, r), 'w', encoding='utf-8') as f:
                    json.dump(good, f, ensure_ascii=False)
                print(f'situation {i} round {r}: {len(good)} phrases', flush=True)
            else:
                print(f'situation {i} round {r} failed, retry next run', flush=True)

    threads = [threading.Thread(target=work) for _ in range(a.workers)]
    for th in threads:
        th.start()
    for th in threads:
        th.join()


if __name__ == '__main__':
    main()
