# -*- coding: utf-8 -*-
"""Generates lib/l10n/app_*.arb from one table, so every key exists in every
locale and nothing can drift. Run:  python tool/gen_arb.py
"""
import json, os, io

L = ["en","it","es","es_419","pt","fr","de","hi","ar","id","ru",
     "ur","pa_Arab","pa","bn","si","zh"]

BRAND = "Italian Words: Learn & Play"

# Placeholder metadata for the template file only.
PH = {
    "wordsAndPhrases": {"words": {"type": "int"}, "phrases": {"type": "int"}},
    "todayProgress": {"n": {"type": "int"}, "total": {"type": "int"}},
    "streakDays": {"n": {"type": "int"}},
    "quizProgress": {"n": {"type": "int"}, "total": {"type": "int"}},
    "scoreOutOf": {"score": {"type": "int"}, "total": {"type": "int"}},
    "nWords": {"n": {"type": "int"}},
    "nLearned": {"n": {"type": "int"}},
    "bestScoreValue": {"score": {"type": "int"}, "total": {"type": "int"}},
    "mistakesCount": {"n": {"type": "int"}},
}

S = {}
def k(key, *vals):
    assert len(vals) == len(L), (key, len(vals))
    S[key] = dict(zip(L, vals))

def same(key, v):
    S[key] = {loc: v for loc in L}

same("appTitle", BRAND)

# ---------------------------------------------------------------- navigation
k("tabSearch",
  "Search","Cerca","Buscar","Buscar","Buscar","Rechercher","Suchen","खोज","بحث","Cari","Поиск",
  "تلاش","تلاش","ਖੋਜ","খোঁজ","සොයන්න","搜索")
k("tabToday",
  "Today","Oggi","Hoy","Hoy","Hoje","Aujourd'hui","Heute","आज","اليوم","Hari ini","Сегодня",
  "آج","اَج","ਅੱਜ","আজ","අද","今天")
k("tabQuiz",
  "Quiz","Quiz","Quiz","Quiz","Quiz","Quiz","Quiz","क्विज़","اختبار","Kuis","Тест",
  "کوئز","کوئز","ਕੁਇਜ਼","কুইজ","ප්‍රශ්නාවලිය","测验")
k("tabTopics",
  "Topics","Argomenti","Temas","Temas","Temas","Thèmes","Themen","विषय","مواضيع","Topik","Темы",
  "موضوعات","موضوع","ਵਿਸ਼ੇ","বিষয়","මාතෘකා","主题")
k("settingsTitle",
  "Settings","Impostazioni","Ajustes","Configuración","Configurações","Réglages","Einstellungen",
  "सेटिंग्स","الإعدادات","Pengaturan","Настройки","ترتیبات","سیٹنگاں","ਸੈਟਿੰਗਾਂ","সেটিংস",
  "සැකසීම්","设置")
k("myWords",
  "My words","Le mie parole","Mis palabras","Mis palabras","Minhas palavras","Mes mots",
  "Meine Wörter","मेरे शब्द","كلماتي","Kata saya","Мои слова","میرے الفاظ","میرے لفظ",
  "ਮੇਰੇ ਸ਼ਬਦ","আমার শব্দ","මගේ වචන","我的单词")

# ---------------------------------------------------------------- generic
k("back",
  "Back","Indietro","Atrás","Atrás","Voltar","Retour","Zurück","वापस","رجوع","Kembali","Назад",
  "واپس","واپس","ਪਿੱਛੇ","পিছনে","ආපසු","返回")
k("next",
  "Next","Avanti","Siguiente","Siguiente","Próximo","Suivant","Weiter","आगे","التالي","Berikutnya",
  "Далее","اگلا","اگلا","ਅਗਲਾ","পরবর্তী","ඊළඟ","下一个")
k("done",
  "Done","Fatto","Listo","Listo","Pronto","Terminé","Fertig","पूरा","تم","Selesai","Готово",
  "مکمل","مکمل","ਮੁਕੰਮਲ","সম্পন্ন","නිමයි","完成")
k("close",
  "Close","Chiudi","Cerrar","Cerrar","Fechar","Fermer","Schließen","बंद करें","إغلاق","Tutup",
  "Закрыть","بند کریں","بند کرو","ਬੰਦ ਕਰੋ","বন্ধ","වසන්න","关闭")
k("cancel",
  "Cancel","Annulla","Cancelar","Cancelar","Cancelar","Annuler","Abbrechen","रद्द करें","إلغاء",
  "Batal","Отмена","منسوخ کریں","رد کرو","ਰੱਦ ਕਰੋ","বাতিল","අවලංගු","取消")
k("confirm",
  "Confirm","Conferma","Confirmar","Confirmar","Confirmar","Confirmer","Bestätigen","पुष्टि करें",
  "تأكيد","Konfirmasi","Подтвердить","تصدیق کریں","تصدیق کرو","ਪੁਸ਼ਟੀ ਕਰੋ","নিশ্চিত করুন",
  "තහවුරු","确认")
k("retry",
  "Try again","Riprova","Reintentar","Reintentar","Tentar de novo","Réessayer","Erneut versuchen",
  "फिर कोशिश करें","حاول مرة أخرى","Coba lagi","Повторить","دوبارہ کوشش کریں","دوبارہ کوشش کرو",
  "ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ","আবার চেষ্টা করুন","නැවත උත්සාහ","重试")
k("listen",
  "Listen","Ascolta","Escuchar","Escuchar","Ouvir","Écouter","Anhören","सुनें","استمع",
  "Dengarkan","Слушать","سنیں","سنو","ਸੁਣੋ","শুনুন","අහන්න","朗读")
k("listenSlow",
  "Slow","Lento","Lento","Lento","Lento","Lent","Langsam","धीरे","بطيء","Lambat","Медленно",
  "آہستہ","ہولی","ਹੌਲੀ","ধীরে","සෙමින්","慢速")
k("explanation",
  "Explanation","Spiegazione","Explicación","Explicación","Explicação","Explication","Erklärung",
  "व्याख्या","الشرح","Penjelasan","Объяснение","وضاحت","وضاحت","ਵਿਆਖਿਆ","ব্যাখ্যা",
  "විස්තරය","解释")
k("exampleLabel",
  "Example","Esempio","Ejemplo","Ejemplo","Exemplo","Exemple","Beispiel","उदाहरण","مثال",
  "Contoh","Пример","مثال","مثال","ਉਦਾਹਰਨ","উদাহরণ","උදාහරණය","例句")

# ---------------------------------------------------------------- word types
k("typeNoun",
  "Noun","Nome","Sustantivo","Sustantivo","Substantivo","Nom","Nomen","संज्ञा","اسم",
  "Kata benda","Существительное","اسم","اسم","ਨਾਂਵ","বিশেষ্য","නාම පදය","名词")
k("typeVerb",
  "Verb","Verbo","Verbo","Verbo","Verbo","Verbe","Verb","क्रिया","فعل","Kata kerja","Глагол",
  "فعل","فعل","ਕਿਰਿਆ","ক্রিয়া","ක්‍රියා පදය","动词")
k("typeAdjective",
  "Adjective","Aggettivo","Adjetivo","Adjetivo","Adjetivo","Adjectif","Adjektiv","विशेषण","صفة",
  "Kata sifat","Прилагательное","صفت","صفت","ਵਿਸ਼ੇਸ਼ਣ","বিশেষণ","විශේෂණ","形容词")
k("typePhrase",
  "Phrase","Frase","Frase","Frase","Frase","Phrase","Satz","वाक्य","عبارة","Frasa","Фраза",
  "جملہ","جملہ","ਵਾਕ","বাক্যাংশ","වාක්‍ය ඛණ්ඩය","短语")

# ---------------------------------------------------------------- search
k("searchHint",
  "Italian, English, اردو, বাংলা…","Italiano, inglese, اردو, বাংলা…",
  "Italiano, inglés, اردو, বাংলা…","Italiano, inglés, اردو, বাংলা…",
  "Italiano, inglês, اردو, বাংলা…","Italien, anglais, اردو, বাংলা…",
  "Italienisch, Englisch, اردو, বাংলা…","इतालवी, अंग्रेज़ी, اردو, বাংলা…",
  "الإيطالية، الإنجليزية، اردو، বাংলা…","Italia, Inggris, اردو, বাংলা…",
  "Итальянский, английский, اردو, বাংলা…","اطالوی، انگریزی، اردو، বাংলা…",
  "اطالوی، انگریزی، اردو، বাংলা…","ਇਤਾਲਵੀ, ਅੰਗਰੇਜ਼ੀ, اردو, বাংলা…",
  "ইতালীয়, ইংরেজি, اردو, বাংলা…","ඉතාලි, ඉංග්‍රීසි, اردو, বাংলা…","意大利语、英语、اردو、বাংলা…")
k("wordsAndPhrases",
  "{words} words · {phrases} phrases","{words} parole · {phrases} frasi",
  "{words} palabras · {phrases} frases","{words} palabras · {phrases} frases",
  "{words} palavras · {phrases} frases","{words} mots · {phrases} phrases",
  "{words} Wörter · {phrases} Sätze","{words} शब्द · {phrases} वाक्य",
  "{words} كلمة · {phrases} عبارة","{words} kata · {phrases} frasa",
  "{words} слов · {phrases} фраз","{words} الفاظ · {phrases} جملے",
  "{words} لفظ · {phrases} جملے","{words} ਸ਼ਬਦ · {phrases} ਵਾਕ",
  "{words} শব্দ · {phrases} বাক্যাংশ","{words} වචන · {phrases} වාක්‍ය","{words} 个单词 · {phrases} 个短语")
k("recentSearches",
  "Recent searches","Ricerche recenti","Búsquedas recientes","Búsquedas recientes",
  "Buscas recentes","Recherches récentes","Letzte Suchen","हाल की खोजें","أحدث عمليات البحث",
  "Pencarian terbaru","Недавние запросы","حالیہ تلاشیں","حالیہ تلاشاں","ਹਾਲੀਆ ਖੋਜਾਂ",
  "সাম্প্রতিক খোঁজ","මෑත සෙවීම්","最近的搜索")
k("clearRecent",
  "Clear","Cancella","Borrar","Borrar","Limpar","Effacer","Löschen","मिटाएँ","حذف","Hapus",
  "Очистить","صاف کریں","صاف کرو","ਸਾਫ਼ ਕਰੋ","মুছুন","ඉවත් කරන්න","清除")
k("noResults",
  "No word found","Nessuna parola trovata","No se encontró ninguna palabra",
  "No se encontró ninguna palabra","Nenhuma palavra encontrada","Aucun mot trouvé",
  "Kein Wort gefunden","कोई शब्द नहीं मिला","لم يتم العثور على كلمة","Kata tidak ditemukan",
  "Слово не найдено","کوئی لفظ نہیں ملا","کوئی لفظ نہیں ملیا","ਕੋਈ ਸ਼ਬਦ ਨਹੀਂ ਮਿਲਿਆ",
  "কোনো শব্দ পাওয়া যায়নি","වචනයක් හමු නොවිණි","未找到单词")
k("didYouMean",
  "Did you mean…?","Volevi dire…?","¿Querías decir…?","¿Querías decir…?","Você quis dizer…?",
  "Vouliez-vous dire…?","Meinten Sie…?","क्या आपका मतलब था…?","هل تقصد…؟","Maksud Anda…?",
  "Возможно, вы имели в виду…?","کیا آپ کا مطلب تھا…؟","کیہ تہانوں ایہ چاہیدا سی…؟",
  "ਕੀ ਤੁਹਾਡਾ ਮਤਲਬ ਸੀ…?","আপনি কি বলতে চেয়েছিলেন…?","ඔබට අදහස් වූයේ…?","您是不是想找…？")
k("searchOnline",
  "Search online","Cerca online","Buscar en línea","Buscar en línea","Pesquisar online",
  "Chercher en ligne","Online suchen","ऑनलाइन खोजें","البحث عبر الإنترنت","Cari online",
  "Искать в интернете","آن لائن تلاش کریں","آن لائن تلاش کرو","ਆਨਲਾਈਨ ਖੋਜੋ","অনলাইনে খুঁজুন",
  "අන්තර්ජාලයේ සොයන්න","在线搜索")
k("searchingOnline",
  "Searching online…","Ricerca online…","Buscando en línea…","Buscando en línea…",
  "Pesquisando online…","Recherche en ligne…","Suche online…","ऑनलाइन खोज रहे हैं…",
  "جارٍ البحث…","Mencari online…","Поиск в интернете…","آن لائن تلاش ہو رہی ہے…",
  "آن لائن تلاش ہو رہی اے…","ਆਨਲਾਈਨ ਖੋਜ ਹੋ ਰਹੀ ਹੈ…","অনলাইনে খোঁজা হচ্ছে…",
  "අන්තර්ජාලයේ සොයමින්…","正在在线搜索…")
