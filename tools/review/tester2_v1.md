# Tester 2 review — v1_*.json (verbs A–D + verb expressions)

Entries checked: 140 (v1_1: 25, v1_2: 25, v1_3: 31, v1_4: 18, v1_5: 41). For every entry I read the headword, type, emoji, all 10 tr slots, all 10 expl, the example and all 10 exTr.

No entry was wrong beyond repair, so none were removed. Every Italian headword (infinitive and -rsi forms), accent and example sentence was correct.

Corrections: 43

Main kinds of fixes:
- Emoji that did not show the action set to null: 🪴 annaffiare, 💦 bagnare, 🚪 bussare, 💬 consigliare, ⏩ continuare, 😵‍💫 confondere, 🤢 avere mal di pancia, ⚠️ dare la precedenza.
- Shahmukhi words that read as a different word: کھلونا ("toy"), مکان ("house"), پینا ("to drink"), بہت ہونا ("to be a lot"), ودھائی ("congratulations"), جوڑیاں ("couples").
- Italian quoted inside expl put into lower case, e.g. «mi chiamo Ali», «desidera?», «dipende!», «mi dispiace», «va bene!».
- Chinese: 打卡 ("clock in") → 打票; 搭车 (to get a lift, not give one) → 顺路送 / 捎一程.
- Gurmukhi spelling ਭਿਉਂਣਾ → ਭਿਉਣਾ; ਜ਼ਰੂਰੀ ਕਰਨਾ ("make compulsory") → ਜ਼ਰੂਰੀ ਹੋਣਾ.
- Example translations that were unnatural or left out part of the meaning (Urdu/Shahmukhi/Gurmukhi distrarsi, Sinhala cliccare and ISEE, French attaccare, LatAm chiamare).

## Corrections (file#index — field — wrong → right)

