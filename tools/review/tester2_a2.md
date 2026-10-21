# Tester 2 review — a2 (adjectives and small words M–Z)

Files: tools/dict_src/a2_1.json (31), a2_2.json (40), a2_3.json (37), a2_4.json (40)
Entries checked: 148 (every field: it, type, topic, emoji, tr[10], expl[10], ex, exTr[10]).
Entries removed: 0.
Corrections: 63 (format: file#index (headword) — field — wrong → right).

Notes
- Italian headwords, accents (più, perché, però, sì, qua without accent, un po') and example sentences were all correct; no change needed in `it`/`ex`.
- Emoji: "close enough" pictures removed → null: 🚫 used for niente / non / senza (it means "forbidden", kept only for vietato), 🤢 orribile, 👎 peggio, ✅ pronto, 💡 per esempio, 🤷 più o meno, 💪 per forza (literal "force"), ➡️ quindi, 😠 scortese, ❔ sconosciuto, 😐 sul serio, 🧮 totale, ⚠️ troppo, 💯 tutto, 🛠️ utile, 👨‍👩‍👧‍👦 tutti.
- mentre: Urdu/Punjabi/Bengali "جب تک / ਜਦ ਤੱਕ / ততক্ষণ" mean "until / that long", not "while".
- neanche: French/Spanish explanations used non-words «Aussi pas» / «También no» → «Pas non plus» / «Tampoco».
- Sinhala: සැහැල්ලු (= light in weight) for "soft", අල්ලලා for "occupied", 'එහෙමමයි' for "so-so", මල්ලි (younger brother) for generic fratello, කවුළුව (house window) for shop window — fixed.
- Shahmukhi: ویہلا (= idle/free) for "lazy", پکا (= sure) for "serious", اکیلا/اکلا (= alone) for "only (child)", "پر ایہہ" for "but" — fixed.
- positivo: Urdu/Shahmukhi expl said "a disease was found", contradicting the pregnancy-test example → "something was found".
- File layout kept unchanged (indent 1, UTF-8, CRLF; verified identical round-trip before writing).

Final validator: `python -I tools/check_dict.py tools/dict_src/a2_*.json` → 148 entries in 4 files, 0 errors

## Corrections
- a2_1.json#0 (ma) — tr[2] — پر / پر ایہہ → پر
- a2_1.json#3 (meno) — tr[2] — گھٹ / گھٹ → گھٹ
- a2_1.json#4 (mentre) — tr[1] — جبکہ / جب تک → جبکہ / کے دوران
- a2_1.json#4 (mentre) — tr[2] — جدوں / جد تک → جدوں / دے دوران
- a2_1.json#4 (mentre) — tr[3] — ਜਦੋਂ / ਜਦ ਤੱਕ → ਜਦੋਂ / ਦੇ ਦੌਰਾਨ
- a2_1.json#4 (mentre) — tr[4] — যখন / ততক্ষণ → যখন / -এর সময়
- a2_1.json#6 (mio) — expl[8] — Que es de mí; femenino «mia», plural «miei», «mie». → Que me pertenece; femenino «mia», plural «miei», «mie».
- a2_1.json#6 (mio) — expl[9] — Que es de mí; femenino «mia», plural «miei», «mie». → Que me pertenece; femenino «mia», plural «miei», «mie».
- a2_1.json#9 (morbido) — tr[5] — මෘදු / සැහැල්ලු → මෘදු / මොළොක්
- a2_1.json#11 (medio) — exTr[2] — مینوں درمیانہ سائز دے دیو، مہربانی؟ → مہربانی کر کے مینوں درمیانہ سائز دے دیو؟
- a2_1.json#14 (massimo) — exTr[0] — In town the maximum speed is fifty per hour. → In town the maximum speed is fifty kilometres an hour.
- a2_1.json#18 (nessuno) — tr[4] — কেউ না / কোনো → কেউ না / কোনোটাই না
- a2_1.json#19 (neanche) — expl[7] — « Aussi pas » ; pour être d'accord avec une phrase négative. → « Pas non plus » ; pour être d'accord avec une phrase négative.
- a2_1.json#19 (neanche) — expl[8] — «También no»; para estar de acuerdo con una frase negativa. → «Tampoco»; para estar de acuerdo con una frase negativa.
- a2_1.json#19 (neanche) — expl[9] — «También no»; para estar de acuerdo con una frase negativa. → «Tampoco»; para estar de acuerdo con una frase negativa.
- a2_1.json#20 (niente) — emoji — 🚫 → null
- a2_1.json#24 (non) — emoji — 🚫 → null
- a2_2.json#1 (occupato) — tr[4] — ব্যস্ত / দখল করা → ব্যস্ত / খালি নেই
- a2_2.json#1 (occupato) — tr[5] — කාර්යබහුල / අල්ලලා → කාර්යබහුල / භාවිතයේ
- a2_2.json#9 (ovvio) — tr[4] — স্পষ্ট / স্বাভাবিক → স্পষ্ট / সুস্পষ্ট
- a2_2.json#11 (orribile) — emoji — 🤢 → null
- a2_2.json#14 (peggio) — emoji — 👎 → null
- a2_2.json#19 (però) — expl[0] — Like 'ma': shows a contrast; often at the end of a sentence. → Like 'ma': shows a contrast between two ideas.
- a2_2.json#22 (piano) — expl[5] — වේගයෙන් නෙවෙයි, නැත්නම් හෙමින් කටහඬින්. → වේගයෙන් නෙවෙයි, නැත්නම් අඩු හඬින්.
- a2_2.json#24 (pigro) — tr[2] — سست / ویہلا → سست / آلسی
- a2_2.json#26 (positivo) — expl[1] — اچھا؛ میڈیکل ٹیسٹ میں مطلب بیماری ملی ہے۔ → اچھا؛ میڈیکل ٹیسٹ میں مطلب کچھ ملا ہے۔
- a2_2.json#26 (positivo) — expl[2] — چنگا؛ میڈیکل ٹیسٹ وچ مطلب بیماری لبھی اے۔ → چنگا؛ میڈیکل ٹیسٹ وچ مطلب کجھ لبھیا اے۔
- a2_2.json#32 (pronto) — emoji — ✅ → null
- a2_2.json#33 (proprio) — exTr[8] — Esta noche estoy muy cansado de verdad. → Esta noche estoy realmente cansado.
- a2_2.json#33 (proprio) — exTr[9] — Esta noche estoy de verdad cansado. → De verdad que estoy cansado esta noche.
- a2_2.json#34 (pubblico) — exTr[0] — My son goes to the public school. → My son goes to a state school.
- a2_3.json#0 (per esempio) — emoji — 💡 → null
- a2_3.json#2 (più o meno) — emoji — 🤷 → null
- a2_3.json#2 (più o meno) — expl[5] — හරියටම නෙවෙයි, ඒත් ළඟයි; 'එහෙමමයි' කියලත්. → හරියටම නෙවෙයි, ඒත් ළඟයි; 'එහෙම මෙහෙම' කියලත්.
- a2_3.json#3 (per caso) — tr[4] — হঠাৎ করে / কোনোভাবে → ঘটনাক্রমে / কোনোভাবে
- a2_3.json#3 (per caso) — expl[2] — بغیر سوچے سمجھے؛ سوال وچ نرمی لیاندا اے۔ → بغیر پروگرام دے؛ سوال وچ نرمی لیاندا اے۔
- a2_3.json#8 (per forza) — emoji — 💪 → null
- a2_3.json#8 (per forza) — exTr[0] — I really have to go to the police office tomorrow. → I really have to go to the police headquarters tomorrow.
- a2_3.json#10 (qualche) — exTr[5] — මම දවස් කීපයක් මල්ලි ළඟ ඉන්නවා. → මම දවස් කීපයක් මගේ සහෝදරයා ළඟ ඉන්නවා.
- a2_3.json#10 (qualche) — exTr[6] — 我在我哥哥家住几天。 → 我在我兄弟家住几天。
- a2_3.json#17 (quasi) — tr[5] — බොහෝ දුරට / ලඟලඟම → බොහෝ දුරට / ආසන්න වශයෙන්
- a2_3.json#17 (quasi) — exTr[5] — අටට ලඟයි, යමු! → අටට ළඟයි, යමු!
- a2_3.json#18 (quello) — exTr[5] — කවුළුවේ තියෙන අර එක මට දෙනවද? → ෂෝකේස් එකේ තියෙන අර එක මට දෙනවද?
- a2_3.json#20 (quindi) — emoji — ➡️ → null
- a2_3.json#28 (semplice) — exTr[3] — ਤਰੀਕਾ ਬਹੁਤ ਸੌਖਾ ਹੈ। → ਰੈਸਿਪੀ ਬਹੁਤ ਸੌਖੀ ਹੈ।
- a2_3.json#29 (senza) — emoji — 🚫 → null
- a2_3.json#30 (serio) — tr[2] — سنجیدہ / پکا → سنجیدہ / گمبھیر
- a2_3.json#30 (serio) — exTr[2] — ایہہ پکا مسئلہ اے، تینوں ڈاکٹر کول جانا چاہیدا اے۔ → ایہہ سنجیدہ مسئلہ اے، تینوں ڈاکٹر کول جانا چاہیدا اے۔
- a2_3.json#34 (soltanto) — exTr[5] — මට තියෙන්නේ යූරෝ පහයි විතරයි. → මට තියෙන්නේ යූරෝ පහක් විතරයි.
- a2_4.json#6 (suo) — exTr[2] — اپنا شناختی کاغذ دیو گے، مہربانی؟ → مہربانی کر کے اپنا شناختی کاغذ دیو گے؟
- a2_4.json#7 (scortese) — emoji — 😠 → null
- a2_4.json#10 (sconosciuto) — emoji — ❔ → null
- a2_4.json#11 (sul serio) — emoji — 😐 → null
- a2_4.json#16 (totale) — emoji — 🧮 → null
- a2_4.json#18 (troppo) — emoji — ⚠️ → null
- a2_4.json#21 (tutto) — emoji — 💯 → null
- a2_4.json#23 (unico) — tr[1] — اکیلا / واحد / انوکھا → اکلوتا / واحد / انوکھا
- a2_4.json#23 (unico) — tr[2] — اکلا / اکو اک → اکلوتا / اکو اک
- a2_4.json#24 (utile) — emoji — 🛠️ → null
- a2_4.json#33 (vostro) — expl[2] — جو تہاڈا سب دا ہووے؛ زنانہ شکل وکھری۔ → جو تہاڈے سبھناں دا ہووے؛ زنانہ شکل وکھری۔
- a2_4.json#33 (vostro) — expl[3] — ਜੋ ਤੁਹਾਡਾ ਸਭ ਦਾ ਹੋਵੇ; ਇਸਤਰੀ ਲਿੰਗ ਰੂਪ ਵੱਖਰਾ। → ਜੋ ਤੁਹਾਡੇ ਸਾਰਿਆਂ ਦਾ ਹੋਵੇ; ਇਸਤਰੀ ਲਿੰਗ ਰੂਪ ਵੱਖਰਾ।
- a2_4.json#37 (tutti) — emoji — 👨‍👩‍👧‍👦 → null
- a2_4.json#38 (stupendo) — exTr[6] — 今天天气真好！ → 多么美好的一天！