k("offlineNotice",
  "You are offline. All words in the app still work.",
  "Sei offline. Tutte le parole dell'app funzionano comunque.",
  "No tienes conexión. Todas las palabras de la app siguen funcionando.",
  "No tienes conexión. Todas las palabras de la app siguen funcionando.",
  "Você está offline. Todas as palavras do app continuam funcionando.",
  "Vous êtes hors ligne. Tous les mots de l'application fonctionnent quand même.",
  "Sie sind offline. Alle Wörter in der App funktionieren weiterhin.",
  "आप ऑफ़लाइन हैं। ऐप के सभी शब्द फिर भी काम करते हैं।",
  "أنت غير متصل بالإنترنت. كل كلمات التطبيق تعمل كما هي.",
  "Anda offline. Semua kata di aplikasi tetap bisa dipakai.",
  "Вы не в сети. Все слова в приложении по-прежнему работают.",
  "آپ آف لائن ہیں۔ ایپ کے تمام الفاظ پھر بھی کام کرتے ہیں۔",
  "تسیں آف لائن او۔ ایپ دے سارے لفظ فیر وی کم کردے نیں۔",
  "ਤੁਸੀਂ ਆਫ਼ਲਾਈਨ ਹੋ। ਐਪ ਦੇ ਸਾਰੇ ਸ਼ਬਦ ਫਿਰ ਵੀ ਕੰਮ ਕਰਦੇ ਹਨ।",
  "আপনি অফলাইনে আছেন। অ্যাপের সব শব্দ তবুও কাজ করে।",
  "ඔබ ඔෆ්ලයින්. යෙදුමේ සියලු වචන තවමත් ක්‍රියා කරයි.",
  "你处于离线状态。应用内的所有单词仍可使用。")
k("onlineResultTitle",
  "From Wiktionary","Da Wikizionario","De Wikcionario","De Wikcionario","Do Wikcionário",
  "Du Wiktionnaire","Aus dem Wiktionary","विक्शनरी से","من ويكاموس","Dari Wiktionary",
  "Из Викисловаря","ویکشنری سے","ویکشنری توں","ਵਿਕਸ਼ਨਰੀ ਤੋਂ","উইকিশনারি থেকে",
  "විකිශබ්දකෝෂයෙන්","来自维基词典")
k("addToMyWords",
  "Add to my words","Aggiungi alle mie parole","Añadir a mis palabras","Agregar a mis palabras",
  "Adicionar às minhas palavras","Ajouter à mes mots","Zu meinen Wörtern","मेरे शब्दों में जोड़ें",
  "أضف إلى كلماتي","Tambah ke kata saya","Добавить в мои слова","میرے الفاظ میں شامل کریں",
  "میرے لفظاں وچ شامل کرو","ਮੇਰੇ ਸ਼ਬਦਾਂ ਵਿੱਚ ਜੋੜੋ","আমার শব্দে যোগ করুন","මගේ වචනවලට එක් කරන්න",
  "添加到我的单词")
k("removeFromMyWords",
  "Remove from my words","Togli dalle mie parole","Quitar de mis palabras","Quitar de mis palabras",
  "Remover das minhas palavras","Retirer de mes mots","Aus meinen Wörtern entfernen",
  "मेरे शब्दों से हटाएँ","إزالة من كلماتي","Hapus dari kata saya","Убрать из моих слов",
  "میرے الفاظ سے نکالیں","میرے لفظاں توں ہٹاؤ","ਮੇਰੇ ਸ਼ਬਦਾਂ ਵਿੱਚੋਂ ਹਟਾਓ","আমার শব্দ থেকে সরান",
  "මගේ වචනවලින් ඉවත් කරන්න","从我的单词中移除")
k("myWordsEmpty",
  "No saved words yet. Use “Add to my words” in Search.",
  "Ancora nessuna parola salvata. Usa “Aggiungi alle mie parole” nella Ricerca.",
  "Aún no hay palabras guardadas. Usa “Añadir a mis palabras” en Buscar.",
  "Aún no hay palabras guardadas. Usa “Agregar a mis palabras” en Buscar.",
  "Ainda não há palavras salvas. Use “Adicionar às minhas palavras” na Busca.",
  "Aucun mot enregistré. Utilisez « Ajouter à mes mots » dans Rechercher.",
  "Noch keine gespeicherten Wörter. Nutzen Sie „Zu meinen Wörtern“ in der Suche.",
  "अभी कोई शब्द सहेजा नहीं गया। खोज में “मेरे शब्दों में जोड़ें” दबाएँ।",
  "لا توجد كلمات محفوظة بعد. استخدم «أضف إلى كلماتي» في البحث.",
  "Belum ada kata tersimpan. Gunakan “Tambah ke kata saya” di Cari.",
  "Пока нет сохранённых слов. Нажмите «Добавить в мои слова» в поиске.",
  "ابھی کوئی لفظ محفوظ نہیں۔ تلاش میں ”میرے الفاظ میں شامل کریں“ دبائیں۔",
  "ہالے کوئی لفظ محفوظ نہیں۔ تلاش وچ ”میرے لفظاں وچ شامل کرو“ دباؤ۔",
  "ਹਾਲੇ ਕੋਈ ਸ਼ਬਦ ਸੰਭਾਲਿਆ ਨਹੀਂ। ਖੋਜ ਵਿੱਚ “ਮੇਰੇ ਸ਼ਬਦਾਂ ਵਿੱਚ ਜੋੜੋ” ਦਬਾਓ।",
  "এখনো কোনো শব্দ সংরক্ষিত নয়। খোঁজে “আমার শব্দে যোগ করুন” চাপুন।",
  "තවම වචන සුරැකී නැත. සෙවීමේ “මගේ වචනවලට එක් කරන්න” භාවිතා කරන්න.",
  "还没有收藏的单词。请在“搜索”中点“添加到我的单词”。")
k("quizOnMyWords",
  "Quiz on my words","Quiz sulle mie parole","Quiz de mis palabras","Quiz de mis palabras",
  "Quiz das minhas palavras","Quiz sur mes mots","Quiz mit meinen Wörtern","मेरे शब्दों का क्विज़",
  "اختبار كلماتي","Kuis kata saya","Тест по моим словам","میرے الفاظ کا کوئز",
  "میرے لفظاں دا کوئز","ਮੇਰੇ ਸ਼ਬਦਾਂ ਦਾ ਕੁਇਜ਼","আমার শব্দের কুইজ","මගේ වචන ප්‍රශ්නාවලිය",
  "我的单词测验")

# ---------------------------------------------------------------- today
k("todayTitle",
  "Today's words","Le parole di oggi","Las palabras de hoy","Las palabras de hoy",
  "As palavras de hoje","Les mots du jour","Wörter des Tages","आज के शब्द","كلمات اليوم",
  "Kata hari ini","Слова дня","آج کے الفاظ","اَج دے لفظ","ਅੱਜ ਦੇ ਸ਼ਬਦ","আজকের শব্দ",
  "අදේ වචන","今天的单词")
k("todayProgress",
  "Word {n} of {total}","Parola {n} di {total}","Palabra {n} de {total}","Palabra {n} de {total}",
  "Palavra {n} de {total}","Mot {n} sur {total}","Wort {n} von {total}","शब्द {n} / {total}",
  "الكلمة {n} من {total}","Kata {n} dari {total}","Слово {n} из {total}","لفظ {n} از {total}",
  "لفظ {n} / {total}","ਸ਼ਬਦ {n} / {total}","শব্দ {n} / {total}","වචනය {n} / {total}",
  "第 {n} / {total} 个单词")
k("streakDays",
  "{n} day streak","{n} giorni di fila","{n} días seguidos","{n} días seguidos",
  "{n} dias seguidos","{n} jours de suite","{n} Tage in Folge","{n} दिन लगातार",
  "{n} أيام متتابعة","{n} hari berturut-turut","{n} дней подряд","{n} دن مسلسل",
  "{n} دن لگاتار","{n} ਦਿਨ ਲਗਾਤਾਰ","{n} দিন টানা","දින {n} ක්","连续 {n} 天")
k("miniQuizCta",
  "Mini-quiz on today's words","Mini-quiz sulle parole di oggi","Mini-quiz de las palabras de hoy",
  "Mini-quiz de las palabras de hoy","Mini-quiz das palavras de hoje","Mini-quiz des mots du jour",
  "Mini-Quiz zu den Wörtern von heute","आज के शब्दों का मिनी क्विज़","اختبار قصير لكلمات اليوم",
  "Kuis mini kata hari ini","Мини-тест по словам дня","آج کے الفاظ کا منی کوئز",
  "اَج دے لفظاں دا منی کوئز","ਅੱਜ ਦੇ ਸ਼ਬਦਾਂ ਦਾ ਮਿਨੀ ਕੁਇਜ਼","আজকের শব্দের মিনি কুইজ",
  "අදේ වචන සඳහා කුඩා ප්‍රශ්නාවලිය","今天单词的小测验")
k("learnedToday",
  "Seen today","Visto oggi","Visto hoy","Visto hoy","Visto hoje","Vu aujourd'hui","Heute gesehen",
  "आज देखा","تمت مشاهدته اليوم","Dilihat hari ini","Просмотрено сегодня","آج دیکھا",
  "اَج ویکھیا","ਅੱਜ ਵੇਖਿਆ","আজ দেখা হয়েছে","අද බැලුවා","今天已看")
k("todayDone",
  "All 10 words seen. Come back tomorrow!","Tutte le 10 parole viste. Torna domani!",
  "Has visto las 10 palabras. ¡Vuelve mañana!","Viste las 10 palabras. ¡Vuelve mañana!",
  "Você viu as 10 palavras. Volte amanhã!","Les 10 mots sont vus. Revenez demain !",
  "Alle 10 Wörter gesehen. Kommen Sie morgen wieder!","सभी 10 शब्द देख लिए। कल फिर आएँ!",
  "شاهدت الكلمات العشر. عد غداً!","Semua 10 kata sudah dilihat. Kembali besok!",
  "Все 10 слов просмотрены. Возвращайтесь завтра!","تمام 10 الفاظ دیکھ لیے۔ کل پھر آئیں!",
  "سارے 10 لفظ ویکھ لئے۔ کل فیر آؤ!","ਸਾਰੇ 10 ਸ਼ਬਦ ਵੇਖ ਲਏ। ਕੱਲ੍ਹ ਫਿਰ ਆਓ!",
  "১০টি শব্দই দেখা হয়েছে। কাল আবার আসুন!","වචන 10 ම බැලුවා. හෙට නැවත එන්න!",
  "10 个单词都看完了，明天再来！")

# ---------------------------------------------------------------- quiz
k("quizPickCategory",
  "Choose a category","Scegli una categoria","Elige una categoría","Elige una categoría",
  "Escolha uma categoria","Choisissez une catégorie","Kategorie wählen","श्रेणी चुनें",
  "اختر فئة","Pilih kategori","Выберите категорию","ایک موضوع چنیں","اک موضوع چنو",
  "ਇੱਕ ਸ਼੍ਰੇਣੀ ਚੁਣੋ","একটি বিভাগ বাছুন","ප්‍රවර්ගයක් තෝරන්න","选择一个类别")
k("mixOfAll",
  "Mix of all","Mix di tutto","Mezcla de todo","Mezcla de todo","Mistura de tudo","Mélange de tout",
  "Alles gemischt","सब मिलाकर","خليط من الكل","Campuran semua","Всё вместе","سب کا مکس",
  "سب دا مکس","ਸਭ ਦਾ ਮਿਕਸ","সব মিলিয়ে","සියල්ල මිශ්‍ර","全部混合")
k("quizProgress",
  "Question {n} of {total}","Domanda {n} di {total}","Pregunta {n} de {total}",
  "Pregunta {n} de {total}","Pergunta {n} de {total}","Question {n} sur {total}",
  "Frage {n} von {total}","प्रश्न {n} / {total}","السؤال {n} من {total}","Soal {n} dari {total}",
  "Вопрос {n} из {total}","سوال {n} از {total}","سوال {n} / {total}","ਸਵਾਲ {n} / {total}",
  "প্রশ্ন {n} / {total}","ප්‍රශ්නය {n} / {total}","第 {n} / {total} 题")
k("quizQuestionPrompt",
  "Does the word match the picture?","La parola corrisponde all'immagine?",
  "¿La palabra corresponde a la imagen?","¿La palabra corresponde a la imagen?",
  "A palavra combina com a imagem?","Le mot correspond-il à l'image ?",
  "Passt das Wort zum Bild?","क्या शब्द तस्वीर से मेल खाता है?","هل تطابق الكلمة الصورة؟",
  "Apakah kata ini sesuai dengan gambar?","Слово соответствует картинке?",
  "کیا لفظ تصویر سے میل کھاتا ہے؟","کیہ لفظ تصویر نال ملدا اے؟",
  "ਕੀ ਸ਼ਬਦ ਤਸਵੀਰ ਨਾਲ ਮੇਲ ਖਾਂਦਾ ਹੈ?","শব্দটি কি ছবির সঙ্গে মেলে?","වචනය පින්තූරයට ගැළපේද?",
  "这个单词和图片相符吗？")
same("vero", "VERO")
same("falso", "FALSO")
k("veroHint",
  "true","vero","verdadero","verdadero","verdadeiro","vrai","richtig","सही","صحيح","benar",
  "верно","درست","درست","ਸਹੀ","সত্য","සත්‍ය","正确")
k("falsoHint",
  "false","falso","falso","falso","falso","faux","falsch","गलत","خطأ","salah","неверно",
  "غلط","غلط","ਗਲਤ","মিথ্যা","අසත්‍ය","错误")
