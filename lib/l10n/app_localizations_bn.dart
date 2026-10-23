// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'খোঁজ';

  @override
  String get tabToday => 'আজ';

  @override
  String get tabQuiz => 'কুইজ';

  @override
  String get tabTopics => 'বিষয়';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get myWords => 'আমার শব্দ';

  @override
  String get back => 'পিছনে';

  @override
  String get next => 'পরবর্তী';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get close => 'বন্ধ';

  @override
  String get cancel => 'বাতিল';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get listen => 'শুনুন';

  @override
  String get listenSlow => 'ধীরে';

  @override
  String get explanation => 'ব্যাখ্যা';

  @override
  String get exampleLabel => 'উদাহরণ';

  @override
  String get typeNoun => 'বিশেষ্য';

  @override
  String get typeVerb => 'ক্রিয়া';

  @override
  String get typeAdjective => 'বিশেষণ';

  @override
  String get typePhrase => 'বাক্যাংশ';

  @override
  String get searchHint => 'ইতালীয়, ইংরেজি, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    final intl.NumberFormat wordsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wordsString = wordsNumberFormat.format(words);
    final intl.NumberFormat phrasesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String phrasesString = phrasesNumberFormat.format(phrases);

    return '$wordsString শব্দ · $phrasesString বাক্যাংশ';
  }

  @override
  String wordsAndPhrasesTotal(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString শব্দ ও বাক্যাংশ';
  }

  @override
  String get recentSearches => 'সাম্প্রতিক খোঁজ';

  @override
  String get clearRecent => 'মুছুন';

  @override
  String get noResults => 'কোনো শব্দ পাওয়া যায়নি';

  @override
  String get didYouMean => 'আপনি কি বলতে চেয়েছিলেন…?';

  @override
  String get searchOnline => 'অনলাইনে খুঁজুন';

  @override
  String get searchingOnline => 'অনলাইনে খোঁজা হচ্ছে…';

  @override
  String get offlineNotice =>
      'আপনি অফলাইনে আছেন। অ্যাপের সব শব্দ তবুও কাজ করে।';

  @override
  String get onlineResultTitle => 'উইকিশনারি থেকে';

  @override
  String get addToMyWords => 'আমার শব্দে যোগ করুন';

  @override
  String get removeFromMyWords => 'আমার শব্দ থেকে সরান';

  @override
  String get myWordsEmpty =>
      'এখনো কোনো শব্দ সংরক্ষিত নয়। খোঁজে “আমার শব্দে যোগ করুন” চাপুন।';

  @override
  String get quizOnMyWords => 'আমার শব্দের কুইজ';

  @override
  String get todayTitle => 'আজকের শব্দ';

  @override
  String todayProgress(int n, int total) {
    return 'শব্দ $n / $total';
  }

  @override
  String streakDays(int n) {
    return '$n দিন টানা';
  }

  @override
  String get miniQuizCta => 'আজকের শব্দের মিনি কুইজ';

  @override
  String get learnedToday => 'আজ দেখা হয়েছে';

  @override
  String get todayDone => '১০টি শব্দই দেখা হয়েছে। কাল আবার আসুন!';

  @override
  String get quizPickCategory => 'একটি বিভাগ বাছুন';

  @override
  String get mixOfAll => 'সব মিলিয়ে';

  @override
  String quizProgress(int n, int total) {
    return 'প্রশ্ন $n / $total';
  }

  @override
  String get quizQuestionPrompt => 'শব্দটি কি ছবির সঙ্গে মেলে?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'সত্য';

  @override
  String get falsoHint => 'মিথ্যা';

  @override
  String get answerCorrect => 'সঠিক!';

  @override
  String get answerWrong => 'ভুল';

  @override
  String get correctAnswerIs => 'সঠিক শব্দ হলো:';

  @override
  String get quizResultTitle => 'আপনার ফলাফল';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'পাস';

  @override
  String get notPassed => 'পাস নয়';

  @override
  String get passRule => '২টি বা কম ভুলে পাস';

  @override
  String mistakesCount(int n) {
    return '$n ভুল';
  }

  @override
  String get noMistakes => 'কোনো ভুল নেই। দারুণ!';

  @override
  String get repeatMistakes => 'ভুলগুলো আবার দেখুন';

  @override
  String get newQuiz => 'নতুন কুইজ';

  @override
  String bestScoreValue(int score, int total) {
    return 'সেরা: $score/$total';
  }

  @override
  String get quizNotEnoughWords => 'এই বিভাগে কুইজের জন্য আরও শব্দ দরকার।';

  @override
  String get topicsSubtitle => 'বিভাগ অনুযায়ী শিখুন';

  @override
  String nWords(int n) {
    return '$n শব্দ';
  }

  @override
  String nLearned(int n) {
    return '$n শেখা হয়েছে';
  }

  @override
  String get flashcards => 'ফ্ল্যাশকার্ড';

  @override
  String get quiz20 => 'কুইজ ২০';

  @override
  String get flashcardTapToFlip => 'অনুবাদ দেখতে কার্ডে চাপ দিন';

  @override
  String get interfaceLanguage => 'অ্যাপের ভাষা';

  @override
  String get audioSpeed => 'অডিওর গতি';

  @override
  String get dailyReminder => 'প্রতিদিনের রিমাইন্ডার';

  @override
  String get reminderTime => 'রিমাইন্ডারের সময়';

  @override
  String get reminderBody => '১০টি নতুন ইতালীয় শব্দ আপনার জন্য অপেক্ষা করছে।';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get resetProgress => 'অগ্রগতি মুছুন';

  @override
  String get resetProgressConfirm => 'স্ট্রিক, স্কোর ও সংরক্ষিত শব্দ মুছবেন?';

  @override
  String get resetDone => 'অগ্রগতি মোছা হয়েছে';

  @override
  String get privacy => 'গোপনীয়তা';

  @override
  String get about => 'অ্যাপ সম্পর্কে';

  @override
  String get adsConsentChange => 'বিজ্ঞাপনের সম্মতি বদলান';

  @override
  String get removeAds => 'বিজ্ঞাপন সরান';

  @override
  String get removeAdsBody =>
      'একবার পেমেন্ট, আর কখনো বিজ্ঞাপন নয়। সব শব্দ, বিষয় ও কুইজ বিনামূল্যেই থাকে।';

  @override
  String get buy => 'কিনুন';

  @override
  String get restorePurchases => 'কেনাকাটা ফেরান';

  @override
  String get adsRemoved => 'বিজ্ঞাপন সরানো হয়েছে। ধন্যবাদ!';

  @override
  String get purchasePending => 'পেমেন্ট চলছে…';

  @override
  String get purchaseError => 'কেনাকাটা সম্পন্ন হয়নি।';

  @override
  String get nothingToRestore => 'আগের কোনো কেনাকাটা পাওয়া যায়নি।';

  @override
  String get webPurchaseNotice =>
      'কেনাকাটা Android ও iPhone অ্যাপে পাওয়া যায়।';

  @override
  String get storeUnavailable => 'স্টোর এখন পাওয়া যাচ্ছে না।';

  @override
  String get voiceHelpTitle => 'ইতালীয় ভয়েস ইনস্টল করুন';

  @override
  String get voiceHelpBody =>
      'আপনার ফোনে এখনো ইতালীয় ভয়েস নেই। সেটিংস › সিস্টেম › ভাষা › টেক্সট-টু-স্পিচ খুলুন, Google ইঞ্জিন বাছুন এবং ইতালীয় ইনস্টল করুন। শব্দ পড়া তবুও কাজ করে।';

  @override
  String get privacyBody =>
      'এই অ্যাপ অফলাইনে চলে এবং লগইন লাগে না। আপনার অগ্রগতি, সংরক্ষিত শব্দ ও সেটিংস কেবল আপনার ফোনেই থাকে। আমরা আপনার নাম, ই-মেইল বা লোকেশন কখনো সংগ্রহ করি না। বিজ্ঞাপন Google AdMob থেকে আসে এবং সম্মতি ফর্মে রাজি হওয়ার পরেই দেখানো হয়; সেটিংসে যেকোনো সময় বদলাতে পারেন। “অনলাইনে খুঁজুন” কেবল লেখা শব্দটি উইকিশনারিতে পাঠায়। ১৩+ বছরের জন্য।';

  @override
  String get aboutBody =>
      'ইতালিতে বাস করা মানুষের জন্য ছোট, সৎ একটি অ্যাপ: শব্দ খুঁজুন, প্রতিদিন দশটি নতুন শব্দ শিখুন এবং ড্রাইভিং পরীক্ষার মতো নিজেকে যাচাই করুন। সবকিছু অফলাইনে চলে, অ্যাকাউন্ট ছাড়াই।';

  @override
  String get creditsBody =>
      'এই অ্যাপের অনুবাদ ও উদাহরণ বাক্য হাতে লেখা ও যাচাই করা। শব্দতালিকা মুক্ত সূত্রের সঙ্গে মিলিয়ে দেখা হয়েছে: Wiktionary ও Wikizionario (CC BY-SA 4.0), Tatoeba-র বাক্য (CC BY 2.0 FR) এবং Open Multilingual Wordnet। ছবিতে Google Noto Emoji (Apache 2.0) ব্যবহৃত। ইতালীয় উচ্চারণ আপনার ফোনের টেক্সট-টু-স্পিচ ব্যবহার করে।';

  @override
  String get dataCoverage => 'এই সংস্করণের শব্দতালিকা';

  @override
  String get mascotCheer => 'বাহ!';

  @override
  String get mascotTryAgain => 'চালিয়ে যান!';

  @override
  String get adsTestIdsNotice =>
      'সেটআপ দরকার: বিজ্ঞাপন এখনো Google-এর টেস্ট আইডি ব্যবহার করে। আয়ের জন্য আসল AdMob আইডি দিন।';

  @override
  String get demoBadge => 'ডেমো কনটেন্ট';

  @override
  String get topicGreetings => 'অভিবাদন ও মৌলিক';

  @override
  String get topicNumbers => 'সংখ্যা';

  @override
  String get topicColors => 'রং';

  @override
  String get topicTime => 'দিন, মাস ও সময়';

  @override
  String get topicFamily => 'পরিবার';

  @override
  String get topicBody => 'শরীর';

  @override
  String get topicHealth => 'স্বাস্থ্য ও ডাক্তার';

  @override
  String get topicPharmacy => 'ফার্মেসি';

  @override
  String get topicFood => 'খাবার';

  @override
  String get topicFruit => 'ফল';

  @override
  String get topicVegetables => 'সবজি';

  @override
  String get topicDrinks => 'পানীয়';

  @override
  String get topicCooking => 'রান্না';

  @override
  String get topicShopping => 'সুপারমার্কেট ও কেনাকাটা';

  @override
  String get topicMoney => 'টাকা ও ব্যাংক';

  @override
  String get topicHouse => 'বাড়ি';

  @override
  String get topicKitchen => 'রান্নাঘর';

  @override
  String get topicBathroom => 'বাথরুম';

  @override
  String get topicClothes => 'পোশাক ও জুতা';

  @override
  String get topicWeather => 'আবহাওয়া ও ঋতু';

  @override
  String get topicCity => 'শহর ও স্থান';

  @override
  String get topicTransport => 'পরিবহন ও দিকনির্দেশ';

  @override
  String get topicWork => 'কাজ';

  @override
  String get topicJobs => 'পেশা';

  @override
  String get topicOffices => 'অফিস ও কাগজপত্র';

  @override
  String get topicSchool => 'স্কুল';

  @override
  String get topicAnimals => 'প্রাণী';

  @override
  String get topicNature => 'প্রকৃতি';

  @override
  String get topicSport => 'খেলা ও অবসর';

  @override
  String get topicFeelings => 'অনুভূতি';

  @override
  String get topicVerbs => 'সাধারণ ক্রিয়া';

  @override
  String get topicAdjectives => 'সাধারণ বিশেষণ';

  @override
  String get topicPhrases => 'দরকারি বাক্য';

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
  String get moreLanguages => 'আরও ভাষা';

  @override
  String get languageNoteWordTranslations =>
      'শব্দের অনুবাদ দশটি প্রধান ভাষায় আছে; অন্য ইন্টারফেস ভাষায় ইংরেজি দেখানো হয়।';

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
