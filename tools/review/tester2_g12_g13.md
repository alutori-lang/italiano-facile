# Tester 2 — g12 (money) + g13 (house)

Files: tools/dict_src/g12_1..4.json, g13_1..6.json
Entries checked: 339 (every field: it, type, topic, emoji, 10 x tr, 10 x expl, ex, 10 x exTr)
Entries after review: 337 (2 duplicates removed)
Corrections: 47 (45 field edits + 2 removed entries)

Overall the quality was high. Italian headwords, articles, accents, examples and the
Spain/LatAm Spanish split were correct throughout. Most fixes were emojis that showed the
wrong thing, Italian words left in Latin letters in the Arabic/Gurmukhi/Bengali/Sinhala slots,
and a few unnatural translations.

Indexes are the ones before the edit. In g13_4, entries after #14 moved up by 1, and entries
after #19 moved up by 2.

## Removed entries (duplicates inside this group)
- g13_4#14 — entry "il mutuo" — duplicate of g12_1#18 → removed
- g13_4#19 — entry "il garante" — duplicate of g12_3#30 → removed. The g12 version already covers both the loan and the rent case.

## Emoji (wrong or misleading picture → null)
- g12_1#19 (la rata) — emoji — 📅 → null
- g12_1#22 (il risparmio) — emoji — 🐷 → null
- g12_1#36 (risparmiare) — emoji — 🐷 → null
- g12_2#20 (la multa) — emoji — 🚓 → null
- g12_3#21 (pagare a rate) — emoji — 📅 → null
- g12_4#23 (Posso pagare a rate?) — emoji — 📅 → null
- g12_4#24 (Quanto pago di rata al mese?) — emoji — 📅 → null
- g13_1#24 (il citofono) — emoji — 📟 (pager) → null

## Script rule (Latin letters in Urdu/Shahmukhi/Gurmukhi/Bengali/Sinhala slots → native script)
- g12_3#34 (la tabaccheria) — expl[5] — 'T' ලකුණ → 'ටී' ලකුණ
- g13_4#37 (arredato) — expl[1] — مؤنث: arredata → مؤنث: آرّیداتا
- g13_4#37 — expl[2] — مؤنث: arredata → زنانہ: آرّیداتا
- g13_4#37 — expl[3] — arredata → ਆਰੇਦਾਤਾ
- g13_4#37 — expl[4] — arredata → আরেদাতা
- g13_4#37 — expl[5] — arredata → අරෙදාතා
- g13_5#18 (Sono rimasto chiuso fuori.) — expl[1] — rimasta → ریماستا
- g13_5#18 — expl[2] — rimasta → ریماستا
- g13_5#18 — expl[3] — rimasta → ਰਿਮਾਸਤਾ
- g13_5#18 — expl[4] — rimasta → রিমাস্তা
- g13_5#18 — expl[5] — rimasta → රිමාස්තා
- g13_6#0 (Devo pagare l'affitto entro il cinque.) — expl[1] — (RLM)entro → انترو
- g13_6#0 — expl[2] — (RLM)entro → انترو
- g13_6#0 — expl[3] — entro → ਐਂਤਰੋ
- g13_6#0 — expl[4] — entro → এন্ত্রো
- g13_6#0 — expl[5] — entro → එන්ත්‍රෝ
- g13_6#11 (Abito al secondo piano.) — expl[1] — piano terra → پیانو تیرّا
- g13_6#11 — expl[2] — piano terra → پیانو تیرّا
- g13_6#11 — expl[3] — piano terra → ਪਿਆਨੋ ਤੇਰਾ
- g13_6#11 — expl[4] — piano terra → পিয়ানো তেররা
- g13_6#11 — expl[5] — piano terra → පියානෝ තෙර්රා

Left as they were on purpose:
- "IT" in the IBAN example: it is the literal code printed on the IBAN.
- "F24" in the Chinese slot: it is the name of the form.
- Italian feminine forms in Latin letters inside Chinese expl: this matches the convention used elsewhere in the dictionary, and Chinese readers can read Latin letters.

## Translations / wording
- g12_1#1 (il centesimo) — expl[1] Urdu — سواں → سوواں (hundredth)
- g12_4#38 (La mia carta è scaduta.) — tr[1] Urdu — میرا کارڈ ختم ہو گیا ہے۔ (the card "finished") → میرے کارڈ کی میعاد ختم ہو گئی ہے۔
- g12_4#38 — exTr[1] — میرا کارڈ ختم ہو گیا ہے، → میرے کارڈ کی میعاد ختم ہو گئی ہے،
- g12_4#38 — tr[2] Shahmukhi — میرا کارڈ مُک گیا اے۔ → میرے کارڈ دی میعاد مُک گئی اے۔
- g12_4#38 — exTr[2] — میرا کارڈ مُک گیا اے، → میرے کارڈ دی میعاد مُک گئی اے،
- g12_4#38 — tr[3] Gurmukhi — ਮੇਰਾ ਕਾਰਡ ਖਤਮ ਹੋ ਗਿਆ ਹੈ। → ਮੇਰੇ ਕਾਰਡ ਦੀ ਮਿਆਦ ਖਤਮ ਹੋ ਗਈ ਹੈ।
- g12_4#38 — exTr[3] — ਮੇਰਾ ਕਾਰਡ ਖਤਮ ਹੋ ਗਿਆ ਹੈ, → ਮੇਰੇ ਕਾਰਡ ਦੀ ਮਿਆਦ ਖਤਮ ਹੋ ਗਈ ਹੈ,
- g13_2#28 (la gruccia) — exTr[2] Shahmukhi — چاہی دے نیں → چاہیدے نیں
- g13_4#9 (la disdetta) — tr[2] Shahmukhi — ٹھیکہ مکان دا نوٹس (reads as "house lease notice") → ٹھیکہ ختم کرن دا نوٹس
- g13_4#38 (luminoso) — tr[1] Urdu — روشن / ہوادار (ہوادار = airy) → روشن
- g13_5#18 (Sono rimasto chiuso fuori.) — tr[1] Urdu — میں باہر بند ہو گیا ہوں۔ → میں باہر رہ گیا ہوں، دروازہ بند ہو گیا۔
- g13_5#18 — exTr[1] — میں باہر بند ہو گیا ہوں، → میں باہر رہ گیا ہوں،
- g13_5#18 — tr[7] French — Je suis enfermé dehors. → Je me suis enfermé dehors.
- g13_5#18 — exTr[7] — Je suis enfermé dehors, → Je me suis enfermé dehors,
- g13_5#16 (È saltata la luce.) — tr[9] LatAm — Se botó la luz / se bajó el breaker. (regional) → Se bajó el breaker / se fue la luz.
- g13_5#16 — exTr[9] — Se botó la luz, → Se bajó el breaker,

## Validator
`python -I tools/check_dict.py tools/dict_src/g12_*.json tools/dict_src/g13_*.json`
→ `337 entries in 10 files, 0 errors`
