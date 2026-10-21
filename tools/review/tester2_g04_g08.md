# Tester 2 — g04 (body, feelings) + g08 (fruit, vegetables, drinks)

Files: tools/dict_src/g04_1..7.json, g08_1..6.json
Entries checked: 447 (every field: it, type, topic, emoji, tr, expl, ex, exTr in all 10 slots)
Entries after review: 446 (1 duplicate removed)
Corrections: 68 (67 field fixes + 1 entry removed)

Final validator: `python -I tools/check_dict.py tools/dict_src/g04_*.json tools/dict_src/g08_*.json`
→ `446 entries in 13 files, 0 errors`

Notes
- Italian headwords, articles, accents, plural notes (le orecchie, le braccia, le dita, le ginocchia, le ossa) and example sentences were all correct. No Italian changes were needed.
- Shahmukhi used "باں" for arm (bāṅh). It was changed everywhere to the standard Punjabi spelling "بانہہ" / "بانہواں".
- Shahmukhi wrote "پھل" (fruit) where it meant "flower". It was changed to "پھُل" in those places only. Entries that really mean "fruit" were left as they were.
- Shahmukhi aubergine: "بتاؤں" → "وتاؤں" (vatāūṅ, matching Gurmukhi ਵਤਾਊਂ).
- Bengali "জল" for tears/water was changed to Bangladesh usage "পানি" (জলপাই = olive is correct and was kept).
- Symbolic emoji were set to null because they do not show the thing: 🦁 brave/courage, 🌞 optimistic, 🌈 hope, 🎁 surprise, 🧘 calm, 💭 dream, ⚖️ weight, 📏 height, 👓 eyesight, 🩺 blood pressure, 🌬️ breathe, 👆 touch, 🤕 back pain, 🥬 cabbage (🥬 is a leafy green, not cabbage). 😎 for "rilassato" was changed to 😌. All fruit and vegetable emoji that were kept show the exact item.