- v1_1.json#13 — expl[2] — سویرے منجی چھڈنا یا کرسی توں کھلونا۔ → سویرے منجی چھڈنا یا کرسی توں کھڑے ہونا۔
- v1_1.json#14 — emoji — 🪴 → null
- v1_1.json#9 — exTr[2] — مینوں کمیٹی دے دفتر وچ اپنا پتا بدلوانا اے۔ → مینوں کمیٹی دے دفتر وچ اپنا پتا اپ ڈیٹ کرانا اے۔
- v1_1.json#19 — exTr[7] — Je colle la photo sur le formulaire. → Je colle la photo sur le formulaire avec de la colle.
- v1_2.json#1 — emoji — 💦 → null
- v1_2.json#1 — tr[3] — ਗਿੱਲਾ ਕਰਨਾ / ਭਿਉਂਣਾ → ਗਿੱਲਾ ਕਰਨਾ / ਭਿਉਣਾ
- v1_2.json#2 — tr[2] — بہت ہونا / پورا ہونا → کافی ہونا / پورا ہونا
- v1_2.json#7 — emoji — 🚪 → null
- v1_2.json#11 — exTr[9] — Mañana le llamo al doctor. → Mañana llamo al doctor.
- v1_2.json#14 — expl[2] — کسے کم دا پہلا حصہ کرنا؛ مکان دا اُلٹ۔ → کسے کم دا پہلا حصہ کرنا؛ مکاؤن دا اُلٹ۔
- v1_2.json#19 — emoji — 💬 → null
- v1_2.json#21 — exTr[2] — جیویں ای کاغذ آ گئے میں تہانوں رابطہ کراں گا۔ → جیویں ای کاغذ آ گئے میں تہاڈے نال رابطہ کراں گا۔
- v1_2.json#22 — emoji — ⏩ → null
- v1_2.json#12 — expl[0] — used to say your name: «Mi chiamo Ali». → used to say your name: «mi chiamo Ali».
- v1_2.json#12 — expl[7] — sert à dire son nom : « Mi chiamo Ali ». → sert à dire son nom : « mi chiamo Ali ».
- v1_2.json#12 — expl[8] — sirve para decir tu nombre: «Mi chiamo Ali». → sirve para decir tu nombre: «mi chiamo Ali».
- v1_2.json#12 — expl[9] — sirve para decir tu nombre: «Mi chiamo Ali». → sirve para decir tu nombre: «mi chiamo Ali».
- v1_3.json#2 — exTr[0] — I click on Send and the form goes. → I click on “Send” and the form is sent.
- v1_3.json#2 — exTr[5] — මම යවන්න ඔබනවා, ෆෝම් එක යනවා. → මම «යවන්න» ක්ලික් කරනවා, ෆෝම් එක යනවා.
- v1_3.json#4 — tr[7] — avoir (ans) / fêter ses → avoir (… ans)
- v1_3.json#6 — emoji — 😵‍💫 → null
- v1_3.json#6 — exTr[2] — میں ہمیشہ دوواں جوڑیاں دے ناں رلا دیندا آں۔ → میں ہمیشہ دوواں جوڑے بچیاں دے ناں رلا دیندا آں۔
- v1_3.json#7 — tr[6] — 验票 / 打卡 → 验票 / 打票
- v1_3.json#13 — expl[0] — to want something very much; shop staff say «Desidera?». → to want something very much; shop staff say «desidera?».
- v1_3.json#13 — expl[7] — vouloir beaucoup quelque chose ; le vendeur dit « Desidera ? ». → vouloir beaucoup quelque chose ; le vendeur dit « desidera ? ».
- v1_3.json#13 — expl[8] — querer mucho algo; en las tiendas dicen «Desidera?». → querer mucho algo; en las tiendas dicen «desidera?».
- v1_3.json#13 — expl[9] — querer mucho algo; en las tiendas dicen «Desidera?». → querer mucho algo; en las tiendas dicen «desidera?».
- v1_3.json#19 — expl[0] — when the result changes because of something else: «Dipende!» → when the result changes because of something else: «dipende!»
- v1_3.json#23 — expl[0] — used in «Mi dispiace» (I'm sorry) and «Le dispiace...?» (do you mind...?). → used in «mi dispiace» (I'm sorry) and «le dispiace...?» (do you mind...?).
- v1_3.json#30 — tr[2] — پینا / لازمی کرنا → ضروری ہونا / لازمی ہونا
- v1_3.json#30 — tr[3] — ਪੈਣਾ / ਜ਼ਰੂਰੀ ਕਰਨਾ → ਪੈਣਾ / ਜ਼ਰੂਰੀ ਹੋਣਾ
- v1_4.json#4 — emoji — 🤢 → null
- v1_4.json#11 — exTr[5] — අයිසී ගැන අහන්න මම කාෆ් එකට කෝල් කරනවා. → අයි එස් ඊ ඊ ගැන අහන්න මම කාෆ් එකට කෝල් කරනවා.
- v1_4.json#14 — emoji — ⚠️ → null
- v1_4.json#15 — tr[6] — 搭车 / 顺路送 → 顺路送 / 捎一程
- v1_5.json#11 — tr[2] — دعا دینا / ودھائی دینا → دعا دینا / چنگا چاہنا
- v1_5.json#27 — exTr[1] — گاڑی چلاتے ہوئے میں فون کی وجہ سے دھیان نہیں ہٹاتا۔ → گاڑی چلاتے ہوئے فون کی وجہ سے میرا دھیان نہیں ہٹتا۔
- v1_5.json#27 — exTr[2] — گڈی چلاندیاں میں فون پاروں دھیان نئیں ہٹاندا۔ → گڈی چلاندیاں فون پاروں میرا دھیان نئیں ہٹدا۔
- v1_5.json#27 — exTr[3] — ਗੱਡੀ ਚਲਾਉਂਦਿਆਂ ਮੈਂ ਫੋਨ ਕਰਕੇ ਧਿਆਨ ਨਹੀਂ ਹਟਾਉਂਦਾ। → ਗੱਡੀ ਚਲਾਉਂਦਿਆਂ ਫੋਨ ਕਰਕੇ ਮੇਰਾ ਧਿਆਨ ਨਹੀਂ ਹਟਦਾ।
- v1_5.json#35 — expl[0] — used to say that something is OK or fits well: «Va bene!». → used to say that something is OK or fits well: «va bene!».
- v1_5.json#35 — expl[7] — sert à dire qu'une chose va ou convient : « Va bene ! ». → sert à dire qu'une chose va ou convient : « va bene ! ».
- v1_5.json#35 — expl[8] — sirve para decir que algo está bien o queda bien: «Va bene!». → sirve para decir que algo está bien o queda bien: «va bene!».
- v1_5.json#35 — expl[9] — sirve para decir que algo está bien o queda bien: «Va bene!». → sirve para decir que algo está bien o queda bien: «va bene!».

## Validator

`python -I tools/check_dict.py tools/dict_src/v1_*.json` → `140 entries in 5 files, 0 errors`
