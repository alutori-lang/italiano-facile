// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Italian Words: Learn & Play';

  @override
  String get tabSearch => 'Cerca';

  @override
  String get tabToday => 'Oggi';

  @override
  String get tabQuiz => 'Quiz';

  @override
  String get tabTopics => 'Argomenti';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get myWords => 'Le mie parole';

  @override
  String get back => 'Indietro';

  @override
  String get next => 'Avanti';

  @override
  String get done => 'Fatto';

  @override
  String get close => 'Chiudi';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get retry => 'Riprova';

  @override
  String get listen => 'Ascolta';

  @override
  String get listenSlow => 'Lento';

  @override
  String get explanation => 'Spiegazione';

  @override
  String get exampleLabel => 'Esempio';

  @override
  String get typeNoun => 'Nome';

  @override
  String get typeVerb => 'Verbo';

  @override
  String get typeAdjective => 'Aggettivo';

  @override
  String get typePhrase => 'Frase';

  @override
  String get searchHint => 'Scrivi in italiano o nella tua lingua…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words parole · $phrases frasi';
  }

  @override
  String get recentSearches => 'Ricerche recenti';

  @override
  String get clearRecent => 'Cancella';

  @override
  String get noResults => 'Nessuna parola trovata';

  @override
  String get didYouMean => 'Volevi dire…?';

  @override
  String get searchOnline => 'Cerca online';

  @override
  String get searchingOnline => 'Ricerca online…';

  @override
  String get offlineNotice =>
      'Sei offline. Tutte le parole dell\'app funzionano comunque.';

  @override
  String get onlineResultTitle => 'Da Wikizionario';

  @override
  String get addToMyWords => 'Aggiungi alle mie parole';

  @override
  String get removeFromMyWords => 'Togli dalle mie parole';

  @override
  String get myWordsEmpty =>
      'Ancora nessuna parola salvata. Usa “Aggiungi alle mie parole” nella Ricerca.';

  @override
  String get quizOnMyWords => 'Quiz sulle mie parole';

  @override
  String get todayTitle => 'Le parole di oggi';

  @override
  String todayProgress(int n, int total) {
    return 'Parola $n di $total';
  }

  @override
  String streakDays(int n) {
    return '$n giorni di fila';
  }

  @override
  String get miniQuizCta => 'Mini-quiz sulle parole di oggi';

  @override
  String get learnedToday => 'Visto oggi';

  @override
  String get todayDone => 'Tutte le 10 parole viste. Torna domani!';

  @override
  String get quizPickCategory => 'Scegli una categoria';

  @override
  String get mixOfAll => 'Mix di tutto';

  @override
  String quizProgress(int n, int total) {
    return 'Domanda $n di $total';
  }

  @override
  String get quizQuestionPrompt => 'La parola corrisponde all\'immagine?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'vero';

  @override
  String get falsoHint => 'falso';

  @override
  String get answerCorrect => 'Giusto!';

  @override
  String get answerWrong => 'Sbagliato';

  @override
  String get correctAnswerIs => 'La parola giusta è:';

  @override
  String get quizResultTitle => 'Il tuo risultato';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'PROMOSSO';

  @override
  String get notPassed => 'NON PROMOSSO';

  @override
  String get passRule => 'Si passa con massimo 2 errori';

  @override
  String mistakesCount(int n) {
    return '$n errori';
  }

  @override
  String get noMistakes => 'Nessun errore. Perfetto!';

  @override
  String get repeatMistakes => 'Ripeti gli errori';

  @override
  String get newQuiz => 'Nuovo quiz';

  @override
  String bestScoreValue(int score, int total) {
    return 'Record: $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'Questa categoria ha bisogno di più parole per il quiz.';

  @override
  String get topicsSubtitle => 'Impara per categoria';

  @override
  String nWords(int n) {
    return '$n parole';
  }

  @override
  String nLearned(int n) {
    return '$n imparate';
  }

  @override
  String get flashcards => 'Flashcard';

  @override
  String get quiz20 => 'Quiz 20';

  @override
  String get flashcardTapToFlip => 'Tocca la carta per vedere la traduzione';

  @override
  String get interfaceLanguage => 'Lingua di traduzione';

  @override
  String get audioSpeed => 'Velocità dell\'audio';

  @override
  String get dailyReminder => 'Promemoria giornaliero';

  @override
  String get reminderTime => 'Ora del promemoria';

  @override
  String get reminderBody => 'Ti aspettano 10 nuove parole italiane.';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get resetProgress => 'Azzera i progressi';

  @override
  String get resetProgressConfirm =>
      'Cancellare serie, punteggi e parole salvate?';

  @override
  String get resetDone => 'Progressi azzerati';

  @override
  String get privacy => 'Privacy';

  @override
  String get about => 'Info e crediti';

  @override
  String get adsConsentChange => 'Modifica consenso pubblicità';

  @override
  String get removeAds => 'Togli la pubblicità';

  @override
  String get removeAdsBody =>
      'Un solo pagamento, mai più pubblicità. Parole, argomenti e quiz restano gratis.';

  @override
  String get buy => 'Acquista';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get adsRemoved => 'Pubblicità rimossa. Grazie!';

  @override
  String get purchasePending => 'Pagamento in corso…';

  @override
  String get purchaseError => 'L\'acquisto non è andato a buon fine.';

  @override
  String get nothingToRestore =>
      'Richiesta inviata. Se avevi già comprato, la pubblicità sparisce tra pochi secondi.';

  @override
  String get webPurchaseNotice =>
      'Gli acquisti sono disponibili nell\'app Android e iPhone.';

  @override
  String get storeUnavailable =>
      'Lo store non è disponibile in questo momento.';

  @override
  String get voiceHelpTitle => 'Installa la voce italiana';

  @override
  String get voiceHelpBody =>
      'Il telefono non ha ancora una voce italiana. Apri Impostazioni › Sistema › Lingue › Sintesi vocale, scegli il motore Google e installa l\'italiano. Leggere le parole funziona comunque.';

  @override
  String get privacyBody =>
      'Questa app funziona offline e non richiede login. I tuoi progressi, le parole salvate e le impostazioni restano solo sul tuo telefono. Non raccogliamo nome, e-mail o posizione. La pubblicità viene da Google AdMob e viene mostrata solo dopo la tua accettazione nel modulo di consenso; puoi cambiare scelta quando vuoi nelle Impostazioni. “Cerca online” invia a Wikizionario solo la parola digitata. Per età 13+.';

  @override
  String get aboutBody =>
      'Un\'app piccola e onesta per chi vive in Italia: cerca una parola, impara dieci parole nuove al giorno e mettiti alla prova come nel quiz della patente. Tutto funziona offline, senza account.';

  @override
  String get creditsBody =>
      'Le traduzioni e le frasi di esempio sono scritte e controllate a mano per questa app. Gli elenchi di parole sono stati confrontati con fonti aperte: Wiktionary e Wikizionario (CC BY-SA 4.0), frasi di Tatoeba (CC BY 2.0 FR) e Open Multilingual Wordnet. Le immagini usano Google Noto Emoji (Apache 2.0). La pronuncia italiana usa la sintesi vocale del telefono.';

  @override
  String get dataCoverage => 'Elenco di parole in questa versione';

  @override
  String get mascotCheer => 'Bravo!';

  @override
  String get mascotTryAgain => 'Dai, continua!';

  @override
  String get adsTestIdsNotice =>
      'Configurazione necessaria: la pubblicità usa ancora gli id di test di Google. Incolla gli id AdMob reali per guadagnare.';

  @override
  String get demoBadge => 'Contenuto dimostrativo';

  @override
  String get topicGreetings => 'Saluti e basi';

  @override
  String get topicNumbers => 'Numeri';

  @override
  String get topicColors => 'Colori';

  @override
  String get topicTime => 'Giorni, mesi e ora';

  @override
  String get topicFamily => 'Famiglia';

  @override
  String get topicBody => 'Corpo';

  @override
  String get topicHealth => 'Salute e medico';

  @override
  String get topicPharmacy => 'Farmacia';

  @override
  String get topicFood => 'Cibo';

  @override
  String get topicFruit => 'Frutta';

  @override
  String get topicVegetables => 'Verdura';

  @override
  String get topicDrinks => 'Bevande';

  @override
  String get topicCooking => 'In cucina';

  @override
  String get topicShopping => 'Supermercato e spesa';

  @override
  String get topicMoney => 'Soldi e banca';

  @override
  String get topicHouse => 'Casa';

  @override
  String get topicKitchen => 'Cucina';

  @override
  String get topicBathroom => 'Bagno';

  @override
  String get topicClothes => 'Vestiti e scarpe';

  @override
  String get topicWeather => 'Tempo e stagioni';

  @override
  String get topicCity => 'Città e luoghi';

  @override
  String get topicTransport => 'Trasporti e indicazioni';

  @override
  String get topicWork => 'Lavoro';

  @override
  String get topicJobs => 'Mestieri';

  @override
  String get topicOffices => 'Uffici e documenti';

  @override
  String get topicSchool => 'Scuola';

  @override
  String get topicAnimals => 'Animali';

  @override
  String get topicNature => 'Natura';

  @override
  String get topicSport => 'Sport e tempo libero';

  @override
  String get topicFeelings => 'Emozioni';

  @override
  String get topicVerbs => 'Verbi comuni';

  @override
  String get topicAdjectives => 'Aggettivi comuni';

  @override
  String get topicPhrases => 'Frasi utili';

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
  String get moreLanguages => 'Altre lingue';

  @override
  String get languageNoteWordTranslations =>
      'Scegli la tua lingua: vedrai il significato delle parole italiane in questa lingua e potrai cercare scrivendo in questa lingua.';
}
