# Tester 2 — g22 (nature)

Files: tools/dict_src/g22_1..4.json
Entries checked: 151 (every field: it, type, topic, emoji, tr, expl, ex, exTr in all 10 slots)
Entries removed: 0
Corrections: 72

Final validator: `python -I tools/check_dict.py tools/dict_src/g22_*.json`
→ `151 entries in 4 files, 0 errors`

Notes
- Italian headwords, articles (lo scoglio, lo smog, l'isola ecologica, le pile usate, i rifiuti), accents, phrase punctuation and example sentences were all correct. No Italian text had to change. Types and topics are fine.
- Emoji: only an exact picture is kept. 27 near-miss pictures set to null, for example 🥾 boot for "sentiero", 🫒 olive for "ulivo", 🍇 grapes for "vigna", 🪵 log for "tronco", 🌑 new moon for "buio", 🧺 basket for "raccolto", 💨 dash for "fumo", 🏭 factory for "inquinamento"/"inquinare", 🌫️ fog for "smog", ☀️ for renewable energy, 🌡️ for global warming, 🌊 wave for "oceano" and for "Il mare è calmo" (a big wave on a calm sea), 🏔️ for "ghiacciaio", 🛡️ for "proteggere", 💧 for "innaffiare", 🍎 for "raccogliere la frutta", 🧑‍🌾 for "coltivare", 🚜 for "agricoltura", plain 🚫 on two signs, a single generic tree 🌳 on "la quercia" and "Mi piace stare all'aria aperta". ✨ (sparkles) on "le stelle" became ⭐; on "Guarda quante stelle!" it became 🌌.
- Wrong words fixed: Urdu شاہ بلوط means chestnut, not oak (quercia now uses بلوط); Shahmukhi برفانی تودا means avalanche, not glacier; Shahmukhi ٹھنڈا ٹھار ("cool") was used for a calm sea; Bengali শৈলশিরা ("ridge") was given for a sea rock; Bengali জ্বালানি ("fuel") was given for energy; Bengali নালা ("drain") and Gurmukhi ਨਾਲੀ were given for a brook; Spain Spanish "selva" (jungle) was given for forest; Sinhala ගස් වැට / "වත්තේ මහත්තයා" were used for hedge / gardener; Sinhala උල්පත ("spring") was used for a drinking fountain.
- Bengali was already Bangladesh usage (পানি, বাসা, চাচা).

## Corrections (file#index — field — wrong → right)
- g22_1.json#2 (il mondo) — exTr[5] — මගේ පන්තියේ ලෝකය පුරා මිනිස්සු ඉන්නවා. → මගේ පන්තියේ ලෝකයේ හැම තැනකින්ම ආපු මිනිස්සු ඉන්නවා.
- g22_1.json#11 (il torrente) — tr[4] — পাহাড়ি ছড়া / খরস্রোতা → পাহাড়ি ছড়া / পাহাড়ি নদী
- g22_1.json#15 (la valle) — exTr[1] — گاؤں وادی کے نیچے ہے۔ → گاؤں وادی کی تہہ میں ہے۔
- g22_1.json#16 (il bosco) — expl[8] — Lugar con muchos árboles, más pequeño que una selva. → Lugar con muchos árboles, más pequeño que un gran bosque.
- g22_1.json#17 (la foresta) — tr[8] — selva / bosque → bosque
- g22_1.json#17 (la foresta) — tr[9] — selva / bosque → bosque / selva
- g22_1.json#17 (la foresta) — exTr[9] — La selva está llena de árboles altísimos. → El bosque está lleno de árboles altísimos.
- g22_1.json#24 (il sentiero) — emoji — 🥾 → null
- g22_1.json#30 (lo scoglio) — tr[4] — সমুদ্রের পাথর / শৈলশিরা → সমুদ্রের পাথর / শিলাখণ্ড
- g22_1.json#35 (Il mare è calmo oggi.) — emoji — 🌊 → null
- g22_1.json#35 (Il mare è calmo oggi.) — tr[2] — اج سمندر ٹھنڈا ٹھار اے۔ → اج سمندر شانت اے۔
- g22_1.json#35 (Il mare è calmo oggi.) — exTr[2] — اج سمندر ٹھنڈا ٹھار اے، اسیں نہا سکدے آں۔ → اج سمندر شانت اے، اسیں نہا سکدے آں۔
- g22_2.json#1 (l'erba) — emoji — 🌱 → null
- g22_2.json#4 (il tronco) — emoji — 🪵 → null
- g22_2.json#10 (la siepe) — tr[5] — ගස් වැට → පඳුරු වැට / ජීවමාන වැට
- g22_2.json#10 (la siepe) — exTr[5] — වත්තේ මහත්තයා ගස් වැට කපනවා. → උයන්පල්ලා පඳුරු වැට කපනවා.
- g22_2.json#13 (l'ulivo) — emoji — 🫒 → null
- g22_2.json#16 (la vigna) — emoji — 🍇 → null
- g22_2.json#23 (l'annaffiatoio) — tr[1] — پانی دینے کا برتن / فوارہ → پودوں کو پانی دینے کا برتن
- g22_2.json#25 (le stelle) — emoji — ✨ → ⭐
- g22_2.json#27 (l'orizzonte) — expl[5] — අහස ගොඩබිමට හෝ මුහුදට ස්පර්ශ වෙනවා වගේ පේන දුර ඉර. → අහස ගොඩබිමට හෝ මුහුදට ස්පර්ශ වෙනවා වගේ පේන දුර රේඛාව.
- g22_2.json#29 (il buio) — emoji — 🌑 → null
- g22_2.json#29 (il buio) — exTr[5] — ශීත කාලයේ පහට කලින්ම අඳුරුයි. → ශීත කාලයේ පහ වෙද්දිම අඳුරු වෙලා.
- g22_2.json#30 (il raccolto) — emoji — 🧺 → null
- g22_2.json#31 (Che bel tramonto!) — tr[2] — کنا سوہنا سورج ڈبنا اے! → سورج ڈبن دا کنا سوہنا نظارہ اے!
- g22_2.json#31 (Che bel tramonto!) — tr[3] — ਕਿੰਨਾ ਸੋਹਣਾ ਸੂਰਜ ਡੁੱਬਣਾ! → ਸੂਰਜ ਡੁੱਬਣ ਦਾ ਕਿੰਨਾ ਸੋਹਣਾ ਨਜ਼ਾਰਾ!
- g22_2.json#31 (Che bel tramonto!) — exTr[2] — سمندر ویکھ: کنا سوہنا سورج ڈبنا اے! → سمندر ویکھ: سورج ڈبن دا کنا سوہنا نظارہ اے!
- g22_2.json#31 (Che bel tramonto!) — exTr[3] — ਸਮੁੰਦਰ ਵੇਖ: ਕਿੰਨਾ ਸੋਹਣਾ ਸੂਰਜ ਡੁੱਬਣਾ! → ਸਮੁੰਦਰ ਵੇਖ: ਸੂਰਜ ਡੁੱਬਣ ਦਾ ਕਿੰਨਾ ਸੋਹਣਾ ਨਜ਼ਾਰਾ!
- g22_2.json#33 (Guarda quante stelle!) — emoji — ✨ → 🌌
- g22_2.json#34 (Non calpestare l'erba.) — emoji — 🚫 → null
- g22_2.json#34 (Non calpestare l'erba.) — expl[7] — Panneau ou consigne dans les parcs. → Panneau dans les parcs : il ne faut pas marcher sur l'herbe.
- g22_2.json#34 (Non calpestare l'erba.) — expl[8] — Cartel o aviso en los parques. → Cartel en los parques: no hay que pisar el césped.
- g22_2.json#34 (Non calpestare l'erba.) — expl[9] — Letrero o aviso en los parques. → Letrero en los parques: no hay que pisar el pasto.
- g22_3.json#1 (il fuoco) — expl[2] — تتے لاٹ جیہڑے لکڑ یا گیس ساڑدے نیں تے چانن تے نگھ دیندے نیں۔ → تتیاں لاٹاں جیہڑیاں لکڑ یا گیس ساڑدیاں نیں تے چانن تے نگھ دیندیاں نیں۔
- g22_3.json#2 (l'incendio) — tr[1] — آگ لگنا / آتش زدگی → آتش زدگی / بڑی آگ
- g22_3.json#2 (l'incendio) — tr[2] — اگ لگنا → وڈی اگ
- g22_3.json#2 (l'incendio) — tr[3] — ਅੱਗ ਲੱਗਣਾ → ਵੱਡੀ ਅੱਗ / ਅਗਨੀਕਾਂਡ
- g22_3.json#3 (il fumo) — emoji — 💨 → null
- g22_3.json#7 (l'inquinamento) — emoji — 🏭 → null
- g22_3.json#8 (lo smog) — emoji — 🌫️ → null
- g22_3.json#17 (l'energia) — tr[4] — শক্তি / জ্বালানি → শক্তি / বিদ্যুৎ
- g22_3.json#20 (il riscaldamento globale) — emoji — 🌡️ → null
- g22_3.json#21 (l'acqua potabile) — expl[4] — পরিষ্কার নিরাপদ পানি; ইতালিতে কলের পানি সাধারণত এমন। → পান করার জন্য নিরাপদ পরিষ্কার পানি; ইতালিতে কলের পানি সাধারণত এমন।
- g22_3.json#21 (l'acqua potabile) — exTr[5] — මේ උල්පතේ තියෙන්නේ පානීය ජලය නෙවෙයි. → මේ පොදු වතුර කරාමයේ තියෙන්නේ බොන්න පුළුවන් වතුර නෙවෙයි.
- g22_3.json#29 (l'energia rinnovabile) — emoji — ☀️ → null
- g22_3.json#33 (Non sprecare l'acqua.) — emoji — 🚰 → null
- g22_3.json#34 (Oggi c'è molto smog.) — emoji — 🌫️ → null
- g22_3.json#34 (Oggi c'è molto smog.) — exTr[5] — අද දුම් මීදුම වැඩියි, දුවන්න යන්න එපා. → අද දුම් මීදුම වැඩියි, අපි දුවන්න නොයමු.
- g22_3.json#34 (Oggi c'è molto smog.) — exTr[8] — Hoy hay mucha contaminación, no vamos a correr. → Hoy hay mucha contaminación, mejor no salgamos a correr.
- g22_4.json#1 (innaffiare) — emoji — 💧 → null
- g22_4.json#3 (inquinare) — emoji — 🏭 → null
- g22_4.json#6 (coltivare) — emoji — 🧑‍🌾 → null
- g22_4.json#9 (proteggere) — emoji — 🛡️ → null
- g22_4.json#16 (raccogliere la frutta) — emoji — 🍎 → null
- g22_4.json#18 (il ruscello) — tr[3] — ਛੋਟੀ ਨਦੀ / ਨਾਲੀ → ਛੋਟੀ ਨਦੀ
- g22_4.json#18 (il ruscello) — tr[4] — ছোট নালা / ঝোরা → ছোট খাল / ছড়া
- g22_4.json#18 (il ruscello) — expl[2] — بہت نکا، ٹھنڈا دریا جیہدا پانی صاف ہووے۔ → بہت نکا، ہولی وگن والا دریا جیہدا پانی صاف ہووے۔
- g22_4.json#18 (il ruscello) — exTr[4] — বাড়ির কাছে একটা ছোট নালা বয়ে যায়। → বাড়ির কাছ দিয়ে একটা ছোট খাল বয়ে যায়।
- g22_4.json#19 (il ghiacciaio) — emoji — 🏔️ → null
- g22_4.json#19 (il ghiacciaio) — tr[2] — گلیشیئر / برفانی تودا → گلیشیئر
- g22_4.json#21 (l'oceano) — emoji — 🌊 → null
- g22_4.json#25 (la paglia) — exTr[1] — ٹوپی بھوسے سے بنی ہے۔ → ٹوپی تنکوں سے بنی ہے۔
- g22_4.json#25 (la paglia) — exTr[2] — ٹوپی توڑی دی بنی اے۔ → ٹوپی تیلیاں دی بنی اے۔
- g22_4.json#25 (la paglia) — exTr[3] — ਟੋਪੀ ਤੂੜੀ ਦੀ ਬਣੀ ਹੈ। → ਟੋਪੀ ਤੀਲਿਆਂ ਦੀ ਬਣੀ ਹੈ।
- g22_4.json#26 (la quercia) — emoji — 🌳 → null
- g22_4.json#26 (la quercia) — tr[1] — شاہ بلوط → بلوط کا درخت
- g22_4.json#26 (la quercia) — exTr[1] — ہم شاہ بلوط کے سائے میں آرام کرتے ہیں۔ → ہم بلوط کے درخت کے سائے میں آرام کرتے ہیں۔
- g22_4.json#27 (la pigna) — tr[1] — چیڑ کا پھل / صنوبر کا کون → چیڑ کا پھل
- g22_4.json#29 (l'agricoltura) — emoji — 🚜 → null
- g22_4.json#30 (il rastrello) — tr[1] — جھاڑنے کا پنجہ / ریک → پنجا / ریک
- g22_4.json#35 (Vietato accendere fuochi.) — emoji — 🚫 → null
- g22_4.json#38 (Mi piace stare all'aria aperta.) — emoji — 🌳 → null
