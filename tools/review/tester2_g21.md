# Tester 2 — g21 (animals)

Files: tools/dict_src/g21_1..4.json
Entries checked: 149 (every field: it, type, topic, emoji, tr, expl, ex, exTr in all 10 slots)
Entries removed: 0
Corrections: 47

Final validator: `python -I tools/check_dict.py tools/dict_src/g21_*.json`
→ `149 entries in 4 files, 0 errors`

Notes
- Italian headwords, articles (lo scoiattolo, lo squalo, lo zoo, l'ape, le corna), accents and example sentences were all correct. No Italian had to change.
- Emoji: only an exact animal is kept. Set to null: 🐾 for "pet" (it is a paw print, not an animal), 🐕/🐈 on the verbs abbaiare/miagolare, and 🦮 (guide dog) for "portare a spasso il cane". 🐾 stays on "la zampa", because it shows the paw itself.
- Wrong words fixed: Sinhala තාත්තා ("father") given for paw; Sinhala කූඩැල්ල ("leech") used for the camel's hump; Shahmukhi لال کیڑی ("red ant") given for ladybird; Urdu بگلا (heron) given for seagull; Urdu سیہ and Bengali শজারু (porcupine) given for hedgehog; Sinhala නයා (cobra) given for "snake" in general; Chinese 大黄蜂 (bumblebee) given for hornet.
- "la cimice": the example is about stink bugs coming into the house in autumn, but 6 slots translated it as bedbug. They now give the stink-bug word first and bedbug second.
- The parrot's «ciao» was written in other scripts in 5 example slots. It is now translated as "hello", like EN/FR/ES already were.
- Bengali was already Bangladesh usage (পানি, বাসা).

## Corrections (file#index — field — wrong → right)
- g21_1.json#0 (l'animale domestico) — emoji — 🐾 → null
- g21_1.json#5 (il pappagallo) — exTr[UR] — ہمارا طوطا «چاؤ» کہتا ہے۔ → ہمارا طوطا «ہیلو» کہتا ہے۔
- g21_1.json#5 (il pappagallo) — exTr[PS] — ساڈا طوطا «چاؤ» آکھدا اے۔ → ساڈا طوطا «ہیلو» آکھدا اے۔
- g21_1.json#5 (il pappagallo) — exTr[PA] — ਸਾਡਾ ਤੋਤਾ «ਚਾਓ» ਕਹਿੰਦਾ ਹੈ। → ਸਾਡਾ ਤੋਤਾ «ਹੈਲੋ» ਕਹਿੰਦਾ ਹੈ।
- g21_1.json#5 (il pappagallo) — exTr[BN] — আমাদের টিয়া পাখি «চাও» বলে। → আমাদের টিয়া পাখি «হ্যালো» বলে।
- g21_1.json#5 (il pappagallo) — exTr[SI] — අපේ ගිරවා «චාඕ» කියනවා. → අපේ ගිරවා «හලෝ» කියනවා.
- g21_1.json#16 (il gallo) — expl[EN] — The male chicken that sings in the morning. → The male chicken that crows in the morning.
- g21_1.json#27 (la stalla) — tr[PS] — تبیلا / کھُرلی → تبیلا / ڈنگراں دا واڑا
- g21_1.json#33 (il gabbiano) — tr[UR] — بگلا / سمندری پرندہ → سمندری بگلا
- g21_1.json#33 (il gabbiano) — exTr[UR] — سمندر پر بگلے کھانا چرا لیتے ہیں۔ → سمندر پر سمندری بگلے کھانا چرا لیتے ہیں۔
- g21_1.json#33 (il gabbiano) — exTr[PS] — سمندر تے بگلے کھانا چُرا لیندے نیں۔ → سمندر تے سمندری بگلے کھانا چُرا لیندے نیں۔
- g21_1.json#33 (il gabbiano) — exTr[PA] — ਸਮੁੰਦਰ ਤੇ ਪੰਛੀ ਖਾਣਾ ਚੁਰਾ ਲੈਂਦੇ ਹਨ। → ਸਮੁੰਦਰ ਤੇ ਸਮੁੰਦਰੀ ਪੰਛੀ ਖਾਣਾ ਚੁਰਾ ਲੈਂਦੇ ਹਨ।
- g21_1.json#34 (il gufo) — exTr[ES] — Por la noche oigo el búho. → Por la noche oigo al búho.
- g21_2.json#5 (la zebra) — exTr[PS] — پیدل لنگن والی لکیراں نوں «زیبرا» وی آکھدے نیں۔ → پیدل لنگن والیاں لکیراں نوں «زیبرا» وی آکھدے نیں۔
- g21_2.json#11 (il riccio) — tr[UR] — خارپشت / سیہ → خارپشت
- g21_2.json#11 (il riccio) — tr[BN] — শজারু → কাঁটাচুয়া
- g21_2.json#11 (il riccio) — exTr[BN] — সন্ধ্যায় একটা শজারু বাগান পার হয়। → সন্ধ্যায় একটা কাঁটাচুয়া বাগান পার হয়।
- g21_2.json#12 (il pipistrello) — exTr[ES] — El murciélago duerme boca abajo. → El murciélago duerme cabeza abajo.
- g21_2.json#13 (il serpente) — tr[SI] — සර්පයා / නයා → සර්පයා
- g21_2.json#17 (il cammello) — expl[SI] — පිටේ කූඩැල්ලක් ඇති, වතුර නැතුව බොහෝ කල් ඉන්න පුළුවන් කාන්තාර සතා. → පිටේ කුදයක් ඇති, වතුර නැතුව බොහෝ කල් ඉන්න පුළුවන් කාන්තාර සතා.
- g21_2.json#31 (il polpo) — expl[SI] — දිග අත් අටක් ඇති මෘදු මුහුදු සතා; ඉතාලියානුවෝ කනවත් කරනවා. → දිග අත් අටක් ඇති මෘදු මුහුදු සතා; ඉතාලියානුවෝ මෙය කෑමටත් ගන්නවා.
- g21_3.json#5 (il calabrone) — tr[ZH] — 大黄蜂 → 胡蜂 / 马蜂
- g21_3.json#5 (il calabrone) — expl[ZH] — 很大的黄蜂，蜇人很危险。 → 很大的胡蜂，蜇人很危险。
- g21_3.json#5 (il calabrone) — exTr[ZH] — 一只大黄蜂飞进了厨房。 → 一只马蜂飞进了厨房。
- g21_3.json#10 (la cimice) — tr[UR] — کھٹمل → بدبودار کیڑا / کھٹمل
- g21_3.json#10 (la cimice) — tr[PS] — کھٹمل → بدبو والا کیڑا / کھٹمل
- g21_3.json#10 (la cimice) — tr[PA] — ਖਟਮਲ → ਬਦਬੂਦਾਰ ਕੀੜਾ / ਖਟਮਲ
- g21_3.json#10 (la cimice) — tr[BN] — ছারপোকা → গান্ধি পোকা / ছারপোকা
- g21_3.json#10 (la cimice) — tr[SI] — මකුණා → ගඳ කෘමියා / මකුණා
- g21_3.json#10 (la cimice) — tr[ZH] — 臭虫 / 蝽 → 椿象 / 臭虫
- g21_3.json#10 (la cimice) — exTr[UR] — خزاں میں کھٹمل گھر میں آ جاتے ہیں۔ → خزاں میں بدبودار کیڑے گھر میں آ جاتے ہیں۔
- g21_3.json#10 (la cimice) — exTr[PS] — پت جھڑ وچ کھٹمل گھر وچ آ جاندے نیں۔ → پت جھڑ وچ بدبو والے کیڑے گھر وچ آ جاندے نیں۔
- g21_3.json#10 (la cimice) — exTr[PA] — ਪਤਝੜ ਵਿੱਚ ਖਟਮਲ ਘਰ ਵਿੱਚ ਆ ਜਾਂਦੇ ਹਨ। → ਪਤਝੜ ਵਿੱਚ ਬਦਬੂਦਾਰ ਕੀੜੇ ਘਰ ਵਿੱਚ ਆ ਜਾਂਦੇ ਹਨ।
- g21_3.json#10 (la cimice) — exTr[BN] — শরৎকালে ছারপোকা ঘরে ঢোকে। → শরৎকালে গান্ধি পোকা ঘরে ঢোকে।
- g21_3.json#10 (la cimice) — exTr[SI] — සරත් කාලයේ මකුණෝ ගෙදරට එනවා. → සරත් කාලයේ ගඳ කෘමීන් ගෙදරට එනවා.
- g21_3.json#10 (la cimice) — exTr[ZH] — 秋天臭虫会进到家里。 → 秋天椿象会进到家里。
- g21_3.json#15 (la coccinella) — tr[PS] — لال کیڑی → لال بھونڈی
- g21_3.json#15 (la coccinella) — exTr[PS] — میرے ہتھ تے اک لال کیڑی اے۔ → میرے ہتھ تے اک لال بھونڈی اے۔
- g21_3.json#19 (la zampa) — tr[SI] — පාදය / තාත්තා → පාදය / කකුල
- g21_3.json#26 (abbaiare) — emoji — 🐕 → null
- g21_3.json#27 (miagolare) — emoji — 🐈 → null
- g21_3.json#30 (graffiare) — tr[PS] — پنجا مارنا / گھروڑنا → پنجا مارنا / جھریٹنا
- g21_3.json#37 (innocuo) — exTr[SI] — බය වෙන්න එපා, මේ මකුළුවා හානියක් නෑ. → බය වෙන්න එපා, මේ මකුළුවාගෙන් හානියක් නෑ.
- g21_4.json#0 (il canile) — expl[SI] — නැති වූ හෝ අතහැර දැමූ බල්ලන් තියන තැන; එතනින් හදාගන්න ගන්න පුළුවන්. → නැති වූ හෝ අතහැර දැමූ බල්ලන් තියන තැන; එතනින් බල්ලෙක් හදාගන්න ගන්න පුළුවන්.
- g21_4.json#0 (il canile) — exTr[ES] — Hemos adoptado el perro en la protectora. → Hemos adoptado al perro en la protectora.
- g21_4.json#27 (portare a spasso il cane) — emoji — 🦮 → null
- g21_4.json#27 (portare a spasso il cane) — exTr[PS] — میں ہر شام کتے نوں سیر کرانداں آں۔ → میں ہر شام کتے نوں سیر کراندا آں۔
