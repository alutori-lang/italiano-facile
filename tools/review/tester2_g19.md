# Tester 2 — g19 (offices & immigration documents)

Files: tools/dict_src/g19_1..6.json
Entries checked: 220 (every field: it, type, topic, emoji, 10 x tr, 10 x expl, ex, 10 x exTr)
Entries removed: 0
Corrections: 64 (29 emoji, 35 text fields)
Validator: `python -I tools/check_dict.py tools/dict_src/g19_*.json` → 220 entries in 6 files, 0 errors

Overall the group is in good shape. The Italian headwords are the official terms, with correct articles, accents and phrase punctuation.
Types and topics are right, and the legal content is accurate: the kit postale, the 4 fototessere, the A2 test for the long-term permit, the 10 years for citizenship, the 250 euro contributo, the contratto di soggiorno within 8 days, NASpI within 68 days, assegno unico under 21, ISEE, CIE about 22 euro, and the CAF / patronato roles.
The fixes are mostly emojis that showed the wrong thing, plus a few wrong words or wrong facts.

Indexes are 0-based and unchanged (no entries were removed).

## Content / legal accuracy
- g19_1#36: the renewal note said "you can apply up to 60 days before expiry". The law (art. 5 TU Immigrazione) asks you to apply at least about 60 days before, so all 10 expl were rewritten to "apply about 60 days before the expiry date".
- g19_1#6: in UR, Shahmukhi and Gurmukhi the expl said the permit was for people with "income and family members" (گھر والوں / ਘਰ ਵਾਲਿਆਂ). The requirement is housing (رہائش / ਰਿਹਾਇਸ਼).

## Emoji (wrong or misleading picture → null, or the exact one)
- g19_1#15 (il giuramento) — emoji — 🤚 → null
- g19_1#20 (la fototessera) — emoji — 🧑 → null
- g19_1#21 (le impronte digitali) — emoji — ☝️ → null
- g19_2#1 (la traduzione giurata) — emoji — 🌐 → null
- g19_2#2 (la legalizzazione) — emoji — 🔏 → null
- g19_2#3 (l'apostille) — emoji — 🔏 → null
- g19_2#5 (l'Agenzia delle Entrate) — emoji — 💶 → null
- g19_2#6 (il CAF) — emoji — 🧮 → null
- g19_2#7 (il patronato) — emoji — 🤝 → null
- g19_3#3 (timbrare) — emoji — 🔏 → null
- g19_3#4 (il timbro) — emoji — 🔏 → null
- g19_3#7 (la fila) — emoji — 🧍 → null
- g19_3#21 (il CAP) — emoji — 📮 → null
- g19_3#27 (il reddito) — emoji — 💵 → 💶
- g19_3#30 (Dove compro la marca da bollo?) — emoji — 🏷️ → null
- g19_4#8 (il rifugiato) — emoji — 🛡️ → null
- g19_4#22 (rilasciare) — emoji — 📤 → null
- g19_4#25 (il certificato penale) — emoji — 📜 → null
- g19_4#32 (Posso delegare qualcuno?) — emoji — 🤝 → null
- g19_4#36 (Serve la traduzione giurata?) — emoji — 🌐 → null
- g19_5#9 (il traduttore) — emoji — 🌐 → null
- g19_6#2 (delegare) — emoji — 🤝 → null
- g19_6#7 (il francobollo) — emoji — 📮 → null
- g19_6#9 (l'esito) — emoji — 📬 → null
- g19_6#10 (il rilascio) — emoji — 🆗 → null
- g19_6#11 (la proroga) — emoji — ➕ → null
- g19_6#13 (il soggiorno) — emoji — 🏠 → null
- g19_6#27 (C'è molta fila oggi.) — emoji — 🧍 → null
- g19_6#28 (Vorrei disdire l'appuntamento.) — emoji — 📵 → null