## Corrections (file#index — field — wrong → right)
- g04_1.json#0 (il corpo) — expl[2 PA-Shahmukhi] — بندے دا سارا سریر: سر، باںہواں، لتاں۔ → بندے دا سارا سریر: سر، بانہواں، لتاں۔
- g04_1.json#9 (le sopracciglia) — exTr[8 ES] — Mi hermana se depila las cejas en la esteticista. → Mi hermana se depila las cejas en el centro de estética.
- g04_1.json#9 (le sopracciglia) — expl[5 SI] — ඇස්වලට උඩින් තියෙන කෙස් පේළි. → ඇස්වලට උඩින් තියෙන රෝම පේළි.
- g04_1.json#10 (le ciglia) — expl[5 SI] — ඇහි පියේ දාරයේ තියෙන පුංචි කෙස්. → ඇහි පියේ දාරයේ තියෙන පුංචි රෝම.
- g04_1.json#16 (la spalla) — expl[2 PA-Shahmukhi] — جتھوں باں شروع ہوندی اے، اوہ حصہ۔ → جتھوں بانہہ شروع ہوندی اے، اوہ حصہ۔
- g04_1.json#17 (il braccio) — tr[2 PA-Shahmukhi] — باں → بانہہ
- g04_1.json#17 (il braccio) — exTr[2 PA-Shahmukhi] — نرس میری باں وچ ٹیکا لاندی اے۔ → نرس میری بانہہ وچ ٹیکا لاندی اے۔
- g04_1.json#18 (il gomito) — expl[2 PA-Shahmukhi] — باں دے وچکار جوڑ جتھوں اوہ مُڑدی اے۔ → بانہہ دے وچکار جوڑ جتھوں اوہ مُڑدی اے۔
- g04_1.json#19 (il polso) — expl[2 PA-Shahmukhi] — ہتھ تے باں دے وچکار جوڑ۔ → ہتھ تے بانہہ دے وچکار جوڑ۔
- g04_1.json#29 (il sedere) — exTr[8 ES] — La inyección se pone en el culo. → La inyección se pone en el trasero.
- g04_1.json#33 (la caviglia) — exTr[4 BN] — আমি পিছলে পড়ে পায়ের গাঁট মচকেছে। → পিছলে পড়ে আমার পায়ের গাঁট মচকে গেছে।
- g04_2.json#6 (la pressione) — emoji — 🩺 → None
- g04_2.json#9 (il livido) — exTr[2 PA-Shahmukhi] — میری باں تے نیل اے۔ → میری بانہہ تے نیل اے۔
- g04_2.json#17 (il peso) — emoji — ⚖️ → None
- g04_2.json#18 (l'altezza) — emoji — 📏 → None
- g04_2.json#19 (l'ascella) — expl[2 PA-Shahmukhi] — باں دے تھلے، موڈھے کول جگہ۔ → بانہہ دے تھلے، موڈھے کول جگہ۔
- g04_2.json#20 (la vista) — emoji — 👓 → None
- g04_2.json#24 (il pugno) — tr[1 UR] — مُکا → مٹھی / مُکا
- g04_2.json#24 (il pugno) — tr[2 PA-Shahmukhi] — مُکا → مُٹھ / مُکا
- g04_2.json#24 (il pugno) — tr[3 PA-Gurmukhi] — ਮੁੱਕਾ → ਮੁੱਠੀ / ਮੁੱਕਾ
- g04_2.json#36 (respirare) — emoji — 🌬️ → None
- g04_3.json#2 (toccare) — emoji — 👆 → None
- g04_3.json#13 (sbadigliare) — tr[5 SI] — ඉවක් අරිනවා → ඈනුම් අරිනවා
- g04_3.json#13 (sbadigliare) — exTr[5 SI] — ඔයා ඉවක් අරින්නේ නිදිමත නිසා. → ඔයා ඈනුම් අරින්නේ නිදිමත නිසා.
- g04_3.json#16 (Mi fa male la schiena.) — emoji — 🤕 → None
- g04_3.json#23 (Mi sono rotto il braccio.) — tr[2 PA-Shahmukhi] — میری باں ٹُٹ گئی اے۔ → میری بانہہ ٹُٹ گئی اے۔
- g04_3.json#23 (Mi sono rotto il braccio.) — exTr[2 PA-Shahmukhi] — میں پوڑی توں ڈگا تے میری باں ٹُٹ گئی۔ → میں پوڑی توں ڈگا تے میری بانہہ ٹُٹ گئی۔
- g04_3.json#29 (Dove le fa male?) — tr[5 SI] — ඔයාට රිදෙන්නේ කොහෙද? → ඔබට රිදෙන්නේ කොහෙද?
- g04_3.json#29 (Dove le fa male?) — exTr[5 SI] — දොස්තර අහනවා: "ඔයාට රිදෙන්නේ කොහෙද?" → දොස්තර අහනවා: "ඔබට රිදෙන්නේ කොහෙද?"
- g04_3.json#32 (Si tolga la maglietta, per favore.) — tr[6 ZH] — 请把短袖衫脱掉。 → 请把T恤脱掉。
- g04_3.json#33 (Non riesco a muovere il braccio.) — tr[2 PA-Shahmukhi] — میں باں نہیں ہلا سکدا۔ → میں بانہہ نہیں ہلا سکدا۔
- g04_3.json#33 (Non riesco a muovere il braccio.) — exTr[2 PA-Shahmukhi] — ڈگن مگروں میں باں نہیں ہلا سکدا۔ → ڈگن مگروں میں بانہہ نہیں ہلا سکدا۔
- g04_4.json#4 (geloso) — tr[1 UR] — حسد کرنے والا / غیرت مند → حسد کرنے والا / شکی
- g04_4.json#28 (rilassato) — emoji — 😎 → 😌
- g04_4.json#33 (coraggioso) — emoji — 🦁 → None
- g04_4.json#35 (commosso) — expl[4 BN] — কিছুতে এত আবেগী যে চোখে জল আসে। → কিছুতে এত আবেগী যে চোখে পানি আসে।
- g04_4.json#37 (ottimista) — emoji — 🌞 → None
- g04_5.json#1 (la rabbia) — tr[2 PA-Shahmukhi] — غصہ / رُکھ → غصہ / کاوڑ
- g04_5.json#1 (la rabbia) — exTr[8 ES] — Cuando tengo rabia, salgo a dar un paseo. → Cuando me da rabia, salgo a dar un paseo.
- g04_5.json#9 (la speranza) — emoji — 🌈 → None
- g04_5.json#14 (la sorpresa) — emoji — 🎁 → None
- g04_5.json#16 (il pianto) — expl[4 BN] — চোখের জল ফেলে কান্না। → চোখের পানি ফেলে কান্না।
- g04_5.json#18 (la lacrima) — tr[4 BN] — চোখের জল / অশ্রু → চোখের পানি / অশ্রু
- g04_5.json#18 (la lacrima) — exTr[4 BN] — তার চোখে জল ছিল। → তার চোখে পানি ছিল।
- g04_5.json#22 (la calma) — emoji — 🧘 → None
- g04_5.json#24 (il coraggio) — emoji — 🦁 → None
- g04_5.json#31 (la stanchezza) — exTr[4 BN] — রাতের শিফটের পর আমি খুব ক্লান্ত লাগি। → রাতের শিফটের পর আমার খুব ক্লান্ত লাগে।
- g04_5.json#34 (l'abbraccio) — expl[2 PA-Shahmukhi] — پیار نال کسے نوں باںہواں وچ لینا۔ → پیار نال کسے نوں بانہواں وچ لینا۔
- g04_5.json#37 (l'invidia) — tr[5 SI] — ඊර්ෂ්‍යාව / ක්‍රෝධය → ඊර්ෂ්‍යාව
- g04_6.json#0 (piangere) — expl[4 BN] — দুঃখ বা ব্যথায় চোখ দিয়ে জল পড়া। → দুঃখ বা ব্যথায় চোখ দিয়ে পানি পড়া।
- g04_6.json#7 (preoccuparsi) — tr[5 SI] — කනස්සල්ලට පත්වෙනවා / හිත හදාගන්නවා → කනස්සල්ලට පත්වෙනවා
- g04_6.json#10 (abbracciare) — expl[2 PA-Shahmukhi] — پیار نال کسے نوں باںہواں وچ لینا۔ → پیار نال کسے نوں بانہواں وچ لینا۔
- g04_6.json#19 (sognare) — emoji — 💭 → None
- g04_7.json#15 (Sono giù di morale.) — tr[7 FR] — J'ai le moral à zéro. → Je n'ai pas le moral.
- g04_7.json#15 (Sono giù di morale.) — exTr[7 FR] — Depuis que j'ai perdu mon travail, j'ai le moral à zéro. → Depuis que j'ai perdu mon travail, je n'ai pas le moral.
- g08_3.json#0 (la melanzana) — tr[2 PA-Shahmukhi] — بتاؤں → وتاؤں
- g08_3.json#0 (la melanzana) — exTr[2 PA-Shahmukhi] — اج رات میں بتاؤں پکاواں گا۔ → اج رات میں وتاؤں پکاواں گا۔
- g08_3.json#0 (la melanzana) — expl[6 ZH] — 一种长长的紫色蔬菜，里面软，用来做茄子焗饭或咖喱。 → 一种长长的紫色蔬菜，里面软，用来做焗茄子（parmigiana）或咖喱。
- g08_3.json#3 (il cavolo) — emoji — 🥬 → None
- g08_3.json#4 (il cavolfiore) — expl[2 PA-Shahmukhi] — وڈی چٹی سبزی جیہڑی پھل ورگی لگدی اے، آلے دوالے ہرے پتے۔ → وڈی چٹی سبزی جیہڑی پھُل ورگی لگدی اے، آلے دوالے ہرے پتے۔
- g08_3.json#27 (il carciofo) — expl[2 PA-Shahmukhi] — ہری سبزی جیہڑی بند پھل ورگی؛ اندر دے نرم پتے کھاندے نیں۔ → ہری سبزی جیہڑی بند پھُل ورگی؛ اندر دے نرم پتے کھاندے نیں۔
- g08_4.json#7 (il mazzo) — expl[2 PA-Shahmukhi] — بوٹیاں، پھل یا سبزیاں اکٹھیاں بنھیاں، جیویں دھنیے دی گڈی۔ → بوٹیاں، پھُل یا سبزیاں اکٹھیاں بنھیاں، جیویں دھنیے دی گڈی۔
- g08_4.json#23 (Mi piacciono le melanzane.) — tr[2 PA-Shahmukhi] — مینوں بتاؤں چنگے لگدے نیں۔ → مینوں وتاؤں چنگے لگدے نیں۔
- g08_4.json#23 (Mi piacciono le melanzane.) — exTr[2 PA-Shahmukhi] — مینوں تلے ہوئے بتاؤں چنگے لگدے نیں۔ → مینوں تلے ہوئے وتاؤں چنگے لگدے نیں۔
- g08_5.json#10 (il ghiaccio) — expl[1 UR] — جمی ہوئی پانی کی برف؛ چھوٹے ٹکڑے ٹھنڈے مشروب میں ڈالتے ہیں۔ → جما ہوا پانی؛ چھوٹے ٹکڑے ٹھنڈے مشروب میں ڈالتے ہیں۔
- g08_5.json#20 (la tisana) — expl[2 PA-Shahmukhi] — جڑی بوٹیاں یا پھلاں توں بنی گرم چیز، چاء پتی توں بغیر۔ → جڑی بوٹیاں یا پھُلاں توں بنی گرم چیز، چاء پتی توں بغیر۔
- g08_5.json#21 (la camomilla) — expl[2 PA-Shahmukhi] — نکے پیلے پھلاں دی گرم چاء؛ سکون تے نیند لئی چنگی۔ → نکے پیلے پھُلاں دی گرم چاء؛ سکون تے نیند لئی چنگی۔
- g08_6.json#16 (avere sete) — whole entry — duplicate of g04_6.json#21 "avere sete" (also covered by g08_6 "Ho sete.") → removed
