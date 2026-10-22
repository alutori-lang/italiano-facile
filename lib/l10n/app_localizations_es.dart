// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'Buscar';

  @override
  String get tabToday => 'Hoy';

  @override
  String get tabQuiz => 'Quiz';

  @override
  String get tabTopics => 'Temas';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get myWords => 'Mis palabras';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get done => 'Listo';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get retry => 'Reintentar';

  @override
  String get listen => 'Escuchar';

  @override
  String get listenSlow => 'Lento';

  @override
  String get explanation => 'Explicación';

  @override
  String get exampleLabel => 'Ejemplo';

  @override
  String get typeNoun => 'Sustantivo';

  @override
  String get typeVerb => 'Verbo';

  @override
  String get typeAdjective => 'Adjetivo';

  @override
  String get typePhrase => 'Frase';

  @override
  String get searchHint => 'Italiano, inglés, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words palabras · $phrases frases';
  }

  @override
  String get recentSearches => 'Búsquedas recientes';

  @override
  String get clearRecent => 'Borrar';

  @override
  String get noResults => 'No se encontró ninguna palabra';

  @override
  String get didYouMean => '¿Querías decir…?';

  @override
  String get searchOnline => 'Buscar en línea';

  @override
  String get searchingOnline => 'Buscando en línea…';

  @override
  String get offlineNotice => 'No tienes conexión. Todas las palabras de la app siguen funcionando.';

  @override
  String get onlineResultTitle => 'De Wikcionario';

  @override
  String get addToMyWords => 'Añadir a mis palabras';

  @override
  String get removeFromMyWords => 'Quitar de mis palabras';

  @override
  String get myWordsEmpty => 'Aún no hay palabras guardadas. Usa “Añadir a mis palabras” en Buscar.';

  @override
  String get quizOnMyWords => 'Quiz de mis palabras';

  @override
  String get todayTitle => 'Las palabras de hoy';

  @override
  String todayProgress(int n, int total) {
    return 'Palabra $n de $total';
  }

  @override
  String streakDays(int n) {
    return '$n días seguidos';
  }

  @override
  String get miniQuizCta => 'Mini-quiz de las palabras de hoy';

  @override
  String get learnedToday => 'Visto hoy';

  @override
  String get todayDone => 'Has visto las 10 palabras. ¡Vuelve mañana!';

  @override
  String get quizPickCategory => 'Elige una categoría';

  @override
  String get mixOfAll => 'Mezcla de todo';

  @override
  String quizProgress(int n, int total) {
    return 'Pregunta $n de $total';
  }

  @override
  String get quizQuestionPrompt => '¿La palabra corresponde a la imagen?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'verdadero';

  @override
  String get falsoHint => 'falso';

  @override
  String get answerCorrect => '¡Correcto!';

  @override
  String get answerWrong => 'Incorrecto';

  @override
  String get correctAnswerIs => 'La palabra correcta es:';

  @override
  String get quizResultTitle => 'Tu resultado';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'APROBADO';

  @override
  String get notPassed => 'NO APROBADO';

  @override
  String get passRule => 'Se aprueba con 2 errores como máximo';

  @override
  String mistakesCount(int n) {
    return '$n errores';
  }

  @override
  String get noMistakes => 'Sin errores. ¡Perfecto!';

  @override
  String get repeatMistakes => 'Repetir los errores';

  @override
  String get newQuiz => 'Nuevo quiz';

  @override
  String bestScoreValue(int score, int total) {
    return 'Mejor: $score/$total';
  }

  @override
  String get quizNotEnoughWords => 'Esta categoría necesita más palabras para el quiz.';

  @override
  String get topicsSubtitle => 'Aprende por categoría';

  @override
  String nWords(int n) {
    return '$n palabras';
  }

  @override
  String nLearned(int n) {
    return '$n aprendidas';
  }

  @override
  String get flashcards => 'Tarjetas';

  @override
  String get quiz20 => 'Quiz 20';

  @override
  String get flashcardTapToFlip => 'Toca la tarjeta para ver la traducción';

  @override
  String get interfaceLanguage => 'Idioma de la app';

  @override
  String get audioSpeed => 'Velocidad del audio';

  @override
  String get dailyReminder => 'Recordatorio diario';

  @override
  String get reminderTime => 'Hora del recordatorio';

  @override
  String get reminderBody => 'Te esperan 10 palabras italianas nuevas.';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get resetProgress => 'Borrar progreso';

  @override
  String get resetProgressConfirm => '¿Borrar racha, puntuaciones y palabras guardadas?';

  @override
  String get resetDone => 'Progreso borrado';

  @override
  String get privacy => 'Privacidad';

  @override
  String get about => 'Acerca de y créditos';

  @override
  String get adsConsentChange => 'Cambiar consentimiento de anuncios';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String get removeAdsBody => 'Un solo pago, nunca más anuncios. Palabras, temas y quizzes siguen gratis.';

  @override
  String get buy => 'Comprar';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get adsRemoved => 'Anuncios eliminados. ¡Gracias!';

  @override
  String get purchasePending => 'Pago en curso…';

  @override
  String get purchaseError => 'La compra no se completó.';

  @override
  String get nothingToRestore => 'No se encontró ninguna compra anterior.';

  @override
  String get webPurchaseNotice => 'Las compras están disponibles en la app de Android y iPhone.';

  @override
  String get storeUnavailable => 'La tienda no está disponible ahora.';

  @override
  String get voiceHelpTitle => 'Instala la voz italiana';

  @override
  String get voiceHelpBody => 'Tu teléfono aún no tiene voz italiana. Abre Ajustes › Sistema › Idiomas › Texto a voz, elige el motor de Google e instala el italiano. Leer las palabras funciona igual.';

  @override
  String get privacyBody => 'Esta app funciona sin conexión y no necesita inicio de sesión. Tu progreso, tus palabras guardadas y tus ajustes se quedan solo en tu teléfono. Nunca recogemos tu nombre, correo ni ubicación. Los anuncios vienen de Google AdMob y solo se muestran si los aceptas en el formulario de consentimiento; puedes cambiar tu elección en Ajustes. “Buscar en línea” envía a Wikcionario solo la palabra escrita. Para 13 años o más.';

  @override
  String get aboutBody => 'Una app pequeña y honesta para quien vive en Italia: busca una palabra, aprende diez nuevas al día y ponte a prueba como en el examen de conducir. Todo funciona sin conexión y sin cuenta.';

  @override
  String get creditsBody => 'Las traducciones y los ejemplos se escriben y revisan a mano para esta app. Las listas de palabras se compararon con fuentes abiertas: Wiktionary y Wikcionario (CC BY-SA 4.0), frases de Tatoeba (CC BY 2.0 FR) y Open Multilingual Wordnet. Las imágenes usan Google Noto Emoji (Apache 2.0). La pronunciación italiana usa el texto a voz del teléfono.';

  @override
  String get dataCoverage => 'Lista de palabras de esta versión';

  @override
  String get mascotCheer => '¡Bravo!';

  @override
  String get mascotTryAgain => '¡Sigue así!';

  @override
  String get adsTestIdsNotice => 'Configuración necesaria: los anuncios siguen usando los id de prueba de Google. Pega los id reales de AdMob para ganar.';

  @override
  String get demoBadge => 'Contenido de demostración';

  @override
  String get topicGreetings => 'Saludos y básicos';

  @override
  String get topicNumbers => 'Números';

  @override
  String get topicColors => 'Colores';

  @override
  String get topicTime => 'Días, meses y hora';

  @override
  String get topicFamily => 'Familia';

  @override
  String get topicBody => 'Cuerpo';

  @override
  String get topicHealth => 'Salud y médico';

  @override
  String get topicPharmacy => 'Farmacia';

  @override
  String get topicFood => 'Comida';

  @override
  String get topicFruit => 'Fruta';

  @override
  String get topicVegetables => 'Verduras';

  @override
  String get topicDrinks => 'Bebidas';

  @override
  String get topicCooking => 'Cocinar';

  @override
  String get topicShopping => 'Supermercado y compras';

  @override
  String get topicMoney => 'Dinero y banco';

  @override
  String get topicHouse => 'Casa';

  @override
  String get topicKitchen => 'Cocina';

  @override
  String get topicBathroom => 'Baño';

  @override
  String get topicClothes => 'Ropa y zapatos';

  @override
  String get topicWeather => 'Clima y estaciones';

  @override
  String get topicCity => 'Ciudad y lugares';

  @override
  String get topicTransport => 'Transporte y direcciones';

  @override
  String get topicWork => 'Trabajo';

  @override
  String get topicJobs => 'Oficios';

  @override
  String get topicOffices => 'Oficinas y documentos';

  @override
  String get topicSchool => 'Escuela';

  @override
  String get topicAnimals => 'Animales';

  @override
  String get topicNature => 'Naturaleza';

  @override
  String get topicSport => 'Deporte y tiempo libre';

  @override
  String get topicFeelings => 'Emociones';

  @override
  String get topicVerbs => 'Verbos comunes';

  @override
  String get topicAdjectives => 'Adjetivos comunes';

  @override
  String get topicPhrases => 'Frases útiles';

  @override
  String get langEn => 'English';

  @override
  String get langUr => 'اردو';

  @override
  String get langPaArab => 'پنجابی (شاہ مکھی)';

  @override
  String get langPa => 'ਪੰਜਾਬੀ (ਗੁਰਮੁਖੀ)';

  @override
  String get langBn => 'বাংলা';

  @override
  String get langSi => 'සිංහල';

  @override
  String get langZh => '简体中文';

  @override
  String get langFr => 'Français';

  @override
  String get langEs => 'Español (España)';

  @override
  String get langEs419 => 'Español (Latinoamérica)';

  @override
  String get langIt => 'Italiano';

  @override
  String get langPt => 'Português (Brasil)';

  @override
  String get langDe => 'Deutsch';

  @override
  String get langHi => 'हिन्दी';

  @override
  String get langAr => 'العربية';

  @override
  String get langId => 'Bahasa Indonesia';

  @override
  String get langRu => 'Русский';

  @override
  String get moreLanguages => 'Más idiomas';

  @override
  String get languageNoteWordTranslations => 'Las traducciones de palabras están en los diez idiomas principales; los demás idiomas de la interfaz usan inglés.';

  @override
  String get bigPreparing => 'Preparing the dictionary…';

  @override
  String bigPlural(String plural) {
    return 'Plural: $plural';
  }

  @override
  String bigInEnglish(String gloss) {
    return 'In English: $gloss';
  }

  @override
  String get bigSource => 'From the big dictionary (Wiktionary)';

  @override
  String get bigLearnedSource => 'Learned from the online dictionary';

  @override
  String get bigSearching => 'Searching the big dictionary…';

  @override
  String get posAdverb => 'Adverb';

  @override
  String get posArticle => 'Article';

  @override
  String get posConjunction => 'Conjunction';

  @override
  String get posDeterminer => 'Determiner';

  @override
  String get posInterjection => 'Interjection';

  @override
  String get posNumeral => 'Number';

  @override
  String get posParticle => 'Particle';

  @override
  String get posPreposition => 'Preposition';

  @override
  String get posPronoun => 'Pronoun';

  @override
  String get posOther => 'Word';

  @override
  String get bigDictTitle => 'Big dictionary';

  @override
  String get bigDictCredits => 'The big dictionary of Italian words (over 100,000 words when complete) comes from Wiktionary, through kaikki.org, under the CC BY-SA 4.0 licence. The meanings in the ten languages were prepared for this app from the Wiktionary definitions.';

  @override
  String get bigSearchingOnline => 'Searching online…';

  @override
  String get bigNotAllowed => 'This word cannot be added to the dictionary.';

  @override
  String get bigNotFoundOnline => 'Not found online either: check how you wrote it.';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419(): super('es_419');

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'Buscar';

  @override
  String get tabToday => 'Hoy';

  @override
  String get tabQuiz => 'Quiz';

  @override
  String get tabTopics => 'Temas';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get myWords => 'Mis palabras';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get done => 'Listo';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get retry => 'Reintentar';

  @override
  String get listen => 'Escuchar';

  @override
  String get listenSlow => 'Lento';

  @override
  String get explanation => 'Explicación';

  @override
  String get exampleLabel => 'Ejemplo';

  @override
  String get typeNoun => 'Sustantivo';

  @override
  String get typeVerb => 'Verbo';

  @override
  String get typeAdjective => 'Adjetivo';

  @override
  String get typePhrase => 'Frase';

  @override
  String get searchHint => 'Italiano, inglés, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words palabras · $phrases frases';
  }

  @override
  String get recentSearches => 'Búsquedas recientes';

  @override
  String get clearRecent => 'Borrar';

  @override
  String get noResults => 'No se encontró ninguna palabra';

  @override
  String get didYouMean => '¿Querías decir…?';

  @override
  String get searchOnline => 'Buscar en línea';

  @override
  String get searchingOnline => 'Buscando en línea…';

  @override
  String get offlineNotice => 'No tienes conexión. Todas las palabras de la app siguen funcionando.';

  @override
  String get onlineResultTitle => 'De Wikcionario';

  @override
  String get addToMyWords => 'Agregar a mis palabras';

  @override
  String get removeFromMyWords => 'Quitar de mis palabras';

  @override
  String get myWordsEmpty => 'Aún no hay palabras guardadas. Usa “Agregar a mis palabras” en Buscar.';

  @override
  String get quizOnMyWords => 'Quiz de mis palabras';

  @override
  String get todayTitle => 'Las palabras de hoy';

  @override
  String todayProgress(int n, int total) {
    return 'Palabra $n de $total';
  }

  @override
  String streakDays(int n) {
    return '$n días seguidos';
  }

  @override
  String get miniQuizCta => 'Mini-quiz de las palabras de hoy';

  @override
  String get learnedToday => 'Visto hoy';

  @override
  String get todayDone => 'Viste las 10 palabras. ¡Vuelve mañana!';

  @override
  String get quizPickCategory => 'Elige una categoría';

  @override
  String get mixOfAll => 'Mezcla de todo';

  @override
  String quizProgress(int n, int total) {
    return 'Pregunta $n de $total';
  }

  @override
  String get quizQuestionPrompt => '¿La palabra corresponde a la imagen?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'verdadero';

  @override
  String get falsoHint => 'falso';

  @override
  String get answerCorrect => '¡Correcto!';

  @override
  String get answerWrong => 'Incorrecto';

  @override
  String get correctAnswerIs => 'La palabra correcta es:';

  @override
  String get quizResultTitle => 'Tu resultado';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'APROBADO';

  @override
  String get notPassed => 'NO APROBADO';

  @override
  String get passRule => 'Se aprueba con 2 errores como máximo';

  @override
  String mistakesCount(int n) {
    return '$n errores';
  }

  @override
  String get noMistakes => 'Sin errores. ¡Perfecto!';

  @override
  String get repeatMistakes => 'Repetir los errores';

  @override
  String get newQuiz => 'Nuevo quiz';

  @override
  String bestScoreValue(int score, int total) {
    return 'Mejor: $score/$total';
  }

  @override
  String get quizNotEnoughWords => 'Esta categoría necesita más palabras para el quiz.';

  @override
  String get topicsSubtitle => 'Aprende por categoría';

  @override
  String nWords(int n) {
    return '$n palabras';
  }

  @override
  String nLearned(int n) {
    return '$n aprendidas';
  }

  @override
  String get flashcards => 'Tarjetas';

  @override
  String get quiz20 => 'Quiz 20';

  @override
  String get flashcardTapToFlip => 'Toca la tarjeta para ver la traducción';

  @override
  String get interfaceLanguage => 'Idioma de la app';

  @override
  String get audioSpeed => 'Velocidad del audio';

  @override
  String get dailyReminder => 'Recordatorio diario';

  @override
  String get reminderTime => 'Hora del recordatorio';

  @override
  String get reminderBody => 'Te esperan 10 palabras italianas nuevas.';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get resetProgress => 'Borrar progreso';

  @override
  String get resetProgressConfirm => '¿Borrar racha, puntuaciones y palabras guardadas?';

  @override
  String get resetDone => 'Progreso borrado';

  @override
  String get privacy => 'Privacidad';

  @override
  String get about => 'Acerca de y créditos';

  @override
  String get adsConsentChange => 'Cambiar consentimiento de anuncios';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String get removeAdsBody => 'Un solo pago, nunca más anuncios. Palabras, temas y quizzes siguen gratis.';

  @override
  String get buy => 'Comprar';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get adsRemoved => 'Anuncios eliminados. ¡Gracias!';

  @override
  String get purchasePending => 'Pago en curso…';

  @override
  String get purchaseError => 'La compra no se completó.';

  @override
  String get nothingToRestore => 'No se encontró ninguna compra anterior.';

  @override
  String get webPurchaseNotice => 'Las compras están disponibles en la app de Android y iPhone.';

  @override
  String get storeUnavailable => 'La tienda no está disponible ahora.';

  @override
  String get voiceHelpTitle => 'Instala la voz italiana';

  @override
  String get voiceHelpBody => 'Tu teléfono aún no tiene voz italiana. Abre Configuración › Sistema › Idiomas › Texto a voz, elige el motor de Google e instala el italiano. Leer las palabras funciona igual.';

  @override
  String get privacyBody => 'Esta app funciona sin conexión y no necesita inicio de sesión. Tu progreso, tus palabras guardadas y tu configuración se quedan solo en tu teléfono. Nunca recogemos tu nombre, correo ni ubicación. Los anuncios vienen de Google AdMob y solo se muestran si los aceptas en el formulario de consentimiento; puedes cambiar tu elección en Configuración. “Buscar en línea” envía a Wikcionario solo la palabra escrita. Para 13 años o más.';

  @override
  String get aboutBody => 'Una app pequeña y honesta para quien vive en Italia: busca una palabra, aprende diez nuevas al día y ponte a prueba como en el examen de manejo. Todo funciona sin conexión y sin cuenta.';

  @override
  String get creditsBody => 'Las traducciones y los ejemplos se escriben y revisan a mano para esta app. Las listas de palabras se compararon con fuentes abiertas: Wiktionary y Wikcionario (CC BY-SA 4.0), frases de Tatoeba (CC BY 2.0 FR) y Open Multilingual Wordnet. Las imágenes usan Google Noto Emoji (Apache 2.0). La pronunciación italiana usa el texto a voz del teléfono.';

  @override
  String get dataCoverage => 'Lista de palabras de esta versión';

  @override
  String get mascotCheer => '¡Bravo!';

  @override
  String get mascotTryAgain => '¡Sigue así!';

  @override
  String get adsTestIdsNotice => 'Configuración necesaria: los anuncios siguen usando los id de prueba de Google. Pega los id reales de AdMob para ganar.';

  @override
  String get demoBadge => 'Contenido de demostración';

  @override
  String get topicGreetings => 'Saludos y básicos';

  @override
  String get topicNumbers => 'Números';

  @override
  String get topicColors => 'Colores';

  @override
  String get topicTime => 'Días, meses y hora';

  @override
  String get topicFamily => 'Familia';

  @override
  String get topicBody => 'Cuerpo';

  @override
  String get topicHealth => 'Salud y médico';

  @override
  String get topicPharmacy => 'Farmacia';

  @override
  String get topicFood => 'Comida';

  @override
  String get topicFruit => 'Fruta';

  @override
  String get topicVegetables => 'Verduras';

  @override
  String get topicDrinks => 'Bebidas';

  @override
  String get topicCooking => 'Cocinar';

  @override
  String get topicShopping => 'Supermercado y compras';

  @override
  String get topicMoney => 'Dinero y banco';

  @override
  String get topicHouse => 'Casa';

  @override
  String get topicKitchen => 'Cocina';

  @override
  String get topicBathroom => 'Baño';

  @override
  String get topicClothes => 'Ropa y zapatos';

  @override
  String get topicWeather => 'Clima y estaciones';

  @override
  String get topicCity => 'Ciudad y lugares';

  @override
  String get topicTransport => 'Transporte y direcciones';

  @override
  String get topicWork => 'Trabajo';

  @override
  String get topicJobs => 'Oficios';

  @override
  String get topicOffices => 'Oficinas y documentos';

  @override
  String get topicSchool => 'Escuela';

  @override
  String get topicAnimals => 'Animales';

  @override
  String get topicNature => 'Naturaleza';

  @override
  String get topicSport => 'Deporte y tiempo libre';

  @override
  String get topicFeelings => 'Emociones';

  @override
  String get topicVerbs => 'Verbos comunes';

  @override
  String get topicAdjectives => 'Adjetivos comunes';

  @override
  String get topicPhrases => 'Frases útiles';

  @override
  String get langEn => 'English';

  @override
  String get langUr => 'اردو';

  @override
  String get langPaArab => 'پنجابی (شاہ مکھی)';

  @override
  String get langPa => 'ਪੰਜਾਬੀ (ਗੁਰਮੁਖੀ)';

  @override
  String get langBn => 'বাংলা';

  @override
  String get langSi => 'සිංහල';

  @override
  String get langZh => '简体中文';

  @override
  String get langFr => 'Français';

  @override
  String get langEs => 'Español (España)';

  @override
  String get langEs419 => 'Español (Latinoamérica)';

  @override
  String get langIt => 'Italiano';

  @override
  String get langPt => 'Português (Brasil)';

  @override
  String get langDe => 'Deutsch';

  @override
  String get langHi => 'हिन्दी';

  @override
  String get langAr => 'العربية';

  @override
  String get langId => 'Bahasa Indonesia';

  @override
  String get langRu => 'Русский';

  @override
  String get moreLanguages => 'Más idiomas';

  @override
  String get languageNoteWordTranslations => 'Las traducciones de palabras están en los diez idiomas principales; los demás idiomas de la interfaz usan inglés.';
}
