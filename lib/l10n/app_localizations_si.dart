// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get appTitle => 'Italian Words: Learn & Play';

  @override
  String get tabSearch => 'සොයන්න';

  @override
  String get tabToday => 'අද';

  @override
  String get tabQuiz => 'ප්‍රශ්නාවලිය';

  @override
  String get tabTopics => 'මාතෘකා';

  @override
  String get settingsTitle => 'සැකසීම්';

  @override
  String get myWords => 'මගේ වචන';

  @override
  String get back => 'ආපසු';

  @override
  String get next => 'ඊළඟ';

  @override
  String get done => 'නිමයි';

  @override
  String get close => 'වසන්න';

  @override
  String get cancel => 'අවලංගු';

  @override
  String get confirm => 'තහවුරු';

  @override
  String get retry => 'නැවත උත්සාහ';

  @override
  String get listen => 'අහන්න';

  @override
  String get listenSlow => 'සෙමින්';

  @override
  String get explanation => 'විස්තරය';

  @override
  String get exampleLabel => 'උදාහරණය';

  @override
  String get typeNoun => 'නාම පදය';

  @override
  String get typeVerb => 'ක්‍රියා පදය';

  @override
  String get typeAdjective => 'විශේෂණ';

  @override
  String get typePhrase => 'වාක්‍ය ඛණ්ඩය';

  @override
  String get searchHint => 'ඉතාලි, ඉංග්‍රීසි, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words වචන · $phrases වාක්‍ය';
  }

  @override
  String get recentSearches => 'මෑත සෙවීම්';

  @override
  String get clearRecent => 'ඉවත් කරන්න';

  @override
  String get noResults => 'වචනයක් හමු නොවිණි';

  @override
  String get didYouMean => 'ඔබට අදහස් වූයේ…?';

  @override
  String get searchOnline => 'අන්තර්ජාලයේ සොයන්න';

  @override
  String get searchingOnline => 'අන්තර්ජාලයේ සොයමින්…';

  @override
  String get offlineNotice =>
      'ඔබ ඔෆ්ලයින්. යෙදුමේ සියලු වචන තවමත් ක්‍රියා කරයි.';

  @override
  String get onlineResultTitle => 'විකිශබ්දකෝෂයෙන්';

  @override
  String get addToMyWords => 'මගේ වචනවලට එක් කරන්න';

  @override
  String get removeFromMyWords => 'මගේ වචනවලින් ඉවත් කරන්න';

  @override
  String get myWordsEmpty =>
      'තවම වචන සුරැකී නැත. සෙවීමේ “මගේ වචනවලට එක් කරන්න” භාවිතා කරන්න.';

  @override
  String get quizOnMyWords => 'මගේ වචන ප්‍රශ්නාවලිය';

  @override
  String get todayTitle => 'අදේ වචන';

  @override
  String todayProgress(int n, int total) {
    return 'වචනය $n / $total';
  }

  @override
  String streakDays(int n) {
    return 'දින $n ක්';
  }

  @override
  String get miniQuizCta => 'අදේ වචන සඳහා කුඩා ප්‍රශ්නාවලිය';

  @override
  String get learnedToday => 'අද බැලුවා';

  @override
  String get todayDone => 'වචන 10 ම බැලුවා. හෙට නැවත එන්න!';

  @override
  String get quizPickCategory => 'ප්‍රවර්ගයක් තෝරන්න';

  @override
  String get mixOfAll => 'සියල්ල මිශ්‍ර';

  @override
  String quizProgress(int n, int total) {
    return 'ප්‍රශ්නය $n / $total';
  }

  @override
  String get quizQuestionPrompt => 'වචනය පින්තූරයට ගැළපේද?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'සත්‍ය';

  @override
  String get falsoHint => 'අසත්‍ය';

  @override
  String get answerCorrect => 'නිවැරදි!';

  @override
  String get answerWrong => 'වැරදි';

  @override
  String get correctAnswerIs => 'නිවැරදි වචනය:';

  @override
  String get quizResultTitle => 'ඔබේ ප්‍රතිඵලය';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'සමත්';

  @override
  String get notPassed => 'අසමත්';

  @override
  String get passRule => 'වැරදි 2ක් හෝ අඩු නම් සමත්';

  @override
  String mistakesCount(int n) {
    return 'වැරදි $n';
  }

  @override
  String get noMistakes => 'වැරදි නැත. විශිෂ්ටයි!';

  @override
  String get repeatMistakes => 'වැරදි නැවත';

  @override
  String get newQuiz => 'නව ප්‍රශ්නාවලිය';

  @override
  String bestScoreValue(int score, int total) {
    return 'හොඳම: $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'මෙම ප්‍රවර්ගයට ප්‍රශ්නාවලියක් සඳහා තවත් වචන අවශ්‍යයි.';

  @override
  String get topicsSubtitle => 'ප්‍රවර්ග අනුව ඉගෙන ගන්න';

  @override
  String nWords(int n) {
    return 'වචන $n';
  }

  @override
  String nLearned(int n) {
    return 'ඉගෙන ගත් $n';
  }

  @override
  String get flashcards => 'කාඩ්පත්';

  @override
  String get quiz20 => 'ප්‍රශ්න 20';

  @override
  String get flashcardTapToFlip => 'පරිවර්තනය බැලීමට කාඩ්පත ස්පර්ශ කරන්න';

  @override
  String get interfaceLanguage => 'යෙදුම් භාෂාව';

  @override
  String get audioSpeed => 'හඬ වේගය';

  @override
  String get dailyReminder => 'දිනපතා මතක් කිරීම';

  @override
  String get reminderTime => 'මතක් කරන වේලාව';

  @override
  String get reminderBody => 'නව ඉතාලි වචන 10 ඔබ එනතුරු.';

  @override
  String get darkMode => 'අඳුරු තේමාව';

  @override
  String get resetProgress => 'ප්‍රගතිය මකන්න';

  @override
  String get resetProgressConfirm => 'දිනදාම, ලකුණු සහ සුරැකි වචන මකන්නද?';

  @override
  String get resetDone => 'ප්‍රගතිය මකා ඇත';

  @override
  String get privacy => 'රහස්‍යතාව';

  @override
  String get about => 'යෙදුම ගැන';

  @override
  String get adsConsentChange => 'දැන්වීම් අනුමැතිය වෙනස් කරන්න';

  @override
  String get removeAds => 'දැන්වීම් ඉවත් කරන්න';

  @override
  String get removeAdsBody =>
      'එක් ගෙවීමක්, නැවත දැන්වීම් නැත. සියලු වචන, මාතෘකා සහ ප්‍රශ්නාවලි නොමිලේ.';

  @override
  String get buy => 'මිලදී ගන්න';

  @override
  String get restorePurchases => 'මිලදී ගැනීම් ප්‍රතිස්ථාපනය';

  @override
  String get adsRemoved => 'දැන්වීම් ඉවත් කළා. ස්තූතියි!';

  @override
  String get purchasePending => 'ගෙවීම සිදුවෙමින්…';

  @override
  String get purchaseError => 'මිලදී ගැනීම සම්පූර්ණ නොවිණි.';

  @override
  String get nothingToRestore => 'පෙර මිලදී ගැනීමක් හමු නොවිණි.';

  @override
  String get webPurchaseNotice => 'මිලදී ගැනීම් Android සහ iPhone යෙදුමේ ඇත.';

  @override
  String get storeUnavailable => 'වෙළඳසැල දැන් නොමැත.';

  @override
  String get voiceHelpTitle => 'ඉතාලි හඬ ස්ථාපනය කරන්න';

  @override
  String get voiceHelpBody =>
      'ඔබේ දුරකථනයේ තවම ඉතාලි හඬක් නැත. සැකසීම් › පද්ධතිය › භාෂා › පෙළ-සිට-කථනය විවෘත කර, Google එන්ජිම තෝරා ඉතාලි ස්ථාපනය කරන්න. වචන කියවීම කෙසේ වෙතත් ක්‍රියා කරයි.';

  @override
  String get privacyBody =>
      'මෙම යෙදුම ඔෆ්ලයින් ක්‍රියා කරයි, පිවිසුමක් අවශ්‍ය නැත. ඔබේ ප්‍රගතිය, සුරැකි වචන සහ සැකසීම් ඔබේ දුරකථනයේ පමණක් රැඳේ. ඔබේ නම, ඊමේල් හෝ ස්ථානය කිසිවිටෙක එකතු නොකරමු. දැන්වීම් Google AdMob වෙතින් පැමිණේ; අනුමැතිය ලබාදීමෙන් පසුව පමණක් පෙන්වයි, සැකසීම්වලින් ඔබේ තේරීම වෙනස් කළ හැක. “අන්තර්ජාලයේ සොයන්න” ඔබ ලියූ වචනය පමණක් විකිශබ්දකෝෂයට යවයි. වයස 13+.';

  @override
  String get aboutBody =>
      'ඉතාලියේ ජීවත් වන අයට කුඩා, අවංක යෙදුමක්: වචනයක් සොයන්න, දිනකට නව වචන දහයක් ඉගෙන ගන්න, රියදුරු බලපත්‍ර විභාගය වගේ ඔබම පරීක්ෂා කරගන්න. සියල්ල ඔෆ්ලයින්, ගිණුමක් නැතිව.';

  @override
  String get creditsBody =>
      'මෙම යෙදුම සඳහා පරිවර්තන සහ උදාහරණ වාක්‍ය අතින් ලියා පරීක්ෂා කර ඇත. වචන ලැයිස්තු විවෘත මූලාශ්‍ර සමඟ සසඳා බලා ඇත: Wiktionary සහ Wikizionario (CC BY-SA 4.0), Tatoeba වාක්‍ය (CC BY 2.0 FR) සහ Open Multilingual Wordnet. පින්තූර සඳහා Google Noto Emoji (Apache 2.0). ඉතාලි උච්චාරණය ඔබේ දුරකථනයේ පෙළ-සිට-කථනය භාවිතා කරයි.';

  @override
  String get dataCoverage => 'මෙම අනුවාදයේ වචන ලැයිස්තුව';

  @override
  String get mascotCheer => 'හොඳයි!';

  @override
  String get mascotTryAgain => 'දිගටම කරගෙන යන්න!';

  @override
  String get adsTestIdsNotice =>
      'සැකසීම අවශ්‍යයි: දැන්වීම් තවමත් Google හි පරීක්ෂණ හැඳුනුම් භාවිතා කරයි. ආදායම සඳහා සැබෑ AdMob හැඳුනුම් යොදන්න.';

  @override
  String get demoBadge => 'ආදර්ශන අන්තර්ගතය';

  @override
  String get topicGreetings => 'ආචාර හා මූලික';

  @override
  String get topicNumbers => 'අංක';

  @override
  String get topicColors => 'වර්ණ';

  @override
  String get topicTime => 'දින, මාස හා වේලාව';

  @override
  String get topicFamily => 'පවුල';

  @override
  String get topicBody => 'ශරීරය';

  @override
  String get topicHealth => 'සෞඛ්‍ය හා වෛද්‍ය';

  @override
  String get topicPharmacy => 'ඔසුසැල';

  @override
  String get topicFood => 'ආහාර';

  @override
  String get topicFruit => 'පලතුරු';

  @override
  String get topicVegetables => 'එළවළු';

  @override
  String get topicDrinks => 'බීම';

  @override
  String get topicCooking => 'උයන්න';

  @override
  String get topicShopping => 'සුපිරි වෙළඳසැල';

  @override
  String get topicMoney => 'මුදල් හා බැංකුව';

  @override
  String get topicHouse => 'නිවස';

  @override
  String get topicKitchen => 'කුස්සිය';

  @override
  String get topicBathroom => 'නාන කාමරය';

  @override
  String get topicClothes => 'ඇඳුම් හා සපත්තු';

  @override
  String get topicWeather => 'කාලගුණය හා ඍතු';

  @override
  String get topicCity => 'නගරය හා ස්ථාන';

  @override
  String get topicTransport => 'ප්‍රවාහනය හා දිශා';

  @override
  String get topicWork => 'රැකියාව';

  @override
  String get topicJobs => 'වෘත්ති';

  @override
  String get topicOffices => 'කාර්යාල හා ලේඛන';

  @override
  String get topicSchool => 'පාසල';

  @override
  String get topicAnimals => 'සතුන්';

  @override
  String get topicNature => 'සොබාදහම';

  @override
  String get topicSport => 'ක්‍රීඩා හා විවේකය';

  @override
  String get topicFeelings => 'හැඟීම්';

  @override
  String get topicVerbs => 'සුලබ ක්‍රියා';

  @override
  String get topicAdjectives => 'සුලබ විශේෂණ';

  @override
  String get topicPhrases => 'ප්‍රයෝජනවත් වාක්‍ය';

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
  String get moreLanguages => 'තවත් භාෂා';

  @override
  String get languageNoteWordTranslations =>
      'වචන පරිවර්තන ප්‍රධාන භාෂා දහයේ ඇත; අනෙක් අතුරුමුහුණත් භාෂා සඳහා ඉංග්‍රීසි පෙන්වයි.';

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