## Text corrections
- g19_1#6 (il permesso di soggiorno UE per soggiornanti di lungo periodo) — expl[1] UR — بغیر میعاد کا پرمیسو، اٹلی میں 5 سال، آمدنی اور گھر والوں کے لیے۔ → بغیر میعاد کا پرمیسو، اٹلی میں 5 سال رہنے والوں کے لیے جن کی آمدنی اور رہائش ہو۔
- g19_1#6 (il permesso di soggiorno UE per soggiornanti di lungo periodo) — expl[2] PA-Shahmukhi — بنا مدت والا پرمیسو، اٹلی وچ 5 سال، کمائی تے گھر والیاں لئی۔ → بنا مدت والا پرمیسو، اٹلی وچ 5 سال رہن والیاں لئی جنہاں دی کمائی تے رہائش ہووے۔
- g19_1#6 (il permesso di soggiorno UE per soggiornanti di lungo periodo) — expl[3] PA-Gurmukhi — ਬਿਨਾਂ ਮਿਆਦ ਦਾ ਪਰਮਿਟ, ਇਟਲੀ ਵਿੱਚ 5 ਸਾਲ, ਆਮਦਨ ਅਤੇ ਘਰ ਵਾਲਿਆਂ ਲਈ। → ਬਿਨਾਂ ਮਿਆਦ ਦਾ ਪਰਮਿਟ, ਇਟਲੀ ਵਿੱਚ 5 ਸਾਲ ਰਹਿਣ ਵਾਲਿਆਂ ਲਈ ਜਿਨ੍ਹਾਂ ਦੀ ਆਮਦਨ ਅਤੇ ਰਿਹਾਇਸ਼ ਹੋਵੇ।
- g19_1#15 (il giuramento) — ex — Il giuramento è in comune venerdì. → Il giuramento è venerdì in comune.
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[0] EN — Time to start the renewal: you can apply up to 60 days before expiry. → Time to renew: you should apply about 60 days before the expiry date.
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[1] UR — تجدید شروع کرنے کا وقت: میعاد سے 60 دن پہلے تک درخواست دے سکتے ہیں۔ → تجدید کا وقت: میعاد ختم ہونے سے تقریباً 60 دن پہلے درخواست دینی چاہیے۔
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[2] PA-Shahmukhi — تجدید شروع کرن دا ویلا: مدت توں 60 دن پہلاں تک درخواست دے سکدے او۔ → تجدید دا ویلا: مدت مکن توں لگ بھگ 60 دن پہلاں درخواست دینی چاہیدی اے۔
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[3] PA-Gurmukhi — ਨਵੀਨੀਕਰਨ ਸ਼ੁਰੂ ਕਰਨ ਦਾ ਸਮਾਂ: ਮਿਆਦ ਤੋਂ 60 ਦਿਨ ਪਹਿਲਾਂ ਅਰਜ਼ੀ ਦੇ ਸਕਦੇ ਹੋ। → ਨਵੀਨੀਕਰਨ ਦਾ ਸਮਾਂ: ਮਿਆਦ ਖ਼ਤਮ ਹੋਣ ਤੋਂ ਲਗਭਗ 60 ਦਿਨ ਪਹਿਲਾਂ ਅਰਜ਼ੀ ਦੇਣੀ ਚਾਹੀਦੀ ਹੈ।
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[4] BN — নবায়ন শুরুর সময়: মেয়াদ শেষের ৬০ দিন আগে থেকেই আবেদন করা যায়। → নবায়নের সময়: মেয়াদ শেষের প্রায় ৬০ দিন আগে আবেদন করা উচিত।
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[5] SI — අලුත් කිරීම පටන් ගන්න කාලයයි: කල් ඉකුත්වීමට දින 60කට පෙර සිට ඉල්ලිය හැක. → අලුත් කිරීමේ කාලයයි: කල් ඉකුත්වීමට දින 60කට පමණ පෙර ඉල්ලිය යුතුයි.
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[6] ZH — 该开始续签了：到期前60天就可以申请。 → 该续签了：应在到期前约60天申请。
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[7] FR — Il faut commencer le renouvellement : on peut demander 60 jours avant. → C'est le moment du renouvellement : il faut le demander environ 60 jours avant.
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[8] ES-ES — Hay que empezar la renovación: se puede pedir 60 días antes. → Toca renovar: hay que pedirlo unos 60 días antes de que caduque.
- g19_1#36 (Il permesso scade il mese prossimo.) — expl[9] ES-LA — Hay que empezar la renovación: se puede pedir 60 días antes. → Toca renovar: hay que pedirlo unos 60 días antes del vencimiento.
- g19_2#4 (l'anagrafe) — tr[1] UR — رجسٹری دفتر (انگرافے) → رجسٹری دفتر (اناگرافے)
- g19_2#4 (l'anagrafe) — tr[2] PA-Shahmukhi — رجسٹری دفتر (انگرافے) → رجسٹری دفتر (اناگرافے)
- g19_2#34 (Manca un documento.) — expl[1] UR — کلرک اکثر یہ کہتا ہے: آپ کو کم والا کاغذ لانا ہوگا۔ → کلرک اکثر یہ کہتا ہے: آپ کو رہ جانے والا کاغذ لانا ہوگا۔
- g19_2#34 (Manca un documento.) — expl[2] PA-Shahmukhi — کلرک اکثر ایہہ آکھدا اے: تہانوں گھٹ والا کاغذ لیانا پوے گا۔ → کلرک اکثر ایہہ آکھدا اے: تہانوں رہ گیا کاغذ لیانا پوے گا۔
- g19_2#34 (Manca un documento.) — expl[3] PA-Gurmukhi — ਕਲਰਕ ਅਕਸਰ ਇਹ ਕਹਿੰਦਾ ਹੈ: ਤੁਹਾਨੂੰ ਘੱਟ ਵਾਲਾ ਕਾਗਜ਼ ਲਿਆਉਣਾ ਪਵੇਗਾ। → ਕਲਰਕ ਅਕਸਰ ਇਹ ਕਹਿੰਦਾ ਹੈ: ਤੁਹਾਨੂੰ ਰਹਿ ਗਿਆ ਕਾਗਜ਼ ਲਿਆਉਣਾ ਪਵੇਗਾ।
- g19_3#13 (la nazionalità) — exTr[5] SI — ජාතිකත්වය: පාකිස්තාන. → ජාතිකත්වය: පාකිස්තාන ජාතික.
- g19_3#22 (il bollettino postale) — tr[8] ES-ES — giro postal / boleto de pago → impreso de pago de Correos
- g19_3#22 (il bollettino postale) — exTr[0] EN — In the kit there is the payment slip to pay. → The kit contains the postal payment slip to pay.
- g19_3#22 (il bollettino postale) — exTr[8] ES-ES — En el kit está el boleto de pago de Correos. → En el kit está el impreso de pago de Correos.
- g19_4#0 (l'ufficio postale) — exTr[0] EN — I send the kit at the post office. → I send the kit from the post office.
- g19_4#0 (l'ufficio postale) — exTr[8] ES-ES — Envío el kit en la oficina de Correos. → Envío el kit desde la oficina de Correos.
- g19_4#0 (l'ufficio postale) — exTr[9] ES-LA — Envío el kit en la oficina de correos. → Envío el kit desde la oficina de correos.
- g19_4#25 (il certificato penale) — exTr[6] ZH — 我国家开的无犯罪记录证明必须认证。 → 我本国开的无犯罪记录证明必须认证。
- g19_4#30 (Come si fa lo SPID?) — expl[7] FR — Il faut une pièce d'identité, la carte vitale, un téléphone et un e-mail ; la poste le fait. → Il faut une pièce d'identité, la carte sanitaire, un téléphone et un e-mail ; la poste le fait.
- g19_5#1 (il duplicato) — exTr[7] FR — J'ai demandé le duplicata de la carte vitale. → J'ai demandé le duplicata de la carte sanitaire.
- g19_5#20 (il cognome) — tr[1] UR — خاندانی نام / ذات → خاندانی نام
- g19_5#20 (il cognome) — tr[2] PA-Shahmukhi — گوت / ذات → خاندانی ناں
- g19_5#20 (il cognome) — exTr[2] PA-Shahmukhi — پہلاں گوت لکھو، فیر اپنا ناں۔ → پہلاں خاندانی ناں لکھو، فیر اپنا ناں۔
- g19_6#33 (Ho bisogno della dichiarazione di ospitalità.) — exTr[1] UR — رہائش کے لیے مجھے اعلان نامہ چاہیے۔ → رہائش کے اندراج کے لیے مجھے رہائش دینے کا اعلان نامہ چاہیے۔
- g19_6#33 (Ho bisogno della dichiarazione di ospitalità.) — exTr[2] PA-Shahmukhi — رہائش لئی مینوں اعلان نامہ چاہیدا اے۔ → رہائش دے اندراج لئی مینوں رہائش دین دا اعلان نامہ چاہیدا اے۔
- g19_6#33 (Ho bisogno della dichiarazione di ospitalità.) — exTr[3] PA-Gurmukhi — ਰਿਹਾਇਸ਼ ਲਈ ਮੈਨੂੰ ਐਲਾਨਨਾਮਾ ਚਾਹੀਦਾ ਹੈ। → ਰਿਹਾਇਸ਼ ਦੇ ਇੰਦਰਾਜ ਲਈ ਮੈਨੂੰ ਰਿਹਾਇਸ਼ ਦੇਣ ਦਾ ਐਲਾਨਨਾਮਾ ਚਾਹੀਦਾ ਹੈ।
