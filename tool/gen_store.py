# -*- coding: utf-8 -*-
"""Writes store/listing.json (Google Play) and store/apple_listing.json
(App Store) with the title, short and full description in every interface
language. Run:  python tool/gen_store.py
"""
import json, io, os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

TITLE = "Italian Words: Learn & Play"

SHORT = {
    "en": "Learn Italian words offline: search, 10 a day, true/false quizzes.",
    "it": "Impara parole italiane offline: cerca, 10 al giorno, quiz vero/falso.",
    "es": "Aprende palabras italianas sin conexión: busca, 10 al día, quizzes.",
    "es-419": "Aprende palabras italianas sin conexión: busca, 10 al día, quizzes.",
    "pt-BR": "Aprenda palavras italianas offline: busque, 10 por dia, quizzes.",
    "fr": "Apprenez l'italien hors ligne : recherche, 10 mots/jour, quiz.",
    "de": "Italienisch offline lernen: Suche, 10 Wörter am Tag, Quiz.",
    "hi": "ऑफ़लाइन इतालवी सीखें: खोज, रोज़ 10 शब्द, सही/गलत क्विज़।",
    "ar": "تعلّم كلمات إيطالية دون إنترنت: بحث، 10 كلمات يومياً، اختبارات.",
    "id": "Belajar kata Italia offline: cari, 10 kata sehari, kuis benar/salah.",
    "ru": "Итальянские слова офлайн: поиск, 10 слов в день, тесты.",
    "ur": "آف لائن اطالوی سیکھیں: تلاش، روز 10 الفاظ، درست/غلط کوئز۔",
    "pa-Arab": "آف لائن اطالوی سکھو: تلاش، روز 10 لفظ، درست/غلط کوئز۔",
    "pa": "ਆਫ਼ਲਾਈਨ ਇਤਾਲਵੀ ਸਿੱਖੋ: ਖੋਜ, ਰੋਜ਼ 10 ਸ਼ਬਦ, ਸਹੀ/ਗਲਤ ਕੁਇਜ਼।",
    "bn": "অফলাইনে ইতালীয় শিখুন: খোঁজ, দিনে ১০ শব্দ, সত্য/মিথ্যা কুইজ।",
    "si": "ඔෆ්ලයින් ඉතාලි ඉගෙන ගන්න: සෙවීම, දිනකට වචන 10, ප්‍රශ්නාවලි.",
    "zh": "离线学习意大利语单词：搜索、每天 10 个词、对错测验。",
}

FULL_EN = """Italian Words: Learn & Play is a small, honest app for people living in Italy.

WHAT IT DOES
• Search — type in Italian or in your own language and find the word. Accents, capitals and small typos do not matter, and a conjugated verb finds its base form.
• Today — ten new everyday words every day, different for every user. Swipe the cards, tap to hear them, then take the mini-quiz.
• Quiz — 20 true/false questions like the driving-licence test. You pass with at most 2 mistakes. The wrong options come from the same topic, so they are tricky.
• Topics — around 30 categories: food, shopping, health and doctor, pharmacy, offices and documents (comune, questura, permesso di soggiorno, codice fiscale, INPS), transport, work, school, house and more.
• My words — save anything you find in Search and quiz yourself on it.

HOW IT IS BUILT
• 100% offline. Every word, phrase, picture and quiz is inside the app. No account, no login.
• Italian pronunciation with your phone's own text-to-speech, at normal and slow speed.
• Every word shows its translation and a short explanation in your language, plus a simple Italian example sentence.
• Interface in English, Urdu, Punjabi (Shahmukhi and Gurmukhi), Bengali, Sinhala, Chinese, French and Spanish (Spain and Latin America), with Italian, Portuguese, German, Hindi, Arabic, Indonesian and Russian as well. Urdu and Shahmukhi read right to left.
• Big buttons, dark mode, progress saved on your phone only.

HONEST ABOUT WHAT IS HERE
This first version ships a hand-checked word list, not a full dictionary: every entry has been written and reviewed by hand in all ten main languages. The list grows with each update.

FREE AND PAID
Everything — all words, all topics, all quizzes — is free. The app shows a small banner and one ad after a finished quiz. A single one-time purchase removes the ads forever.

Ages 13 and up."""