k("answerCorrect",
  "Correct!","Giusto!","¡Correcto!","¡Correcto!","Correto!","Correct !","Richtig!","सही!",
  "صحيح!","Benar!","Верно!","درست!","درست!","ਸਹੀ!","সঠিক!","නිවැරදි!","正确！")
k("answerWrong",
  "Wrong","Sbagliato","Incorrecto","Incorrecto","Errado","Faux","Falsch","गलत","خطأ","Salah",
  "Неверно","غلط","غلط","ਗਲਤ","ভুল","වැරදි","错误")
k("correctAnswerIs",
  "The right word is:","La parola giusta è:","La palabra correcta es:","La palabra correcta es:",
  "A palavra certa é:","Le bon mot est :","Das richtige Wort ist:","सही शब्द है:",
  "الكلمة الصحيحة هي:","Kata yang benar:","Правильное слово:","صحیح لفظ یہ ہے:",
  "صحیح لفظ ایہ اے:","ਸਹੀ ਸ਼ਬਦ ਹੈ:","সঠিক শব্দ হলো:","නිවැරදි වචනය:","正确的单词是：")
k("quizResultTitle",
  "Your result","Il tuo risultato","Tu resultado","Tu resultado","Seu resultado","Votre résultat",
  "Ihr Ergebnis","आपका परिणाम","نتيجتك","Hasil Anda","Ваш результат","آپ کا نتیجہ",
  "تہاڈا نتیجہ","ਤੁਹਾਡਾ ਨਤੀਜਾ","আপনার ফলাফল","ඔබේ ප්‍රතිඵලය","你的成绩")
k("scoreOutOf",
  "{score} / {total}","{score} / {total}","{score} / {total}","{score} / {total}",
  "{score} / {total}","{score} / {total}","{score} / {total}","{score} / {total}",
  "{score} / {total}","{score} / {total}","{score} / {total}","{score} / {total}",
  "{score} / {total}","{score} / {total}","{score} / {total}","{score} / {total}","{score} / {total}")
k("passed",
  "PASSED","PROMOSSO","APROBADO","APROBADO","APROVADO","RÉUSSI","BESTANDEN","पास","ناجح",
  "LULUS","СДАНО","پاس","پاس","ਪਾਸ","পাস","සමත්","通过")
k("notPassed",
  "NOT PASSED","NON PROMOSSO","NO APROBADO","NO APROBADO","NÃO APROVADO","NON RÉUSSI",
  "NICHT BESTANDEN","फेल","غير ناجح","TIDAK LULUS","НЕ СДАНО","پاس نہیں","پاس نہیں",
  "ਪਾਸ ਨਹੀਂ","পাস নয়","අසමත්","未通过")
k("passRule",
  "Pass with 2 mistakes or fewer","Si passa con massimo 2 errori",
  "Se aprueba con 2 errores como máximo","Se aprueba con 2 errores como máximo",
  "Aprova com no máximo 2 erros","Réussi avec 2 erreurs au maximum",
  "Bestanden mit höchstens 2 Fehlern","2 या कम गलतियों पर पास","تنجح بخطأين كحد أقصى",
  "Lulus dengan maksimal 2 kesalahan","Сдано при 2 ошибках или меньше",
  "2 یا کم غلطیوں پر پاس","2 یا کم غلطیاں تے پاس","2 ਜਾਂ ਘੱਟ ਗਲਤੀਆਂ ਤੇ ਪਾਸ",
  "২টি বা কম ভুলে পাস","වැරදි 2ක් හෝ අඩු නම් සමත්","错 2 题以内算通过")
k("mistakesCount",
  "{n} mistakes","{n} errori","{n} errores","{n} errores","{n} erros","{n} erreurs","{n} Fehler",
  "{n} गलतियाँ","{n} أخطاء","{n} kesalahan","{n} ошибок","{n} غلطیاں","{n} غلطیاں",
  "{n} ਗਲਤੀਆਂ","{n} ভুল","වැරදි {n}","错 {n} 题")
k("noMistakes",
  "No mistakes. Perfect!","Nessun errore. Perfetto!","Sin errores. ¡Perfecto!",
  "Sin errores. ¡Perfecto!","Sem erros. Perfeito!","Aucune erreur. Parfait !",
  "Keine Fehler. Perfekt!","कोई गलती नहीं। बहुत खूब!","لا أخطاء. ممتاز!","Tanpa kesalahan. Sempurna!",
  "Без ошибок. Отлично!","کوئی غلطی نہیں۔ بہت خوب!","کوئی غلطی نہیں۔ بہت خوب!",
  "ਕੋਈ ਗਲਤੀ ਨਹੀਂ। ਬਹੁਤ ਵਧੀਆ!","কোনো ভুল নেই। দারুণ!","වැරදි නැත. විශිෂ්ටයි!","全对，太棒了！")
k("repeatMistakes",
  "Repeat the mistakes","Ripeti gli errori","Repetir los errores","Repetir los errores",
  "Repetir os erros","Revoir les erreurs","Fehler wiederholen","गलतियाँ दोहराएँ",
  "أعد الأخطاء","Ulangi kesalahan","Повторить ошибки","غلطیاں دہرائیں","غلطیاں دہراؤ",
  "ਗਲਤੀਆਂ ਦੁਹਰਾਓ","ভুলগুলো আবার দেখুন","වැරදි නැවත","重做错题")
k("newQuiz",
  "New quiz","Nuovo quiz","Nuevo quiz","Nuevo quiz","Novo quiz","Nouveau quiz","Neues Quiz",
  "नया क्विज़","اختبار جديد","Kuis baru","Новый тест","نیا کوئز","نواں کوئز","ਨਵਾਂ ਕੁਇਜ਼",
  "নতুন কুইজ","නව ප්‍රශ්නාවලිය","新测验")
k("bestScoreValue",
  "Best: {score}/{total}","Record: {score}/{total}","Mejor: {score}/{total}",
  "Mejor: {score}/{total}","Melhor: {score}/{total}","Record : {score}/{total}",
  "Bestwert: {score}/{total}","सर्वश्रेष्ठ: {score}/{total}","الأفضل: {score}/{total}",
  "Terbaik: {score}/{total}","Лучший: {score}/{total}","بہترین: {score}/{total}",
  "ودھیا: {score}/{total}","ਸਭ ਤੋਂ ਵਧੀਆ: {score}/{total}","সেরা: {score}/{total}",
  "හොඳම: {score}/{total}","最佳：{score}/{total}")
k("quizNotEnoughWords",
  "This category needs more words for a quiz.",
  "Questa categoria ha bisogno di più parole per il quiz.",
  "Esta categoría necesita más palabras para el quiz.",
  "Esta categoría necesita más palabras para el quiz.",
  "Esta categoria precisa de mais palavras para o quiz.",
  "Cette catégorie a besoin de plus de mots pour un quiz.",
  "Diese Kategorie braucht mehr Wörter für ein Quiz.",
  "इस श्रेणी में क्विज़ के लिए और शब्द चाहिए।",
  "تحتاج هذه الفئة إلى كلمات أكثر للاختبار.",
  "Kategori ini butuh lebih banyak kata untuk kuis.",
  "Для теста в этой категории нужно больше слов.",
  "اس موضوع میں کوئز کے لیے مزید الفاظ درکار ہیں۔",
  "ایس موضوع وچ کوئز لئی ہور لفظ چاہیدے نیں۔",
  "ਇਸ ਸ਼੍ਰੇਣੀ ਵਿੱਚ ਕੁਇਜ਼ ਲਈ ਹੋਰ ਸ਼ਬਦ ਚਾਹੀਦੇ ਹਨ।",
  "এই বিভাগে কুইজের জন্য আরও শব্দ দরকার।",
  "මෙම ප්‍රවර්ගයට ප්‍රශ්නාවලියක් සඳහා තවත් වචන අවශ්‍යයි.",
  "该类别的单词数量不足，无法测验。")

# ---------------------------------------------------------------- topics
k("topicsSubtitle",
  "Learn by category","Impara per categoria","Aprende por categoría","Aprende por categoría",
  "Aprenda por categoria","Apprendre par catégorie","Nach Kategorie lernen","श्रेणी से सीखें",
  "تعلّم حسب الفئة","Belajar per kategori","Учитесь по категориям","موضوع کے حساب سے سیکھیں",
  "موضوع مطابق سکھو","ਸ਼੍ਰੇਣੀ ਅਨੁਸਾਰ ਸਿੱਖੋ","বিভাগ অনুযায়ী শিখুন","ප්‍රවර්ග අනුව ඉගෙන ගන්න",
  "按类别学习")
k("nWords",
  "{n} words","{n} parole","{n} palabras","{n} palabras","{n} palavras","{n} mots","{n} Wörter",
  "{n} शब्द","{n} كلمة","{n} kata","{n} слов","{n} الفاظ","{n} لفظ","{n} ਸ਼ਬਦ","{n} শব্দ",
  "වචන {n}","{n} 个单词")
k("nLearned",
  "{n} learned","{n} imparate","{n} aprendidas","{n} aprendidas","{n} aprendidas","{n} appris",
  "{n} gelernt","{n} सीखे","{n} متعلّمة","{n} dipelajari","{n} изучено","{n} سیکھے","{n} سکھے",
  "{n} ਸਿੱਖੇ","{n} শেখা হয়েছে","ඉගෙන ගත් {n}","已掌握 {n} 个")
k("flashcards",
  "Flashcards","Flashcard","Tarjetas","Tarjetas","Cartões","Cartes","Lernkarten","फ़्लैशकार्ड",
  "بطاقات","Kartu","Карточки","فلیش کارڈ","فلیش کارڈ","ਫਲੈਸ਼ਕਾਰਡ","ফ্ল্যাশকার্ড","කාඩ්පත්",
  "单词卡")
k("quiz20",
  "Quiz 20","Quiz 20","Quiz 20","Quiz 20","Quiz 20","Quiz 20","Quiz 20","क्विज़ 20","اختبار 20",
  "Kuis 20","Тест 20","کوئز 20","کوئز 20","ਕੁਇਜ਼ 20","কুইজ ২০","ප්‍රශ්න 20","20 题测验")
k("flashcardTapToFlip",
  "Tap the card to see the translation","Tocca la carta per vedere la traduzione",
  "Toca la tarjeta para ver la traducción","Toca la tarjeta para ver la traducción",
  "Toque no cartão para ver a tradução","Touchez la carte pour voir la traduction",
  "Karte antippen, um die Übersetzung zu sehen","अनुवाद देखने के लिए कार्ड दबाएँ",
  "اضغط على البطاقة لرؤية الترجمة","Sentuh kartu untuk melihat terjemahan",
  "Нажмите карточку, чтобы увидеть перевод","ترجمہ دیکھنے کے لیے کارڈ دبائیں",
  "ترجمہ ویکھن لئی کارڈ دباؤ","ਅਨੁਵਾਦ ਵੇਖਣ ਲਈ ਕਾਰਡ ਦਬਾਓ","অনুবাদ দেখতে কার্ডে চাপ দিন",
  "පරිවර්තනය බැලීමට කාඩ්පත ස්පර්ශ කරන්න","点击卡片查看翻译")

# ---------------------------------------------------------------- settings
k("interfaceLanguage",
  "Interface language","Lingua dell'app","Idioma de la app","Idioma de la app",
  "Idioma do app","Langue de l'application","App-Sprache","ऐप की भाषा","لغة التطبيق",
  "Bahasa aplikasi","Язык приложения","ایپ کی زبان","ایپ دی زبان","ਐਪ ਦੀ ਭਾਸ਼ਾ","অ্যাপের ভাষা",
  "යෙදුම් භාෂාව","界面语言")
k("audioSpeed",
  "Audio speed","Velocità dell'audio","Velocidad del audio","Velocidad del audio",
  "Velocidade do áudio","Vitesse de l'audio","Audiogeschwindigkeit","ऑडियो की गति",
  "سرعة الصوت","Kecepatan audio","Скорость речи","آواز کی رفتار","آواز دی رفتار",
  "ਆਵਾਜ਼ ਦੀ ਰਫ਼ਤਾਰ","অডিওর গতি","හඬ වේගය","朗读速度")
k("dailyReminder",
  "Daily reminder","Promemoria giornaliero","Recordatorio diario","Recordatorio diario",
  "Lembrete diário","Rappel quotidien","Tägliche Erinnerung","रोज़ाना याद दिलाना",
  "تذكير يومي","Pengingat harian","Ежедневное напоминание","روزانہ یاد دہانی",
  "روزانہ یاد دہانی","ਰੋਜ਼ਾਨਾ ਯਾਦ","প্রতিদিনের রিমাইন্ডার","දිනපතා මතක් කිරීම","每日提醒")
k("reminderTime",
  "Reminder time","Ora del promemoria","Hora del recordatorio","Hora del recordatorio",
  "Hora do lembrete","Heure du rappel","Uhrzeit der Erinnerung","याद दिलाने का समय",
  "وقت التذكير","Waktu pengingat","Время напоминания","یاد دہانی کا وقت","یاد دہانی دا ویلا",
  "ਯਾਦ ਦਾ ਸਮਾਂ","রিমাইন্ডারের সময়","මතක් කරන වේලාව","提醒时间")
