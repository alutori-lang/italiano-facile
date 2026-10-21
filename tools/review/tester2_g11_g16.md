# Tester 2 — g11 (shopping) + g16 (transport)

Files: tools/dict_src/g11_1..6.json, g16_1..5.json
Entries checked: 368 (every field: it, type, topic, emoji, 10 x tr, 10 x expl, ex, 10 x exTr)
Entries after review: 364 (4 duplicates inside this group removed)
Corrections: 69 (44 text/type/headword edits, 21 emoji → null, 4 removed entries)
Validator: `python -I tools/check_dict.py tools/dict_src/g11_*.json tools/dict_src/g16_*.json` → 364 entries in 11 files, 0 errors

Overall quality was good: Italian headwords, articles, accents and examples were correct, and the Spain/LatAm
Spanish split was consistent (coche/carro, conducir/manejar, billete/boleto, aparcar/estacionar). Fixes were mostly
emojis that show something else, Italian words transliterated into example translations (codice fiscale,
Motorizzazione), a few unnatural or wrong words (Sinhala "ජෝඩිය" = pair, "නැවැත්තුම" = halt for car park), Urdu
gender of سپر مارکیٹ, and five headwords duplicated between g11 and g16.

Indexes are the ones BEFORE the edit (entries after a removed one moved up by 1).
"il cambio" (gearbox, g16_3#26) clashed with "il cambio" (exchange, g11_3#11); it was renamed "il cambio
automatico" with new tr/expl so both stay. Quoted Italian forms in explanations (diretta, cancellata, Mi sono persa,
al pezzo) were left as they are, which the validator allows on purpose.

Format: "file#index (headword) — field[slot] — wrong → right" (slot: 0 en, 1 ur, 2 pa-Arab, 3 pa-Guru, 4 bn, 5 si, 6 zh, 7 fr, 8 es, 9 es-419)