FULL = {
    "en": FULL_EN,
    "it": """Italian Words: Learn & Play è un'app piccola e onesta per chi vive in Italia.

COSA FA
• Cerca — scrivi in italiano o nella tua lingua e trova la parola. Accenti, maiuscole e piccoli errori non contano, e un verbo coniugato trova l'infinito.
• Oggi — dieci nuove parole di uso quotidiano ogni giorno, diverse per ogni utente. Scorri le carte, tocca per ascoltarle, poi fai il mini-quiz.
• Quiz — 20 domande vero/falso come il quiz della patente. Si passa con massimo 2 errori. Le risposte sbagliate vengono dalla stessa categoria, quindi sono insidiose.
• Argomenti — circa 30 categorie: cibo, spesa, salute e medico, farmacia, uffici e documenti (comune, questura, permesso di soggiorno, codice fiscale, INPS), trasporti, lavoro, scuola, casa e altro.
• Le mie parole — salva ciò che trovi nella Ricerca e mettiti alla prova.

COM'È FATTA
• 100% offline. Parole, frasi, immagini e quiz sono dentro l'app. Nessun account, nessun login.
• Pronuncia italiana con la sintesi vocale del telefono, a velocità normale e lenta.
• Ogni parola mostra la traduzione e una breve spiegazione nella tua lingua, più una semplice frase di esempio in italiano.
• Interfaccia in inglese, urdu, punjabi (shahmukhi e gurmukhi), bengalese, singalese, cinese, francese e spagnolo (Spagna e America Latina), oltre a italiano, portoghese, tedesco, hindi, arabo, indonesiano e russo. Urdu e shahmukhi si leggono da destra a sinistra.
• Pulsanti grandi, modalità scura, progressi salvati solo sul telefono.

ONESTI SU COSA C'È
Questa prima versione contiene un elenco di parole controllato a mano, non un dizionario completo: ogni voce è stata scritta e verificata a mano in tutte e dieci le lingue principali. L'elenco cresce ad ogni aggiornamento.

GRATIS E A PAGAMENTO
Tutto — parole, argomenti, quiz — è gratis. L'app mostra un piccolo banner e una pubblicità dopo un quiz finito. Un unico acquisto togli-pubblicità la rimuove per sempre.

Dai 13 anni.""",
    "es": """Italian Words: Learn & Play es una app pequeña y honesta para quien vive en Italia.

QUÉ HACE
• Buscar — escribe en italiano o en tu idioma y encuentra la palabra. Los acentos, las mayúsculas y los pequeños errores no importan, y un verbo conjugado encuentra su infinitivo.
• Hoy — diez palabras nuevas de uso diario cada día, distintas para cada usuario. Desliza las tarjetas, toca para escucharlas y haz el mini-quiz.
• Quiz — 20 preguntas de verdadero/falso como el examen de conducir. Se aprueba con 2 errores como máximo. Las opciones falsas vienen de la misma categoría.
• Temas — unas 30 categorías: comida, compras, salud y médico, farmacia, oficinas y documentos (comune, questura, permesso di soggiorno, codice fiscale, INPS), transporte, trabajo, escuela, casa y más.
• Mis palabras — guarda lo que encuentres en Buscar y ponte a prueba.

CÓMO ESTÁ HECHA
• 100% sin conexión. Palabras, frases, imágenes y quizzes están dentro de la app. Sin cuenta, sin inicio de sesión.
• Pronunciación italiana con el texto a voz de tu teléfono, a velocidad normal y lenta.
• Cada palabra muestra su traducción y una breve explicación en tu idioma, más una frase de ejemplo sencilla en italiano.
• Interfaz en inglés, urdu, punjabi (shahmukhi y gurmukhi), bengalí, cingalés, chino, francés y español (España y Latinoamérica), además de italiano, portugués, alemán, hindi, árabe, indonesio y ruso.
• Botones grandes, modo oscuro, progreso guardado solo en tu teléfono.

HONESTOS CON LO QUE HAY
Esta primera versión incluye una lista de palabras revisada a mano, no un diccionario completo: cada entrada se escribió y verificó a mano en los diez idiomas principales. La lista crece con cada actualización.

GRATIS Y DE PAGO
Todo — palabras, temas, quizzes — es gratis. La app muestra un banner pequeño y un anuncio tras un quiz terminado. Una única compra quita los anuncios para siempre.

A partir de 13 años.""",
}
FULL["es-419"] = FULL["es"].replace("examen de conducir", "examen de manejo")

