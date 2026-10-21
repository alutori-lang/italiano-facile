// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'Italian Words: Learn & Play';

  @override
  String get tabSearch => 'تلاش';

  @override
  String get tabToday => 'آج';

  @override
  String get tabQuiz => 'کوئز';

  @override
  String get tabTopics => 'موضوعات';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get myWords => 'میرے الفاظ';

  @override
  String get back => 'واپس';

  @override
  String get next => 'اگلا';

  @override
  String get done => 'مکمل';

  @override
  String get close => 'بند کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get listen => 'سنیں';

  @override
  String get listenSlow => 'آہستہ';

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
    return '$words الفاظ · $phrases جملے';
  }

  @override
  String get recentSearches => 'حالیہ تلاشیں';

  @override
  String get clearRecent => 'صاف کریں';

  @override
  String get noResults => 'کوئی لفظ نہیں ملا';

  @override
  String get didYouMean => 'کیا آپ کا مطلب تھا…؟';

  @override
  String get searchOnline => 'آن لائن تلاش کریں';

  @override
  String get searchingOnline => 'آن لائن تلاش ہو رہی ہے…';

  @override
  String get offlineNotice =>
      'آپ آف لائن ہیں۔ ایپ کے تمام الفاظ پھر بھی کام کرتے ہیں۔';

  @override
  String get onlineResultTitle => 'ویکشنری سے';

  @override
  String get addToMyWords => 'میرے الفاظ میں شامل کریں';

  @override
  String get removeFromMyWords => 'میرے الفاظ سے نکالیں';

  @override
  String get myWordsEmpty =>
      'ابھی کوئی لفظ محفوظ نہیں۔ تلاش میں ”میرے الفاظ میں شامل کریں“ دبائیں۔';

  @override
  String get quizOnMyWords => 'میرے الفاظ کا کوئز';

  @override
  String get todayTitle => 'آج کے الفاظ';

  @override
  String todayProgress(int n, int total) {
    return 'لفظ $n از $total';
  }

  @override
  String streakDays(int n) {
    return '$n دن مسلسل';
  }

  @override
  String get miniQuizCta => 'آج کے الفاظ کا منی کوئز';

  @override
  String get learnedToday => 'آج دیکھا';

  @override
  String get todayDone => 'تمام 10 الفاظ دیکھ لیے۔ کل پھر آئیں!';

  @override
  String get quizPickCategory => 'ایک موضوع چنیں';

  @override
  String get mixOfAll => 'سب کا مکس';

  @override
  String quizProgress(int n, int total) {
    return 'سوال $n از $total';
  }

  @override
  String get quizQuestionPrompt => 'کیا لفظ تصویر سے میل کھاتا ہے؟';

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
  String get correctAnswerIs => 'صحیح لفظ یہ ہے:';

  @override
  String get quizResultTitle => 'آپ کا نتیجہ';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'پاس';

  @override
  String get notPassed => 'پاس نہیں';

  @override
  String get passRule => '2 یا کم غلطیوں پر پاس';

  @override
  String mistakesCount(int n) {
    return '$n غلطیاں';
  }

  @override
  String get noMistakes => 'کوئی غلطی نہیں۔ بہت خوب!';

  @override
  String get repeatMistakes => 'غلطیاں دہرائیں';

  @override
  String get newQuiz => 'نیا کوئز';

  @override
  String bestScoreValue(int score, int total) {
    return 'بہترین: $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'اس موضوع میں کوئز کے لیے مزید الفاظ درکار ہیں۔';

  @override
  String get topicsSubtitle => 'موضوع کے حساب سے سیکھیں';

  @override
  String nWords(int n) {
    return '$n الفاظ';
  }

  @override
  String nLearned(int n) {
    return '$n سیکھے';
  }

  @override
  String get flashcards => 'فلیش کارڈ';

  @override
  String get quiz20 => 'کوئز 20';

  @override
  String get flashcardTapToFlip => 'ترجمہ دیکھنے کے لیے کارڈ دبائیں';

  @override
  String get interfaceLanguage => 'ایپ کی زبان';

  @override
  String get audioSpeed => 'آواز کی رفتار';

  @override
  String get dailyReminder => 'روزانہ یاد دہانی';

  @override
  String get reminderTime => 'یاد دہانی کا وقت';

  @override
  String get reminderBody => '10 نئے اطالوی الفاظ آپ کے منتظر ہیں۔';

  @override
  String get darkMode => 'ڈارک موڈ';

  @override
  String get resetProgress => 'پیش رفت مٹائیں';

  @override
  String get resetProgressConfirm => 'سلسلہ، اسکور اور محفوظ الفاظ مٹا دیں؟';

  @override
  String get resetDone => 'پیش رفت مٹ گئی';

  @override
  String get privacy => 'پرائیویسی';

  @override
  String get about => 'ایپ کے بارے میں';

  @override
  String get adsConsentChange => 'اشتہارات کی رضامندی بدلیں';

  @override
  String get removeAds => 'اشتہارات ہٹائیں';

  @override
  String get removeAdsBody =>
      'ایک بار ادائیگی، پھر کبھی اشتہار نہیں۔ تمام الفاظ، موضوعات اور کوئز مفت رہتے ہیں۔';

  @override
  String get buy => 'خریدیں';

  @override
  String get restorePurchases => 'خریداری بحال کریں';

  @override
  String get adsRemoved => 'اشتہارات ہٹ گئے۔ شکریہ!';

  @override
  String get purchasePending => 'ادائیگی جاری ہے…';

  @override
  String get purchaseError => 'خریداری مکمل نہیں ہوئی۔';

  @override
  String get nothingToRestore => 'کوئی سابقہ خریداری نہیں ملی۔';

  @override
  String get webPurchaseNotice =>
      'خریداری Android اور iPhone ایپ میں دستیاب ہے۔';

  @override
  String get storeUnavailable => 'اسٹور ابھی دستیاب نہیں ہے۔';

  @override
  String get voiceHelpTitle => 'اطالوی آواز انسٹال کریں';

  @override
  String get voiceHelpBody =>
      'آپ کے فون میں ابھی اطالوی آواز نہیں ہے۔ ترتیبات › سسٹم › زبانیں › ٹیکسٹ ٹو اسپیچ کھولیں، Google انجن چنیں اور اطالوی انسٹال کریں۔ الفاظ پڑھنا پھر بھی کام کرتا ہے۔';

  @override
  String get privacyBody =>
      'یہ ایپ آف لائن چلتی ہے اور لاگ اِن نہیں مانگتی۔ آپ کی پیش رفت، محفوظ الفاظ اور ترتیبات صرف آپ کے فون پر رہتی ہیں۔ ہم آپ کا نام، ای میل یا مقام کبھی جمع نہیں کرتے۔ اشتہارات Google AdMob سے آتے ہیں اور رضامندی فارم میں قبول کرنے کے بعد ہی دکھائے جاتے ہیں؛ آپ ترتیبات میں کبھی بھی تبدیل کر سکتے ہیں۔ ”آن لائن تلاش“ صرف لکھا ہوا لفظ ویکشنری کو بھیجتی ہے۔ 13 سال اور اوپر کے لیے۔';

  @override
  String get aboutBody =>
      'اطالیہ میں رہنے والوں کے لیے ایک چھوٹی، ایماندار ایپ: لفظ تلاش کریں، روز دس نئے الفاظ سیکھیں اور ڈرائیونگ ٹیسٹ کی طرح خود کو آزمائیں۔ سب کچھ آف لائن چلتا ہے، بغیر اکاؤنٹ۔';

  @override
  String get creditsBody =>
      'اس ایپ کے تراجم اور مثالی جملے ہاتھ سے لکھے اور جانچے گئے ہیں۔ الفاظ کی فہرستیں کھلے ذرائع سے ملائی گئیں: Wiktionary اور Wikizionario (CC BY-SA 4.0)، Tatoeba کے جملے (CC BY 2.0 FR) اور Open Multilingual Wordnet۔ تصاویر Google Noto Emoji (Apache 2.0) سے ہیں۔ اطالوی تلفظ آپ کے فون کی ٹیکسٹ ٹو اسپیچ سے آتا ہے۔';

  @override
  String get dataCoverage => 'اس ورژن میں الفاظ کی فہرست';

  @override
  String get mascotCheer => 'شاباش!';

  @override
  String get mascotTryAgain => 'آگے بڑھیں!';

  @override
  String get adsTestIdsNotice =>
      'سیٹ اپ ضروری: اشتہارات ابھی Google کی ٹیسٹ آئی ڈی استعمال کرتے ہیں۔ کمائی کے لیے اصل AdMob آئی ڈی لگائیں۔';

  @override
  String get demoBadge => 'ڈیمو مواد';

  @override
  String get topicGreetings => 'سلام اور بنیادی باتیں';

  @override
  String get topicNumbers => 'اعداد';

  @override
  String get topicColors => 'رنگ';

  @override
  String get topicTime => 'دن، مہینے اور وقت';

  @override
  String get topicFamily => 'خاندان';

  @override
  String get topicBody => 'جسم';

  @override
  String get topicHealth => 'صحت اور ڈاکٹر';

  @override
  String get topicPharmacy => 'فارمیسی';

  @override
  String get topicFood => 'کھانا';

  @override
  String get topicFruit => 'پھل';

  @override
  String get topicVegetables => 'سبزیاں';

  @override
  String get topicDrinks => 'مشروبات';

  @override
  String get topicCooking => 'پکانا';

  @override
  String get topicShopping => 'سپر مارکیٹ اور خریداری';

  @override
  String get topicMoney => 'پیسہ اور بینک';

  @override
  String get topicHouse => 'گھر';

  @override
  String get topicKitchen => 'باورچی خانہ';

  @override
  String get topicBathroom => 'غسل خانہ';

  @override
  String get topicClothes => 'کپڑے اور جوتے';

  @override
  String get topicWeather => 'موسم اور فصلیں';

  @override
  String get topicCity => 'شہر اور جگہیں';

  @override
  String get topicTransport => 'ٹرانسپورٹ اور راستہ';

  @override
  String get topicWork => 'کام';

  @override
  String get topicJobs => 'پیشے';

  @override
  String get topicOffices => 'دفاتر اور دستاویزات';

  @override
  String get topicSchool => 'اسکول';

  @override
  String get topicAnimals => 'جانور';

  @override
  String get topicNature => 'قدرت';

  @override
  String get topicSport => 'کھیل اور فارغ وقت';

  @override
  String get topicFeelings => 'احساسات';

  @override
  String get topicVerbs => 'عام فعل';

  @override
  String get topicAdjectives => 'عام صفات';

  @override
  String get topicPhrases => 'کارآمد جملے';

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
  String get moreLanguages => 'مزید زبانیں';

  @override
  String get languageNoteWordTranslations =>
      'الفاظ کے تراجم دس بنیادی زبانوں میں ہیں؛ باقی انٹرفیس زبانوں میں انگریزی دکھائی جاتی ہے۔';

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
