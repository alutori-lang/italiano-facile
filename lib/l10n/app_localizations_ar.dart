// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Italian Words: Learn & Play';

  @override
  String get tabSearch => 'بحث';

  @override
  String get tabToday => 'اليوم';

  @override
  String get tabQuiz => 'اختبار';

  @override
  String get tabTopics => 'مواضيع';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get myWords => 'كلماتي';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get close => 'إغلاق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get retry => 'حاول مرة أخرى';

  @override
  String get listen => 'استمع';

  @override
  String get listenSlow => 'بطيء';

  @override
  String get explanation => 'الشرح';

  @override
  String get exampleLabel => 'مثال';

  @override
  String get typeNoun => 'اسم';

  @override
  String get typeVerb => 'فعل';

  @override
  String get typeAdjective => 'صفة';

  @override
  String get typePhrase => 'عبارة';

  @override
  String get searchHint => 'الإيطالية، الإنجليزية، اردو، বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words كلمة · $phrases عبارة';
  }

  @override
  String get recentSearches => 'أحدث عمليات البحث';

  @override
  String get clearRecent => 'حذف';

  @override
  String get noResults => 'لم يتم العثور على كلمة';

  @override
  String get didYouMean => 'هل تقصد…؟';

  @override
  String get searchOnline => 'البحث عبر الإنترنت';

  @override
  String get searchingOnline => 'جارٍ البحث…';

  @override
  String get offlineNotice =>
      'أنت غير متصل بالإنترنت. كل كلمات التطبيق تعمل كما هي.';

  @override
  String get onlineResultTitle => 'من ويكاموس';

  @override
  String get addToMyWords => 'أضف إلى كلماتي';

  @override
  String get removeFromMyWords => 'إزالة من كلماتي';

  @override
  String get myWordsEmpty =>
      'لا توجد كلمات محفوظة بعد. استخدم «أضف إلى كلماتي» في البحث.';

  @override
  String get quizOnMyWords => 'اختبار كلماتي';

  @override
  String get todayTitle => 'كلمات اليوم';

  @override
  String todayProgress(int n, int total) {
    return 'الكلمة $n من $total';
  }

  @override
  String streakDays(int n) {
    return '$n أيام متتابعة';
  }

  @override
  String get miniQuizCta => 'اختبار قصير لكلمات اليوم';

  @override
  String get learnedToday => 'تمت مشاهدته اليوم';

  @override
  String get todayDone => 'شاهدت الكلمات العشر. عد غداً!';

  @override
  String get quizPickCategory => 'اختر فئة';

  @override
  String get mixOfAll => 'خليط من الكل';

  @override
  String quizProgress(int n, int total) {
    return 'السؤال $n من $total';
  }

  @override
  String get quizQuestionPrompt => 'هل تطابق الكلمة الصورة؟';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'صحيح';

  @override
  String get falsoHint => 'خطأ';

  @override
  String get answerCorrect => 'صحيح!';

  @override
  String get answerWrong => 'خطأ';

  @override
  String get correctAnswerIs => 'الكلمة الصحيحة هي:';

  @override
  String get quizResultTitle => 'نتيجتك';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'ناجح';

  @override
  String get notPassed => 'غير ناجح';

  @override
  String get passRule => 'تنجح بخطأين كحد أقصى';

  @override
  String mistakesCount(int n) {
    return '$n أخطاء';
  }

  @override
  String get noMistakes => 'لا أخطاء. ممتاز!';

  @override
  String get repeatMistakes => 'أعد الأخطاء';

  @override
  String get newQuiz => 'اختبار جديد';

  @override
  String bestScoreValue(int score, int total) {
    return 'الأفضل: $score/$total';
  }

  @override
  String get quizNotEnoughWords => 'تحتاج هذه الفئة إلى كلمات أكثر للاختبار.';

  @override
  String get topicsSubtitle => 'تعلّم حسب الفئة';

  @override
  String nWords(int n) {
    return '$n كلمة';
  }

  @override
  String nLearned(int n) {
    return '$n متعلّمة';
  }

  @override
  String get flashcards => 'بطاقات';

  @override
  String get quiz20 => 'اختبار 20';

  @override
  String get flashcardTapToFlip => 'اضغط على البطاقة لرؤية الترجمة';

  @override
  String get interfaceLanguage => 'لغة التطبيق';

  @override
  String get audioSpeed => 'سرعة الصوت';

  @override
  String get dailyReminder => 'تذكير يومي';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get reminderBody => '10 كلمات إيطالية جديدة تنتظرك.';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get resetProgress => 'إعادة ضبط التقدّم';

  @override
  String get resetProgressConfirm => 'حذف السلسلة والنتائج والكلمات المحفوظة؟';

  @override
  String get resetDone => 'تمت إعادة الضبط';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get about => 'حول التطبيق';

  @override
  String get adsConsentChange => 'تغيير موافقة الإعلانات';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get removeAdsBody =>
      'دفعة واحدة وبلا إعلانات للأبد. كل الكلمات والمواضيع والاختبارات تبقى مجانية.';

  @override
  String get buy => 'شراء';

  @override
  String get restorePurchases => 'استعادة الشراء';

  @override
  String get adsRemoved => 'تمت إزالة الإعلانات. شكراً!';

  @override
  String get purchasePending => 'جارٍ الدفع…';

  @override
  String get purchaseError => 'لم تكتمل عملية الشراء.';

  @override
  String get nothingToRestore => 'لم يتم العثور على شراء سابق.';

  @override
  String get webPurchaseNotice => 'الشراء متاح في تطبيق Android و iPhone.';

  @override
  String get storeUnavailable => 'المتجر غير متاح حالياً.';

  @override
  String get voiceHelpTitle => 'تثبيت الصوت الإيطالي';

  @override
  String get voiceHelpBody =>
      'لا يوجد صوت إيطالي على هاتفك. افتح الإعدادات › النظام › اللغات › تحويل النص إلى كلام، اختر محرّك Google وثبّت الإيطالية. قراءة الكلمات تعمل على أي حال.';

  @override
  String get privacyBody =>
      'يعمل هذا التطبيق دون إنترنت ولا يطلب تسجيل الدخول. يبقى تقدّمك وكلماتك المحفوظة وإعداداتك على هاتفك فقط. لا نجمع اسمك أو بريدك أو موقعك أبداً. تأتي الإعلانات من Google AdMob ولا تظهر إلا بعد موافقتك في نموذج الموافقة؛ ويمكنك تغيير اختيارك في الإعدادات. «البحث عبر الإنترنت» يرسل الكلمة المكتوبة فقط إلى ويكاموس. للأعمار 13 وما فوق.';

  @override
  String get aboutBody =>
      'تطبيق صغير وصادق لمن يعيش في إيطاليا: ابحث عن كلمة، تعلّم عشر كلمات جديدة كل يوم، واختبر نفسك كما في اختبار رخصة القيادة. كل شيء يعمل دون إنترنت وبلا حساب.';

  @override
  String get creditsBody =>
      'تُكتب الترجمات وأمثلة الجمل وتُراجع يدوياً لهذا التطبيق. وقد قوبلت قوائم الكلمات بمصادر مفتوحة: ويكاموس وWikizionario (CC BY-SA 4.0)، وجمل Tatoeba (CC BY 2.0 FR)، وOpen Multilingual Wordnet. الصور من Google Noto Emoji (Apache 2.0). النطق الإيطالي يعتمد على تحويل النص إلى كلام في هاتفك.';

  @override
  String get dataCoverage => 'قائمة الكلمات في هذه النسخة';

  @override
  String get mascotCheer => 'أحسنت!';

  @override
  String get mascotTryAgain => 'واصل!';

  @override
  String get adsTestIdsNotice =>
      'الإعداد مطلوب: لا تزال الإعلانات تستخدم معرّفات Google التجريبية. ألصق معرّفات AdMob الحقيقية لتحقيق الأرباح.';

  @override
  String get demoBadge => 'محتوى تجريبي';

  @override
  String get topicGreetings => 'التحيات والأساسيات';

  @override
  String get topicNumbers => 'الأرقام';

  @override
  String get topicColors => 'الألوان';

  @override
  String get topicTime => 'الأيام والأشهر والوقت';

  @override
  String get topicFamily => 'العائلة';

  @override
  String get topicBody => 'الجسم';

  @override
  String get topicHealth => 'الصحة والطبيب';

  @override
  String get topicPharmacy => 'الصيدلية';

  @override
  String get topicFood => 'الطعام';

  @override
  String get topicFruit => 'الفواكه';

  @override
  String get topicVegetables => 'الخضروات';

  @override
  String get topicDrinks => 'المشروبات';

  @override
  String get topicCooking => 'الطهي';

  @override
  String get topicShopping => 'السوق والتسوّق';

  @override
  String get topicMoney => 'المال والبنك';

  @override
  String get topicHouse => 'المنزل';

  @override
  String get topicKitchen => 'المطبخ';

  @override
  String get topicBathroom => 'الحمّام';

  @override
  String get topicClothes => 'الملابس والأحذية';

  @override
  String get topicWeather => 'الطقس والفصول';

  @override
  String get topicCity => 'المدينة والأماكن';

  @override
  String get topicTransport => 'المواصلات والاتجاهات';

  @override
  String get topicWork => 'العمل';

  @override
  String get topicJobs => 'المهن';

  @override
  String get topicOffices => 'المكاتب والوثائق';

  @override
  String get topicSchool => 'المدرسة';

  @override
  String get topicAnimals => 'الحيوانات';

  @override
  String get topicNature => 'الطبيعة';

  @override
  String get topicSport => 'الرياضة ووقت الفراغ';

  @override
  String get topicFeelings => 'المشاعر';

  @override
  String get topicVerbs => 'أفعال شائعة';

  @override
  String get topicAdjectives => 'صفات شائعة';

  @override
  String get topicPhrases => 'عبارات مفيدة';

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
  String get moreLanguages => 'لغات أخرى';

  @override
  String get languageNoteWordTranslations =>
      'ترجمات الكلمات متوفّرة بعشر لغات رئيسية؛ أما لغات الواجهة الأخرى فتعود إلى الإنجليزية.';
}
