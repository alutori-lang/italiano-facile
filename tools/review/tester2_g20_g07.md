# Tester 2 — g20 (school) + g07 (food)

Files: tools/dict_src/g20_1..4.json, g07_1..5.json
Entries checked: 351 (every field: it, type, topic, emoji, tr, expl, ex, exTr in all 10 slots)
Entries after review: 350 (1 duplicate removed)
Corrections: 33 (32 field fixes + 1 entry removed)

Final validator: `python -I tools/check_dict.py tools/dict_src/g20_*.json tools/dict_src/g07_*.json`
→ `350 entries in 9 files, 0 errors`

Notes
- Italian headwords, articles, accents, gender, infinitives and example sentences were all correct. No Italian changes were needed.
- 'la mensa' was in both g07_3 (#38) and g20_1 (#26), which the validator reports as an error. I kept the school entry in g20_1 and removed the g07_3 copy.
- Emoji: pictures that do not show the thing itself were set to null: 🧸 kindergarten, 👔 head teacher, 🚪 classroom, 🚌 school trip, ⏸️ break, 🏆 to pass, 🙈 forgot, 🚫 "no pork / no alcohol", 🧊 frozen, 🍗 (a drumstick) for chicken breast, 📞 to book, 🍰 (strawberry shortcake) for tiramisu, 🎄 for panettone.
- Italian forms quoted in expl (e.g. 'Avere fame', 'allergica', senza, cena/pranzo) were kept in Latin script on purpose. The validator allows quoted Italian in expl, and it shows learners the real spelling.
- Bengali was already Bangladesh usage everywhere (পানি, লবণ, নাস্তা, রোজা). One school term was aligned to the Bangladesh name (নিম্ন মাধ্যমিক).

## Corrections (file#index — field — wrong → right)
Indexes are the positions before the removal; g07_3 has no entries after #38.
- g07_1.json#4 (lo spuntino) — tr[LA] — snack / bocadillo → snack / refrigerio
- g07_2.json#1 (surgelato) — emoji — 🧊 → null
- g07_2.json#28 (la carne macinata) — exTr[SI] — මට කොටපු මස් බාගයක් ඕනේ. → මට කොටපු මස් කිලෝ බාගයක් ඕනේ.
- g07_2.json#31 (il petto di pollo) — emoji — 🍗 → null
- g07_3.json#29 (le mandorle) — exTr[LA] — Me como un puño de almendras. → Me como un puñado de almendras.
- g07_3.json#37 (la dieta) — exTr[FR] — Je suis au régime, pas de dessert. → Je suis au régime, pas de sucreries.
- g07_3.json#38 (la mensa) — entry — REMOVED (duplicate of g20_1.json#26 'la mensa')
- g07_4.json#5 (prenotare) — emoji — 📞 → null
- g07_4.json#25 (il tiramisù) — emoji — 🍰 → null
- g07_4.json#35 (Non mangio carne di maiale.) — emoji — 🚫 → null
- g07_5.json#1 (il panettone) — emoji — 🎄 → null
- g07_5.json#14 (È buonissimo!) — exTr[UR] — خاتون، قیمے کی چٹنی بہت مزیدار ہے! → میڈم، قیمے کی چٹنی بہت مزیدار ہے!
- g07_5.json#25 (Non bevo alcol.) — emoji — 🚫 → null
- g20_1.json#1 (la scuola dell'infanzia) — emoji — 🧸 → null
- g20_1.json#3 (la scuola media) — tr[BN] — মাধ্যমিক বিদ্যালয় (নিম্ন) → নিম্ন মাধ্যমিক বিদ্যালয়
- g20_1.json#12 (il preside) — emoji — 👔 → null
- g20_1.json#14 (la maestra) — tr[PS] — استانی / مسٹرانی → استانی / ماسٹرنی
- g20_1.json#22 (l'insegnante di sostegno) — tr[FR] — enseignant de soutien (AESH) → enseignant spécialisé / de soutien
- g20_1.json#23 (l'aula) — emoji — 🚪 → null
- g20_1.json#28 (la gita scolastica) — emoji — 🚌 → null
- g20_1.json#29 (la ricreazione) — emoji — ⏸️ → null
- g20_1.json#34 (il doposcuola) — tr[ES] — actividades extraescolares / refuerzo → refuerzo escolar / ayuda con los deberes
- g20_2.json#19 (la penna) — exTr[UR] — کیا آپ مجھے ایک قلم دیں گے، پلیز؟ → براہِ کرم، کیا آپ مجھے ایک قلم دیں گے؟
- g20_2.json#19 (la penna) — exTr[PS] — مینوں اک پین دے دیو گے، مہربانی؟ → مہربانی کر کے مینوں اک پین دے دیو گے؟
- g20_3.json#25 (contare) — tr[ZH] — 数（数） → 数数 / 数
- g20_3.json#30 (superare) — emoji — 🏆 → null
- g20_3.json#34 (promosso) — exTr[SI] — ජයවේවා, මගේ පුතා සමත්! → නියමයි, මගේ පුතා සමත් වුණා!
- g20_4.json#10 (Può parlare più piano, per favore?) — tr[PS] — ہولی بول سکدے او، مہربانی؟ → مہربانی کر کے ہولی بول سکدے او؟
- g20_4.json#18 (Vorrei iscrivermi a un corso di italiano.) — exTr[SI] — සුබ උදෑසනක්, මට රාත්‍රී ඉතාලි පාඨමාලාවකට ලියාපදිංචි වෙන්න ඕනේ. → සුබ උදෑසනක්, මට සවස ඉතාලි පාඨමාලාවකට ලියාපදිංචි වෙන්න ඕනේ.
- g20_4.json#21 (Posso andare in bagno?) — exTr[PS] — استانی جی، میں واش روم جا سکدا آں، مہربانی؟ → استانی جی، کی میں واش روم جا سکدا آں؟
- g20_4.json#22 (Ho dimenticato il quaderno a casa.) — emoji — 🙈 → null
- g20_4.json#24 (Mio figlio non mangia carne di maiale.) — emoji — 🚫 → null
- g20_4.json#26 (fare i compiti) — exTr[UR] — ناشتے کے بعد ہوم ورک کرو! → کچھ کھا کر ہوم ورک کرو!
