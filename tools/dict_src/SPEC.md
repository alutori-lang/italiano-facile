# Dictionary entry spec (Italian Words app)

Users are foreigners living in Italy (Pakistan, India/Punjab, Bangladesh, Sri Lanka,
China, French/Spanish speakers, Latin America). Choose the words and phrases they
REALLY need in everyday life in Italy: home, work, food, shopping, doctor, offices,
transport, school, family. Most common first. No rare, literary or regional words.

## File format
Write JSON files (UTF-8, valid JSON, no comments) named `<group>_<part>.json`,
e.g. `food_1.json`, `food_2.json` — at most ~40 entries per file. Each file is a
JSON array of objects:

```json
{
  "it": "il pomodoro",
  "type": "n",
  "topic": "vegetables",
  "emoji": "🍅",
  "tr":   ["tomato", "ٹماٹر", "ٹماٹر", "ਟਮਾਟਰ", "টমেটো", "තක්කාලි", "番茄", "tomate", "tomate", "tomate, jitomate"],
  "expl": [10 short explanations],
  "ex":   "Compro un chilo di pomodori.",
  "exTr": [10 translations of the example]
}
```

### The 10 language slots, ALWAYS in this order
0 English · 1 Urdu (Nastaliq/Arabic script) · 2 Punjabi Shahmukhi (Arabic script, Pakistani Punjabi —
real Punjabi words, not just Urdu copied) · 3 Punjabi Gurmukhi (ਗੁਰਮੁਖੀ) · 4 Bengali (Bangladesh usage) ·
5 Sinhala (සිංහල) · 6 Chinese Simplified · 7 French · 8 Spanish (Spain) · 9 Spanish (Latin America:
carro, celular, computadora, jugo, durazno, frijoles, papa, departamento, manejar, camión/autobús…).

### Fields
- `it`: Italian headword. NOUNS ALWAYS WITH THE DEFINITE ARTICLE: il / lo / la / l' / i / gli / le
  (lo before s+consonant, z, gn, ps, x, y: "lo zucchero", "lo sciopero", "gli zaini"; l' before a vowel:
  "l'acqua", "l'ospedale"). Plural-only nouns with plural article ("gli occhiali", "i soldi").
  Correct accents: perché, città, caffè, lunedì, più, università, tè, ventitré, può, già.
  Verbs in the infinitive ("parlare", "alzarsi"). Adjectives in masculine singular, add feminine if
  irregular only in expl. Phrases: a full natural sentence with correct punctuation ("Quanto costa?").
- `type`: "n" noun, "v" verb, "a" adjective/adverb/other word, "p" phrase (2+ words used as a unit or a sentence).
- `topic`: one of the topic ids given to you.
- `emoji`: ONE emoji that clearly shows the thing (🍅 for pomodoro, 🗣️ for parlare, 🚌 for autobus).
  If no emoji really shows it, use null. A WRONG picture is worse than none. Never use a flag for a language.
- `tr`: the translation in each language — the word people actually use, short (1–4 words;
  alternatives separated by " / "). For nouns do NOT add articles in other languages
  (except French/Spanish may omit them too: "tomate").
- `expl`: ONE short sentence (max ~15 words) in EACH language that explains the meaning/usage simply,
  so that a word with no picture is still clear (e.g. "rinnovare" → "to make a document valid again
  for more time, e.g. the residence permit"). Written natively in each language, not transliterated.
- `ex`: one short, simple, natural Italian example sentence (A1–A2 level), correct grammar and accents.
- `exTr`: the example translated into the 10 languages.

## Quality rules (testers will check EVERY entry)
- Italian 100% correct: spelling, accents, article, gender, apostrophes ( l'acqua — use the straight ' ).
- Urdu & Shahmukhi in Arabic script, Gurmukhi in Gurmukhi script, Bengali in Bengali script, Sinhala in
  Sinhala script, Chinese in simplified characters. NO Latin letters inside those slots (except digits).
- Never leave a slot empty, never write "N/A", never copy English into another slot.
- No duplicates inside your files and do not repeat the words listed as already existing.
- Validate your files with: `python -I tools/check_dict.py tools/dict_src/<your files>` and fix every error
  before finishing (run it from the project root).