k("reminderBody",
  "10 new Italian words are waiting for you.","Ti aspettano 10 nuove parole italiane.",
  "Te esperan 10 palabras italianas nuevas.","Te esperan 10 palabras italianas nuevas.",
  "10 novas palavras italianas esperam por você.","10 nouveaux mots italiens vous attendent.",
  "10 neue italienische Wörter warten auf Sie.","10 नए इतालवी शब्द आपका इंतज़ार कर रहे हैं।",
  "10 كلمات إيطالية جديدة تنتظرك.","10 kata Italia baru menunggu Anda.",
  "Вас ждут 10 новых итальянских слов.","10 نئے اطالوی الفاظ آپ کے منتظر ہیں۔",
  "10 نویں اطالوی لفظ تہاڈی اڈیک وچ نیں۔","10 ਨਵੇਂ ਇਤਾਲਵੀ ਸ਼ਬਦ ਤੁਹਾਡੀ ਉਡੀਕ ਕਰ ਰਹੇ ਹਨ।",
  "১০টি নতুন ইতালীয় শব্দ আপনার জন্য অপেক্ষা করছে।","නව ඉතාලි වචන 10 ඔබ එනතුරු.",
  "10 个新的意大利语单词在等你。")
k("darkMode",
  "Dark mode","Modalità scura","Modo oscuro","Modo oscuro","Modo escuro","Mode sombre",
  "Dunkler Modus","डार्क मोड","الوضع الداكن","Mode gelap","Тёмная тема","ڈارک موڈ","ڈارک موڈ",
  "ਡਾਰਕ ਮੋਡ","ডার্ক মোড","අඳුරු තේමාව","深色模式")
k("resetProgress",
  "Reset progress","Azzera i progressi","Borrar progreso","Borrar progreso","Apagar progresso",
  "Réinitialiser la progression","Fortschritt zurücksetzen","प्रगति मिटाएँ","إعادة ضبط التقدّم",
  "Reset kemajuan","Сбросить прогресс","پیش رفت مٹائیں","ترقی مٹاؤ","ਪ੍ਰਗਤੀ ਮਿਟਾਓ",
  "অগ্রগতি মুছুন","ප්‍රගතිය මකන්න","重置进度")
k("resetProgressConfirm",
  "Delete streak, scores and saved words?","Cancellare serie, punteggi e parole salvate?",
  "¿Borrar racha, puntuaciones y palabras guardadas?",
  "¿Borrar racha, puntuaciones y palabras guardadas?",
  "Apagar sequência, pontuações e palavras salvas?",
  "Supprimer la série, les scores et les mots enregistrés ?",
  "Serie, Ergebnisse und gespeicherte Wörter löschen?",
  "स्ट्रीक, स्कोर और सहेजे शब्द मिटाएँ?",
  "حذف السلسلة والنتائج والكلمات المحفوظة؟",
  "Hapus streak, skor, dan kata tersimpan?",
  "Удалить серию, результаты и сохранённые слова?",
  "سلسلہ، اسکور اور محفوظ الفاظ مٹا دیں؟",
  "سلسلہ، اسکور تے محفوظ لفظ مٹا دیئے جان؟",
  "ਸਟ੍ਰੀਕ, ਸਕੋਰ ਅਤੇ ਸੰਭਾਲੇ ਸ਼ਬਦ ਮਿਟਾਉਣੇ?",
  "স্ট্রিক, স্কোর ও সংরক্ষিত শব্দ মুছবেন?",
  "දිනදාම, ලකුණු සහ සුරැකි වචන මකන්නද?",
  "要删除连续天数、成绩和收藏的单词吗？")
k("resetDone",
  "Progress reset","Progressi azzerati","Progreso borrado","Progreso borrado",
  "Progresso apagado","Progression réinitialisée","Fortschritt zurückgesetzt","प्रगति मिट गई",
  "تمت إعادة الضبط","Kemajuan direset","Прогресс сброшен","پیش رفت مٹ گئی","ترقی مٹ گئی",
  "ਪ੍ਰਗਤੀ ਮਿਟ ਗਈ","অগ্রগতি মোছা হয়েছে","ප්‍රගතිය මකා ඇත","进度已重置")
k("privacy",
  "Privacy","Privacy","Privacidad","Privacidad","Privacidade","Confidentialité","Datenschutz",
  "निजता","الخصوصية","Privasi","Конфиденциальность","پرائیویسی","پرائیویسی","ਪਰਦੇਦਾਰੀ",
  "গোপনীয়তা","රහස්‍යතාව","隐私")
k("about",
  "About & credits","Info e crediti","Acerca de y créditos","Acerca de y créditos",
  "Sobre e créditos","À propos et crédits","Über & Credits","ऐप के बारे में","حول التطبيق",
  "Tentang & kredit","О приложении","ایپ کے بارے میں","ایپ بارے","ਐਪ ਬਾਰੇ","অ্যাপ সম্পর্কে",
  "යෙදුම ගැන","关于与致谢")
k("adsConsentChange",
  "Change ads consent","Modifica consenso pubblicità","Cambiar consentimiento de anuncios",
  "Cambiar consentimiento de anuncios","Alterar consentimento de anúncios",
  "Modifier le consentement publicitaire","Werbe-Einwilligung ändern","विज्ञापन सहमति बदलें",
  "تغيير موافقة الإعلانات","Ubah izin iklan","Изменить согласие на рекламу",
  "اشتہارات کی رضامندی بدلیں","اشتہاراں دی رضامندی بدلو","ਵਿਗਿਆਪਨ ਸਹਿਮਤੀ ਬਦਲੋ",
  "বিজ্ঞাপনের সম্মতি বদলান","දැන්වීම් අනුමැතිය වෙනස් කරන්න","更改广告授权")

# ---------------------------------------------------------------- purchase
k("removeAds",
  "Remove ads","Togli la pubblicità","Quitar anuncios","Quitar anuncios","Remover anúncios",
  "Supprimer les publicités","Werbung entfernen","विज्ञापन हटाएँ","إزالة الإعلانات",
  "Hapus iklan","Убрать рекламу","اشتہارات ہٹائیں","اشتہار ہٹاؤ","ਵਿਗਿਆਪਨ ਹਟਾਓ",
  "বিজ্ঞাপন সরান","දැන්වීම් ඉවත් කරන්න","去除广告")
k("removeAdsBody",
  "One payment, no ads ever again. All words, topics and quizzes stay free.",
  "Un solo pagamento, mai più pubblicità. Parole, argomenti e quiz restano gratis.",
  "Un solo pago, nunca más anuncios. Palabras, temas y quizzes siguen gratis.",
  "Un solo pago, nunca más anuncios. Palabras, temas y quizzes siguen gratis.",
  "Um único pagamento, nunca mais anúncios. Palavras, temas e quizzes continuam grátis.",
  "Un seul paiement, plus aucune publicité. Mots, thèmes et quiz restent gratuits.",
  "Eine Zahlung, nie wieder Werbung. Wörter, Themen und Quiz bleiben kostenlos.",
  "एक बार भुगतान, फिर कोई विज्ञापन नहीं। सभी शब्द, विषय और क्विज़ मुफ़्त रहते हैं।",
  "دفعة واحدة وبلا إعلانات للأبد. كل الكلمات والمواضيع والاختبارات تبقى مجانية.",
  "Sekali bayar, tanpa iklan selamanya. Semua kata, topik, dan kuis tetap gratis.",
  "Один платёж — и больше никакой рекламы. Все слова, темы и тесты остаются бесплатными.",
  "ایک بار ادائیگی، پھر کبھی اشتہار نہیں۔ تمام الفاظ، موضوعات اور کوئز مفت رہتے ہیں۔",
  "اک واری ادائیگی، فیر کدے اشتہار نہیں۔ سارے لفظ، موضوع تے کوئز مفت رہندے نیں۔",
  "ਇੱਕ ਵਾਰ ਭੁਗਤਾਨ, ਫਿਰ ਕੋਈ ਵਿਗਿਆਪਨ ਨਹੀਂ। ਸਾਰੇ ਸ਼ਬਦ, ਵਿਸ਼ੇ ਅਤੇ ਕੁਇਜ਼ ਮੁਫ਼ਤ ਰਹਿੰਦੇ ਹਨ।",
  "একবার পেমেন্ট, আর কখনো বিজ্ঞাপন নয়। সব শব্দ, বিষয় ও কুইজ বিনামূল্যেই থাকে।",
  "එක් ගෙවීමක්, නැවත දැන්වීම් නැත. සියලු වචන, මාතෘකා සහ ප්‍රශ්නාවලි නොමිලේ.",
  "一次付费，永久无广告。所有单词、主题和测验依旧免费。")
k("buy",
  "Buy","Acquista","Comprar","Comprar","Comprar","Acheter","Kaufen","खरीदें","شراء","Beli",
  "Купить","خریدیں","خریدو","ਖਰੀਦੋ","কিনুন","මිලදී ගන්න","购买")
k("restorePurchases",
  "Restore purchases","Ripristina acquisti","Restaurar compras","Restaurar compras",
  "Restaurar compras","Restaurer les achats","Käufe wiederherstellen","खरीद बहाल करें",
  "استعادة الشراء","Pulihkan pembelian","Восстановить покупки","خریداری بحال کریں",
  "خریداری بحال کرو","ਖਰੀਦ ਬਹਾਲ ਕਰੋ","কেনাকাটা ফেরান","මිලදී ගැනීම් ප්‍රතිස්ථාපනය","恢复购买")
k("adsRemoved",
  "Ads removed. Thank you!","Pubblicità rimossa. Grazie!","Anuncios eliminados. ¡Gracias!",
  "Anuncios eliminados. ¡Gracias!","Anúncios removidos. Obrigado!",
  "Publicités supprimées. Merci !","Werbung entfernt. Danke!","विज्ञापन हट गए। धन्यवाद!",
  "تمت إزالة الإعلانات. شكراً!","Iklan dihapus. Terima kasih!","Реклама убрана. Спасибо!",
  "اشتہارات ہٹ گئے۔ شکریہ!","اشتہار ہٹ گئے۔ شکریہ!","ਵਿਗਿਆਪਨ ਹਟ ਗਏ। ਧੰਨਵਾਦ!",
  "বিজ্ঞাপন সরানো হয়েছে। ধন্যবাদ!","දැන්වීම් ඉවත් කළා. ස්තූතියි!","广告已去除，谢谢！")
k("purchasePending",
  "Payment in progress…","Pagamento in corso…","Pago en curso…","Pago en curso…",
  "Pagamento em andamento…","Paiement en cours…","Zahlung läuft…","भुगतान जारी है…",
  "جارٍ الدفع…","Pembayaran diproses…","Платёж обрабатывается…","ادائیگی جاری ہے…",
  "ادائیگی جاری اے…","ਭੁਗਤਾਨ ਚੱਲ ਰਿਹਾ ਹੈ…","পেমেন্ট চলছে…","ගෙවීම සිදුවෙමින්…","支付进行中…")
k("purchaseError",
  "The purchase did not go through.","L'acquisto non è andato a buon fine.",
  "La compra no se completó.","La compra no se completó.","A compra não foi concluída.",
  "L'achat n'a pas abouti.","Der Kauf ist nicht abgeschlossen worden.","खरीद पूरी नहीं हुई।",
  "لم تكتمل عملية الشراء.","Pembelian tidak berhasil.","Покупка не прошла.",
  "خریداری مکمل نہیں ہوئی۔","خریداری مکمل نہیں ہوئی۔","ਖਰੀਦ ਪੂਰੀ ਨਹੀਂ ਹੋਈ।",
  "কেনাকাটা সম্পন্ন হয়নি।","මිලදී ගැනීම සම්පූර්ණ නොවිණි.","购买未完成。")
k("nothingToRestore",
  "No earlier purchase found.","Nessun acquisto precedente trovato.",
  "No se encontró ninguna compra anterior.","No se encontró ninguna compra anterior.",
  "Nenhuma compra anterior encontrada.","Aucun achat précédent trouvé.",
  "Kein früherer Kauf gefunden.","कोई पुरानी खरीद नहीं मिली।","لم يتم العثور على شراء سابق.",
  "Tidak ada pembelian sebelumnya.","Прежних покупок не найдено.","کوئی سابقہ خریداری نہیں ملی۔",
  "کوئی پہلی خریداری نہیں ملی۔","ਕੋਈ ਪੁਰਾਣੀ ਖਰੀਦ ਨਹੀਂ ਮਿਲੀ।","আগের কোনো কেনাকাটা পাওয়া যায়নি।",
  "පෙර මිලදී ගැනීමක් හමු නොවිණි.","未找到以往的购买记录。")
k("webPurchaseNotice",
  "Purchases are available in the Android and iPhone app.",
  "Gli acquisti sono disponibili nell'app Android e iPhone.",
  "Las compras están disponibles en la app de Android y iPhone.",
  "Las compras están disponibles en la app de Android y iPhone.",
  "As compras estão disponíveis no app Android e iPhone.",
  "Les achats sont disponibles dans l'application Android et iPhone.",
  "Käufe sind in der Android- und iPhone-App verfügbar.",
  "खरीद Android और iPhone ऐप में उपलब्ध है।",
  "الشراء متاح في تطبيق Android و iPhone.",
  "Pembelian tersedia di aplikasi Android dan iPhone.",
  "Покупки доступны в приложении для Android и iPhone.",
  "خریداری Android اور iPhone ایپ میں دستیاب ہے۔",
  "خریداری Android تے iPhone ایپ وچ دستیاب اے۔",
  "ਖਰੀਦ Android ਅਤੇ iPhone ਐਪ ਵਿੱਚ ਉਪਲਬਧ ਹੈ।",
  "কেনাকাটা Android ও iPhone অ্যাপে পাওয়া যায়।",
  "මිලදී ගැනීම් Android සහ iPhone යෙදුමේ ඇත.",
  "购买功能在 Android 和 iPhone 应用中提供。")
