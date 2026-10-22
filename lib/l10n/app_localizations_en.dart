// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabToday => 'Today';

  @override
  String get tabQuiz => 'Quiz';

  @override
  String get tabTopics => 'Topics';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get myWords => 'My words';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get retry => 'Try again';

  @override
  String get listen => 'Listen';

  @override
  String get listenSlow => 'Slow';

  @override
  String get explanation => 'Explanation';

  @override
  String get exampleLabel => 'Example';

  @override
  String get typeNoun => 'Noun';

  @override
  String get typeVerb => 'Verb';

  @override
  String get typeAdjective => 'Adjective';

  @override
  String get typePhrase => 'Phrase';

  @override
  String get searchHint => 'Italian, English, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words words · $phrases phrases';
  }

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearRecent => 'Clear';

  @override
  String get noResults => 'No word found';

  @override
  String get didYouMean => 'Did you mean…?';

  @override
  String get searchOnline => 'Search online';

  @override
  String get searchingOnline => 'Searching online…';

  @override
  String get offlineNotice =>
      'You are offline. All words in the app still work.';

  @override
  String get onlineResultTitle => 'From Wiktionary';

  @override
  String get addToMyWords => 'Add to my words';

  @override
  String get removeFromMyWords => 'Remove from my words';

  @override
  String get myWordsEmpty =>
      'No saved words yet. Use “Add to my words” in Search.';

  @override
  String get quizOnMyWords => 'Quiz on my words';

  @override
  String get todayTitle => 'Today\'s words';

  @override
  String todayProgress(int n, int total) {
    return 'Word $n of $total';
  }

  @override
  String streakDays(int n) {
    return '$n day streak';
  }

  @override
  String get miniQuizCta => 'Mini-quiz on today\'s words';

  @override
  String get learnedToday => 'Seen today';

  @override
  String get todayDone => 'All 10 words seen. Come back tomorrow!';

  @override
  String get quizPickCategory => 'Choose a category';

  @override
  String get mixOfAll => 'Mix of all';

  @override
  String quizProgress(int n, int total) {
    return 'Question $n of $total';
  }

  @override
  String get quizQuestionPrompt => 'Does the word match the picture?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'true';

  @override
  String get falsoHint => 'false';

  @override
  String get answerCorrect => 'Correct!';

  @override
  String get answerWrong => 'Wrong';

  @override
  String get correctAnswerIs => 'The right word is:';

  @override
  String get quizResultTitle => 'Your result';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'PASSED';

  @override
  String get notPassed => 'NOT PASSED';

  @override
  String get passRule => 'Pass with 2 mistakes or fewer';

  @override
  String mistakesCount(int n) {
    return '$n mistakes';
  }

  @override
  String get noMistakes => 'No mistakes. Perfect!';

  @override
  String get repeatMistakes => 'Repeat the mistakes';

  @override
  String get newQuiz => 'New quiz';

  @override
  String bestScoreValue(int score, int total) {
    return 'Best: $score/$total';
  }

  @override
  String get quizNotEnoughWords => 'This category needs more words for a quiz.';

  @override
  String get topicsSubtitle => 'Learn by category';

  @override
  String nWords(int n) {
    return '$n words';
  }

  @override
  String nLearned(int n) {
    return '$n learned';
  }

  @override
  String get flashcards => 'Flashcards';

  @override
  String get quiz20 => 'Quiz 20';

  @override
  String get flashcardTapToFlip => 'Tap the card to see the translation';

  @override
  String get interfaceLanguage => 'Interface language';

  @override
  String get audioSpeed => 'Audio speed';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get reminderBody => '10 new Italian words are waiting for you.';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get resetProgress => 'Reset progress';

  @override
  String get resetProgressConfirm => 'Delete streak, scores and saved words?';

  @override
  String get resetDone => 'Progress reset';

  @override
  String get privacy => 'Privacy';

  @override
  String get about => 'About & credits';

  @override
  String get adsConsentChange => 'Change ads consent';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get removeAdsBody =>
      'One payment, no ads ever again. All words, topics and quizzes stay free.';

  @override
  String get buy => 'Buy';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get adsRemoved => 'Ads removed. Thank you!';

  @override
  String get purchasePending => 'Payment in progress…';

  @override
  String get purchaseError => 'The purchase did not go through.';

  @override
  String get nothingToRestore => 'No earlier purchase found.';

  @override
  String get webPurchaseNotice =>
      'Purchases are available in the Android and iPhone app.';

  @override
  String get storeUnavailable => 'The store is not available right now.';

  @override
  String get voiceHelpTitle => 'Install the Italian voice';

  @override
  String get voiceHelpBody =>
      'Your phone has no Italian voice yet. Open Settings › System › Languages › Text-to-speech, choose the Google speech engine and install Italian. Reading the words works anyway.';

  @override
  String get privacyBody =>
      'This app works offline and has no login. Your progress, saved words and settings stay on your phone only. We never collect your name, e-mail or location. Ads come from Google AdMob and are shown only after you accept them in the consent form; you can change your choice at any time in Settings. “Search online” sends only the word you typed to Wiktionary. For ages 13+.';

  @override
  String get aboutBody =>
      'A small, honest app for people living in Italy: search a word, learn ten new ones a day, and test yourself like in the driving-licence quiz. Everything works offline, with no account.';

  @override
  String get creditsBody =>
      'Translations and example sentences are written and checked by hand for this app. Word lists were cross-checked against open sources: Wiktionary and Wikizionario (CC BY-SA 4.0), Tatoeba example sentences (CC BY 2.0 FR) and the Open Multilingual Wordnet. Pictures use Google Noto Emoji (Apache 2.0). Italian pronunciation uses your phone\'s own text-to-speech.';

  @override
  String get dataCoverage => 'Word list in this version';

  @override
  String get mascotCheer => 'Bravo!';

  @override
  String get mascotTryAgain => 'Keep going!';

  @override
  String get adsTestIdsNotice =>
      'Setup needed: the ads still use Google\'s test ids. Paste the real AdMob ids to earn from them.';

  @override
  String get demoBadge => 'Demo content';

  @override
  String get topicGreetings => 'Greetings & basics';

  @override
  String get topicNumbers => 'Numbers';

  @override
  String get topicColors => 'Colors';

  @override
  String get topicTime => 'Days, months & time';

  @override
  String get topicFamily => 'Family';

  @override
  String get topicBody => 'Body';

  @override
  String get topicHealth => 'Health & doctor';

  @override
  String get topicPharmacy => 'Pharmacy';

  @override
  String get topicFood => 'Food';

  @override
  String get topicFruit => 'Fruit';

  @override
  String get topicVegetables => 'Vegetables';

  @override
  String get topicDrinks => 'Drinks';

  @override
  String get topicCooking => 'Cooking';

  @override
  String get topicShopping => 'Supermarket & shopping';

  @override
  String get topicMoney => 'Money & bank';

  @override
  String get topicHouse => 'House';

  @override
  String get topicKitchen => 'Kitchen';

  @override
  String get topicBathroom => 'Bathroom';

  @override
  String get topicClothes => 'Clothes & shoes';

  @override
  String get topicWeather => 'Weather & seasons';

  @override
  String get topicCity => 'City & places';

  @override
  String get topicTransport => 'Transport & directions';

  @override
  String get topicWork => 'Work';

  @override
  String get topicJobs => 'Jobs';

  @override
  String get topicOffices => 'Offices & documents';

  @override
  String get topicSchool => 'School';

  @override
  String get topicAnimals => 'Animals';

  @override
  String get topicNature => 'Nature';

  @override
  String get topicSport => 'Sport & free time';

  @override
  String get topicFeelings => 'Feelings';

  @override
  String get topicVerbs => 'Common verbs';

  @override
  String get topicAdjectives => 'Common adjectives';

  @override
  String get topicPhrases => 'Useful phrases';

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
  String get moreLanguages => 'More languages';

  @override
  String get languageNoteWordTranslations =>
      'Word translations are shown in the ten main languages; other interface languages fall back to English.';

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

  @override
  String get bigSearchingOnline => 'Searching online…';

  @override
  String get bigNotAllowed => 'This word cannot be added to the dictionary.';

  @override
  String get bigNotFoundOnline =>
      'Not found online either: check how you wrote it.';
}
