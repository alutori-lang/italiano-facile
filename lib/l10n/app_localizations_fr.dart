// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Italian Words: Learn & Play';

  @override
  String get tabSearch => 'Rechercher';

  @override
  String get tabToday => 'Aujourd\'hui';

  @override
  String get tabQuiz => 'Quiz';

  @override
  String get tabTopics => 'Thèmes';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get myWords => 'Mes mots';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get done => 'Terminé';

  @override
  String get close => 'Fermer';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get retry => 'Réessayer';

  @override
  String get listen => 'Écouter';

  @override
  String get listenSlow => 'Lent';

  @override
  String get explanation => 'Explication';

  @override
  String get exampleLabel => 'Exemple';

  @override
  String get typeNoun => 'Nom';

  @override
  String get typeVerb => 'Verbe';

  @override
  String get typeAdjective => 'Adjectif';

  @override
  String get typePhrase => 'Phrase';

  @override
  String get searchHint => 'Italien, anglais, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words mots · $phrases phrases';
  }

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String get clearRecent => 'Effacer';

  @override
  String get noResults => 'Aucun mot trouvé';

  @override
  String get didYouMean => 'Vouliez-vous dire…?';

  @override
  String get searchOnline => 'Chercher en ligne';

  @override
  String get searchingOnline => 'Recherche en ligne…';

  @override
  String get offlineNotice =>
      'Vous êtes hors ligne. Tous les mots de l\'application fonctionnent quand même.';

  @override
  String get onlineResultTitle => 'Du Wiktionnaire';

  @override
  String get addToMyWords => 'Ajouter à mes mots';

  @override
  String get removeFromMyWords => 'Retirer de mes mots';

  @override
  String get myWordsEmpty =>
      'Aucun mot enregistré. Utilisez « Ajouter à mes mots » dans Rechercher.';

  @override
  String get quizOnMyWords => 'Quiz sur mes mots';

  @override
  String get todayTitle => 'Les mots du jour';

  @override
  String todayProgress(int n, int total) {
    return 'Mot $n sur $total';
  }

  @override
  String streakDays(int n) {
    return '$n jours de suite';
  }

  @override
  String get miniQuizCta => 'Mini-quiz des mots du jour';

  @override
  String get learnedToday => 'Vu aujourd\'hui';

  @override
  String get todayDone => 'Les 10 mots sont vus. Revenez demain !';

  @override
  String get quizPickCategory => 'Choisissez une catégorie';

  @override
  String get mixOfAll => 'Mélange de tout';

  @override
  String quizProgress(int n, int total) {
    return 'Question $n sur $total';
  }

  @override
  String get quizQuestionPrompt => 'Le mot correspond-il à l\'image ?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'vrai';

  @override
  String get falsoHint => 'faux';

  @override
  String get answerCorrect => 'Correct !';

  @override
  String get answerWrong => 'Faux';

  @override
  String get correctAnswerIs => 'Le bon mot est :';

  @override
  String get quizResultTitle => 'Votre résultat';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'RÉUSSI';

  @override
  String get notPassed => 'NON RÉUSSI';

  @override
  String get passRule => 'Réussi avec 2 erreurs au maximum';

  @override
  String mistakesCount(int n) {
    return '$n erreurs';
  }

  @override
  String get noMistakes => 'Aucune erreur. Parfait !';

  @override
  String get repeatMistakes => 'Revoir les erreurs';

  @override
  String get newQuiz => 'Nouveau quiz';

  @override
  String bestScoreValue(int score, int total) {
    return 'Record : $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'Cette catégorie a besoin de plus de mots pour un quiz.';

  @override
  String get topicsSubtitle => 'Apprendre par catégorie';

  @override
  String nWords(int n) {
    return '$n mots';
  }

  @override
  String nLearned(int n) {
    return '$n appris';
  }

  @override
  String get flashcards => 'Cartes';

  @override
  String get quiz20 => 'Quiz 20';

  @override
  String get flashcardTapToFlip => 'Touchez la carte pour voir la traduction';

  @override
  String get interfaceLanguage => 'Langue de l\'application';

  @override
  String get audioSpeed => 'Vitesse de l\'audio';

  @override
  String get dailyReminder => 'Rappel quotidien';

  @override
  String get reminderTime => 'Heure du rappel';

  @override
  String get reminderBody => '10 nouveaux mots italiens vous attendent.';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get resetProgress => 'Réinitialiser la progression';

  @override
  String get resetProgressConfirm =>
      'Supprimer la série, les scores et les mots enregistrés ?';

  @override
  String get resetDone => 'Progression réinitialisée';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get about => 'À propos et crédits';

  @override
  String get adsConsentChange => 'Modifier le consentement publicitaire';

  @override
  String get removeAds => 'Supprimer les publicités';

  @override
  String get removeAdsBody =>
      'Un seul paiement, plus aucune publicité. Mots, thèmes et quiz restent gratuits.';

  @override
  String get buy => 'Acheter';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get adsRemoved => 'Publicités supprimées. Merci !';

  @override
  String get purchasePending => 'Paiement en cours…';

  @override
  String get purchaseError => 'L\'achat n\'a pas abouti.';

  @override
  String get nothingToRestore => 'Aucun achat précédent trouvé.';

  @override
  String get webPurchaseNotice =>
      'Les achats sont disponibles dans l\'application Android et iPhone.';

  @override
  String get storeUnavailable =>
      'La boutique n\'est pas disponible pour le moment.';

  @override
  String get voiceHelpTitle => 'Installer la voix italienne';

  @override
  String get voiceHelpBody =>
      'Votre téléphone n\'a pas encore de voix italienne. Ouvrez Réglages › Système › Langues › Synthèse vocale, choisissez le moteur Google et installez l\'italien. La lecture des mots fonctionne quand même.';

  @override
  String get privacyBody =>
      'Cette application fonctionne hors ligne et sans compte. Votre progression, vos mots enregistrés et vos réglages restent uniquement sur votre téléphone. Nous ne collectons jamais votre nom, votre e-mail ni votre position. Les publicités viennent de Google AdMob et ne s\'affichent qu\'après votre acceptation dans le formulaire de consentement ; vous pouvez changer d\'avis dans les Réglages. « Chercher en ligne » n\'envoie au Wiktionnaire que le mot saisi. Pour 13 ans et plus.';

  @override
  String get aboutBody =>
      'Une petite application honnête pour celles et ceux qui vivent en Italie : cherchez un mot, apprenez dix nouveaux mots par jour et testez-vous comme à l\'examen du permis. Tout fonctionne hors ligne, sans compte.';

  @override
  String get creditsBody =>
      'Les traductions et les phrases d\'exemple sont écrites et vérifiées à la main pour cette application. Les listes de mots ont été recoupées avec des sources ouvertes : Wiktionary et Wikizionario (CC BY-SA 4.0), phrases de Tatoeba (CC BY 2.0 FR) et Open Multilingual Wordnet. Les images utilisent Google Noto Emoji (Apache 2.0). La prononciation italienne utilise la synthèse vocale du téléphone.';

  @override
  String get dataCoverage => 'Liste de mots de cette version';

  @override
  String get mascotCheer => 'Bravo !';

  @override
  String get mascotTryAgain => 'Continuez !';

  @override
  String get adsTestIdsNotice =>
      'Configuration nécessaire : les publicités utilisent encore les id de test de Google. Collez les vrais id AdMob pour gagner.';

  @override
  String get demoBadge => 'Contenu de démonstration';

  @override
  String get topicGreetings => 'Salutations et bases';

  @override
  String get topicNumbers => 'Nombres';

  @override
  String get topicColors => 'Couleurs';

  @override
  String get topicTime => 'Jours, mois et heure';

  @override
  String get topicFamily => 'Famille';

  @override
  String get topicBody => 'Corps';

  @override
  String get topicHealth => 'Santé et médecin';

  @override
  String get topicPharmacy => 'Pharmacie';

  @override
  String get topicFood => 'Nourriture';

  @override
  String get topicFruit => 'Fruits';

  @override
  String get topicVegetables => 'Légumes';

  @override
  String get topicDrinks => 'Boissons';

  @override
  String get topicCooking => 'Cuisiner';

  @override
  String get topicShopping => 'Supermarché et courses';

  @override
  String get topicMoney => 'Argent et banque';

  @override
  String get topicHouse => 'Maison';

  @override
  String get topicKitchen => 'Cuisine';

  @override
  String get topicBathroom => 'Salle de bain';

  @override
  String get topicClothes => 'Vêtements et chaussures';

  @override
  String get topicWeather => 'Météo et saisons';

  @override
  String get topicCity => 'Ville et lieux';

  @override
  String get topicTransport => 'Transports et itinéraires';

  @override
  String get topicWork => 'Travail';

  @override
  String get topicJobs => 'Métiers';

  @override
  String get topicOffices => 'Administrations et documents';

  @override
  String get topicSchool => 'École';

  @override
  String get topicAnimals => 'Animaux';

  @override
  String get topicNature => 'Nature';

  @override
  String get topicSport => 'Sport et loisirs';

  @override
  String get topicFeelings => 'Émotions';

  @override
  String get topicVerbs => 'Verbes courants';

  @override
  String get topicAdjectives => 'Adjectifs courants';

  @override
  String get topicPhrases => 'Phrases utiles';

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
  String get moreLanguages => 'Autres langues';

  @override
  String get languageNoteWordTranslations =>
      'Les traductions des mots sont dans les dix langues principales ; les autres langues d\'interface utilisent l\'anglais.';

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
  String get bigDictCredits =>
      'The big dictionary of Italian words (over 100,000 words when complete) comes from Wiktionary, through kaikki.org, under the CC BY-SA 4.0 licence. The meanings in the ten languages were prepared for this app from the Wiktionary definitions.';
}