k("storeUnavailable",
  "The store is not available right now.","Lo store non è disponibile in questo momento.",
  "La tienda no está disponible ahora.","La tienda no está disponible ahora.",
  "A loja não está disponível agora.","La boutique n'est pas disponible pour le moment.",
  "Der Store ist gerade nicht verfügbar.","स्टोर अभी उपलब्ध नहीं है।","المتجر غير متاح حالياً.",
  "Toko tidak tersedia saat ini.","Магазин сейчас недоступен.","اسٹور ابھی دستیاب نہیں ہے۔",
  "اسٹور ہُݨ دستیاب نہیں۔","ਸਟੋਰ ਹੁਣ ਉਪਲਬਧ ਨਹੀਂ ਹੈ।","স্টোর এখন পাওয়া যাচ্ছে না।",
  "වෙළඳසැල දැන් නොමැත.","商店当前不可用。")

# ---------------------------------------------------------------- tts help
k("voiceHelpTitle",
  "Install the Italian voice","Installa la voce italiana","Instala la voz italiana",
  "Instala la voz italiana","Instale a voz italiana","Installer la voix italienne",
  "Italienische Stimme installieren","इतालवी आवाज़ इंस्टॉल करें","تثبيت الصوت الإيطالي",
  "Pasang suara Italia","Установите итальянский голос","اطالوی آواز انسٹال کریں",
  "اطالوی آواز انسٹال کرو","ਇਤਾਲਵੀ ਆਵਾਜ਼ ਇੰਸਟਾਲ ਕਰੋ","ইতালীয় ভয়েস ইনস্টল করুন",
  "ඉතාලි හඬ ස්ථාපනය කරන්න","安装意大利语语音")
k("voiceHelpBody",
  "Your phone has no Italian voice yet. Open Settings › System › Languages › Text-to-speech, choose the Google speech engine and install Italian. Reading the words works anyway.",
  "Il telefono non ha ancora una voce italiana. Apri Impostazioni › Sistema › Lingue › Sintesi vocale, scegli il motore Google e installa l'italiano. Leggere le parole funziona comunque.",
  "Tu teléfono aún no tiene voz italiana. Abre Ajustes › Sistema › Idiomas › Texto a voz, elige el motor de Google e instala el italiano. Leer las palabras funciona igual.",
  "Tu teléfono aún no tiene voz italiana. Abre Configuración › Sistema › Idiomas › Texto a voz, elige el motor de Google e instala el italiano. Leer las palabras funciona igual.",
  "Seu telefone ainda não tem voz italiana. Abra Configurações › Sistema › Idiomas › Conversão de texto em voz, escolha o mecanismo do Google e instale o italiano. Ler as palavras funciona do mesmo jeito.",
  "Votre téléphone n'a pas encore de voix italienne. Ouvrez Réglages › Système › Langues › Synthèse vocale, choisissez le moteur Google et installez l'italien. La lecture des mots fonctionne quand même.",
  "Ihr Telefon hat noch keine italienische Stimme. Öffnen Sie Einstellungen › System › Sprachen › Text-in-Sprache, wählen Sie die Google-Engine und installieren Sie Italienisch. Das Lesen der Wörter funktioniert trotzdem.",
  "आपके फ़ोन में इतालवी आवाज़ नहीं है। सेटिंग्स › सिस्टम › भाषाएँ › टेक्स्ट-टू-स्पीच खोलें, Google इंजन चुनें और इतालवी इंस्टॉल करें। शब्द पढ़ना फिर भी काम करता है।",
  "لا يوجد صوت إيطالي على هاتفك. افتح الإعدادات › النظام › اللغات › تحويل النص إلى كلام، اختر محرّك Google وثبّت الإيطالية. قراءة الكلمات تعمل على أي حال.",
  "Ponsel Anda belum memiliki suara Italia. Buka Pengaturan › Sistem › Bahasa › Teks ke ucapan, pilih mesin Google dan pasang bahasa Italia. Membaca kata tetap bisa.",
  "На телефоне ещё нет итальянского голоса. Откройте Настройки › Система › Языки › Синтез речи, выберите движок Google и установите итальянский. Читать слова можно и так.",
  "آپ کے فون میں ابھی اطالوی آواز نہیں ہے۔ ترتیبات › سسٹم › زبانیں › ٹیکسٹ ٹو اسپیچ کھولیں، Google انجن چنیں اور اطالوی انسٹال کریں۔ الفاظ پڑھنا پھر بھی کام کرتا ہے۔",
  "تہاڈے فون وچ ہالے اطالوی آواز نہیں۔ سیٹنگاں › سسٹم › زباناں › ٹیکسٹ ٹو اسپیچ کھولو، Google انجن چنو تے اطالوی انسٹال کرو۔ لفظ پڑھنا فیر وی کم کردا اے۔",
  "ਤੁਹਾਡੇ ਫ਼ੋਨ ਵਿੱਚ ਹਾਲੇ ਇਤਾਲਵੀ ਆਵਾਜ਼ ਨਹੀਂ ਹੈ। ਸੈਟਿੰਗਾਂ › ਸਿਸਟਮ › ਭਾਸ਼ਾਵਾਂ › ਟੈਕਸਟ-ਟੂ-ਸਪੀਚ ਖੋਲ੍ਹੋ, Google ਇੰਜਨ ਚੁਣੋ ਅਤੇ ਇਤਾਲਵੀ ਇੰਸਟਾਲ ਕਰੋ। ਸ਼ਬਦ ਪੜ੍ਹਨਾ ਫਿਰ ਵੀ ਕੰਮ ਕਰਦਾ ਹੈ।",
  "আপনার ফোনে এখনো ইতালীয় ভয়েস নেই। সেটিংস › সিস্টেম › ভাষা › টেক্সট-টু-স্পিচ খুলুন, Google ইঞ্জিন বাছুন এবং ইতালীয় ইনস্টল করুন। শব্দ পড়া তবুও কাজ করে।",
  "ඔබේ දුරකථනයේ තවම ඉතාලි හඬක් නැත. සැකසීම් › පද්ධතිය › භාෂා › පෙළ-සිට-කථනය විවෘත කර, Google එන්ජිම තෝරා ඉතාලි ස්ථාපනය කරන්න. වචන කියවීම කෙසේ වෙතත් ක්‍රියා කරයි.",
  "你的手机还没有意大利语语音。打开 设置 › 系统 › 语言 › 文字转语音，选择 Google 引擎并安装意大利语。阅读单词仍然可用。")

# ---------------------------------------------------------------- privacy / about
k("privacyBody",
  "This app works offline and has no login. Your progress, saved words and settings stay on your phone only. We never collect your name, e-mail or location. Ads come from Google AdMob and are shown only after you accept them in the consent form; you can change your choice at any time in Settings. “Search online” sends only the word you typed to Wiktionary. For ages 13+.",
  "Questa app funziona offline e non richiede login. I tuoi progressi, le parole salvate e le impostazioni restano solo sul tuo telefono. Non raccogliamo nome, e-mail o posizione. La pubblicità viene da Google AdMob e viene mostrata solo dopo la tua accettazione nel modulo di consenso; puoi cambiare scelta quando vuoi nelle Impostazioni. “Cerca online” invia a Wikizionario solo la parola digitata. Per età 13+.",
  "Esta app funciona sin conexión y no necesita inicio de sesión. Tu progreso, tus palabras guardadas y tus ajustes se quedan solo en tu teléfono. Nunca recogemos tu nombre, correo ni ubicación. Los anuncios vienen de Google AdMob y solo se muestran si los aceptas en el formulario de consentimiento; puedes cambiar tu elección en Ajustes. “Buscar en línea” envía a Wikcionario solo la palabra escrita. Para 13 años o más.",
  "Esta app funciona sin conexión y no necesita inicio de sesión. Tu progreso, tus palabras guardadas y tu configuración se quedan solo en tu teléfono. Nunca recogemos tu nombre, correo ni ubicación. Los anuncios vienen de Google AdMob y solo se muestran si los aceptas en el formulario de consentimiento; puedes cambiar tu elección en Configuración. “Buscar en línea” envía a Wikcionario solo la palabra escrita. Para 13 años o más.",
  "Este app funciona offline e não pede login. Seu progresso, palavras salvas e configurações ficam apenas no seu telefone. Nunca coletamos seu nome, e-mail ou localização. Os anúncios vêm do Google AdMob e só aparecem depois de você aceitar no formulário de consentimento; pode mudar a escolha nas Configurações. “Pesquisar online” envia ao Wikcionário apenas a palavra digitada. Para 13+.",
  "Cette application fonctionne hors ligne et sans compte. Votre progression, vos mots enregistrés et vos réglages restent uniquement sur votre téléphone. Nous ne collectons jamais votre nom, votre e-mail ni votre position. Les publicités viennent de Google AdMob et ne s'affichent qu'après votre acceptation dans le formulaire de consentement ; vous pouvez changer d'avis dans les Réglages. « Chercher en ligne » n'envoie au Wiktionnaire que le mot saisi. Pour 13 ans et plus.",
  "Diese App funktioniert offline und ohne Anmeldung. Ihr Fortschritt, Ihre gespeicherten Wörter und Einstellungen bleiben nur auf Ihrem Telefon. Wir erfassen niemals Namen, E-Mail oder Standort. Werbung kommt von Google AdMob und wird nur nach Ihrer Zustimmung im Einwilligungsformular gezeigt; Sie können Ihre Wahl in den Einstellungen jederzeit ändern. „Online suchen“ sendet nur das eingegebene Wort an das Wiktionary. Ab 13 Jahren.",
  "यह ऐप ऑफ़लाइन चलता है और लॉगिन नहीं मांगता। आपकी प्रगति, सहेजे शब्द और सेटिंग्स केवल आपके फ़ोन पर रहती हैं। हम नाम, ई-मेल या लोकेशन कभी नहीं लेते। विज्ञापन Google AdMob से आते हैं और सहमति फ़ॉर्म में स्वीकार करने के बाद ही दिखते हैं; आप सेटिंग्स में कभी भी बदल सकते हैं। “ऑनलाइन खोजें” केवल लिखा शब्द विक्शनरी को भेजता है। 13+ के लिए।",
  "يعمل هذا التطبيق دون إنترنت ولا يطلب تسجيل الدخول. يبقى تقدّمك وكلماتك المحفوظة وإعداداتك على هاتفك فقط. لا نجمع اسمك أو بريدك أو موقعك أبداً. تأتي الإعلانات من Google AdMob ولا تظهر إلا بعد موافقتك في نموذج الموافقة؛ ويمكنك تغيير اختيارك في الإعدادات. «البحث عبر الإنترنت» يرسل الكلمة المكتوبة فقط إلى ويكاموس. للأعمار 13 وما فوق.",
  "Aplikasi ini bekerja offline dan tanpa login. Kemajuan, kata tersimpan, dan pengaturan Anda hanya tersimpan di ponsel. Kami tidak pernah mengumpulkan nama, e-mail, atau lokasi. Iklan berasal dari Google AdMob dan hanya tampil setelah Anda setuju pada formulir izin; Anda dapat mengubahnya di Pengaturan. “Cari online” hanya mengirim kata yang Anda tulis ke Wiktionary. Untuk usia 13+.",
  "Приложение работает без интернета и без входа в аккаунт. Прогресс, сохранённые слова и настройки остаются только на вашем телефоне. Мы никогда не собираем имя, e-mail или местоположение. Реклама — от Google AdMob и показывается только после вашего согласия в форме; изменить выбор можно в настройках. «Искать в интернете» отправляет в Викисловарь только введённое слово. Для 13+.",
  "یہ ایپ آف لائن چلتی ہے اور لاگ اِن نہیں مانگتی۔ آپ کی پیش رفت، محفوظ الفاظ اور ترتیبات صرف آپ کے فون پر رہتی ہیں۔ ہم آپ کا نام، ای میل یا مقام کبھی جمع نہیں کرتے۔ اشتہارات Google AdMob سے آتے ہیں اور رضامندی فارم میں قبول کرنے کے بعد ہی دکھائے جاتے ہیں؛ آپ ترتیبات میں کبھی بھی تبدیل کر سکتے ہیں۔ ”آن لائن تلاش“ صرف لکھا ہوا لفظ ویکشنری کو بھیجتی ہے۔ 13 سال اور اوپر کے لیے۔",
  "ایہ ایپ آف لائن چلدی اے تے لاگ اِن نہیں منگدی۔ تہاڈی ترقی، محفوظ لفظ تے سیٹنگاں صرف تہاڈے فون تے رہندیاں نیں۔ اسیں تہاڈا ناں، ای میل یا مقام کدے جمع نہیں کردے۔ اشتہار Google AdMob توں آؤندے نیں تے رضامندی فارم وچ قبول کرن توں بعد ای دکھائے جاندے نیں؛ تسیں سیٹنگاں وچ کدے وی بدل سکدے او۔ ”آن لائن تلاش“ صرف لکھیا لفظ ویکشنری نوں بھیجدی اے۔ 13 سال تے اوپر لئی۔",
  "ਇਹ ਐਪ ਆਫ਼ਲਾਈਨ ਚੱਲਦੀ ਹੈ ਅਤੇ ਲਾਗ-ਇਨ ਨਹੀਂ ਮੰਗਦੀ। ਤੁਹਾਡੀ ਪ੍ਰਗਤੀ, ਸੰਭਾਲੇ ਸ਼ਬਦ ਅਤੇ ਸੈਟਿੰਗਾਂ ਸਿਰਫ਼ ਤੁਹਾਡੇ ਫ਼ੋਨ ਉੱਤੇ ਰਹਿੰਦੀਆਂ ਹਨ। ਅਸੀਂ ਤੁਹਾਡਾ ਨਾਮ, ਈ-ਮੇਲ ਜਾਂ ਸਥਾਨ ਕਦੇ ਇਕੱਠਾ ਨਹੀਂ ਕਰਦੇ। ਵਿਗਿਆਪਨ Google AdMob ਤੋਂ ਆਉਂਦੇ ਹਨ ਅਤੇ ਸਹਿਮਤੀ ਫਾਰਮ ਵਿੱਚ ਮਨਜ਼ੂਰੀ ਤੋਂ ਬਾਅਦ ਹੀ ਦਿਖਦੇ ਹਨ; ਤੁਸੀਂ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਕਦੇ ਵੀ ਬਦਲ ਸਕਦੇ ਹੋ। “ਆਨਲਾਈਨ ਖੋਜੋ” ਸਿਰਫ਼ ਲਿਖਿਆ ਸ਼ਬਦ ਵਿਕਸ਼ਨਰੀ ਨੂੰ ਭੇਜਦੀ ਹੈ। 13+ ਲਈ।",
  "এই অ্যাপ অফলাইনে চলে এবং লগইন লাগে না। আপনার অগ্রগতি, সংরক্ষিত শব্দ ও সেটিংস কেবল আপনার ফোনেই থাকে। আমরা আপনার নাম, ই-মেইল বা লোকেশন কখনো সংগ্রহ করি না। বিজ্ঞাপন Google AdMob থেকে আসে এবং সম্মতি ফর্মে রাজি হওয়ার পরেই দেখানো হয়; সেটিংসে যেকোনো সময় বদলাতে পারেন। “অনলাইনে খুঁজুন” কেবল লেখা শব্দটি উইকিশনারিতে পাঠায়। ১৩+ বছরের জন্য।",
  "මෙම යෙදුම ඔෆ්ලයින් ක්‍රියා කරයි, පිවිසුමක් අවශ්‍ය නැත. ඔබේ ප්‍රගතිය, සුරැකි වචන සහ සැකසීම් ඔබේ දුරකථනයේ පමණක් රැඳේ. ඔබේ නම, ඊමේල් හෝ ස්ථානය කිසිවිටෙක එකතු නොකරමු. දැන්වීම් Google AdMob වෙතින් පැමිණේ; අනුමැතිය ලබාදීමෙන් පසුව පමණක් පෙන්වයි, සැකසීම්වලින් ඔබේ තේරීම වෙනස් කළ හැක. “අන්තර්ජාලයේ සොයන්න” ඔබ ලියූ වචනය පමණක් විකිශබ්දකෝෂයට යවයි. වයස 13+.",
  "本应用可离线使用，无需登录。你的学习进度、收藏单词和设置只保存在手机本地。我们绝不收集你的姓名、邮箱或位置。广告来自 Google AdMob，只有在你于授权表单中同意后才会显示；你可以随时在设置中更改选择。“在线搜索”仅把你输入的单词发送给维基词典。适合 13 岁以上。")
