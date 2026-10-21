# Tester 2 review — g15 (city) + g18 (jobs)

Files: tools/dict_src/g15_1..5.json, g18_1..4.json
Entries checked: 330 (every field: it, type, topic, emoji, tr[10], expl[10], ex, exTr[10]).
Entries after review: 327 (3 removed as duplicates).
Corrections: 70 (format: file#index — field — wrong → right; indices are the ORIGINAL indices, before the 3 removals).

Notes
- Sinhala: the pharmacy word was misspelled ඵාමසිය everywhere; corrected to ෆාමසිය.
- Sinhala expl contained Italian words in Latin script (now rejected by check_dict.py); transliterated into Sinhala script.
- Floors: Chinese/Bengali count the ground floor as 1, so Italian "terzo piano"/"primo piano" were shifted (四楼/চারতলায়, 二楼).
- Duplicates il parrucchiere / il barbiere / il fioraio existed in both g15 (shop) and g18 (person); the g15 copies were removed, the g18 jobs entries kept.
- File layout normalised to the compact one-field-per-line style used by the other groups.

Final validator: `python -I tools/check_dict.py tools/dict_src/g15_*.json tools/dict_src/g18_*.json` → 327 entries in 9 files, 0 errors

## Corrections
- g15_1.json#8 — tr[5] — රාත්‍රී සේවා ඵාමසිය → මුර සේවයේ ෆාමසිය
- g15_1.json#8 — expl[5] — මාරුවෙන් රාත්‍රියේ සහ නිවාඩු දිනවල විවෘත ඵාමසිය. → මාරුවෙන් රාත්‍රියේ සහ නිවාඩු දිනවල විවෘත ෆාමසිය.
- g15_1.json#8 — exTr[5] — රෑට හැමවෙලේම එක ඵාමසියක් විවෘතයි. → රෑට හැමවෙලේම එක ෆාමසියක් විවෘතයි.
- g15_3.json#14 — exTr[5] — ඵාමසිය වම් පැත්තේ. → ෆාමසිය වම් පැත්තේ.
- g15_3.json#23 — exTr[5] — කැෆේ එක බැංකුව සහ ඵාමසිය අතර. → කැෆේ එක බැංකුව සහ ෆාමසිය අතර.
- g15_4.json#13 — exTr[5] — ඵාමසියේ කොළ පාට පුවරුව හොයන්න. → ෆාමසියේ කොළ පාට පුවරුව හොයන්න.
- g15_4.json#29 — exTr[5] — ඵාමසියද? මෙතනම ළඟ, බැංකුවෙන් පස්සේ. → ෆාමසියද? මෙතනම ළඟ, බැංකුවෙන් පස්සේ.
- g15_5.json#4 — tr[5] — ඒක ඵාමසිය ළඟ. → ඒක ෆාමසිය ළඟ.
- g15_5.json#4 — expl[5] — හඳුනාගන්න ලකුණක් දෙන්න: ඒ තැන ඵාමසියට හරියටම ළඟ. → හඳුනාගන්න ලකුණක් දෙන්න: ඒ තැන ෆාමසියට හරියටම ළඟ.
- g15_5.json#4 — exTr[5] — පැට්‍රොනාටෝ එකද? ඵාමසිය ළඟ. → පැට්‍රොනාටෝ එකද? ෆාමසිය ළඟ.
- g15_1.json#6 — ex — "Devo spedire il kit all'ufficio postale." → "Devo spedire il kit dall'ufficio postale."
- g15_1.json#6 — exTr[0] — I have to send the kit at the post office. → I have to send the kit from the post office.
- g15_1.json#6 — exTr[7] — Je dois envoyer le kit au bureau de poste. → Je dois envoyer le kit depuis le bureau de poste.
- g15_1.json#6 — exTr[8] — Tengo que enviar el kit en la oficina de correos. → Tengo que enviar el kit desde la oficina de correos.
- g15_1.json#6 — exTr[9] — Tengo que mandar el kit en la oficina de correos. → Tengo que mandar el kit desde la oficina de correos.
- g15_1.json#26 — emoji — '🏡' → None
- g15_2.json#35 — expl[5] — ආයුධ, ඇණ, යතුරු, තීන්ත සහ ගෙදර අලුත්වැඩියා බඩු කඩය. → මෙවලම්, ඇණ, යතුරු, තීන්ත සහ ගෙදර අලුත්වැඩියා බඩු කඩය.
- g15_2.json#20 — exTr[6] — 我住在那栋楼的三楼。 → 我住在那栋楼的四楼。
- g15_2.json#20 — exTr[4] — আমি ওই ভবনের তিনতলায় থাকি। → আমি ওই ভবনের চারতলায় থাকি।
- g15_3.json#26 — exTr[8] — Hace frío, esperamos dentro. → Hace frío, esperemos dentro.
- g15_4.json#32 — tr[7] — Comment je vais à la gare ? → Comment aller à la gare ?
- g15_4.json#32 — exTr[7] — Comment je vais à la gare ? – Prenez le bus numéro 3. → Comment aller à la gare ? – Prenez le bus numéro 3.
- g15_5.json#7 — tr[7] — J'habite 10, rue de Rome. → J'habite au 10, via Roma.
- g15_5.json#7 — exTr[7] — J'habite 10, rue de Rome, au deuxième étage. → J'habite au 10, via Roma, au deuxième étage.
- g15_5.json#9 — exTr[7] — Vous avez dépassé la banque : revenez de cent mètres. → Vous avez dépassé la banque : revenez cent mètres en arrière.
- g15_5.json#17 — exTr[8] — ¿Puedo aparcar aquí? – No, está reservado a minusválidos. → ¿Puedo aparcar aquí? – No, está reservado a personas con discapacidad.
- g15_5.json#24 — emoji — '🚪' → None
- g15_5.json#30 — emoji — '↩️' → '⬅️'
- g18_1.json#21 — tr[7] — boulanger / fournier → boulanger
- g18_2.json#15 — exTr[8] — Por la tarde trabajo de repartidor en bici. → Por la noche trabajo de repartidor en bici.
- g18_3.json#12 — tr[9] — florista / florero → florista
- g18_3.json#13 — tr[9] — heladero / nevero → heladero
- g18_3.json#17 — tr[1] — لوہار → لوہار / تالے والا
- g18_3.json#17 — tr[2] — لوہار → لوہار / جندرے والا
- g18_3.json#17 — tr[3] — ਲੋਹਾਰ → ਲੋਹਾਰ / ਜਿੰਦਰੇ ਵਾਲਾ
- g18_3.json#17 — tr[4] — কামার → কামার / তালা মিস্ত্রি
- g18_3.json#17 — tr[5] — කම්මල්කරු → කම්මල්කරු / අගුළු කාර්මිකයා
- g18_3.json#17 — exTr[2] — میریاں چابیاں گواچ گئیاں، مینوں لوہار سدنا پوے گا۔ → میریاں چابیاں گواچ گئیاں، مینوں جندرے والا سدنا پوے گا۔
- g18_3.json#17 — exTr[3] — ਮੇਰੀਆਂ ਚਾਬੀਆਂ ਗੁਆਚ ਗਈਆਂ, ਮੈਨੂੰ ਲੋਹਾਰ ਬੁਲਾਉਣਾ ਪਵੇਗਾ। → ਮੇਰੀਆਂ ਚਾਬੀਆਂ ਗੁਆਚ ਗਈਆਂ, ਮੈਨੂੰ ਜਿੰਦਰੇ ਵਾਲਾ ਬੁਲਾਉਣਾ ਪਵੇਗਾ।
- g18_3.json#26 — tr[2] — نوٹری / اشٹام والا → نوٹری
- g18_4.json#5 — tr[7] — profession libérale / freelance → professionnel libéral / freelance
- g18_4.json#15 — exTr[6] — 一楼的退休老人很和善。 → 二楼的退休老人很和善。
- g18_4.json#21 — ex — 'Cercano operatori di call center che parlano arabo.' → 'Cercano operatori di call center che parlino arabo.'
- g15_2.json#10 — entry removed ('il barbiere', duplicate of the same headword in g18; kept the jobs entry)
- g15_2.json#9 — entry removed ('il parrucchiere', duplicate of the same headword in g18; kept the jobs entry)
- g15_4.json#8 — entry removed ('il fioraio', duplicate of the same headword in g18; kept the jobs entry)
- g15_3.json#15 — expl[5] — හැරෙන්නේ නැතිව ඉස්සරහට; 'diritto' කියලත් කියනවා. → හැරෙන්නේ නැතිව ඉස්සරහට; 'දිරිත්තෝ' කියලත් කියනවා.
- g15_3.json#16 — expl[5] — යමක් ඉදිරිපිට; 'davanti a' පස්සේ ස්ථානය. → යමක් ඉදිරිපිට; 'දාවන්ති අ' පස්සේ ස්ථානය.
- g15_3.json#17 — expl[5] — යමක පිටුපසින්; 'davanti' හි විරුද්ධ පදය. → යමක පිටුපසින්; 'දාවන්ති' හි විරුද්ධ පදය.
- g15_3.json#18 — expl[5] — යමක හරියටම පැත්තෙන්; 'accanto a' පස්සේ ස්ථානය. → යමක හරියටම පැත්තෙන්; 'අක්කාන්තෝ අ' පස්සේ ස්ථානය.
- g15_3.json#19 — expl[5] — ගොඩක් දුරින්; 'vicino' හි විරුද්ධ පදය. → ගොඩක් දුරින්; 'විචිනෝ' හි විරුද්ධ පදය.
- g15_3.json#22 — expl[5] — අනෙක් පැත්තේ, මුහුණට මුහුණ; 'di fronte a' පස්සේ ස්ථානය. → අනෙක් පැත්තේ, මුහුණට මුහුණ; 'දි ෆ්‍රොන්තේ අ' පස්සේ ස්ථානය.
- g15_3.json#23 — expl[5] — දේවල් දෙකක් මැද; කාලයත් එක්ක: 'විනාඩි 5කින්'. 'fra' කියලත්. → දේවල් දෙකක් මැද; කාලයත් එක්ක: 'විනාඩි 5කින්'. 'ෆ්‍රා' කියලත්.
- g15_3.json#24 — expl[5] — මම ඉන්න මේ තැන; 'qua' කියලත්. → මම ඉන්න මේ තැන; 'ක්වා' කියලත්.
- g15_3.json#28 — expl[5] — උස් තැනක් දිහාවට; 'vado su' = මම උඩට යනවා. → උස් තැනක් දිහාවට; 'වාදෝ සු' = මම උඩට යනවා.
- g15_3.json#29 — expl[5] — පහත් තැනක් දිහාවට; 'vado giù' = මම පහළට යනවා. → පහත් තැනක් දිහාවට; 'වාදෝ ජු' = මම පහළට යනවා.
- g15_3.json#30 — expl[5] — ස්ථානයක් ගැන අහන ප්‍රශ්න පදය; 'dov'è…?' = කොහෙද…? → ස්ථානයක් ගැන අහන ප්‍රශ්න පදය; 'දොවේ…?' = කොහෙද…?
- g15_3.json#31 — expl[5] — යමක් වටේ හැම තැනම; 'intorno a' පස්සේ ස්ථානය. → යමක් වටේ හැම තැනම; 'ඉන්තෝර්නෝ අ' පස්සේ ස්ථානය.
- g15_4.json#9 — expl[5] — පොත් මිලදී ගන්න කඩය; පුස්තකාලය 'biblioteca' කියනවා. → පොත් මිලදී ගන්න කඩය; පුස්තකාලය 'බිබ්ලියොතේකා' කියනවා.
- g15_4.json#15 — expl[5] — නගරයක හෝ පළාතක කොටසක්; 'in zona' = ළඟපාත. → නගරයක හෝ පළාතක කොටසක්; 'ඉන් ත්සෝනා' = ළඟපාත.
- g15_4.json#28 — expl[5] — ඔබ කොහෙද කියා නොදන්නකොට කියන්න; කාන්තාවක් 'Mi sono persa' කියයි. → ඔබ කොහෙද කියා නොදන්නකොට කියන්න; කාන්තාවක් 'මි සෝනෝ පේර්සා' කියයි.
- g15_4.json#30 — expl[5] — පයින් කොච්චර වෙලා යනවද කියන්න; 'in macchina' = වාහනයෙන්. → පයින් කොච්චර වෙලා යනවද කියන්න; 'ඉන් මක්කිනා' = වාහනයෙන්.
- g15_5.json#7 — expl[5] — ලිපිනය කියන විදිය: 'in via' + වීදියේ නම, ඊට පස්සේ අංකය. → ලිපිනය කියන විදිය: 'ඉන් විආ' + වීදියේ නම, ඊට පස්සේ අංකය.
- g15_5.json#12 — expl[5] — ඕනෑම තැනක් අරින වෙලාව අහන්න; 'il museo' වෙනස් කරන්න. → ඕනෑම තැනක් අරින වෙලාව අහන්න; 'ඉල් මුසේඕ' වෙනස් කරන්න.
- g15_5.json#14 — expl[5] — 'più vicino/a' = ළඟම; ඕනෑම තැනකට යොදන්න පුළුවන්. → 'පියු විචිනෝ/නා' = ළඟම; ඕනෑම තැනකට යොදන්න පුළුවන්.
- g15_5.json#16 — expl[5] — 'Quanto ci vuole?' = කොච්චර වෙලාවක් ඕනෙද. → 'ක්වාන්තෝ චි වුඕලේ?' = කොච්චර වෙලාවක් ඕනෙද.
- g15_5.json#20 — expl[5] — 'Dove si trova…?' = 'Dov'è…?' හි ටිකක් විධිමත් රූපය. → 'දෝවේ සි ත්‍රෝවා…?' = 'දොවේ…?' හි ටිකක් විධිමත් රූපය.
- g15_5.json#25 — expl[5] — මග අහන ඉතා ආචාරශීලී ක්‍රමය: 'Sa dove…?' = … කොහෙද කියලා දන්නවද? → මග අහන ඉතා ආචාරශීලී ක්‍රමය: 'සා දෝවේ…?' = … කොහෙද කියලා දන්නවද?
- g15_5.json#26 — expl[5] — 'Le indicazioni' = මග පෙන්වන පාරේ සලකුණු. → 'ලේ ඉන්දිකාත්සියෝනි' = මග පෙන්වන පාරේ සලකුණු.
- g15_5.json#30 — expl[5] — 'prossimo' = ඊළඟ; මග කියනකොට සහ බස් එකේ බහුලව යොදනවා. → 'ප්‍රොස්සිමෝ' = ඊළඟ; මග කියනකොට සහ බස් එකේ බහුලව යොදනවා.
