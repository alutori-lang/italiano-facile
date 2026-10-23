// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'ਖੋਜ';

  @override
  String get tabToday => 'ਅੱਜ';

  @override
  String get tabQuiz => 'ਕੁਇਜ਼';

  @override
  String get tabTopics => 'ਵਿਸ਼ੇ';

  @override
  String get settingsTitle => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get myWords => 'ਮੇਰੇ ਸ਼ਬਦ';

  @override
  String get back => 'ਪਿੱਛੇ';

  @override
  String get next => 'ਅਗਲਾ';

  @override
  String get done => 'ਮੁਕੰਮਲ';

  @override
  String get close => 'ਬੰਦ ਕਰੋ';

  @override
  String get cancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get confirm => 'ਪੁਸ਼ਟੀ ਕਰੋ';

  @override
  String get retry => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get listen => 'ਸੁਣੋ';

  @override
  String get listenSlow => 'ਹੌਲੀ';

  @override
  String get explanation => 'ਵਿਆਖਿਆ';

  @override
  String get exampleLabel => 'ਉਦਾਹਰਨ';

  @override
  String get typeNoun => 'ਨਾਂਵ';

  @override
  String get typeVerb => 'ਕਿਰਿਆ';

  @override
  String get typeAdjective => 'ਵਿਸ਼ੇਸ਼ਣ';

  @override
  String get typePhrase => 'ਵਾਕ';

  @override
  String get searchHint => 'ਇਤਾਲਵੀ, ਅੰਗਰੇਜ਼ੀ, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    final intl.NumberFormat wordsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wordsString = wordsNumberFormat.format(words);
    final intl.NumberFormat phrasesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String phrasesString = phrasesNumberFormat.format(phrases);

    return '$wordsString ਸ਼ਬਦ · $phrasesString ਵਾਕ';
  }

  @override
  String wordsAndPhrasesTotal(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString ਸ਼ਬਦ ਅਤੇ ਵਾਕ';
  }

  @override
  String get recentSearches => 'ਹਾਲੀਆ ਖੋਜਾਂ';

  @override
  String get clearRecent => 'ਸਾਫ਼ ਕਰੋ';

  @override
  String get noResults => 'ਕੋਈ ਸ਼ਬਦ ਨਹੀਂ ਮਿਲਿਆ';

  @override
  String get didYouMean => 'ਕੀ ਤੁਹਾਡਾ ਮਤਲਬ ਸੀ…?';

  @override
  String get searchOnline => 'ਆਨਲਾਈਨ ਖੋਜੋ';

  @override
  String get searchingOnline => 'ਆਨਲਾਈਨ ਖੋਜ ਹੋ ਰਹੀ ਹੈ…';

  @override
  String get offlineNotice =>
      'ਤੁਸੀਂ ਆਫ਼ਲਾਈਨ ਹੋ। ਐਪ ਦੇ ਸਾਰੇ ਸ਼ਬਦ ਫਿਰ ਵੀ ਕੰਮ ਕਰਦੇ ਹਨ।';

  @override
  String get onlineResultTitle => 'ਵਿਕਸ਼ਨਰੀ ਤੋਂ';

  @override
  String get addToMyWords => 'ਮੇਰੇ ਸ਼ਬਦਾਂ ਵਿੱਚ ਜੋੜੋ';

  @override
  String get removeFromMyWords => 'ਮੇਰੇ ਸ਼ਬਦਾਂ ਵਿੱਚੋਂ ਹਟਾਓ';

  @override
  String get myWordsEmpty =>
      'ਹਾਲੇ ਕੋਈ ਸ਼ਬਦ ਸੰਭਾਲਿਆ ਨਹੀਂ। ਖੋਜ ਵਿੱਚ “ਮੇਰੇ ਸ਼ਬਦਾਂ ਵਿੱਚ ਜੋੜੋ” ਦਬਾਓ।';

  @override
  String get quizOnMyWords => 'ਮੇਰੇ ਸ਼ਬਦਾਂ ਦਾ ਕੁਇਜ਼';

  @override
  String get todayTitle => 'ਅੱਜ ਦੇ ਸ਼ਬਦ';

  @override
  String todayProgress(int n, int total) {
    return 'ਸ਼ਬਦ $n / $total';
  }

  @override
  String streakDays(int n) {
    return '$n ਦਿਨ ਲਗਾਤਾਰ';
  }

  @override
  String get miniQuizCta => 'ਅੱਜ ਦੇ ਸ਼ਬਦਾਂ ਦਾ ਮਿਨੀ ਕੁਇਜ਼';

  @override
  String get learnedToday => 'ਅੱਜ ਵੇਖਿਆ';

  @override
  String get todayDone => 'ਸਾਰੇ 10 ਸ਼ਬਦ ਵੇਖ ਲਏ। ਕੱਲ੍ਹ ਫਿਰ ਆਓ!';

  @override
  String get quizPickCategory => 'ਇੱਕ ਸ਼੍ਰੇਣੀ ਚੁਣੋ';

  @override
  String get mixOfAll => 'ਸਭ ਦਾ ਮਿਕਸ';

  @override
  String quizProgress(int n, int total) {
    return 'ਸਵਾਲ $n / $total';
  }

  @override
  String get quizQuestionPrompt => 'ਕੀ ਸ਼ਬਦ ਤਸਵੀਰ ਨਾਲ ਮੇਲ ਖਾਂਦਾ ਹੈ?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'ਸਹੀ';

  @override
  String get falsoHint => 'ਗਲਤ';

  @override
  String get answerCorrect => 'ਸਹੀ!';

  @override
  String get answerWrong => 'ਗਲਤ';

  @override
  String get correctAnswerIs => 'ਸਹੀ ਸ਼ਬਦ ਹੈ:';

  @override
  String get quizResultTitle => 'ਤੁਹਾਡਾ ਨਤੀਜਾ';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'ਪਾਸ';

  @override
  String get notPassed => 'ਪਾਸ ਨਹੀਂ';

  @override
  String get passRule => '2 ਜਾਂ ਘੱਟ ਗਲਤੀਆਂ ਤੇ ਪਾਸ';

  @override
  String mistakesCount(int n) {
    return '$n ਗਲਤੀਆਂ';
  }

  @override
  String get noMistakes => 'ਕੋਈ ਗਲਤੀ ਨਹੀਂ। ਬਹੁਤ ਵਧੀਆ!';

  @override
  String get repeatMistakes => 'ਗਲਤੀਆਂ ਦੁਹਰਾਓ';

  @override
  String get newQuiz => 'ਨਵਾਂ ਕੁਇਜ਼';

  @override
  String bestScoreValue(int score, int total) {
    return 'ਸਭ ਤੋਂ ਵਧੀਆ: $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'ਇਸ ਸ਼੍ਰੇਣੀ ਵਿੱਚ ਕੁਇਜ਼ ਲਈ ਹੋਰ ਸ਼ਬਦ ਚਾਹੀਦੇ ਹਨ।';

  @override
  String get topicsSubtitle => 'ਸ਼੍ਰੇਣੀ ਅਨੁਸਾਰ ਸਿੱਖੋ';

  @override
  String nWords(int n) {
    return '$n ਸ਼ਬਦ';
  }

  @override
  String nLearned(int n) {
    return '$n ਸਿੱਖੇ';
  }

  @override
  String get flashcards => 'ਫਲੈਸ਼ਕਾਰਡ';

  @override
  String get quiz20 => 'ਕੁਇਜ਼ 20';

  @override
  String get flashcardTapToFlip => 'ਅਨੁਵਾਦ ਵੇਖਣ ਲਈ ਕਾਰਡ ਦਬਾਓ';

  @override
  String get interfaceLanguage => 'ਐਪ ਦੀ ਭਾਸ਼ਾ';

  @override
  String get audioSpeed => 'ਆਵਾਜ਼ ਦੀ ਰਫ਼ਤਾਰ';

  @override
  String get dailyReminder => 'ਰੋਜ਼ਾਨਾ ਯਾਦ';

  @override
  String get reminderTime => 'ਯਾਦ ਦਾ ਸਮਾਂ';

  @override
  String get reminderBody => '10 ਨਵੇਂ ਇਤਾਲਵੀ ਸ਼ਬਦ ਤੁਹਾਡੀ ਉਡੀਕ ਕਰ ਰਹੇ ਹਨ।';

  @override
  String get darkMode => 'ਡਾਰਕ ਮੋਡ';

  @override
  String get resetProgress => 'ਪ੍ਰਗਤੀ ਮਿਟਾਓ';

  @override
  String get resetProgressConfirm => 'ਸਟ੍ਰੀਕ, ਸਕੋਰ ਅਤੇ ਸੰਭਾਲੇ ਸ਼ਬਦ ਮਿਟਾਉਣੇ?';

  @override
  String get resetDone => 'ਪ੍ਰਗਤੀ ਮਿਟ ਗਈ';

  @override
  String get privacy => 'ਪਰਦੇਦਾਰੀ';

  @override
  String get about => 'ਐਪ ਬਾਰੇ';

  @override
  String get adsConsentChange => 'ਵਿਗਿਆਪਨ ਸਹਿਮਤੀ ਬਦਲੋ';

  @override
  String get removeAds => 'ਵਿਗਿਆਪਨ ਹਟਾਓ';

  @override
  String get removeAdsBody =>
      'ਇੱਕ ਵਾਰ ਭੁਗਤਾਨ, ਫਿਰ ਕੋਈ ਵਿਗਿਆਪਨ ਨਹੀਂ। ਸਾਰੇ ਸ਼ਬਦ, ਵਿਸ਼ੇ ਅਤੇ ਕੁਇਜ਼ ਮੁਫ਼ਤ ਰਹਿੰਦੇ ਹਨ।';

  @override
  String get buy => 'ਖਰੀਦੋ';

  @override
  String get restorePurchases => 'ਖਰੀਦ ਬਹਾਲ ਕਰੋ';

  @override
  String get adsRemoved => 'ਵਿਗਿਆਪਨ ਹਟ ਗਏ। ਧੰਨਵਾਦ!';

  @override
  String get purchasePending => 'ਭੁਗਤਾਨ ਚੱਲ ਰਿਹਾ ਹੈ…';

  @override
  String get purchaseError => 'ਖਰੀਦ ਪੂਰੀ ਨਹੀਂ ਹੋਈ।';

  @override
  String get nothingToRestore => 'ਕੋਈ ਪੁਰਾਣੀ ਖਰੀਦ ਨਹੀਂ ਮਿਲੀ।';

  @override
  String get webPurchaseNotice => 'ਖਰੀਦ Android ਅਤੇ iPhone ਐਪ ਵਿੱਚ ਉਪਲਬਧ ਹੈ।';

  @override
  String get storeUnavailable => 'ਸਟੋਰ ਹੁਣ ਉਪਲਬਧ ਨਹੀਂ ਹੈ।';

  @override
  String get voiceHelpTitle => 'ਇਤਾਲਵੀ ਆਵਾਜ਼ ਇੰਸਟਾਲ ਕਰੋ';

  @override
  String get voiceHelpBody =>
      'ਤੁਹਾਡੇ ਫ਼ੋਨ ਵਿੱਚ ਹਾਲੇ ਇਤਾਲਵੀ ਆਵਾਜ਼ ਨਹੀਂ ਹੈ। ਸੈਟਿੰਗਾਂ › ਸਿਸਟਮ › ਭਾਸ਼ਾਵਾਂ › ਟੈਕਸਟ-ਟੂ-ਸਪੀਚ ਖੋਲ੍ਹੋ, Google ਇੰਜਨ ਚੁਣੋ ਅਤੇ ਇਤਾਲਵੀ ਇੰਸਟਾਲ ਕਰੋ। ਸ਼ਬਦ ਪੜ੍ਹਨਾ ਫਿਰ ਵੀ ਕੰਮ ਕਰਦਾ ਹੈ।';

  @override
  String get privacyBody =>
      'ਇਹ ਐਪ ਆਫ਼ਲਾਈਨ ਚੱਲਦੀ ਹੈ ਅਤੇ ਲਾਗ-ਇਨ ਨਹੀਂ ਮੰਗਦੀ। ਤੁਹਾਡੀ ਪ੍ਰਗਤੀ, ਸੰਭਾਲੇ ਸ਼ਬਦ ਅਤੇ ਸੈਟਿੰਗਾਂ ਸਿਰਫ਼ ਤੁਹਾਡੇ ਫ਼ੋਨ ਉੱਤੇ ਰਹਿੰਦੀਆਂ ਹਨ। ਅਸੀਂ ਤੁਹਾਡਾ ਨਾਮ, ਈ-ਮੇਲ ਜਾਂ ਸਥਾਨ ਕਦੇ ਇਕੱਠਾ ਨਹੀਂ ਕਰਦੇ। ਵਿਗਿਆਪਨ Google AdMob ਤੋਂ ਆਉਂਦੇ ਹਨ ਅਤੇ ਸਹਿਮਤੀ ਫਾਰਮ ਵਿੱਚ ਮਨਜ਼ੂਰੀ ਤੋਂ ਬਾਅਦ ਹੀ ਦਿਖਦੇ ਹਨ; ਤੁਸੀਂ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਕਦੇ ਵੀ ਬਦਲ ਸਕਦੇ ਹੋ। “ਆਨਲਾਈਨ ਖੋਜੋ” ਸਿਰਫ਼ ਲਿਖਿਆ ਸ਼ਬਦ ਵਿਕਸ਼ਨਰੀ ਨੂੰ ਭੇਜਦੀ ਹੈ। 13+ ਲਈ।';

  @override
  String get aboutBody =>
      'ਇਟਲੀ ਵਿੱਚ ਰਹਿਣ ਵਾਲਿਆਂ ਲਈ ਇੱਕ ਛੋਟੀ, ਇਮਾਨਦਾਰ ਐਪ: ਸ਼ਬਦ ਖੋਜੋ, ਰੋਜ਼ ਦਸ ਨਵੇਂ ਸ਼ਬਦ ਸਿੱਖੋ ਅਤੇ ਡਰਾਈਵਿੰਗ ਟੈਸਟ ਵਾਂਗ ਆਪਣੇ ਆਪ ਨੂੰ ਪਰਖੋ। ਸਭ ਕੁਝ ਆਫ਼ਲਾਈਨ ਚੱਲਦਾ ਹੈ, ਬਿਨਾਂ ਖਾਤੇ।';

  @override
  String get creditsBody =>
      'ਇਸ ਐਪ ਦੇ ਅਨੁਵਾਦ ਅਤੇ ਉਦਾਹਰਨ ਵਾਕ ਹੱਥ ਨਾਲ ਲਿਖੇ ਅਤੇ ਜਾਂਚੇ ਗਏ ਹਨ। ਸ਼ਬਦ ਸੂਚੀਆਂ ਖੁੱਲ੍ਹੇ ਸਰੋਤਾਂ ਨਾਲ ਮਿਲਾਈਆਂ ਗਈਆਂ: Wiktionary ਅਤੇ Wikizionario (CC BY-SA 4.0), Tatoeba ਦੇ ਵਾਕ (CC BY 2.0 FR) ਅਤੇ Open Multilingual Wordnet। ਤਸਵੀਰਾਂ Google Noto Emoji (Apache 2.0) ਤੋਂ ਹਨ। ਇਤਾਲਵੀ ਉਚਾਰਨ ਤੁਹਾਡੇ ਫ਼ੋਨ ਦੀ ਟੈਕਸਟ-ਟੂ-ਸਪੀਚ ਵਰਤਦਾ ਹੈ।';

  @override
  String get dataCoverage => 'ਇਸ ਵਰਜਨ ਦੀ ਸ਼ਬਦ ਸੂਚੀ';

  @override
  String get mascotCheer => 'ਸ਼ਾਬਾਸ਼!';

  @override
  String get mascotTryAgain => 'ਅੱਗੇ ਵਧੋ!';

  @override
  String get adsTestIdsNotice =>
      'ਸੈਟਅਪ ਲੋੜੀਂਦਾ: ਵਿਗਿਆਪਨ ਹਾਲੇ Google ਦੀਆਂ ਟੈਸਟ ਆਈਡੀ ਵਰਤਦੇ ਹਨ। ਕਮਾਈ ਲਈ ਅਸਲੀ AdMob ਆਈਡੀ ਪਾਓ।';

  @override
  String get demoBadge => 'ਡੈਮੋ ਸਮੱਗਰੀ';

  @override
  String get topicGreetings => 'ਨਮਸਕਾਰ ਤੇ ਮੂਲ';

  @override
  String get topicNumbers => 'ਗਿਣਤੀ';

  @override
  String get topicColors => 'ਰੰਗ';

  @override
  String get topicTime => 'ਦਿਨ, ਮਹੀਨੇ ਤੇ ਸਮਾਂ';

  @override
  String get topicFamily => 'ਪਰਿਵਾਰ';

  @override
  String get topicBody => 'ਸਰੀਰ';

  @override
  String get topicHealth => 'ਸਿਹਤ ਤੇ ਡਾਕਟਰ';

  @override
  String get topicPharmacy => 'ਫਾਰਮੇਸੀ';

  @override
  String get topicFood => 'ਖਾਣਾ';

  @override
  String get topicFruit => 'ਫਲ';

  @override
  String get topicVegetables => 'ਸਬਜ਼ੀਆਂ';

  @override
  String get topicDrinks => 'ਪੀਣ ਵਾਲੀਆਂ ਚੀਜ਼ਾਂ';

  @override
  String get topicCooking => 'ਪਕਾਉਣਾ';

  @override
  String get topicShopping => 'ਸੁਪਰਮਾਰਕੀਟ ਤੇ ਖਰੀਦਦਾਰੀ';

  @override
  String get topicMoney => 'ਪੈਸਾ ਤੇ ਬੈਂਕ';

  @override
  String get topicHouse => 'ਘਰ';

  @override
  String get topicKitchen => 'ਰਸੋਈ';

  @override
  String get topicBathroom => 'ਗੁਸਲਖਾਨਾ';

  @override
  String get topicClothes => 'ਕੱਪੜੇ ਤੇ ਜੁੱਤੀਆਂ';

  @override
  String get topicWeather => 'ਮੌਸਮ ਤੇ ਰੁੱਤਾਂ';

  @override
  String get topicCity => 'ਸ਼ਹਿਰ ਤੇ ਥਾਂਵਾਂ';

  @override
  String get topicTransport => 'ਟਰਾਂਸਪੋਰਟ ਤੇ ਰਾਹ';

  @override
  String get topicWork => 'ਕੰਮ';

  @override
  String get topicJobs => 'ਪੇਸ਼ੇ';

  @override
  String get topicOffices => 'ਦਫ਼ਤਰ ਤੇ ਦਸਤਾਵੇਜ਼';

  @override
  String get topicSchool => 'ਸਕੂਲ';

  @override
  String get topicAnimals => 'ਜਾਨਵਰ';

  @override
  String get topicNature => 'ਕੁਦਰਤ';

  @override
  String get topicSport => 'ਖੇਡ ਤੇ ਵਿਹਲਾ ਸਮਾਂ';

  @override
  String get topicFeelings => 'ਭਾਵਨਾਵਾਂ';

  @override
  String get topicVerbs => 'ਆਮ ਕਿਰਿਆਵਾਂ';

  @override
  String get topicAdjectives => 'ਆਮ ਵਿਸ਼ੇਸ਼ਣ';

  @override
  String get topicPhrases => 'ਕੰਮ ਆਉਂਦੇ ਵਾਕ';

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
  String get moreLanguages => 'ਹੋਰ ਭਾਸ਼ਾਵਾਂ';

  @override
  String get languageNoteWordTranslations =>
      'ਸ਼ਬਦਾਂ ਦੇ ਅਨੁਵਾਦ ਦਸ ਮੁੱਖ ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਹਨ; ਬਾਕੀ ਇੰਟਰਫੇਸ ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਅੰਗਰੇਜ਼ੀ ਦਿਖਦੀ ਹੈ।';

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

  @override
  String get rewardNoAdsLink => 'Remove ads for 1 hour (watch a video)';

  @override
  String get rewardNoAdsTitle => '1 hour without ads';

  @override
  String get rewardNoAdsSubtitle => 'Watch a short video: no ads for one hour.';

  @override
  String get rewardNotAvailable => 'Video not available, try again later';

  @override
  String get rewardGranted => 'Done! No ads for one hour.';

  @override
  String get rewardNotEarned =>
      'Video closed early: watch it to the end to remove the ads.';

  @override
  String get noAdsActiveTitle => 'Ads switched off';

  @override
  String noAdsRemaining(int minutes) {
    return 'No ads for another $minutes min';
  }
}