k("aboutBody",
  "A small, honest app for people living in Italy: search a word, learn ten new ones a day, and test yourself like in the driving-licence quiz. Everything works offline, with no account.",
  "Un'app piccola e onesta per chi vive in Italia: cerca una parola, impara dieci parole nuove al giorno e mettiti alla prova come nel quiz della patente. Tutto funziona offline, senza account.",
  "Una app pequeña y honesta para quien vive en Italia: busca una palabra, aprende diez nuevas al día y ponte a prueba como en el examen de conducir. Todo funciona sin conexión y sin cuenta.",
  "Una app pequeña y honesta para quien vive en Italia: busca una palabra, aprende diez nuevas al día y ponte a prueba como en el examen de manejo. Todo funciona sin conexión y sin cuenta.",
  "Um app pequeno e honesto para quem vive na Itália: busque uma palavra, aprenda dez novas por dia e teste-se como na prova de direção. Tudo funciona offline, sem conta.",
  "Une petite application honnête pour celles et ceux qui vivent en Italie : cherchez un mot, apprenez dix nouveaux mots par jour et testez-vous comme à l'examen du permis. Tout fonctionne hors ligne, sans compte.",
  "Eine kleine, ehrliche App für Menschen, die in Italien leben: ein Wort suchen, täglich zehn neue lernen und sich wie bei der Führerscheinprüfung testen. Alles funktioniert offline, ohne Konto.",
  "इटली में रहने वालों के लिए एक छोटा, ईमानदार ऐप: शब्द खोजें, रोज़ दस नए शब्द सीखें और ड्राइविंग टेस्ट जैसे खुद को परखें। सब कुछ ऑफ़लाइन चलता है, बिना अकाउंट।",
  "تطبيق صغير وصادق لمن يعيش في إيطاليا: ابحث عن كلمة، تعلّم عشر كلمات جديدة كل يوم، واختبر نفسك كما في اختبار رخصة القيادة. كل شيء يعمل دون إنترنت وبلا حساب.",
  "Aplikasi kecil dan jujur untuk Anda yang tinggal di Italia: cari sebuah kata, pelajari sepuluh kata baru setiap hari, dan uji diri seperti tes SIM. Semua bekerja offline, tanpa akun.",
  "Небольшое честное приложение для тех, кто живёт в Италии: найдите слово, выучите десять новых каждый день и проверьте себя, как на экзамене по вождению. Всё работает без интернета и без аккаунта.",
  "اطالیہ میں رہنے والوں کے لیے ایک چھوٹی، ایماندار ایپ: لفظ تلاش کریں، روز دس نئے الفاظ سیکھیں اور ڈرائیونگ ٹیسٹ کی طرح خود کو آزمائیں۔ سب کچھ آف لائن چلتا ہے، بغیر اکاؤنٹ۔",
  "اطالیہ وچ رہݨ والیاں لئی اک نکی، ایماندار ایپ: لفظ تلاش کرو، روز دس نویں لفظ سکھو تے ڈرائیونگ ٹیسٹ وانگ اپنے آپ نوں پرکھو۔ سب کجھ آف لائن چلدا اے، بغیر اکاؤنٹ۔",
  "ਇਟਲੀ ਵਿੱਚ ਰਹਿਣ ਵਾਲਿਆਂ ਲਈ ਇੱਕ ਛੋਟੀ, ਇਮਾਨਦਾਰ ਐਪ: ਸ਼ਬਦ ਖੋਜੋ, ਰੋਜ਼ ਦਸ ਨਵੇਂ ਸ਼ਬਦ ਸਿੱਖੋ ਅਤੇ ਡਰਾਈਵਿੰਗ ਟੈਸਟ ਵਾਂਗ ਆਪਣੇ ਆਪ ਨੂੰ ਪਰਖੋ। ਸਭ ਕੁਝ ਆਫ਼ਲਾਈਨ ਚੱਲਦਾ ਹੈ, ਬਿਨਾਂ ਖਾਤੇ।",
  "ইতালিতে বাস করা মানুষের জন্য ছোট, সৎ একটি অ্যাপ: শব্দ খুঁজুন, প্রতিদিন দশটি নতুন শব্দ শিখুন এবং ড্রাইভিং পরীক্ষার মতো নিজেকে যাচাই করুন। সবকিছু অফলাইনে চলে, অ্যাকাউন্ট ছাড়াই।",
  "ඉතාලියේ ජීවත් වන අයට කුඩා, අවංක යෙදුමක්: වචනයක් සොයන්න, දිනකට නව වචන දහයක් ඉගෙන ගන්න, රියදුරු බලපත්‍ර විභාගය වගේ ඔබම පරීක්ෂා කරගන්න. සියල්ල ඔෆ්ලයින්, ගිණුමක් නැතිව.",
  "一款为在意大利生活的人做的小而实在的应用：查一个词，每天学十个新词，并像考驾照那样自测。全部离线可用，无需账号。")
k("creditsBody",
  "Translations and example sentences are written and checked by hand for this app. Word lists were cross-checked against open sources: Wiktionary and Wikizionario (CC BY-SA 4.0), Tatoeba example sentences (CC BY 2.0 FR) and the Open Multilingual Wordnet. Pictures use Google Noto Emoji (Apache 2.0). Italian pronunciation uses your phone's own text-to-speech.",
  "Le traduzioni e le frasi di esempio sono scritte e controllate a mano per questa app. Gli elenchi di parole sono stati confrontati con fonti aperte: Wiktionary e Wikizionario (CC BY-SA 4.0), frasi di Tatoeba (CC BY 2.0 FR) e Open Multilingual Wordnet. Le immagini usano Google Noto Emoji (Apache 2.0). La pronuncia italiana usa la sintesi vocale del telefono.",
  "Las traducciones y los ejemplos se escriben y revisan a mano para esta app. Las listas de palabras se compararon con fuentes abiertas: Wiktionary y Wikcionario (CC BY-SA 4.0), frases de Tatoeba (CC BY 2.0 FR) y Open Multilingual Wordnet. Las imágenes usan Google Noto Emoji (Apache 2.0). La pronunciación italiana usa el texto a voz del teléfono.",
  "Las traducciones y los ejemplos se escriben y revisan a mano para esta app. Las listas de palabras se compararon con fuentes abiertas: Wiktionary y Wikcionario (CC BY-SA 4.0), frases de Tatoeba (CC BY 2.0 FR) y Open Multilingual Wordnet. Las imágenes usan Google Noto Emoji (Apache 2.0). La pronunciación italiana usa el texto a voz del teléfono.",
  "As traduções e as frases de exemplo são escritas e revisadas à mão para este app. As listas de palavras foram comparadas com fontes abertas: Wiktionary e Wikizionario (CC BY-SA 4.0), frases do Tatoeba (CC BY 2.0 FR) e Open Multilingual Wordnet. As imagens usam Google Noto Emoji (Apache 2.0). A pronúncia italiana usa a conversão de texto em voz do telefone.",
  "Les traductions et les phrases d'exemple sont écrites et vérifiées à la main pour cette application. Les listes de mots ont été recoupées avec des sources ouvertes : Wiktionary et Wikizionario (CC BY-SA 4.0), phrases de Tatoeba (CC BY 2.0 FR) et Open Multilingual Wordnet. Les images utilisent Google Noto Emoji (Apache 2.0). La prononciation italienne utilise la synthèse vocale du téléphone.",
  "Übersetzungen und Beispielsätze wurden für diese App von Hand geschrieben und geprüft. Die Wortlisten wurden mit offenen Quellen abgeglichen: Wiktionary und Wikizionario (CC BY-SA 4.0), Tatoeba-Sätze (CC BY 2.0 FR) und Open Multilingual Wordnet. Die Bilder nutzen Google Noto Emoji (Apache 2.0). Die italienische Aussprache nutzt die Sprachausgabe Ihres Telefons.",
  "इस ऐप के अनुवाद और उदाहरण वाक्य हाथ से लिखे और जाँचे गए हैं। शब्द सूचियाँ खुले स्रोतों से मिलाई गईं: Wiktionary और Wikizionario (CC BY-SA 4.0), Tatoeba वाक्य (CC BY 2.0 FR) और Open Multilingual Wordnet। चित्र Google Noto Emoji (Apache 2.0) के हैं। इतालवी उच्चारण फ़ोन की टेक्स्ट-टू-स्पीच से आता है।",
  "تُكتب الترجمات وأمثلة الجمل وتُراجع يدوياً لهذا التطبيق. وقد قوبلت قوائم الكلمات بمصادر مفتوحة: ويكاموس وWikizionario (CC BY-SA 4.0)، وجمل Tatoeba (CC BY 2.0 FR)، وOpen Multilingual Wordnet. الصور من Google Noto Emoji (Apache 2.0). النطق الإيطالي يعتمد على تحويل النص إلى كلام في هاتفك.",
  "Terjemahan dan contoh kalimat ditulis serta diperiksa secara manual untuk aplikasi ini. Daftar kata dibandingkan dengan sumber terbuka: Wiktionary dan Wikizionario (CC BY-SA 4.0), kalimat Tatoeba (CC BY 2.0 FR), dan Open Multilingual Wordnet. Gambar memakai Google Noto Emoji (Apache 2.0). Pelafalan Italia memakai teks-ke-ucapan ponsel Anda.",
  "Переводы и примеры предложений написаны и проверены вручную для этого приложения. Списки слов сверялись с открытыми источниками: Wiktionary и Wikizionario (CC BY-SA 4.0), предложения Tatoeba (CC BY 2.0 FR) и Open Multilingual Wordnet. Картинки — Google Noto Emoji (Apache 2.0). Итальянское произношение использует синтез речи телефона.",
  "اس ایپ کے تراجم اور مثالی جملے ہاتھ سے لکھے اور جانچے گئے ہیں۔ الفاظ کی فہرستیں کھلے ذرائع سے ملائی گئیں: Wiktionary اور Wikizionario (CC BY-SA 4.0)، Tatoeba کے جملے (CC BY 2.0 FR) اور Open Multilingual Wordnet۔ تصاویر Google Noto Emoji (Apache 2.0) سے ہیں۔ اطالوی تلفظ آپ کے فون کی ٹیکسٹ ٹو اسپیچ سے آتا ہے۔",
  "ایس ایپ دے ترجمے تے مثالی جملے ہتھ نال لکھے تے جانچے گئے نیں۔ لفظاں دیاں فہرستاں کھلے ذریعیاں نال ملائیاں گئیاں: Wiktionary تے Wikizionario (CC BY-SA 4.0)، Tatoeba دے جملے (CC BY 2.0 FR) تے Open Multilingual Wordnet۔ تصویراں Google Noto Emoji (Apache 2.0) توں نیں۔ اطالوی تلفظ تہاڈے فون دی ٹیکسٹ ٹو اسپیچ توں آؤندا اے۔",
  "ਇਸ ਐਪ ਦੇ ਅਨੁਵਾਦ ਅਤੇ ਉਦਾਹਰਨ ਵਾਕ ਹੱਥ ਨਾਲ ਲਿਖੇ ਅਤੇ ਜਾਂਚੇ ਗਏ ਹਨ। ਸ਼ਬਦ ਸੂਚੀਆਂ ਖੁੱਲ੍ਹੇ ਸਰੋਤਾਂ ਨਾਲ ਮਿਲਾਈਆਂ ਗਈਆਂ: Wiktionary ਅਤੇ Wikizionario (CC BY-SA 4.0), Tatoeba ਦੇ ਵਾਕ (CC BY 2.0 FR) ਅਤੇ Open Multilingual Wordnet। ਤਸਵੀਰਾਂ Google Noto Emoji (Apache 2.0) ਤੋਂ ਹਨ। ਇਤਾਲਵੀ ਉਚਾਰਨ ਤੁਹਾਡੇ ਫ਼ੋਨ ਦੀ ਟੈਕਸਟ-ਟੂ-ਸਪੀਚ ਵਰਤਦਾ ਹੈ।",
  "এই অ্যাপের অনুবাদ ও উদাহরণ বাক্য হাতে লেখা ও যাচাই করা। শব্দতালিকা মুক্ত সূত্রের সঙ্গে মিলিয়ে দেখা হয়েছে: Wiktionary ও Wikizionario (CC BY-SA 4.0), Tatoeba-র বাক্য (CC BY 2.0 FR) এবং Open Multilingual Wordnet। ছবিতে Google Noto Emoji (Apache 2.0) ব্যবহৃত। ইতালীয় উচ্চারণ আপনার ফোনের টেক্সট-টু-স্পিচ ব্যবহার করে।",
  "මෙම යෙදුම සඳහා පරිවර්තන සහ උදාහරණ වාක්‍ය අතින් ලියා පරීක්ෂා කර ඇත. වචන ලැයිස්තු විවෘත මූලාශ්‍ර සමඟ සසඳා බලා ඇත: Wiktionary සහ Wikizionario (CC BY-SA 4.0), Tatoeba වාක්‍ය (CC BY 2.0 FR) සහ Open Multilingual Wordnet. පින්තූර සඳහා Google Noto Emoji (Apache 2.0). ඉතාලි උච්චාරණය ඔබේ දුරකථනයේ පෙළ-සිට-කථනය භාවිතා කරයි.",
  "本应用的翻译与例句均由人工撰写并校对。词表与开放来源逐条核对：Wiktionary 与 Wikizionario（CC BY-SA 4.0）、Tatoeba 例句（CC BY 2.0 FR）以及 Open Multilingual Wordnet。图片使用 Google Noto Emoji（Apache 2.0）。意大利语发音使用手机自带的文字转语音。")
