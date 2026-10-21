# Tester 2 review — g23 (sport & free time, incl. cricket)

Files: tools/dict_src/g23_1.json (39), g23_2.json (40), g23_3.json (38)
Entries checked: 117 (every field: it, type, topic, emoji, tr[10], expl[10], ex, exTr[10]).
Entries removed: 0.
Corrections: 30 (format: file#index — field — wrong → right).

Notes
- Overall quality was high; Italian headwords, articles, accents and examples were all correct.
- Emoji: "close enough" pictures removed (🏏 for the cricket ground, 📣 for tifoso/tifare/"Per quale squadra tifi?", 🚌 for gita, 📊 for classifica) → null.
- Sinhala: ලකුණු පුවරුව is a scoreboard, not a league table → ලකුණු වගුව; ඉස්කෝප්පු (= spades) removed from "cards".
- Shahmukhi: "il ballo" is dance in general, not bhangra; kulfi ≠ gelato.
- Urdu/Shahmukhi/Gurmukhi کورس / ਕੋਰਸ for choir reads as "course" → کوائر / ਕੋਆਇਰ.
- File layout kept unchanged (compact one-field-per-line style; verified by round-trip before writing).

Final validator: `python -I tools/check_dict.py tools/dict_src/g23_*.json` → 117 entries in 3 files, 0 errors

## Corrections
- g23_1.json#3 — tr[5] — පන්දු පිතිකරු → පිතිකරු
- g23_1.json#4 — exTr[4] — আমার ভাই খুব দ্রুত বোলার। → আমার ভাই খুব দ্রুতগতির বোলার।
- g23_1.json#5 — emoji — 🏏 → null
- g23_1.json#18 — tr[2] — تارو / تیراکی → تارنا / تیراکی
- g23_1.json#24 — tr[5] — කාඩ් / ඉස්කෝප්පු → කාඩ් / සෙල්ලම් කාඩ්
- g23_1.json#24 — exTr[6] — 晚上我们在酒吧打牌。 → 晚上我们在咖啡馆打牌。
- g23_1.json#26 — emoji — 📣 → null
- g23_1.json#37 — exTr[0] — In Pakistan hockey is very loved. → In Pakistan hockey is very popular.
- g23_2.json#4 — exTr[3] — ਮੈਂ ਤਰੀਕਾ ਇੰਟਰਨੈੱਟ 'ਤੇ ਲੱਭਿਆ। → ਮੈਂ ਰੈਸਿਪੀ ਇੰਟਰਨੈੱਟ 'ਤੇ ਲੱਭੀ।
- g23_2.json#14 — emoji — 🚌 → null
- g23_2.json#16 — tr[2] — نچ / بھنگڑا → نچ / ڈانس
- g23_2.json#16 — exTr[2] — پنجاب دا ریتی نچ بھنگڑا اے۔ → پنجاب دا روایتی نچ بھنگڑا اے۔
- g23_2.json#20 — exTr[7] — Espérons gagner le match. → On espère gagner le match.
- g23_2.json#25 — emoji — 📣 → null
- g23_2.json#25 — exTr[8] — Yo soy del Pakistán y él de la India. → Yo voy con Pakistán y él con la India.
- g23_2.json#27 — exTr[1] — میری بیٹی اسکول کے کورس میں گاتی ہے۔ → میری بیٹی اسکول کے کوائر میں گاتی ہے۔
- g23_2.json#27 — exTr[2] — میری دھی سکول دے کورس وچ گاندی اے۔ → میری دھی سکول دے کوائر وچ گاندی اے۔
- g23_2.json#27 — exTr[3] — ਮੇਰੀ ਧੀ ਸਕੂਲ ਦੇ ਕੋਰਸ ਵਿੱਚ ਗਾਉਂਦੀ ਹੈ। → ਮੇਰੀ ਧੀ ਸਕੂਲ ਦੇ ਕੋਆਇਰ ਵਿੱਚ ਗਾਉਂਦੀ ਹੈ।
- g23_2.json#37 — expl[4] — বাদ্যযন্ত্র বাজানো; ঘণ্টা বা ফোন বাজাও। → বাদ্যযন্ত্র বাজানো; ঘণ্টা বা ফোন বাজার অর্থেও।
- g23_2.json#38 — expl[2] — شوق لئی کنڈی نال مچھی پھڑنا؛ اٹلی وچ لائسنس لوڑیندا ہو سکدا اے۔ → شوق لئی کنڈی نال مچھی پھڑنا؛ اٹلی وچ لائسنس چاہیدا ہو سکدا اے۔
- g23_2.json#39 — exTr[5] — පාටිය හරිම විනෝදජනකයි. → පාටිය හරිම විනෝදජනක වුණා.
- g23_3.json#3 — emoji — 📊 → null
- g23_3.json#3 — tr[5] — ලකුණු පුවරුව → ලකුණු වගුව
- g23_3.json#3 — exTr[5] — අපේ කණ්ඩායම ලකුණු පුවරුවේ පළමුවැනියා. → අපේ කණ්ඩායම ලකුණු වගුවේ පළමු තැන.
- g23_3.json#17 — exTr[8] — Ayer jugaban Pakistán e India: ¿quién ha ganado? → Ayer jugaron Pakistán e India: ¿quién ganó?
- g23_3.json#19 — emoji — 📣 → null
- g23_3.json#19 — exTr[5] — ඔයා මොන කණ්ඩායමටද? මම යුවෙන්ටස්. → ඔයා සහාය දෙන්නේ මොන කණ්ඩායමටද? මම යුවෙන්ටස් රසිකයෙක්.
- g23_3.json#28 — exTr[2] — اج رات باہر چلیے؟ شہر وچ قلفی کھاندے آں۔ → اج رات باہر چلیے؟ شہر وچ آئس کریم کھاندے آں۔
- g23_3.json#31 — tr[6] — 我们去散步吧？ → 我们去散步好吗？
- g23_3.json#31 — exTr[6] — 出太阳了：我们去散步吧？ → 出太阳了：我们去散步好吗？