/// The translations for Panjabi Punjabi, using the Arabic script (`pa_Arab`).
class AppLocalizationsPaArab extends AppLocalizationsPa {
  AppLocalizationsPaArab() : super('pa_Arab');

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'تلاش';

  @override
  String get tabToday => 'اَج';

  @override
  String get tabQuiz => 'کوئز';

  @override
  String get tabTopics => 'موضوع';

  @override
  String get settingsTitle => 'سیٹنگاں';

  @override
  String get myWords => 'میرے لفظ';

  @override
  String get back => 'واپس';

  @override
  String get next => 'اگلا';

  @override
  String get done => 'مکمل';

  @override
  String get close => 'بند کرو';

  @override
  String get cancel => 'رد کرو';

  @override
  String get confirm => 'تصدیق کرو';

  @override
  String get retry => 'دوبارہ کوشش کرو';

  @override
  String get listen => 'سنو';

  @override
  String get listenSlow => 'ہولی';

  @override
  String get explanation => 'وضاحت';

  @override
  String get exampleLabel => 'مثال';

  @override
  String get typeNoun => 'اسم';

  @override
  String get typeVerb => 'فعل';

  @override
  String get typeAdjective => 'صفت';

  @override
  String get typePhrase => 'جملہ';

  @override
  String get searchHint => 'اطالوی، انگریزی، اردو، বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    final intl.NumberFormat wordsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wordsString = wordsNumberFormat.format(words);
    final intl.NumberFormat phrasesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String phrasesString = phrasesNumberFormat.format(phrases);