k("dataCoverage",
  "Word list in this version","Elenco di parole in questa versione","Lista de palabras de esta versión",
  "Lista de palabras de esta versión","Lista de palavras desta versão","Liste de mots de cette version",
  "Wortliste dieser Version","इस संस्करण की शब्द सूची","قائمة الكلمات في هذه النسخة",
  "Daftar kata di versi ini","Список слов в этой версии","اس ورژن میں الفاظ کی فہرست",
  "ایس ورژن وچ لفظاں دی فہرست","ਇਸ ਵਰਜਨ ਦੀ ਸ਼ਬਦ ਸੂਚੀ","এই সংস্করণের শব্দতালিকা",
  "මෙම අනුවාදයේ වචන ලැයිස්තුව","本版本的词表")

# ---------------------------------------------------------------- misc
k("mascotCheer",
  "Bravo!","Bravo!","¡Bravo!","¡Bravo!","Bravo!","Bravo !","Bravo!","शाबाश!","أحسنت!","Hebat!",
  "Молодец!","شاباش!","شاباش!","ਸ਼ਾਬਾਸ਼!","বাহ!","හොඳයි!","太棒了！")
k("mascotTryAgain",
  "Keep going!","Dai, continua!","¡Sigue así!","¡Sigue así!","Continue!","Continuez !",
  "Weiter so!","चलते रहो!","واصل!","Terus semangat!","Продолжайте!","آگے بڑھیں!","اگے ودھو!",
  "ਅੱਗੇ ਵਧੋ!","চালিয়ে যান!","දිගටම කරගෙන යන්න!","继续加油！")
k("adsTestIdsNotice",
  "Setup needed: the ads still use Google's test ids. Paste the real AdMob ids to earn from them.",
  "Configurazione necessaria: la pubblicità usa ancora gli id di test di Google. Incolla gli id AdMob reali per guadagnare.",
  "Configuración necesaria: los anuncios siguen usando los id de prueba de Google. Pega los id reales de AdMob para ganar.",
  "Configuración necesaria: los anuncios siguen usando los id de prueba de Google. Pega los id reales de AdMob para ganar.",
  "Configuração necessária: os anúncios ainda usam os ids de teste do Google. Cole os ids reais do AdMob para ganhar.",
  "Configuration nécessaire : les publicités utilisent encore les id de test de Google. Collez les vrais id AdMob pour gagner.",
  "Einrichtung nötig: Die Werbung nutzt noch Googles Test-IDs. Fügen Sie die echten AdMob-IDs ein, um zu verdienen.",
  "सेटअप ज़रूरी: विज्ञापन अभी Google की टेस्ट आईडी इस्तेमाल करते हैं। कमाई के लिए असली AdMob आईडी डालें।",
  "الإعداد مطلوب: لا تزال الإعلانات تستخدم معرّفات Google التجريبية. ألصق معرّفات AdMob الحقيقية لتحقيق الأرباح.",
  "Perlu disiapkan: iklan masih memakai id uji Google. Tempel id AdMob asli agar menghasilkan.",
  "Нужна настройка: реклама пока использует тестовые id Google. Вставьте настоящие id AdMob, чтобы получать доход.",
  "سیٹ اپ ضروری: اشتہارات ابھی Google کی ٹیسٹ آئی ڈی استعمال کرتے ہیں۔ کمائی کے لیے اصل AdMob آئی ڈی لگائیں۔",
  "سیٹ اپ ضروری: اشتہار ہالے Google دیاں ٹیسٹ آئی ڈی ورتدے نیں۔ کمائی لئی اصل AdMob آئی ڈی لاؤ۔",
  "ਸੈਟਅਪ ਲੋੜੀਂਦਾ: ਵਿਗਿਆਪਨ ਹਾਲੇ Google ਦੀਆਂ ਟੈਸਟ ਆਈਡੀ ਵਰਤਦੇ ਹਨ। ਕਮਾਈ ਲਈ ਅਸਲੀ AdMob ਆਈਡੀ ਪਾਓ।",
  "সেটআপ দরকার: বিজ্ঞাপন এখনো Google-এর টেস্ট আইডি ব্যবহার করে। আয়ের জন্য আসল AdMob আইডি দিন।",
  "සැකසීම අවශ්‍යයි: දැන්වීම් තවමත් Google හි පරීක්ෂණ හැඳුනුම් භාවිතා කරයි. ආදායම සඳහා සැබෑ AdMob හැඳුනුම් යොදන්න.",
  "需要设置：广告仍在使用 Google 的测试 ID。请填入真实的 AdMob ID 才能获得收入。")
k("demoBadge",
  "Demo content","Contenuto dimostrativo","Contenido de demostración","Contenido de demostración",
  "Conteúdo de demonstração","Contenu de démonstration","Demo-Inhalt","डेमो सामग्री",
  "محتوى تجريبي","Konten demo","Демо-содержимое","ڈیمو مواد","ڈیمو مواد","ਡੈਮੋ ਸਮੱਗਰੀ",
  "ডেমো কনটেন্ট","ආදර්ශන අන්තර්ගතය","演示内容")