## Removed entries (duplicates inside g11+g16)
- g11_2.json#36 — entry — 'la coda' → removed (duplicate)
- g16_1.json#28 — entry — "l'orario" → removed (duplicate)
- g16_2.json#12 — entry — 'la tabaccheria' → removed (duplicate)
- g16_2.json#21 — entry — 'il rimborso' → removed (duplicate)
  (kept: g16_2 la coda covers queue + traffic jam; g11_3 l'orario already has 'opening hours / timetable'; g11_1 la tabaccheria and g11_3 il rimborso already cover the transport use)

## Emoji (wrong or only 'close enough' picture → null)
- g11_1.json#27 (il macellaio) — emoji — '🔪' → None
- g11_1.json#35 (la vetrina) — emoji — '🪟' → None
- g11_2.json#5 (i surgelati) — emoji — '🧊' → None
- g11_2.json#6 (la gastronomia) — emoji — '🧀' → None
- g11_2.json#15 (la qualità) — emoji — '⭐' → None
- g11_2.json#16 (la data di scadenza) — emoji — '📅' → None
- g11_2.json#31 (il volantino) — emoji — '📰' → None
- g11_3.json#4 (il buono sconto) — emoji — '🎟️' → None
- g11_3.json#12 (la garanzia) — emoji — '📜' → None
- g11_4.json#8 (risparmiare) — emoji — '🐷' → None
- g11_4.json#17 (la consegna a domicilio) — emoji — '🏠' → None
- g11_6.json#13 (Quanto dura la garanzia?) — emoji — '📜' → None
- g16_1.json#27 (il ritardo) — emoji — '⏳' → None
- g16_2.json#1 (l'andata) — emoji — '➡️' → None
- g16_2.json#9 (la sala d'attesa) — emoji — '🪑' → None
- g16_2.json#20 (lo sciopero) — emoji — '✊' → None
- g16_2.json#28 (il traffico) — emoji — '🚗' → None
- g16_3.json#8 (la revisione) — emoji — '🔧' → None
- g16_4.json#33 (C'è molto traffico.) — emoji — '🚗' → None
- g16_5.json#18 (in orario) — emoji — '⏰' → None
- g16_5.json#30 (Oggi c'è sciopero dei mezzi.) — emoji — '✊' → None

## Text, type and headword corrections
- g11_1.json#3 (la panetteria) — tr[2] — 'بیکری / نان والی ہٹی' → 'بیکری'
- g11_1.json#7 (il discount) — tr[1] — 'سستا سپر مارکیٹ' → 'سستی سپر مارکیٹ'
- g11_1.json#8 (l'ipermercato) — tr[1] — 'بڑا سپر مارکیٹ' → 'بڑی سپر مارکیٹ'
- g11_1.json#8 (l'ipermercato) — exTr[1] — 'بڑا سپر مارکیٹ شہر سے باہر ہے۔' → 'بڑی سپر مارکیٹ شہر سے باہر ہے۔'
- g11_1.json#19 (la tabaccheria) — tr[1] — 'تمباکو کی دکان / ٹوباکی' → 'تمباکو کی دکان'
- g11_1.json#19 (la tabaccheria) — expl[1] — "'ٹی' والی دکان: سگریٹ، بس ٹکٹ، ٹکٹیں اور بل جمع کرانا۔" → "'ٹی' والی دکان: سگریٹ، بس ٹکٹ، ڈاک ٹکٹ اور بل جمع کرانا۔"
- g11_1.json#34 (la cassa automatica) — tr[2] — 'آپ والا کاؤنٹر' → 'سیلف چیک آؤٹ مشین'
- g11_1.json#34 (la cassa automatica) — exTr[2] — 'آپ والے کاؤنٹر تے لین نہیں اے۔' → 'سیلف چیک آؤٹ مشین تے لین نہیں اے۔'
- g11_2.json#10 (il barattolo) — tr[1] — 'مرتبان / بوتل' → 'مرتبان / جار'
- g11_2.json#10 (il barattolo) — tr[5] — 'භාජනය / ජෝඩිය' → 'වීදුරු භාජනය / ජාඩිය'
- g11_2.json#20 (il mezzo chilo) — exTr[5] — 'මට මස් ඇඹරුම් කිලෝ භාගයක් ඕනේ.' → 'මට ඇඹරූ මස් කිලෝ භාගයක් ඕනේ.'
- g11_3.json#9 (la fattura) — exTr[1] — 'کیا مجھے میرے کوڈ فیسکالے کے ساتھ بل مل سکتا ہے؟' → 'کیا مجھے میرے ٹیکس کوڈ کے ساتھ بل مل سکتا ہے؟'
- g11_3.json#9 (la fattura) — exTr[2] — 'کی مینوں میرے کوڈ فیسکالے نال بل مل سکدا اے؟' → 'کی مینوں میرے ٹیکس کوڈ نال بل مل سکدا اے؟'
- g11_3.json#9 (la fattura) — exTr[3] — 'ਕੀ ਮੈਨੂੰ ਮੇਰੇ ਕੋਡ ਫ਼ਿਸਕਾਲੇ ਨਾਲ ਬਿੱਲ ਮਿਲ ਸਕਦਾ ਹੈ?' → 'ਕੀ ਮੈਨੂੰ ਮੇਰੇ ਟੈਕਸ ਕੋਡ ਨਾਲ ਬਿੱਲ ਮਿਲ ਸਕਦਾ ਹੈ?'
- g11_3.json#9 (la fattura) — exTr[4] — 'আমার কোদিচে ফিসকালে দিয়ে ইনভয়েস পেতে পারি?' → 'আমার ট্যাক্স কোড দিয়ে ইনভয়েস পেতে পারি?'
- g11_3.json#15 (gli spiccioli) — exTr[9] — '¿Tiene cambio / feria?' → '¿Tiene cambio?'
- g11_3.json#36 (a metà prezzo) — type — 'a' → 'p'
- g11_3.json#36 (a metà prezzo) — exTr[2] — 'شامی روٹی ادھے مُل تے ہوندی اے۔' → 'شام نوں روٹی ادھے مُل تے ہوندی اے۔'
- g11_4.json#19 (la spedizione) — tr[5] — 'නැව්ගත කිරීම / යැවීම' → 'යැවීම / බඩු යැවීම'
- g11_5.json#18 (Posso avere lo scontrino?) — exTr[1] — 'کیا مجھے رسید مل سکتی ہے، مہربانی؟' → 'براہ مہربانی، کیا مجھے رسید مل سکتی ہے؟'
- g11_5.json#18 (Posso avere lo scontrino?) — exTr[2] — 'کی مینوں رسید مل سکدی اے، مہربانی؟' → 'مہربانی کر کے، کی مینوں رسید مل سکدی اے؟'
- g11_6.json#8 (Tocca a me?) — tr[4] — 'আমার পালা কি?' → 'এখন কি আমার পালা?'
- g16_1.json#11 (il furgone) — exTr[5] — 'සමාගමේ වෑන් එක වාහන නැවැත්තුමේ තියෙනවා.' → 'සමාගමේ වෑන් එක වාහන නවත්වන තැන තියෙනවා.'
- g16_2.json#2 (il ritorno) — exTr[2] — 'واپسی اتوار دی شام نوں اے۔' → 'واپسی ایتوار دی شام نوں اے۔'
- g16_3.json#1 (la conversione della patente) — exTr[1] — 'لائسنس کی تبدیلی کے لیے میں موٹرائزیشن دفتر جاتا ہوں۔' → 'لائسنس کی تبدیلی کے لیے میں گاڑیوں کے سرکاری دفتر جاتا ہوں۔'
- g16_3.json#1 (la conversione della patente) — exTr[2] — 'لائسنس بدلوان لئی میں موٹرائزیشن دفتر جانا واں۔' → 'لائسنس بدلوان لئی میں گڈیاں دے سرکاری دفتر جانا واں۔'
- g16_3.json#1 (la conversione della patente) — exTr[3] — 'ਲਾਇਸੈਂਸ ਬਦਲਵਾਉਣ ਲਈ ਮੈਂ ਮੋਟਰਾਈਜ਼ੇਸ਼ਨ ਦਫ਼ਤਰ ਜਾਂਦਾ ਹਾਂ।' → 'ਲਾਇਸੈਂਸ ਬਦਲਵਾਉਣ ਲਈ ਮੈਂ ਗੱਡੀਆਂ ਦੇ ਸਰਕਾਰੀ ਦਫ਼ਤਰ ਜਾਂਦਾ ਹਾਂ।'
- g16_3.json#1 (la conversione della patente) — exTr[4] — 'লাইসেন্স রূপান্তরের জন্য আমি মোটরাইজেশন অফিসে যাই।' → 'লাইসেন্স রূপান্তরের জন্য আমি মোটরযান অফিসে যাই।'
- g16_3.json#1 (la conversione della patente) — exTr[7] — 'Pour la conversion du permis, je vais à la préfecture des véhicules.' → 'Pour la conversion du permis, je vais au service des permis de conduire.'
- g16_3.json#26 (il cambio automatico) — it — 'il cambio' → 'il cambio automatico'
- g16_3.json#26 (il cambio automatico) — tr — ['gearbox / gear stick', 'گیئر', 'گیئر', 'ਗੇਅਰ', 'গিয়ার', 'ගියර් පෙට්ටිය', '变速箱 / 挡位', 'boîte de vitesses', 'cambio de marchas', 'palanca de velocidades'] → ['automatic gearbox', 'آٹومیٹک گیئر', 'آٹومیٹک گیئر', 'ਆਟੋਮੈਟਿਕ ਗੇਅਰ', 'অটোমেটিক গিয়ার', 'ඔටෝ ගියර්', '自动挡', 'boîte automatique', 'cambio automático', 'transmisión automática']
- g16_3.json#26 (il cambio automatico) — expl — ['Lever to change gears; a car can be manual or automatic.', 'گیئر بدلنے کا لیور؛ گاڑی دستی یا آٹومیٹک ہو سکتی ہے۔', 'گیئر بدلن دا لیور؛ گڈی ہتھ والی یا آٹومیٹک ہو سکدی اے۔', 'ਗੇਅਰ ਬਦਲਣ ਦਾ ਲੀਵਰ; ਗੱਡੀ ਹੱਥ ਵਾਲੀ ਜਾਂ ਆਟੋਮੈਟਿਕ ਹੋ ਸਕਦੀ ਹੈ।', 'গিয়ার বদলানোর লিভার; গাড়ি ম্যানুয়াল বা অটোমেটিক হতে পারে।', 'ගියර් මාරු කරන ලීවරය; වාහනය මැනුවල් හෝ ඔටෝ විය හැක.', '换挡的杆，车可以是手动挡或自动挡。', 'Levier pour changer de vitesse ; une voiture peut être manuelle ou automatique.', 'Palanca para cambiar de marcha; el coche puede ser manual o automático.', 'Palanca para cambiar de velocidad; el carro puede ser estándar o automático.'] → ['Gearbox that changes gears by itself, with no clutch pedal.', 'ایسا گیئر سسٹم جو خود گیئر بدلتا ہے، کلچ پیڈل کے بغیر۔', 'اجیہا گیئر جیہڑا آپے گیئر بدلدا اے، کلچ پیڈل توں بغیر۔', 'ਅਜਿਹਾ ਗੇਅਰ ਜੋ ਆਪੇ ਗੇਅਰ ਬਦਲਦਾ ਹੈ, ਕਲੱਚ ਪੈਡਲ ਤੋਂ ਬਿਨਾਂ।', 'যে গিয়ার নিজে নিজে বদলায়, ক্লাচ প্যাডেল লাগে না।', 'ක්ලච් පැඩලයක් නැතිව, තනියම ගියර් මාරු වන ගියර් පද්ධතිය.', '自己换挡的变速箱，没有离合器踏板。', "Boîte de vitesses qui change de vitesse toute seule, sans pédale d'embrayage.", 'Cambio que pone las marchas solo, sin pedal de embrague.', 'Transmisión que cambia las velocidades sola, sin pedal de clutch.']
- g16_3.json#28 (la retromarcia) — exTr[5] — 'වාහන නැවැත්තුමෙන් එළියට එන්න පස්සට ගියර් එක දාන්න.' → 'පාකින් එකෙන් එළියට එන්න පස්සට ගියර් එක දාන්න.'
- g16_3.json#32 (Devo convertire la patente.) — expl[1] — 'عمل شروع کرنے کے لیے ڈرائیونگ اسکول یا موٹرائزیشن دفتر میں کہیں۔' → 'عمل شروع کرنے کے لیے ڈرائیونگ اسکول یا گاڑیوں کے سرکاری دفتر میں کہیں۔'
- g16_3.json#32 (Devo convertire la patente.) — expl[2] — 'کم شروع کرن لئی ڈرائیونگ سکول یا موٹرائزیشن دفتر وچ آکھو۔' → 'کم شروع کرن لئی ڈرائیونگ سکول یا گڈیاں دے سرکاری دفتر وچ آکھو۔'
- g16_3.json#32 (Devo convertire la patente.) — expl[3] — 'ਕੰਮ ਸ਼ੁਰੂ ਕਰਨ ਲਈ ਡਰਾਈਵਿੰਗ ਸਕੂਲ ਜਾਂ ਮੋਟਰਾਈਜ਼ੇਸ਼ਨ ਦਫ਼ਤਰ ਵਿੱਚ ਕਹੋ।' → 'ਕੰਮ ਸ਼ੁਰੂ ਕਰਨ ਲਈ ਡਰਾਈਵਿੰਗ ਸਕੂਲ ਜਾਂ ਗੱਡੀਆਂ ਦੇ ਸਰਕਾਰੀ ਦਫ਼ਤਰ ਵਿੱਚ ਕਹੋ।'
- g16_3.json#32 (Devo convertire la patente.) — expl[4] — 'প্রক্রিয়া শুরু করতে ড্রাইভিং স্কুল বা মোটরাইজেশন অফিসে বলুন।' → 'প্রক্রিয়া শুরু করতে ড্রাইভিং স্কুল বা মোটরযান অফিসে বলুন।'
- g16_4.json#8 (il parcheggio) — tr[5] — 'වාහන නැවැත්තුම' → 'වාහන නැවැත්වීමේ ස්ථානය / පාකින් එක'
- g16_4.json#8 (il parcheggio) — exTr[5] — 'රෝහලේ වාහන නැවැත්තුමට ගෙවන්න ඕනේ.' → 'රෝහලේ පාකින් එකට ගෙවන්න ඕනේ.'
- g16_4.json#17 (il vigile) — tr[6] — '交警 / 城管警察' → '交警 / 市政警察'
- g16_4.json#27 (Ho avuto un incidente.) — exTr[8] — 'Diga, he tenido un accidente en la circunvalación.' → 'Hola, he tenido un accidente en la circunvalación.'
- g16_4.json#30 (Dov'è il parcheggio?) — tr[5] — 'වාහන නැවැත්තුම කොහෙද?' → 'පාකින් එක කොහෙද?'
- g16_4.json#30 (Dov'è il parcheggio?) — exTr[5] — 'සමාවෙන්න, රෝහලේ වාහන නැවැත්තුම කොහෙද?' → 'සමාවෙන්න, රෝහලේ පාකින් එක කොහෙද?'
- g16_5.json#27 (Ogni quanto passa l'autobus?) — exTr[2] — 'اتوار نوں بس کِنی دیر بعد آندی اے؟' → 'ایتوار نوں بس کِنی دیر بعد آندی اے؟'