    return '$wordsString لفظ · $phrasesString جملے';
  }

  @override
  String wordsAndPhrasesTotal(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString لفظ تے جملے';
  }

  @override
  String get recentSearches => 'حالیہ تلاشاں';

  @override
  String get clearRecent => 'صاف کرو';

  @override
  String get noResults => 'کوئی لفظ نہیں ملیا';

  @override
  String get didYouMean => 'کیہ تہانوں ایہ چاہیدا سی…؟';

  @override
  String get searchOnline => 'آن لائن تلاش کرو';

  @override
  String get searchingOnline => 'آن لائن تلاش ہو رہی اے…';

  @override
  String get offlineNotice =>
      'تسیں آف لائن او۔ ایپ دے سارے لفظ فیر وی کم کردے نیں۔';

  @override
  String get onlineResultTitle => 'ویکشنری توں';

  @override
  String get addToMyWords => 'میرے لفظاں وچ شامل کرو';

  @override
  String get removeFromMyWords => 'میرے لفظاں توں ہٹاؤ';

  @override
  String get myWordsEmpty =>
      'ہالے کوئی لفظ محفوظ نہیں۔ تلاش وچ ”میرے لفظاں وچ شامل کرو“ دباؤ۔';

  @override
  String get quizOnMyWords => 'میرے لفظاں دا کوئز';

  @override
  String get todayTitle => 'اَج دے لفظ';

  @override
  String todayProgress(int n, int total) {
    return 'لفظ $n / $total';
  }

  @override
  String streakDays(int n) {
    return '$n دن لگاتار';
  }

  @override
  String get miniQuizCta => 'اَج دے لفظاں دا منی کوئز';

  @override
  String get learnedToday => 'اَج ویکھیا';

  @override
  String get todayDone => 'سارے 10 لفظ ویکھ لئے۔ کل فیر آؤ!';

  @override
  String get quizPickCategory => 'اک موضوع چنو';

  @override
  String get mixOfAll => 'سب دا مکس';

  @override
  String quizProgress(int n, int total) {
    return 'سوال $n / $total';
  }

  @override
  String get quizQuestionPrompt => 'کیہ لفظ تصویر نال ملدا اے؟';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'درست';

  @override
  String get falsoHint => 'غلط';

  @override
  String get answerCorrect => 'درست!';

  @override
  String get answerWrong => 'غلط';

  @override
  String get correctAnswerIs => 'صحیح لفظ ایہ اے:';

  @override
  String get quizResultTitle => 'تہاڈا نتیجہ';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'پاس';

  @override
  String get notPassed => 'پاس نہیں';

  @override
  String get passRule => '2 یا کم غلطیاں تے پاس';

  @override
  String mistakesCount(int n) {
    return '$n غلطیاں';
  }

  @override
  String get noMistakes => 'کوئی غلطی نہیں۔ بہت خوب!';

  @override
  String get repeatMistakes => 'غلطیاں دہراؤ';

  @override
  String get newQuiz => 'نواں کوئز';

  @override
  String bestScoreValue(int score, int total) {
    return 'ودھیا: $score/$total';
  }

  @override
  String get quizNotEnoughWords => 'ایس موضوع وچ کوئز لئی ہور لفظ چاہیدے نیں۔';

  @override
  String get topicsSubtitle => 'موضوع مطابق سکھو';

  @override
  String nWords(int n) {
    return '$n لفظ';
  }

  @override
  String nLearned(int n) {
    return '$n سکھے';
  }

  @override
  String get flashcards => 'فلیش کارڈ';

  @override
  String get quiz20 => 'کوئز 20';

  @override
  String get flashcardTapToFlip => 'ترجمہ ویکھن لئی کارڈ دباؤ';

  @override
  String get interfaceLanguage => 'ایپ دی زبان';

  @override
  String get audioSpeed => 'آواز دی رفتار';

  @override
  String get dailyReminder => 'روزانہ یاد دہانی';

  @override
  String get reminderTime => 'یاد دہانی دا ویلا';

  @override
  String get reminderBody => '10 نویں اطالوی لفظ تہاڈی اڈیک وچ نیں۔';

  @override
  String get darkMode => 'ڈارک موڈ';

  @override
  String get resetProgress => 'ترقی مٹاؤ';

  @override
  String get resetProgressConfirm => 'سلسلہ، اسکور تے محفوظ لفظ مٹا دیئے جان؟';

  @override
  String get resetDone => 'ترقی مٹ گئی';

  @override
  String get privacy => 'پرائیویسی';

  @override
  String get about => 'ایپ بارے';

  @override
  String get adsConsentChange => 'اشتہاراں دی رضامندی بدلو';

  @override
  String get removeAds => 'اشتہار ہٹاؤ';

  @override
  String get removeAdsBody =>
      'اک واری ادائیگی، فیر کدے اشتہار نہیں۔ سارے لفظ، موضوع تے کوئز مفت رہندے نیں۔';

  @override
  String get buy => 'خریدو';

  @override
  String get restorePurchases => 'خریداری بحال کرو';

  @override
  String get adsRemoved => 'اشتہار ہٹ گئے۔ شکریہ!';

  @override
  String get purchasePending => 'ادائیگی جاری اے…';

  @override
  String get purchaseError => 'خریداری مکمل نہیں ہوئی۔';

  @override
  String get nothingToRestore => 'کوئی پہلی خریداری نہیں ملی۔';

  @override
  String get webPurchaseNotice => 'خریداری Android تے iPhone ایپ وچ دستیاب اے۔';

  @override
  String get storeUnavailable => 'اسٹور ہُݨ دستیاب نہیں۔';

  @override
  String get voiceHelpTitle => 'اطالوی آواز انسٹال کرو';

  @override
  String get voiceHelpBody =>
      'تہاڈے فون وچ ہالے اطالوی آواز نہیں۔ سیٹنگاں › سسٹم › زباناں › ٹیکسٹ ٹو اسپیچ کھولو، Google انجن چنو تے اطالوی انسٹال کرو۔ لفظ پڑھنا فیر وی کم کردا اے۔';

  @override
  String get privacyBody =>
      'ایہ ایپ آف لائن چلدی اے تے لاگ اِن نہیں منگدی۔ تہاڈی ترقی، محفوظ لفظ تے سیٹنگاں صرف تہاڈے فون تے رہندیاں نیں۔ اسیں تہاڈا ناں، ای میل یا مقام کدے جمع نہیں کردے۔ اشتہار Google AdMob توں آؤندے نیں تے رضامندی فارم وچ قبول کرن توں بعد ای دکھائے جاندے نیں؛ تسیں سیٹنگاں وچ کدے وی بدل سکدے او۔ ”آن لائن تلاش“ صرف لکھیا لفظ ویکشنری نوں بھیجدی اے۔ 13 سال تے اوپر لئی۔';

  @override
  String get aboutBody =>
      'اطالیہ وچ رہݨ والیاں لئی اک نکی، ایماندار ایپ: لفظ تلاش کرو، روز دس نویں لفظ سکھو تے ڈرائیونگ ٹیسٹ وانگ اپنے آپ نوں پرکھو۔ سب کجھ آف لائن چلدا اے، بغیر اکاؤنٹ۔';

  @override
  String get creditsBody =>
      'ایس ایپ دے ترجمے تے مثالی جملے ہتھ نال لکھے تے جانچے گئے نیں۔ لفظاں دیاں فہرستاں کھلے ذریعیاں نال ملائیاں گئیاں: Wiktionary تے Wikizionario (CC BY-SA 4.0)، Tatoeba دے جملے (CC BY 2.0 FR) تے Open Multilingual Wordnet۔ تصویراں Google Noto Emoji (Apache 2.0) توں نیں۔ اطالوی تلفظ تہاڈے فون دی ٹیکسٹ ٹو اسپیچ توں آؤندا اے۔';

  @override
  String get dataCoverage => 'ایس ورژن وچ لفظاں دی فہرست';

  @override
  String get mascotCheer => 'شاباش!';

  @override
  String get mascotTryAgain => 'اگے ودھو!';

  @override
  String get adsTestIdsNotice =>
      'سیٹ اپ ضروری: اشتہار ہالے Google دیاں ٹیسٹ آئی ڈی ورتدے نیں۔ کمائی لئی اصل AdMob آئی ڈی لاؤ۔';

  @override
  String get demoBadge => 'ڈیمو مواد';

  @override
  String get topicGreetings => 'سلام تے بنیادی گلاں';

  @override
  String get topicNumbers => 'گݨتی';

  @override
  String get topicColors => 'رنگ';

  @override
  String get topicTime => 'دن، مہینے تے ویلا';

  @override
  String get topicFamily => 'ٹبر';

  @override
  String get topicBody => 'جسم';

  @override
  String get topicHealth => 'صحت تے ڈاکٹر';

  @override
  String get topicPharmacy => 'فارمیسی';

  @override
  String get topicFood => 'کھاݨا';

  @override
  String get topicFruit => 'پھل';

  @override
  String get topicVegetables => 'سبزیاں';

  @override
  String get topicDrinks => 'پیݨ والیاں چیزاں';

  @override
  String get topicCooking => 'پکاݨا';

  @override
  String get topicShopping => 'سپر مارکیٹ تے خریداری';

  @override
  String get topicMoney => 'پیسہ تے بینک';

  @override
  String get topicHouse => 'گھر';

  @override
  String get topicKitchen => 'رسوئی';

  @override
  String get topicBathroom => 'غسل خانہ';

  @override
  String get topicClothes => 'کپڑے تے جُتیاں';

  @override
  String get topicWeather => 'موسم تے رُتاں';

  @override
  String get topicCity => 'شہر تے تھاں';

  @override
  String get topicTransport => 'ٹرانسپورٹ تے راہ';

  @override
  String get topicWork => 'کم';

  @override
  String get topicJobs => 'پیشے';

  @override
  String get topicOffices => 'دفتر تے کاغذ';

  @override
  String get topicSchool => 'سکول';

  @override
  String get topicAnimals => 'جانور';

  @override
  String get topicNature => 'قدرت';

  @override
  String get topicSport => 'کھیل تے ویلھ';

  @override
  String get topicFeelings => 'احساس';

  @override
  String get topicVerbs => 'عام فعل';

  @override
  String get topicAdjectives => 'عام صفتاں';

  @override
  String get topicPhrases => 'کم آؤندے جملے';

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
  String get moreLanguages => 'ہور زباناں';

  @override
  String get languageNoteWordTranslations =>
      'لفظاں دے ترجمے دس بنیادی زباناں وچ نیں؛ باقی انٹرفیس زباناں وچ انگریزی دکھائی جاندی اے۔';
}