# ---------------------------------------------------------------- topic names
TOPIC_KEYS = [
 ("topicGreetings","Greetings & basics","Saluti e basi","Saludos y básicos","Saludos y básicos",
  "Saudações e básicos","Salutations et bases","Begrüßung & Grundlagen","अभिवादन और बुनियाद",
  "التحيات والأساسيات","Sapaan & dasar","Приветствия и основы","سلام اور بنیادی باتیں",
  "سلام تے بنیادی گلاں","ਨਮਸਕਾਰ ਤੇ ਮੂਲ","অভিবাদন ও মৌলিক","ආචාර හා මූලික","问候与基础"),
 ("topicNumbers","Numbers","Numeri","Números","Números","Números","Nombres","Zahlen","संख्याएँ",
  "الأرقام","Angka","Числа","اعداد","گݨتی","ਗਿਣਤੀ","সংখ্যা","අංක","数字"),
 ("topicColors","Colors","Colori","Colores","Colores","Cores","Couleurs","Farben","रंग","الألوان",
  "Warna","Цвета","رنگ","رنگ","ਰੰਗ","রং","වර්ණ","颜色"),
 ("topicTime","Days, months & time","Giorni, mesi e ora","Días, meses y hora","Días, meses y hora",
  "Dias, meses e horas","Jours, mois et heure","Tage, Monate & Zeit","दिन, महीने और समय",
  "الأيام والأشهر والوقت","Hari, bulan & waktu","Дни, месяцы и время","دن، مہینے اور وقت",
  "دن، مہینے تے ویلا","ਦਿਨ, ਮਹੀਨੇ ਤੇ ਸਮਾਂ","দিন, মাস ও সময়","දින, මාස හා වේලාව","日期与时间"),
 ("topicFamily","Family","Famiglia","Familia","Familia","Família","Famille","Familie","परिवार",
  "العائلة","Keluarga","Семья","خاندان","ٹبر","ਪਰਿਵਾਰ","পরিবার","පවුල","家庭"),
 ("topicBody","Body","Corpo","Cuerpo","Cuerpo","Corpo","Corps","Körper","शरीर","الجسم","Tubuh",
  "Тело","جسم","جسم","ਸਰੀਰ","শরীর","ශරීරය","身体"),
 ("topicHealth","Health & doctor","Salute e medico","Salud y médico","Salud y médico",
  "Saúde e médico","Santé et médecin","Gesundheit & Arzt","स्वास्थ्य और डॉक्टर","الصحة والطبيب",
  "Kesehatan & dokter","Здоровье и врач","صحت اور ڈاکٹر","صحت تے ڈاکٹر","ਸਿਹਤ ਤੇ ਡਾਕਟਰ",
  "স্বাস্থ্য ও ডাক্তার","සෞඛ්‍ය හා වෛද්‍ය","健康与就医"),
 ("topicPharmacy","Pharmacy","Farmacia","Farmacia","Farmacia","Farmácia","Pharmacie","Apotheke",
  "दवा की दुकान","الصيدلية","Apotek","Аптека","فارمیسی","فارمیسی","ਫਾਰਮੇਸੀ","ফার্মেসি",
  "ඔසුසැල","药店"),
 ("topicFood","Food","Cibo","Comida","Comida","Comida","Nourriture","Essen","खाना","الطعام",
  "Makanan","Еда","کھانا","کھاݨا","ਖਾਣਾ","খাবার","ආහාර","食物"),
 ("topicFruit","Fruit","Frutta","Fruta","Fruta","Frutas","Fruits","Obst","फल","الفواكه","Buah",
  "Фрукты","پھل","پھل","ਫਲ","ফল","පලතුරු","水果"),
 ("topicVegetables","Vegetables","Verdura","Verduras","Verduras","Legumes","Légumes","Gemüse",
  "सब्ज़ियाँ","الخضروات","Sayuran","Овощи","سبزیاں","سبزیاں","ਸਬਜ਼ੀਆਂ","সবজি","එළවළු","蔬菜"),
 ("topicDrinks","Drinks","Bevande","Bebidas","Bebidas","Bebidas","Boissons","Getränke","पेय",
  "المشروبات","Minuman","Напитки","مشروبات","پیݨ والیاں چیزاں","ਪੀਣ ਵਾਲੀਆਂ ਚੀਜ਼ਾਂ","পানীয়",
  "බීම","饮料"),
 ("topicCooking","Cooking","In cucina","Cocinar","Cocinar","Cozinhar","Cuisiner","Kochen",
  "पकाना","الطهي","Memasak","Готовка","پکانا","پکاݨا","ਪਕਾਉਣਾ","রান্না","උයන්න","烹饪"),
 ("topicShopping","Supermarket & shopping","Supermercato e spesa","Supermercado y compras",
  "Supermercado y compras","Supermercado e compras","Supermarché et courses",
  "Supermarkt & Einkauf","सुपरमार्केट और खरीदारी","السوق والتسوّق","Supermarket & belanja",
  "Супермаркет и покупки","سپر مارکیٹ اور خریداری","سپر مارکیٹ تے خریداری",
  "ਸੁਪਰਮਾਰਕੀਟ ਤੇ ਖਰੀਦਦਾਰੀ","সুপারমার্কেট ও কেনাকাটা","සුපිරි වෙළඳසැල","超市与购物"),
 ("topicMoney","Money & bank","Soldi e banca","Dinero y banco","Dinero y banco","Dinheiro e banco",
  "Argent et banque","Geld & Bank","पैसा और बैंक","المال والبنك","Uang & bank","Деньги и банк",
  "پیسہ اور بینک","پیسہ تے بینک","ਪੈਸਾ ਤੇ ਬੈਂਕ","টাকা ও ব্যাংক","මුදල් හා බැංකුව","金钱与银行"),
 ("topicHouse","House","Casa","Casa","Casa","Casa","Maison","Haus","घर","المنزل","Rumah","Дом",
  "گھر","گھر","ਘਰ","বাড়ি","නිවස","家"),
 ("topicKitchen","Kitchen","Cucina","Cocina","Cocina","Cozinha","Cuisine","Küche","रसोई",
  "المطبخ","Dapur","Кухня","باورچی خانہ","رسوئی","ਰਸੋਈ","রান্নাঘর","කුස්සිය","厨房"),
 ("topicBathroom","Bathroom","Bagno","Baño","Baño","Banheiro","Salle de bain","Badezimmer",
  "स्नानघर","الحمّام","Kamar mandi","Ванная","غسل خانہ","غسل خانہ","ਗੁਸਲਖਾਨਾ","বাথরুম",
  "නාන කාමරය","浴室"),
 ("topicClothes","Clothes & shoes","Vestiti e scarpe","Ropa y zapatos","Ropa y zapatos",
  "Roupas e sapatos","Vêtements et chaussures","Kleidung & Schuhe","कपड़े और जूते",
  "الملابس والأحذية","Pakaian & sepatu","Одежда и обувь","کپڑے اور جوتے","کپڑے تے جُتیاں",
  "ਕੱਪੜੇ ਤੇ ਜੁੱਤੀਆਂ","পোশাক ও জুতা","ඇඳුම් හා සපත්තු","衣服与鞋"),
 ("topicWeather","Weather & seasons","Tempo e stagioni","Clima y estaciones","Clima y estaciones",
  "Tempo e estações","Météo et saisons","Wetter & Jahreszeiten","मौसम और ऋतुएँ",
  "الطقس والفصول","Cuaca & musim","Погода и времена года","موسم اور فصلیں","موسم تے رُتاں",
  "ਮੌਸਮ ਤੇ ਰੁੱਤਾਂ","আবহাওয়া ও ঋতু","කාලගුණය හා ඍතු","天气与季节"),
 ("topicCity","City & places","Città e luoghi","Ciudad y lugares","Ciudad y lugares",
  "Cidade e lugares","Ville et lieux","Stadt & Orte","शहर और जगहें","المدينة والأماكن",
  "Kota & tempat","Город и места","شہر اور جگہیں","شہر تے تھاں","ਸ਼ਹਿਰ ਤੇ ਥਾਂਵਾਂ",
  "শহর ও স্থান","නගරය හා ස්ථාන","城市与地点"),
 ("topicTransport","Transport & directions","Trasporti e indicazioni","Transporte y direcciones",
  "Transporte y direcciones","Transporte e direções","Transports et itinéraires",
  "Verkehr & Wegbeschreibung","परिवहन और रास्ता","المواصلات والاتجاهات","Transportasi & arah",
  "Транспорт и направления","ٹرانسپورٹ اور راستہ","ٹرانسپورٹ تے راہ","ਟਰਾਂਸਪੋਰਟ ਤੇ ਰਾਹ",
  "পরিবহন ও দিকনির্দেশ","ප්‍රවාහනය හා දිශා","交通与问路"),
 ("topicWork","Work","Lavoro","Trabajo","Trabajo","Trabalho","Travail","Arbeit","काम","العمل",
  "Pekerjaan","Работа","کام","کم","ਕੰਮ","কাজ","රැකියාව","工作"),
 ("topicJobs","Jobs","Mestieri","Oficios","Oficios","Profissões","Métiers","Berufe","पेशे",
  "المهن","Profesi","Профессии","پیشے","پیشے","ਪੇਸ਼ੇ","পেশা","වෘත්ති","职业"),
 ("topicOffices","Offices & documents","Uffici e documenti","Oficinas y documentos",
  "Oficinas y documentos","Repartições e documentos","Administrations et documents",
  "Behörden & Dokumente","दफ़्तर और दस्तावेज़","المكاتب والوثائق","Kantor & dokumen",
  "Учреждения и документы","دفاتر اور دستاویزات","دفتر تے کاغذ","ਦਫ਼ਤਰ ਤੇ ਦਸਤਾਵੇਜ਼",
  "অফিস ও কাগজপত্র","කාර්යාල හා ලේඛන","政府机构与证件"),
 ("topicSchool","School","Scuola","Escuela","Escuela","Escola","École","Schule","स्कूल",
  "المدرسة","Sekolah","Школа","اسکول","سکول","ਸਕੂਲ","স্কুল","පාසල","学校"),
 ("topicAnimals","Animals","Animali","Animales","Animales","Animais","Animaux","Tiere","जानवर",
  "الحيوانات","Hewan","Животные","جانور","جانور","ਜਾਨਵਰ","প্রাণী","සතුන්","动物"),
 ("topicNature","Nature","Natura","Naturaleza","Naturaleza","Natureza","Nature","Natur","प्रकृति",
  "الطبيعة","Alam","Природа","قدرت","قدرت","ਕੁਦਰਤ","প্রকৃতি","සොබාදහම","自然"),
 ("topicSport","Sport & free time","Sport e tempo libero","Deporte y tiempo libre",
  "Deporte y tiempo libre","Esporte e tempo livre","Sport et loisirs","Sport & Freizeit",
  "खेल और खाली समय","الرياضة ووقت الفراغ","Olahraga & waktu luang","Спорт и отдых",
  "کھیل اور فارغ وقت","کھیل تے ویلھ","ਖੇਡ ਤੇ ਵਿਹਲਾ ਸਮਾਂ","খেলা ও অবসর","ක්‍රීඩා හා විවේකය",
  "运动与休闲"),
 ("topicFeelings","Feelings","Emozioni","Emociones","Emociones","Sentimentos","Émotions",
  "Gefühle","भावनाएँ","المشاعر","Perasaan","Чувства","احساسات","احساس","ਭਾਵਨਾਵਾਂ","অনুভূতি",
  "හැඟීම්","情绪"),
 ("topicVerbs","Common verbs","Verbi comuni","Verbos comunes","Verbos comunes","Verbos comuns",
  "Verbes courants","Häufige Verben","आम क्रियाएँ","أفعال شائعة","Kata kerja umum",
  "Частые глаголы","عام فعل","عام فعل","ਆਮ ਕਿਰਿਆਵਾਂ","সাধারণ ক্রিয়া","සුලබ ක්‍රියා","常用动词"),
 ("topicAdjectives","Common adjectives","Aggettivi comuni","Adjetivos comunes",
  "Adjetivos comunes","Adjetivos comuns","Adjectifs courants","Häufige Adjektive",
  "आम विशेषण","صفات شائعة","Kata sifat umum","Частые прилагательные","عام صفات","عام صفتاں",
  "ਆਮ ਵਿਸ਼ੇਸ਼ਣ","সাধারণ বিশেষণ","සුලබ විශේෂණ","常用形容词"),
 ("topicPhrases","Useful phrases","Frasi utili","Frases útiles","Frases útiles","Frases úteis",
  "Phrases utiles","Nützliche Sätze","उपयोगी वाक्य","عبارات مفيدة","Frasa berguna",
  "Полезные фразы","کارآمد جملے","کم آؤندے جملے","ਕੰਮ ਆਉਂਦੇ ਵਾਕ","দরকারি বাক্য",
  "ප්‍රයෝජනවත් වාක්‍ය","实用短语"),
]
for row in TOPIC_KEYS:
    k(row[0], *row[1:])

# ---------------------------------------------------------------- language names
# Shown in the language picker: each one written in its own language.
LANG_NAMES = {
    "langEn": "English",
    "langUr": "اردو",
    "langPaArab": "پنجابی (شاہ مکھی)",
    "langPa": "ਪੰਜਾਬੀ (ਗੁਰਮੁਖੀ)",
    "langBn": "বাংলা",
    "langSi": "සිංහල",
    "langZh": "简体中文",
    "langFr": "Français",
    "langEs": "Español (España)",
    "langEs419": "Español (Latinoamérica)",
    "langIt": "Italiano",
    "langPt": "Português (Brasil)",
    "langDe": "Deutsch",
    "langHi": "हिन्दी",
    "langAr": "العربية",
    "langId": "Bahasa Indonesia",
    "langRu": "Русский",
}
for key, val in LANG_NAMES.items():
    same(key, val)

k("moreLanguages",
  "More languages","Altre lingue","Más idiomas","Más idiomas","Mais idiomas","Autres langues",
  "Weitere Sprachen","और भाषाएँ","لغات أخرى","Bahasa lain","Другие языки","مزید زبانیں",
  "ہور زباناں","ਹੋਰ ਭਾਸ਼ਾਵਾਂ","আরও ভাষা","තවත් භාෂා","更多语言")
k("languageNoteWordTranslations",
  "Word translations are shown in the ten main languages; other interface languages fall back to English.",
  "Le traduzioni delle parole sono nelle dieci lingue principali; le altre lingue dell'interfaccia usano l'inglese.",
  "Las traducciones de palabras están en los diez idiomas principales; los demás idiomas de la interfaz usan inglés.",
  "Las traducciones de palabras están en los diez idiomas principales; los demás idiomas de la interfaz usan inglés.",
  "As traduções das palavras estão nos dez idiomas principais; os outros idiomas da interface usam inglês.",
  "Les traductions des mots sont dans les dix langues principales ; les autres langues d'interface utilisent l'anglais.",
  "Wortübersetzungen gibt es in den zehn Hauptsprachen; andere Oberflächensprachen nutzen Englisch.",
  "शब्दों के अनुवाद दस मुख्य भाषाओं में हैं; बाकी इंटरफ़ेस भाषाओं में अंग्रेज़ी दिखती है।",
  "ترجمات الكلمات متوفّرة بعشر لغات رئيسية؛ أما لغات الواجهة الأخرى فتعود إلى الإنجليزية.",
  "Terjemahan kata tersedia dalam sepuluh bahasa utama; bahasa antarmuka lain memakai bahasa Inggris.",
  "Переводы слов доступны на десяти основных языках; остальные языки интерфейса используют английский.",
  "الفاظ کے تراجم دس بنیادی زبانوں میں ہیں؛ باقی انٹرفیس زبانوں میں انگریزی دکھائی جاتی ہے۔",
  "لفظاں دے ترجمے دس بنیادی زباناں وچ نیں؛ باقی انٹرفیس زباناں وچ انگریزی دکھائی جاندی اے۔",
  "ਸ਼ਬਦਾਂ ਦੇ ਅਨੁਵਾਦ ਦਸ ਮੁੱਖ ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਹਨ; ਬਾਕੀ ਇੰਟਰਫੇਸ ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਅੰਗਰੇਜ਼ੀ ਦਿਖਦੀ ਹੈ।",
  "শব্দের অনুবাদ দশটি প্রধান ভাষায় আছে; অন্য ইন্টারফেস ভাষায় ইংরেজি দেখানো হয়।",
  "වචන පරිවර්තන ප්‍රධාන භාෂා දහයේ ඇත; අනෙක් අතුරුමුහුණත් භාෂා සඳහා ඉංග්‍රීසි පෙන්වයි.",
  "单词翻译提供十种主要语言；其他界面语言将回退为英语。")

# ------------------------------------------------------------------- write
out = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "lib", "l10n")
os.makedirs(out, exist_ok=True)
for loc in L:
    data = {"@@locale": loc}
    if loc == "en":
        data["@@last_modified"] = "generated by tool/gen_arb.py"
    for key in S:
        data[key] = S[key][loc]
        if loc == "en":
            meta = {"description": key}
            if key in PH:
                meta["placeholders"] = PH[key]
            data["@" + key] = meta
    path = os.path.join(out, "app_%s.arb" % loc)
    with io.open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(json.dumps(data, ensure_ascii=False, indent=2))
        f.write("\n")
print("wrote %d locales x %d keys" % (len(L), len(S)))
