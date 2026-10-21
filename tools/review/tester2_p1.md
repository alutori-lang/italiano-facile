# Tester 2 review — p1 (everyday sentences: introductions, nationalities, understanding, help, directions, yes/no, thanks, apologies)

Files: tools/dict_src/p1_1.json (37), p1_2.json (35), p1_3.json (35), p1_4.json (35)
Entries checked: 142 (every field: it, type, topic, emoji, tr[10], expl[10], ex, exTr[10]).
Entries removed: 0.
Corrections: 73 (format: file#index (headword) — field — wrong → right).

Notes
- Italian headwords and examples: grammar, accents, apostrophes (dov'è, un po', dall'India, dallo Sri Lanka, dallo Zhejiang) and nationality adjectives (pakistano, bengalese, indiano, srilankese, cinese) were all correct. tu/Lei is stated in every expl and matches the Italian form. The only Italian change: p1_2#13 example quoted the untranslated word "vietato" in every exTr; the example was rewritten so the translations need no Italian.
- Urdu tu/Lei: informal (tu) entries used آپ (formal) → تم (p1_1#0, #17).
- Urdu: "خاتون،" used as a form of address → "محترمہ،" (4 examples).
- Urdu/Punjabi پتا / ਪਤਾ for "address" read as "I don't know" in "مجھے پتا نہیں مل رہا" → ایڈریس / ਐਡਰੈੱਸ.
- Urdu/Punjabi "موڑ کے پیچھے" (behind the bend) for "dietro l'angolo" → "موڑ مڑتے ہی" (right after the turn).
- Transliterated Italian in exTr (کمونے / ਕੋਮੂਨੇ for Comune) → بلدیہ کا دفتر / ਨਗਰਪਾਲਿਕਾ ਦਾ ਦਫ਼ਤਰ.
- Sinhala: "මාව හදනවද" (= will you make/fix me) → "මාව නිවැරදි කරනවද"; grammar "මට ... හිටියේ" → "මම ... හිටියේ"; නීතිය (law) → රීතිය (grammar rule).
- French: "Oui, ça va" (= I'm fine) for agreeing to a time → "Oui, ça me va".
- LatAm Spanish: "vivo aquí hace X años" (regional) → "hace X años que vivo aquí".
- Emoji: 📏 (ruler) for near/far/how far and 🙂 for "darci del tu" were close-enough pictures → null.
- File layout kept unchanged (only the changed string tokens were replaced in place; original indentation and line endings kept).

Final validator: `python -I tools/check_dict.py tools/dict_src/p1_*.json` → 142 entries in 4 files, 0 errors

## Corrections
- p1_1.json#0 (Mi chiamo Fatima, e tu?) — tr[1] — میرا نام فاطمہ ہے، اور آپ کا؟ → میرا نام فاطمہ ہے، اور تمہارا؟
- p1_1.json#0 (Mi chiamo Fatima, e tu?) — exTr[1] — ہیلو! میرا نام فاطمہ ہے، اور آپ کا؟ → ہیلو! میرا نام فاطمہ ہے، اور تمہارا؟
- p1_1.json#1 (Come si chiama?) — exTr[1] — السلام علیکم، خاتون، آپ کا نام کیا ہے؟ → السلام علیکم محترمہ، آپ کا نام کیا ہے؟
- p1_1.json#4 (Piacere di conoscerla.) — expl[7] — Formel (Lei) : pour un patron, un médecin, un employé ou une personne âgée. → Formel (Lei) : pour un patron, un médecin, un fonctionnaire ou une personne âgée.
- p1_1.json#10 (Sono cinese.) — exTr[9] — Soy chino, pero vivo aquí hace diez años. → Soy chino, pero hace diez años que vivo aquí.
- p1_1.json#17 (Da quanto tempo sei in Italia?) — tr[1] — آپ کب سے اٹلی میں ہیں؟ → تم کب سے اٹلی میں ہو؟
- p1_1.json#17 (Da quanto tempo sei in Italia?) — exTr[1] — آپ کب سے اٹلی میں ہیں؟ – تین سال سے۔ → تم کب سے اٹلی میں ہو؟ – تین سال سے۔
- p1_1.json#19 (Vivo a Parma da cinque anni.) — tr[9] — Vivo en Parma hace cinco años. → Hace cinco años que vivo en Parma.
- p1_1.json#19 (Vivo a Parma da cinque anni.) — exTr[9] — Vivo en Parma hace cinco años y trabajo aquí. → Hace cinco años que vivo en Parma y trabajo aquí.
- p1_1.json#23 (Sono qui con la mia famiglia.) — exTr[9] — Estoy aquí con mi familia hace dos años. → Hace dos años que estoy aquí con mi familia.
- p1_1.json#30 (Possiamo darci del tu?) — emoji — 🙂 → null
- p1_1.json#31 (Quanti anni ha?) — exTr[1] — خاتون، آپ کے بیٹے کی عمر کتنی ہے؟ → محترمہ، آپ کے بیٹے کی عمر کتنی ہے؟
- p1_2.json#1 (Non capisco.) — tr[1] — میں نہیں سمجھتا۔ → مجھے سمجھ نہیں آ رہا۔
- p1_2.json#7 (Può scriverlo?) — exTr[1] — مجھے پتا سمجھ نہیں آیا۔ کیا آپ اسے لکھ سکتے ہیں؟ → مجھے ایڈریس سمجھ نہیں آیا۔ کیا آپ اسے لکھ سکتے ہیں؟
- p1_2.json#7 (Può scriverlo?) — exTr[2] — مینوں پتا سمجھ نئیں آیا۔ تسیں ایہنوں لکھ سکدے او؟ → مینوں ایڈریس سمجھ نئیں آیا۔ تسیں ایہنوں لکھ سکدے او؟
- p1_2.json#7 (Può scriverlo?) — exTr[3] — ਮੈਨੂੰ ਪਤਾ ਸਮਝ ਨਹੀਂ ਆਇਆ। ਕੀ ਤੁਸੀਂ ਇਹਨੂੰ ਲਿਖ ਸਕਦੇ ਹੋ? → ਮੈਨੂੰ ਐਡਰੈੱਸ ਸਮਝ ਨਹੀਂ ਆਇਆ। ਕੀ ਤੁਸੀਂ ਇਹਨੂੰ ਲਿਖ ਸਕਦੇ ਹੋ?
- p1_2.json#13 (Che cosa significa?) — ex — C'è scritto "vietato". Che cosa significa? → Scusi, che cosa significa questo cartello?
- p1_2.json#13 (Che cosa significa?) — exTr[0] — It says "vietato". What does it mean? → Excuse me, what does this sign mean?
- p1_2.json#13 (Che cosa significa?) — exTr[1] — یہاں "vietato" لکھا ہے۔ اس کا مطلب کیا ہے؟ → معاف کیجیے، اس بورڈ کا کیا مطلب ہے؟
- p1_2.json#13 (Che cosa significa?) — exTr[2] — ایتھے "vietato" لکھیا اے۔ ایہدا مطلب کی اے؟ → معاف کرنا، ایس بورڈ دا کی مطلب اے؟
- p1_2.json#13 (Che cosa significa?) — exTr[3] — ਇੱਥੇ "vietato" ਲਿਖਿਆ ਹੈ। ਇਸਦਾ ਮਤਲਬ ਕੀ ਹੈ? → ਮਾਫ਼ ਕਰਨਾ, ਇਸ ਬੋਰਡ ਦਾ ਕੀ ਮਤਲਬ ਹੈ?
- p1_2.json#13 (Che cosa significa?) — exTr[4] — এখানে "vietato" লেখা আছে। এর মানে কী? → মাফ করবেন, এই সাইনবোর্ডের মানে কী?
- p1_2.json#13 (Che cosa significa?) — exTr[5] — මෙතන "vietato" කියලා ලියලා. ඒකේ තේරුම මොකක්ද? → සමාවෙන්න, මේ පුවරුවේ තේරුම මොකක්ද?
- p1_2.json#13 (Che cosa significa?) — exTr[6] — 上面写着"vietato"。这是什么意思？ → 请问，这个牌子是什么意思？
- p1_2.json#13 (Che cosa significa?) — exTr[7] — C'est écrit « vietato ». Qu'est-ce que ça veut dire ? → Excusez-moi, qu'est-ce que ce panneau veut dire ?
- p1_2.json#13 (Che cosa significa?) — exTr[8] — Pone «vietato». ¿Qué significa? → Perdone, ¿qué significa este cartel?
- p1_2.json#13 (Che cosa significa?) — exTr[9] — Dice «vietato». ¿Qué significa? → Disculpe, ¿qué significa este letrero?
- p1_2.json#16 (Come si pronuncia?) — tr[1] — اس کا تلفظ کیسے ہے؟ → اس کا تلفظ کیسے کرتے ہیں؟
- p1_2.json#16 (Come si pronuncia?) — exTr[1] — اس لفظ کا تلفظ کیسے ہے؟ → اس لفظ کا تلفظ کیسے کرتے ہیں؟
- p1_2.json#22 (Mi può fare un esempio?) — exTr[5] — මට මේ නීතිය හරියට තේරෙන්නේ නෑ. උදාහරණයක් දෙන්න පුළුවන්ද? → මට මේ රීතිය හරියට තේරෙන්නේ නෑ. උදාහරණයක් දෙන්න පුළුවන්ද?
- p1_2.json#27 (Mi correggi se sbaglio?) — tr[1] — اگر میں غلطی کروں تو مجھے ٹھیک کرو گے؟ → اگر میں غلطی کروں تو میری اصلاح کرو گے؟
- p1_2.json#27 (Mi correggi se sbaglio?) — tr[5] — මම වැරදුණොත් මාව හදනවද? → මට වැරදුණොත් මාව නිවැරදි කරනවද?
- p1_2.json#27 (Mi correggi se sbaglio?) — exTr[1] — میں اچھا بولنا چاہتا ہوں: غلطی کروں تو ٹھیک کرو گے؟ → میں اچھا بولنا چاہتا ہوں: غلطی کروں تو میری اصلاح کرو گے؟
- p1_2.json#27 (Mi correggi se sbaglio?) — exTr[5] — මට හොඳට කතා කරන්න ඕනේ: වැරදුණොත් හදනවද? → මට හොඳට කතා කරන්න ඕනේ: වැරදුණොත් මාව නිවැරදි කරනවද?
- p1_2.json#28 (Come si scrive il suo nome?) — tr[4] — আপনার নাম কীভাবে লেখে? → আপনার নামের বানান কী?
- p1_2.json#28 (Come si scrive il suo nome?) — exTr[4] — আপনার নাম কীভাবে লেখে? K দিয়ে না C দিয়ে? → আপনার নামের বানান কী? K দিয়ে না C দিয়ে?
- p1_2.json#31 (Aspetti, uso il traduttore.) — tr[4] — একটু দাঁড়ান, আমি অনুবাদক ব্যবহার করি। → একটু দাঁড়ান, আমি অনুবাদক ব্যবহার করছি।
- p1_2.json#31 (Aspetti, uso il traduttore.) — exTr[1] — رکیے، میں فون کا ترجمہ استعمال کرتا ہوں۔ → رکیے، میں فون پر ترجمہ کرتا ہوں۔
- p1_2.json#31 (Aspetti, uso il traduttore.) — exTr[2] — رکو جی، میں فون والا ترجمہ ورتنا آں۔ → رکو جی، میں فون تے ترجمہ کرنا آں۔
- p1_2.json#31 (Aspetti, uso il traduttore.) — exTr[3] — ਰੁਕੋ ਜੀ, ਮੈਂ ਫ਼ੋਨ ਵਾਲਾ ਅਨੁਵਾਦ ਵਰਤਦਾ ਹਾਂ। → ਰੁਕੋ ਜੀ, ਮੈਂ ਫ਼ੋਨ ’ਤੇ ਅਨੁਵਾਦ ਕਰਦਾ ਹਾਂ।
- p1_2.json#31 (Aspetti, uso il traduttore.) — exTr[4] — একটু দাঁড়ান, আমি ফোনের অনুবাদক ব্যবহার করি। → একটু দাঁড়ান, আমি ফোনের অনুবাদক ব্যবহার করছি।
- p1_3.json#3 (Scusi, un'informazione.) — exTr[1] — معاف کیجیے، ایک بات: کمونے (بلدیہ) کہاں ہے؟ → معاف کیجیے، ایک بات: بلدیہ کا دفتر کہاں ہے؟
- p1_3.json#3 (Scusi, un'informazione.) — exTr[2] — معاف کرنا، اک گل: کمونے (بلدیہ) کتھے اے؟ → معاف کرنا، اک گل: بلدیہ دا دفتر کتھے اے؟
- p1_3.json#3 (Scusi, un'informazione.) — exTr[3] — ਮਾਫ਼ ਕਰਨਾ, ਇੱਕ ਗੱਲ: ਕੋਮੂਨੇ (ਨਗਰਪਾਲਿਕਾ) ਕਿੱਥੇ ਹੈ? → ਮਾਫ਼ ਕਰਨਾ, ਇੱਕ ਗੱਲ: ਨਗਰਪਾਲਿਕਾ ਦਾ ਦਫ਼ਤਰ ਕਿੱਥੇ ਹੈ?
- p1_3.json#6 (Mi può dare una mano?) — exTr[1] — خاتون، کیا بچہ گاڑی میں میرا ہاتھ بٹا سکتی ہیں؟ → محترمہ، کیا آپ بچہ گاڑی کے ساتھ میرا ہاتھ بٹا سکتی ہیں؟
- p1_3.json#6 (Mi può dare una mano?) — exTr[2] — بی بی جی، بچیاں والی گڈی وچ میرا ہتھ ونڈا سکدے او؟ → بی بی جی، بچیاں والی گڈی نال میرا ہتھ ونڈا سکدے او؟
- p1_3.json#9 (Non trovo l'indirizzo.) — tr[1] — مجھے پتا نہیں مل رہا۔ → مجھے ایڈریس نہیں مل رہا۔
- p1_3.json#9 (Non trovo l'indirizzo.) — tr[2] — مینوں پتا نئیں لبھ رہیا۔ → مینوں ایڈریس نئیں لبھ رہیا۔
- p1_3.json#9 (Non trovo l'indirizzo.) — tr[3] — ਮੈਨੂੰ ਪਤਾ ਨਹੀਂ ਲੱਭ ਰਿਹਾ। → ਮੈਨੂੰ ਐਡਰੈੱਸ ਨਹੀਂ ਲੱਭ ਰਿਹਾ।
- p1_3.json#9 (Non trovo l'indirizzo.) — exTr[1] — معاف کیجیے، مجھے پتا نہیں مل رہا۔ کیا آپ کو معلوم ہے ویردی گلی کہاں ہے؟ → معاف کیجیے، مجھے ایڈریس نہیں مل رہا۔ کیا آپ کو معلوم ہے ویردی گلی کہاں ہے؟
- p1_3.json#9 (Non trovo l'indirizzo.) — exTr[2] — معاف کرنا، مینوں پتا نئیں لبھ رہیا۔ تہانوں پتا اے ویردی گلی کتھے اے؟ → معاف کرنا، مینوں ایڈریس نئیں لبھ رہیا۔ تہانوں پتا اے ویردی گلی کتھے اے؟
- p1_3.json#9 (Non trovo l'indirizzo.) — exTr[3] — ਮਾਫ਼ ਕਰਨਾ, ਮੈਨੂੰ ਪਤਾ ਨਹੀਂ ਲੱਭ ਰਿਹਾ। ਤੁਹਾਨੂੰ ਪਤਾ ਹੈ ਵੇਰਦੀ ਗਲੀ ਕਿੱਥੇ ਹੈ? → ਮਾਫ਼ ਕਰਨਾ, ਮੈਨੂੰ ਐਡਰੈੱਸ ਨਹੀਂ ਲੱਭ ਰਿਹਾ। ਤੁਹਾਨੂੰ ਪਤਾ ਹੈ ਵੇਰਦੀ ਗਲੀ ਕਿੱਥੇ ਹੈ?
- p1_3.json#12 (È lontano?) — emoji — 📏 → null
- p1_3.json#13 (È vicino?) — emoji — 📏 → null
- p1_3.json#21 (Quanto è lontano da qui?) — emoji — 📏 → null
- p1_3.json#14 (Si può andare a piedi?) — exTr[2] — شہر دا وچکار دور اے؟ پیدل جا سکدے آں؟ → شہر دا سینٹر دور اے؟ پیدل جا سکدے آں؟
- p1_3.json#14 (Si può andare a piedi?) — exTr[3] — ਸ਼ਹਿਰ ਦਾ ਵਿਚਕਾਰ ਦੂਰ ਹੈ? ਪੈਦਲ ਜਾ ਸਕਦੇ ਹਾਂ? → ਸ਼ਹਿਰ ਦਾ ਸੈਂਟਰ ਦੂਰ ਹੈ? ਪੈਦਲ ਜਾ ਸਕਦੇ ਹਾਂ?
- p1_3.json#19 (È dietro l'angolo.) — tr[1] — یہ بس موڑ کے پیچھے ہے۔ → بس موڑ مڑتے ہی ہے۔
- p1_3.json#19 (È dietro l'angolo.) — tr[2] — ایہہ بس موڑ دے پچھے اے۔ → بس موڑ مڑدیاں ای اے۔
- p1_3.json#19 (È dietro l'angolo.) — tr[3] — ਇਹ ਬੱਸ ਮੋੜ ਦੇ ਪਿੱਛੇ ਹੈ। → ਬੱਸ ਮੋੜ ਮੁੜਦਿਆਂ ਹੀ ਹੈ।
- p1_3.json#19 (È dietro l'angolo.) — exTr[1] — کیفے؟ یہ بس موڑ کے پیچھے ہے۔ → کیفے؟ بس موڑ مڑتے ہی ہے۔
- p1_3.json#19 (È dietro l'angolo.) — exTr[2] — کیفے؟ ایہہ بس موڑ دے پچھے اے۔ → کیفے؟ بس موڑ مڑدیاں ای اے۔
- p1_3.json#19 (È dietro l'angolo.) — exTr[3] — ਕੈਫ਼ੇ? ਇਹ ਬੱਸ ਮੋੜ ਦੇ ਪਿੱਛੇ ਹੈ। → ਕੈਫ਼ੇ? ਬੱਸ ਮੋੜ ਮੁੜਦਿਆਂ ਹੀ ਹੈ।
- p1_3.json#34 (Quanti minuti ci vogliono a piedi?) — tr[0] — How many minutes on foot? → How many minutes does it take on foot?
- p1_3.json#34 (Quanti minuti ci vogliono a piedi?) — exTr[0] — To get to the centre, how many minutes on foot? → How many minutes does it take to walk to the centre?
- p1_3.json#34 (Quanti minuti ci vogliono a piedi?) — exTr[2] — شہر دے وچکار تک پیدل کنے منٹ لگدے نیں؟ → شہر دے سینٹر تک پیدل کنے منٹ لگدے نیں؟
- p1_3.json#34 (Quanti minuti ci vogliono a piedi?) — exTr[3] — ਸ਼ਹਿਰ ਦੇ ਵਿਚਕਾਰ ਤੱਕ ਪੈਦਲ ਕਿੰਨੇ ਮਿੰਟ ਲੱਗਦੇ ਹਨ? → ਸ਼ਹਿਰ ਦੇ ਸੈਂਟਰ ਤੱਕ ਪੈਦਲ ਕਿੰਨੇ ਮਿੰਟ ਲੱਗਦੇ ਹਨ?
- p1_4.json#5 (Volentieri!) — tr[4] — খুশি মনে! → সানন্দে!
- p1_4.json#5 (Volentieri!) — exTr[4] — আমাদের বাসায় রাতে খেতে আসবে? – খুশি মনে! → আমাদের বাসায় রাতে খেতে আসবে? – সানন্দে!
- p1_4.json#12 (Lei è molto gentile.) — exTr[1] — شکریہ خاتون، آپ بہت مہربان ہیں۔ → شکریہ محترمہ، آپ بہت مہربان ہیں۔
- p1_4.json#24 (Sì, va bene.) — tr[7] — Oui, ça va. → Oui, ça me va.
- p1_4.json#24 (Sì, va bene.) — exTr[7] — Demain à neuf heures, ça vous va ? – Oui, ça va. → Demain à neuf heures, ça vous va ? – Oui, ça me va.
- p1_4.json#32 (Scusa per ieri.) — exTr[5] — ඊයේ ගැන සමාවෙන්න, මට හරිම කේන්තියෙන් හිටියේ. → ඊයේ ගැන සමාවෙන්න, මම හරිම කේන්තියෙන් හිටියේ.
