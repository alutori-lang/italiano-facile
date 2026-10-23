// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'खोज';

  @override
  String get tabToday => 'आज';

  @override
  String get tabQuiz => 'क्विज़';

  @override
  String get tabTopics => 'विषय';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get myWords => 'मेरे शब्द';

  @override
  String get back => 'वापस';

  @override
  String get next => 'आगे';

  @override
  String get done => 'पूरा';

  @override
  String get close => 'बंद करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get listen => 'सुनें';

  @override
  String get listenSlow => 'धीरे';

  @override
  String get explanation => 'व्याख्या';

  @override
  String get exampleLabel => 'उदाहरण';

  @override
  String get typeNoun => 'संज्ञा';

  @override
  String get typeVerb => 'क्रिया';

  @override
  String get typeAdjective => 'विशेषण';

  @override
  String get typePhrase => 'वाक्य';

  @override
  String get searchHint => 'इतालवी, अंग्रेज़ी, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    final intl.NumberFormat wordsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wordsString = wordsNumberFormat.format(words);
    final intl.NumberFormat phrasesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String phrasesString = phrasesNumberFormat.format(phrases);

    return '$wordsString शब्द · $phrasesString वाक्य';
  }

  @override
  String wordsAndPhrasesTotal(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString शब्द और वाक्य';
  }

  @override
  String get recentSearches => 'हाल की खोजें';

  @override
  String get clearRecent => 'मिटाएँ';

  @override
  String get noResults => 'कोई शब्द नहीं मिला';

  @override
  String get didYouMean => 'क्या आपका मतलब था…?';

  @override
  String get searchOnline => 'ऑनलाइन खोजें';

  @override
  String get searchingOnline => 'ऑनलाइन खोज रहे हैं…';

  @override
  String get offlineNotice =>
      'आप ऑफ़लाइन हैं। ऐप के सभी शब्द फिर भी काम करते हैं।';

  @override
  String get onlineResultTitle => 'विक्शनरी से';

  @override
  String get addToMyWords => 'मेरे शब्दों में जोड़ें';

  @override
  String get removeFromMyWords => 'मेरे शब्दों से हटाएँ';

  @override
  String get myWordsEmpty =>
      'अभी कोई शब्द सहेजा नहीं गया। खोज में “मेरे शब्दों में जोड़ें” दबाएँ।';

  @override
  String get quizOnMyWords => 'मेरे शब्दों का क्विज़';

  @override
  String get todayTitle => 'आज के शब्द';

  @override
  String todayProgress(int n, int total) {
    return 'शब्द $n / $total';
  }

  @override
  String streakDays(int n) {
    return '$n दिन लगातार';
  }

  @override
  String get miniQuizCta => 'आज के शब्दों का मिनी क्विज़';

  @override
  String get learnedToday => 'आज देखा';

  @override
  String get todayDone => 'सभी 10 शब्द देख लिए। कल फिर आएँ!';

  @override
  String get quizPickCategory => 'श्रेणी चुनें';

  @override
  String get mixOfAll => 'सब मिलाकर';

  @override
  String quizProgress(int n, int total) {
    return 'प्रश्न $n / $total';
  }

  @override
  String get quizQuestionPrompt => 'क्या शब्द तस्वीर से मेल खाता है?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'सही';

  @override
  String get falsoHint => 'गलत';

  @override
  String get answerCorrect => 'सही!';

  @override
  String get answerWrong => 'गलत';

  @override
  String get correctAnswerIs => 'सही शब्द है:';

  @override
  String get quizResultTitle => 'आपका परिणाम';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'पास';

  @override
  String get notPassed => 'फेल';

  @override
  String get passRule => '2 या कम गलतियों पर पास';

  @override
  String mistakesCount(int n) {
    return '$n गलतियाँ';
  }

  @override
  String get noMistakes => 'कोई गलती नहीं। बहुत खूब!';

  @override
  String get repeatMistakes => 'गलतियाँ दोहराएँ';

  @override
  String get newQuiz => 'नया क्विज़';

  @override
  String bestScoreValue(int score, int total) {
    return 'सर्वश्रेष्ठ: $score/$total';
  }

  @override
  String get quizNotEnoughWords => 'इस श्रेणी में क्विज़ के लिए और शब्द चाहिए।';

  @override
  String get topicsSubtitle => 'श्रेणी से सीखें';

  @override
  String nWords(int n) {
    return '$n शब्द';
  }

  @override
  String nLearned(int n) {
    return '$n सीखे';
  }

  @override
  String get flashcards => 'फ़्लैशकार्ड';

  @override
  String get quiz20 => 'क्विज़ 20';

  @override
  String get flashcardTapToFlip => 'अनुवाद देखने के लिए कार्ड दबाएँ';

  @override
  String get interfaceLanguage => 'ऐप की भाषा';

  @override
  String get audioSpeed => 'ऑडियो की गति';

  @override
  String get dailyReminder => 'रोज़ाना याद दिलाना';

  @override
  String get reminderTime => 'याद दिलाने का समय';

  @override
  String get reminderBody => '10 नए इतालवी शब्द आपका इंतज़ार कर रहे हैं।';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get resetProgress => 'प्रगति मिटाएँ';

  @override
  String get resetProgressConfirm => 'स्ट्रीक, स्कोर और सहेजे शब्द मिटाएँ?';

  @override
  String get resetDone => 'प्रगति मिट गई';

  @override
  String get privacy => 'निजता';

  @override
  String get about => 'ऐप के बारे में';

  @override
  String get adsConsentChange => 'विज्ञापन सहमति बदलें';

  @override
  String get removeAds => 'विज्ञापन हटाएँ';

  @override
  String get removeAdsBody =>
      'एक बार भुगतान, फिर कोई विज्ञापन नहीं। सभी शब्द, विषय और क्विज़ मुफ़्त रहते हैं।';

  @override
  String get buy => 'खरीदें';

  @override
  String get restorePurchases => 'खरीद बहाल करें';

  @override
  String get adsRemoved => 'विज्ञापन हट गए। धन्यवाद!';

  @override
  String get purchasePending => 'भुगतान जारी है…';

  @override
  String get purchaseError => 'खरीद पूरी नहीं हुई।';

  @override
  String get nothingToRestore => 'कोई पुरानी खरीद नहीं मिली।';

  @override
  String get webPurchaseNotice => 'खरीद Android और iPhone ऐप में उपलब्ध है।';

  @override
  String get storeUnavailable => 'स्टोर अभी उपलब्ध नहीं है।';

  @override
  String get voiceHelpTitle => 'इतालवी आवाज़ इंस्टॉल करें';

  @override
  String get voiceHelpBody =>
      'आपके फ़ोन में इतालवी आवाज़ नहीं है। सेटिंग्स › सिस्टम › भाषाएँ › टेक्स्ट-टू-स्पीच खोलें, Google इंजन चुनें और इतालवी इंस्टॉल करें। शब्द पढ़ना फिर भी काम करता है।';

  @override
  String get privacyBody =>
      'यह ऐप ऑफ़लाइन चलता है और लॉगिन नहीं मांगता। आपकी प्रगति, सहेजे शब्द और सेटिंग्स केवल आपके फ़ोन पर रहती हैं। हम नाम, ई-मेल या लोकेशन कभी नहीं लेते। विज्ञापन Google AdMob से आते हैं और सहमति फ़ॉर्म में स्वीकार करने के बाद ही दिखते हैं; आप सेटिंग्स में कभी भी बदल सकते हैं। “ऑनलाइन खोजें” केवल लिखा शब्द विक्शनरी को भेजता है। 13+ के लिए।';

  @override
  String get aboutBody =>
      'इटली में रहने वालों के लिए एक छोटा, ईमानदार ऐप: शब्द खोजें, रोज़ दस नए शब्द सीखें और ड्राइविंग टेस्ट जैसे खुद को परखें। सब कुछ ऑफ़लाइन चलता है, बिना अकाउंट।';

  @override
  String get creditsBody =>
      'इस ऐप के अनुवाद और उदाहरण वाक्य हाथ से लिखे और जाँचे गए हैं। शब्द सूचियाँ खुले स्रोतों से मिलाई गईं: Wiktionary और Wikizionario (CC BY-SA 4.0), Tatoeba वाक्य (CC BY 2.0 FR) और Open Multilingual Wordnet। चित्र Google Noto Emoji (Apache 2.0) के हैं। इतालवी उच्चारण फ़ोन की टेक्स्ट-टू-स्पीच से आता है।';

  @override
  String get dataCoverage => 'इस संस्करण की शब्द सूची';

  @override
  String get mascotCheer => 'शाबाश!';

  @override
  String get mascotTryAgain => 'चलते रहो!';

  @override
  String get adsTestIdsNotice =>
      'सेटअप ज़रूरी: विज्ञापन अभी Google की टेस्ट आईडी इस्तेमाल करते हैं। कमाई के लिए असली AdMob आईडी डालें।';

  @override
  String get demoBadge => 'डेमो सामग्री';

  @override
  String get topicGreetings => 'अभिवादन और बुनियाद';

  @override
  String get topicNumbers => 'संख्याएँ';

  @override
  String get topicColors => 'रंग';

  @override
  String get topicTime => 'दिन, महीने और समय';

  @override
  String get topicFamily => 'परिवार';

  @override
  String get topicBody => 'शरीर';

  @override
  String get topicHealth => 'स्वास्थ्य और डॉक्टर';

  @override
  String get topicPharmacy => 'दवा की दुकान';

  @override
  String get topicFood => 'खाना';

  @override
  String get topicFruit => 'फल';

  @override
  String get topicVegetables => 'सब्ज़ियाँ';

  @override
  String get topicDrinks => 'पेय';

  @override
  String get topicCooking => 'पकाना';

  @override
  String get topicShopping => 'सुपरमार्केट और खरीदारी';

  @override
  String get topicMoney => 'पैसा और बैंक';

  @override
  String get topicHouse => 'घर';

  @override
  String get topicKitchen => 'रसोई';

  @override
  String get topicBathroom => 'स्नानघर';

  @override
  String get topicClothes => 'कपड़े और जूते';

  @override
  String get topicWeather => 'मौसम और ऋतुएँ';

  @override
  String get topicCity => 'शहर और जगहें';

  @override
  String get topicTransport => 'परिवहन और रास्ता';

  @override
  String get topicWork => 'काम';

  @override
  String get topicJobs => 'पेशे';

  @override
  String get topicOffices => 'दफ़्तर और दस्तावेज़';

  @override
  String get topicSchool => 'स्कूल';

  @override
  String get topicAnimals => 'जानवर';

  @override
  String get topicNature => 'प्रकृति';

  @override
  String get topicSport => 'खेल और खाली समय';

  @override
  String get topicFeelings => 'भावनाएँ';

  @override
  String get topicVerbs => 'आम क्रियाएँ';

  @override
  String get topicAdjectives => 'आम विशेषण';

  @override
  String get topicPhrases => 'उपयोगी वाक्य';

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
  String get moreLanguages => 'और भाषाएँ';

  @override
  String get languageNoteWordTranslations =>
      'शब्दों के अनुवाद दस मुख्य भाषाओं में हैं; बाकी इंटरफ़ेस भाषाओं में अंग्रेज़ी दिखती है।';

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
