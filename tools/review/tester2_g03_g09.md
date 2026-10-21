# Tester 2 — g03 (time, weather) + g09 (cooking)

Files: tools/dict_src/g03_1..7.json, g09_1..4.json
Entries checked: 376 (every field: it, type, topic, emoji, tr, expl, ex, exTr in all 10 slots)
Entries after review: 375 (1 duplicate removed)
Corrections: 61

Final validator: `python -I tools/check_dict.py tools/dict_src/g03_*.json tools/dict_src/g09_*.json`
→ `375 entries in 11 files, 0 errors`

Notes
- Italian headwords, articles, accents and example sentences were all correct; no Italian changes were needed.
- Bengali slot in g03_5/g03_6 used West-Bengal "জল"; changed to Bangladesh "পানি" (জলবায়ু kept, it is standard in Bangladesh too).
- Multi-word adverbials (a volte, in ritardo, al dente, al forno...) are kept as type "a", the same way across all files.

## Corrections (file#index — field — wrong → right)
- g03_1.json#3 (venerdì) — exTr[5 SI] — සිකුරාදා මම පල්ලියට යනවා. → සිකුරාදා මම මුස්ලිම් පල්ලියට යනවා.
- g03_1.json#31 (la mezza) — expl[1 UR] — گھنٹے کے تیس منٹ بعد: ساڑھے ایک، ساڑھے دو۔ → گھنٹے کے تیس منٹ بعد: ڈیڑھ، ڈھائی۔
- g03_1.json#20 (la mezzanotte) — expl[7 FR] — Douze heures la nuit. → Douze heures, au milieu de la nuit.
- g03_1.json#21 (il mezzogiorno) — expl[7 FR] — Douze heures dans la journée, l'heure du déjeuner. → Douze heures, en pleine journée : l'heure du déjeuner.
- g03_2.json#14 (il Ferragosto) — tr[6 ZH] — 八月节（8月15日假日） → 八月十五日假日
- g03_2.json#14 (il Ferragosto) — exTr[6 ZH] — 八月节的时候城里空荡荡的。 → 八月十五日假日那天，城里空荡荡的。
- g03_2.json#16 (la vigilia di Natale) — tr[5 SI] — නත්තල් උදාව (දෙසැම්බර් 24) → නත්තල් පෙර දිනය (දෙසැම්බර් 24)
- g03_2.json#16 (la vigilia di Natale) — exTr[5 SI] — නත්තල් උදාවේ කඩේ ඉක්මනට වහනවා. → නත්තල් පෙර දිනයේ කඩේ ඉක්මනට වහනවා.
- g03_3.json#14 (adesso) — exTr[5 SI] — දැන් මට බැහැ, මම වැඩ. → දැන් මට බැහැ, මම වැඩ කරනවා.
- g03_4.json#27 (Il negozio è chiuso la domenica.) — expl[5 SI] — "ලා දොමෙනිකා" (ලිපිය සමඟ) කියන්නේ හැම ඉරිදාම. → "ලා දොමෙනිකා" (උපපදය සමඟ) කියන්නේ හැම ඉරිදාම.
- g03_4.json#3 (È mezzogiorno.) — expl[7 FR] — Il est douze heures dans la journée. → Il est douze heures, en pleine journée.
- g03_4.json#4 (Sono le otto e un quarto.) — expl[7 FR] — Il est quinze minutes après huit heures. → Il est huit heures quinze.
- g03_4.json#4 (Sono le otto e un quarto.) — expl[8 ES] — Son quince minutos después de las ocho. → Son las ocho y quince.
- g03_4.json#4 (Sono le otto e un quarto.) — expl[9 ES-LatAm] — Son quince minutos después de las ocho. → Son las ocho y quince.
- g03_4.json#5 (Sono le sei meno un quarto.) — expl[7 FR] — Il est quinze minutes avant six heures : 5 h 45. → Il est six heures moins quinze : 5 h 45.
- g03_5.json#2 (il vento) — tr[1 UR] — ہوا / آندھی → ہوا
- g03_5.json#4 (il temporale) — tr[1 UR] — طوفانی بارش / آندھی → طوفانی بارش / گرج چمک
- g03_5.json#8 (la grandine) — emoji — 🧊 → None
- g03_5.json#18 (la tempesta) — emoji — 🌪️ → ⛈️
- g03_5.json#21 (la pozzanghera) — emoji — 💦 → None
- g03_5.json#22 (il gelo) — tr[4 BN] — তীব্র ঠান্ডা / তুষার → তীব্র ঠান্ডা / হিম
- g03_5.json#22 (il gelo) — tr[5 SI] — දැඩි සීතල / හිම පිදීම → දැඩි සීතල
- g03_5.json#23 (la brina) — tr[4 BN] — শিশিরের বরফ / তুষার কণা → তুহিন / জমাট শিশির
- g03_5.json#24 (il fango) — emoji — 🟫 → None
- g03_5.json#30 (l'alluvione) — exTr[0 EN] — The flood flooded the streets. → The flood covered the streets with water.
- g03_6.json#3 (la stagione) — emoji — 🍁 → None
- g03_6.json#17 (ventoso) — tr[4 BN] — ঝোড়ো / বাতাসযুক্ত → বাতাসযুক্ত / হাওয়াময়
- g03_6.json#17 (ventoso) — exTr[4 BN] — দিনটা ঠান্ডা আর ঝোড়ো। → দিনটা ঠান্ডা, আর খুব বাতাস বইছে।
- g03_6.json#22 (fresco) — expl[0 EN] — A little cold in a pleasant way; also "new" for food. → A little cold in a pleasant way; for food it means "not old".
- g03_6.json#22 (fresco) — expl[7 FR] — Un peu froid de façon agréable ; pour la nourriture, « nouveau ». → Un peu froid de façon agréable ; pour la nourriture, « pas vieux ».
- g03_6.json#27 (asciutto) — emoji — 👕 → None
- g03_7.json#13 (Pioverà domani?) — exTr[5 SI] — හෙට වහියිද? මට ඇඳුම් වනන්න ඕනේ. → හෙට වහියිද? මට ඇඳුම් වේළන්න දාන්න ඕනේ.
- g03_7.json#16 (Prendi l'ombrello!) — exTr[6 ZH] — 带上伞，天都黑了。 → 带上伞，天上都是乌云。
- g03_5.json#7 (l'umidità) — expl[4 BN] — বাতাসে জল; ঘরে দেয়াল স্যাঁতসেঁতে হতে পারে। → বাতাসে পানি; ঘরে দেয়াল স্যাঁতসেঁতে হতে পারে।
- g03_5.json#9 (il ghiaccio) — expl[4 BN] — জমে যাওয়া জল; শীতে রাস্তায় বিপজ্জনক। → জমে যাওয়া পানি; শীতে রাস্তায় বিপজ্জনক।
- g03_5.json#20 (l'ondata di caldo) — expl[4 BN] — কয়েক দিনের তীব্র গরম; জল খান, ছায়ায় থাকুন। → কয়েক দিনের তীব্র গরম; পানি খান, ছায়ায় থাকুন।
- g03_5.json#21 (la pozzanghera) — tr[4 BN] — জলের ডোবা / খানাখন্দে জল → পানির ডোবা / খানাখন্দে জমা পানি
- g03_5.json#21 (la pozzanghera) — expl[4 BN] — মাটিতে জমা বৃষ্টির জলের ছোট ডোবা। → মাটিতে জমা বৃষ্টির পানির ছোট ডোবা।
- g03_5.json#21 (la pozzanghera) — exTr[4 BN] — বাচ্চাটা জলের ডোবায় লাফায়। → বাচ্চাটা পানির ডোবায় লাফায়।
- g03_5.json#22 (il gelo) — expl[4 BN] — এত ঠান্ডা যে জল জমে যায়। → এত ঠান্ডা যে পানি জমে যায়।
- g03_5.json#26 (l'impermeabile) — expl[4 BN] — যে কোট দিয়ে বৃষ্টির জল ঢোকে না। → যে কোট দিয়ে বৃষ্টির পানি ঢোকে না।
- g03_5.json#30 (l'alluvione) — expl[4 BN] — যখন নদী বা বৃষ্টি রাস্তা ও ঘর জলে ডুবিয়ে দেয়। → যখন নদী বা বৃষ্টি রাস্তা ও ঘর পানিতে ডুবিয়ে দেয়।
- g03_5.json#32 (la goccia) — expl[4 BN] — জল বা বৃষ্টির খুব ছোট্ট পরিমাণ। → পানি বা বৃষ্টির খুব ছোট্ট পরিমাণ।
- g03_6.json#16 (umido) — expl[4 BN] — বাতাসে অনেক জল বা একটু ভেজা। → বাতাসে অনেক পানি বা একটু ভেজা।
- g03_6.json#25 (secco) — expl[4 BN] — জল বা বৃষ্টি ছাড়া। → পানি বা বৃষ্টি ছাড়া।
- g03_6.json#26 (bagnato) — expl[4 BN] — জলে ভেজা, যেমন বৃষ্টির পরে। → পানিতে ভেজা, যেমন বৃষ্টির পরে।
- g03_6.json#30 (sotto zero) — expl[4 BN] — ০ ডিগ্রির কম তাপমাত্রা; জল জমে যায়। → ০ ডিগ্রির কম তাপমাত্রা; পানি জমে যায়।
- g03_6.json#31 (piovere) — expl[4 BN] — যখন মেঘ থেকে জল পড়ে; "পিওভে" = বৃষ্টি হচ্ছে। → যখন মেঘ থেকে পানি পড়ে; "পিওভে" = বৃষ্টি হচ্ছে।
- g03_6.json#34 (gelare) — expl[4 BN] — যখন ঠান্ডায় জল বরফ হয়ে যায়। → যখন ঠান্ডায় পানি বরফ হয়ে যায়।
- g03_6.json#37 (sudare) — expl[4 BN] — গরমে যখন চামড়া থেকে জল বের হয়। → গরমে যখন চামড়া থেকে পানি বের হয়।
- g09_1.json#13 (scongelare) — tr[2 PA-Shahmukhi] — برف کھولنا → برف پگھلانا / ڈی فراسٹ کرنا
- g09_1.json#13 (scongelare) — tr[3 PA-Gurmukhi] — ਬਰਫ਼ ਖੋਲ੍ਹਣਾ / ਡੀਫ੍ਰੌਸਟ ਕਰਨਾ → ਬਰਫ਼ ਪਿਘਲਾਉਣਾ / ਡੀਫ੍ਰੌਸਟ ਕਰਨਾ
- g09_1.json#13 (scongelare) — exTr[2 PA-Shahmukhi] — میں گوشت اک رات پہلاں کھول لیندا آں۔ → میں گوشت دی برف اک رات پہلاں پگھلا لیندا آں۔
- g09_1.json#26 (congelare) — emoji — 🥶 → 🧊
- g09_1.json#33 (lievitare) — tr[5 SI] — පිපෙනවා → පිම්බෙනවා
- g09_1.json#33 (lievitare) — exTr[5 SI] — පිටි ගුලිය පැය දෙකක් පිපෙන්න ඕනේ. → පිටි ගුලිය පැය දෙකක් පිම්බෙන්න ඕනේ.
- g09_1.json#36 (ungere) — exTr[7 FR] — Beurre le moule avec un peu de beurre. → Graisse le moule avec un peu de beurre.
- g09_3.json#10 (surgelato) — exTr[5 SI] — මම අයිස් කළ බෝංචි ඇට ගන්නවා. → මම අයිස් කළ ග්‍රීන් පීස් ගන්නවා.
- g09_2.json#38 (il ripieno) — exTr[5 SI] — පිරවුම අල සහ බෝංචි ඇට වලින්. → පිරවුම අල සහ ග්‍රීන් පීස් වලින්.
- g09_4.json#25 (Mettilo in frigo.) — emoji — 🧊 → None
- g09_2.json#35 (la goccia) — whole entry — duplicate of g03_5.json#32 → removed