# For the remaining languages the full description is the English one plus a
# translated opening line, so nothing is ever shown as an untranslated wall of
# text while the copy is still being localised by a native speaker.
OPENERS = {
    "pt-BR": "Um app pequeno e honesto para quem vive na Itália.",
    "fr": "Une petite application honnête pour celles et ceux qui vivent en Italie.",
    "de": "Eine kleine, ehrliche App für Menschen, die in Italien leben.",
    "hi": "इटली में रहने वालों के लिए एक छोटा, ईमानदार ऐप।",
    "ar": "تطبيق صغير وصادق لمن يعيش في إيطاليا.",
    "id": "Aplikasi kecil dan jujur untuk Anda yang tinggal di Italia.",
    "ru": "Небольшое честное приложение для тех, кто живёт в Италии.",
    "ur": "اطالیہ میں رہنے والوں کے لیے ایک چھوٹی، ایماندار ایپ۔",
    "pa-Arab": "اطالیہ وچ رہݨ والیاں لئی اک نکی، ایماندار ایپ۔",
    "pa": "ਇਟਲੀ ਵਿੱਚ ਰਹਿਣ ਵਾਲਿਆਂ ਲਈ ਇੱਕ ਛੋਟੀ, ਇਮਾਨਦਾਰ ਐਪ।",
    "bn": "ইতালিতে বাস করা মানুষের জন্য ছোট, সৎ একটি অ্যাপ।",
    "si": "ඉතාලියේ ජීවත් වන අයට කුඩා, අවංක යෙදුමක්.",
    "zh": "一款为在意大利生活的人做的小而实在的应用。",
}
for tag, opener in OPENERS.items():
    FULL[tag] = opener + "\n\n" + FULL_EN

KEYWORDS = (
    "italian,learn italian,italian words,vocabulary,offline dictionary,"
    "italian for foreigners,permesso di soggiorno,quiz,flashcards,pronunciation"
)

listing = {
    "packageName": "dev.fluttercursor.app.simple_flutter_app_651",
    "defaultLanguage": "en-US",
    "contentRating": "Everyone / PEGI 3 — suitable for ages 13+",
    "category": "EDUCATION",
    "containsAds": True,
    "inAppPurchases": True,
    "price": "free",
    "products": [
        {
            "id": "remove_ads",
            "type": "inapp",
            "title": "Remove ads",
            "description": "One payment, no ads ever again. All words stay free.",
            "price": "3.99",
            "currency": "EUR",
        }
    ],
    "listings": {
        tag: {
            "title": TITLE,
            "shortDescription": SHORT[tag],
            "fullDescription": FULL[tag],
        }
        for tag in SHORT
    },
}

apple = {
    "bundleId": "dev.fluttercursor.app.simple_flutter_app_651",
    "primaryLanguage": "en-US",
    "ageRating": "12+ (suitable for ages 13 and up)",
    "primaryCategory": "EDUCATION",
    "secondaryCategory": "REFERENCE",
    "containsAds": True,
    "inAppPurchases": [
        {
            "productId": "simple_flutter_app_651_remove_ads",
            "referenceName": "Remove ads",
            "type": "NON_CONSUMABLE",
            "displayName": "Remove ads",
            "description": "One payment, no ads ever again. All words stay free.",
            "price": "3.99",
            "currency": "EUR",
        }
    ],
    "keywords": KEYWORDS,
    "supportUrl": "",
    "privacyPolicyUrl": "",
    "localizations": {
        tag: {
            "name": TITLE,
            "subtitle": SHORT[tag],
            "description": FULL[tag],
            "keywords": KEYWORDS,
        }
        for tag in SHORT
    },
    "privacyAnswers": {
        "dataCollected": "none",
        "tracking": "Only if the user accepts the ads consent form.",
        "notes": "Progress and settings stay on the device. Ads come from Google AdMob after consent.",
    },
}

out = os.path.join(ROOT, "store")
os.makedirs(out, exist_ok=True)
for name, data in (("listing.json", listing), ("apple_listing.json", apple)):
    with io.open(os.path.join(out, name), "w", encoding="utf-8", newline="\n") as f:
        f.write(json.dumps(data, ensure_ascii=False, indent=2))
        f.write("\n")
print("wrote store listings for %d languages" % len(SHORT))
