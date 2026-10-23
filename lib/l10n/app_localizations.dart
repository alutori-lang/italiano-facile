import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('pa'),
    Locale.fromSubtags(languageCode: 'pa', scriptCode: 'Arab'),
    Locale('pt'),
    Locale('ru'),
    Locale('si'),
    Locale('ur'),
    Locale('zh')
  ];

  /// appTitle
  ///
  /// In en, this message translates to:
  /// **'Italiano Facile per Stranieri'**
  String get appTitle;

  /// tabSearch
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tabSearch;

  /// tabToday
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// tabQuiz
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get tabQuiz;

  /// tabTopics
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get tabTopics;

  /// settingsTitle
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// myWords
  ///
  /// In en, this message translates to:
  /// **'My words'**
  String get myWords;

  /// back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// retry
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// listen
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// listenSlow
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get listenSlow;

  /// explanation
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// exampleLabel
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get exampleLabel;

  /// typeNoun
  ///
  /// In en, this message translates to:
  /// **'Noun'**
  String get typeNoun;

  /// typeVerb
  ///
  /// In en, this message translates to:
  /// **'Verb'**
  String get typeVerb;

  /// typeAdjective
  ///
  /// In en, this message translates to:
  /// **'Adjective'**
  String get typeAdjective;

  /// typePhrase
  ///
  /// In en, this message translates to:
  /// **'Phrase'**
  String get typePhrase;

  /// searchHint
  ///
  /// In en, this message translates to:
  /// **'Italian, English, اردو, বাংলা…'**
  String get searchHint;

  /// wordsAndPhrases
  ///
  /// In en, this message translates to:
  /// **'{words} words · {phrases} phrases'**
  String wordsAndPhrases(int words, int phrases);

  /// Search header: words and phrases in one count
  ///
  /// In en, this message translates to:
  /// **'{count} words and phrases'**
  String wordsAndPhrasesTotal(int count);

  /// recentSearches
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// clearRecent
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearRecent;

  /// noResults
  ///
  /// In en, this message translates to:
  /// **'No word found'**
  String get noResults;

  /// didYouMean
  ///
  /// In en, this message translates to:
  /// **'Did you mean…?'**
  String get didYouMean;

  /// searchOnline
  ///
  /// In en, this message translates to:
  /// **'Search online'**
  String get searchOnline;

  /// searchingOnline
  ///
  /// In en, this message translates to:
  /// **'Searching online…'**
  String get searchingOnline;

  /// offlineNotice
  ///
  /// In en, this message translates to:
  /// **'You are offline. All words in the app still work.'**
  String get offlineNotice;

  /// onlineResultTitle
  ///
  /// In en, this message translates to:
  /// **'From Wiktionary'**
  String get onlineResultTitle;

  /// addToMyWords
  ///
  /// In en, this message translates to:
  /// **'Add to my words'**
  String get addToMyWords;

  /// removeFromMyWords
  ///
  /// In en, this message translates to:
  /// **'Remove from my words'**
  String get removeFromMyWords;

  /// myWordsEmpty
  ///
  /// In en, this message translates to:
  /// **'No saved words yet. Use “Add to my words” in Search.'**
  String get myWordsEmpty;

  /// quizOnMyWords
  ///
  /// In en, this message translates to:
  /// **'Quiz on my words'**
  String get quizOnMyWords;

  /// todayTitle
  ///
  /// In en, this message translates to:
  /// **'Today\'s words'**
  String get todayTitle;

  /// todayProgress
  ///
  /// In en, this message translates to:
  /// **'Word {n} of {total}'**
  String todayProgress(int n, int total);

  /// streakDays
  ///
  /// In en, this message translates to:
  /// **'{n} day streak'**
  String streakDays(int n);

  /// miniQuizCta
  ///
  /// In en, this message translates to:
  /// **'Mini-quiz on today\'s words'**
  String get miniQuizCta;

  /// learnedToday
  ///
  /// In en, this message translates to:
  /// **'Seen today'**
  String get learnedToday;

  /// todayDone
  ///
  /// In en, this message translates to:
  /// **'All 10 words seen. Come back tomorrow!'**
  String get todayDone;

  /// quizPickCategory
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get quizPickCategory;

  /// mixOfAll
  ///
  /// In en, this message translates to:
  /// **'Mix of all'**
  String get mixOfAll;

  /// quizProgress
  ///
  /// In en, this message translates to:
  /// **'Question {n} of {total}'**
  String quizProgress(int n, int total);

  /// quizQuestionPrompt
  ///
  /// In en, this message translates to:
  /// **'Does the word match the picture?'**
  String get quizQuestionPrompt;

  /// vero
  ///
  /// In en, this message translates to:
  /// **'VERO'**
  String get vero;

  /// falso
  ///
  /// In en, this message translates to:
  /// **'FALSO'**
  String get falso;

  /// veroHint
  ///
  /// In en, this message translates to:
  /// **'true'**
  String get veroHint;

  /// falsoHint
  ///
  /// In en, this message translates to:
  /// **'false'**
  String get falsoHint;

  /// answerCorrect
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get answerCorrect;

  /// answerWrong
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get answerWrong;

  /// correctAnswerIs
  ///
  /// In en, this message translates to:
  /// **'The right word is:'**
  String get correctAnswerIs;

  /// quizResultTitle
  ///
  /// In en, this message translates to:
  /// **'Your result'**
  String get quizResultTitle;

  /// scoreOutOf
  ///
  /// In en, this message translates to:
  /// **'{score} / {total}'**
  String scoreOutOf(int score, int total);

  /// passed
  ///
  /// In en, this message translates to:
  /// **'PASSED'**
  String get passed;

  /// notPassed
  ///
  /// In en, this message translates to:
  /// **'NOT PASSED'**
  String get notPassed;

  /// passRule
  ///
  /// In en, this message translates to:
  /// **'Pass with 2 mistakes or fewer'**
  String get passRule;

  /// mistakesCount
  ///
  /// In en, this message translates to:
  /// **'{n} mistakes'**
  String mistakesCount(int n);

  /// noMistakes
  ///
  /// In en, this message translates to:
  /// **'No mistakes. Perfect!'**
  String get noMistakes;

  /// repeatMistakes
  ///
  /// In en, this message translates to:
  /// **'Repeat the mistakes'**
  String get repeatMistakes;

  /// newQuiz
  ///
  /// In en, this message translates to:
  /// **'New quiz'**
  String get newQuiz;

  /// bestScoreValue
  ///
  /// In en, this message translates to:
  /// **'Best: {score}/{total}'**
  String bestScoreValue(int score, int total);

  /// quizNotEnoughWords
  ///
  /// In en, this message translates to:
  /// **'This category needs more words for a quiz.'**
  String get quizNotEnoughWords;

  /// topicsSubtitle
  ///
  /// In en, this message translates to:
  /// **'Learn by category'**
  String get topicsSubtitle;

  /// nWords
  ///
  /// In en, this message translates to:
  /// **'{n} words'**
  String nWords(int n);

  /// nLearned
  ///
  /// In en, this message translates to:
  /// **'{n} learned'**
  String nLearned(int n);

  /// flashcards
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// quiz20
  ///
  /// In en, this message translates to:
  /// **'Quiz 20'**
  String get quiz20;

  /// flashcardTapToFlip
  ///
  /// In en, this message translates to:
  /// **'Tap the card to see the translation'**
  String get flashcardTapToFlip;

  /// interfaceLanguage
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get interfaceLanguage;

  /// audioSpeed
  ///
  /// In en, this message translates to:
  /// **'Audio speed'**
  String get audioSpeed;

  /// dailyReminder
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// reminderTime
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// reminderBody
  ///
  /// In en, this message translates to:
  /// **'10 new Italian words are waiting for you.'**
  String get reminderBody;

  /// darkMode
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// resetProgress
  ///
  /// In en, this message translates to:
  /// **'Reset progress'**
  String get resetProgress;

  /// resetProgressConfirm
  ///
  /// In en, this message translates to:
  /// **'Delete streak, scores and saved words?'**
  String get resetProgressConfirm;

  /// resetDone
  ///
  /// In en, this message translates to:
  /// **'Progress reset'**
  String get resetDone;

  /// privacy
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// about
  ///
  /// In en, this message translates to:
  /// **'About & credits'**
  String get about;

  /// adsConsentChange
  ///
  /// In en, this message translates to:
  /// **'Change ads consent'**
  String get adsConsentChange;

  /// removeAds
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// removeAdsBody
  ///
  /// In en, this message translates to:
  /// **'One payment, no ads ever again. All words, topics and quizzes stay free.'**
  String get removeAdsBody;

  /// buy
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// restorePurchases
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// adsRemoved
  ///
  /// In en, this message translates to:
  /// **'Ads removed. Thank you!'**
  String get adsRemoved;

  /// purchasePending
  ///
  /// In en, this message translates to:
  /// **'Payment in progress…'**
  String get purchasePending;

  /// purchaseError
  ///
  /// In en, this message translates to:
  /// **'The purchase did not go through.'**
  String get purchaseError;

  /// nothingToRestore
  ///
  /// In en, this message translates to:
  /// **'No earlier purchase found.'**
  String get nothingToRestore;

  /// webPurchaseNotice
  ///
  /// In en, this message translates to:
  /// **'Purchases are available in the Android and iPhone app.'**
  String get webPurchaseNotice;

  /// storeUnavailable
  ///
  /// In en, this message translates to:
  /// **'The store is not available right now.'**
  String get storeUnavailable;

  /// voiceHelpTitle
  ///
  /// In en, this message translates to:
  /// **'Install the Italian voice'**
  String get voiceHelpTitle;

  /// voiceHelpBody
  ///
  /// In en, this message translates to:
  /// **'Your phone has no Italian voice yet. Open Settings › System › Languages › Text-to-speech, choose the Google speech engine and install Italian. Reading the words works anyway.'**
  String get voiceHelpBody;

  /// privacyBody
  ///
  /// In en, this message translates to:
  /// **'This app works offline and has no login. Your progress, saved words and settings stay on your phone only. We never collect your name, e-mail or location. Ads come from Google AdMob and are shown only after you accept them in the consent form; you can change your choice at any time in Settings. “Search online” sends only the word you typed to Wiktionary. For ages 13+.'**
  String get privacyBody;

  /// aboutBody
  ///
  /// In en, this message translates to:
  /// **'A small, honest app for people living in Italy: search a word, learn ten new ones a day, and test yourself like in the driving-licence quiz. Everything works offline, with no account.'**
  String get aboutBody;

  /// creditsBody
  ///
  /// In en, this message translates to:
  /// **'Translations and example sentences are written and checked by hand for this app. Word lists were cross-checked against open sources: Wiktionary and Wikizionario (CC BY-SA 4.0), Tatoeba example sentences (CC BY 2.0 FR) and the Open Multilingual Wordnet. Pictures use Google Noto Emoji (Apache 2.0). Italian pronunciation uses your phone\'s own text-to-speech.'**
  String get creditsBody;

  /// dataCoverage
  ///
  /// In en, this message translates to:
  /// **'Word list in this version'**
  String get dataCoverage;

  /// mascotCheer
  ///
  /// In en, this message translates to:
  /// **'Bravo!'**
  String get mascotCheer;

  /// mascotTryAgain
  ///
  /// In en, this message translates to:
  /// **'Keep going!'**
  String get mascotTryAgain;

  /// adsTestIdsNotice
  ///
  /// In en, this message translates to:
  /// **'Debug build: the ads still use Google\'s test ids. The release build uses the real AdMob ids.'**
  String get adsTestIdsNotice;

  /// demoBadge
  ///
  /// In en, this message translates to:
  /// **'Demo content'**
  String get demoBadge;

  /// topicGreetings
  ///
  /// In en, this message translates to:
  /// **'Greetings & basics'**
  String get topicGreetings;

  /// topicNumbers
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get topicNumbers;

  /// topicColors
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get topicColors;

  /// topicTime
  ///
  /// In en, this message translates to:
  /// **'Days, months & time'**
  String get topicTime;

  /// topicFamily
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get topicFamily;

  /// topicBody
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get topicBody;

  /// topicHealth
  ///
  /// In en, this message translates to:
  /// **'Health & doctor'**
  String get topicHealth;

  /// topicPharmacy
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get topicPharmacy;

  /// topicFood
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get topicFood;

  /// topicFruit
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get topicFruit;

  /// topicVegetables
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get topicVegetables;

  /// topicDrinks
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get topicDrinks;

  /// topicCooking
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get topicCooking;

  /// topicShopping
  ///
  /// In en, this message translates to:
  /// **'Supermarket & shopping'**
  String get topicShopping;

  /// topicMoney
  ///
  /// In en, this message translates to:
  /// **'Money & bank'**
  String get topicMoney;

  /// topicHouse
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get topicHouse;

  /// topicKitchen
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get topicKitchen;

  /// topicBathroom
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get topicBathroom;

  /// topicClothes
  ///
  /// In en, this message translates to:
  /// **'Clothes & shoes'**
  String get topicClothes;

  /// topicWeather
  ///
  /// In en, this message translates to:
  /// **'Weather & seasons'**
  String get topicWeather;

  /// topicCity
  ///
  /// In en, this message translates to:
  /// **'City & places'**
  String get topicCity;

  /// topicTransport
  ///
  /// In en, this message translates to:
  /// **'Transport & directions'**
  String get topicTransport;

  /// topicWork
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get topicWork;

  /// topicJobs
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get topicJobs;

  /// topicOffices
  ///
  /// In en, this message translates to:
  /// **'Offices & documents'**
  String get topicOffices;

  /// topicSchool
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get topicSchool;

  /// topicAnimals
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get topicAnimals;

  /// topicNature
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get topicNature;

  /// topicSport
  ///
  /// In en, this message translates to:
  /// **'Sport & free time'**
  String get topicSport;

  /// topicFeelings
  ///
  /// In en, this message translates to:
  /// **'Feelings'**
  String get topicFeelings;

  /// topicVerbs
  ///
  /// In en, this message translates to:
  /// **'Common verbs'**
  String get topicVerbs;

  /// topicAdjectives
  ///
  /// In en, this message translates to:
  /// **'Common adjectives'**
  String get topicAdjectives;

  /// topicPhrases
  ///
  /// In en, this message translates to:
  /// **'Useful phrases'**
  String get topicPhrases;

  /// langEn
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEn;

  /// langUr
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get langUr;

  /// langPaArab
  ///
  /// In en, this message translates to:
  /// **'پنجابی (شاہ مکھی)'**
  String get langPaArab;

  /// langPa
  ///
  /// In en, this message translates to:
  /// **'ਪੰਜਾਬੀ (ਗੁਰਮੁਖੀ)'**
  String get langPa;

  /// langBn
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get langBn;

  /// langSi
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get langSi;

  /// langZh
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get langZh;

  /// langFr
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFr;

  /// langEs
  ///
  /// In en, this message translates to:
  /// **'Español (España)'**
  String get langEs;

  /// langEs419
  ///
  /// In en, this message translates to:
  /// **'Español (Latinoamérica)'**
  String get langEs419;

  /// langIt
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get langIt;

  /// langPt
  ///
  /// In en, this message translates to:
  /// **'Português (Brasil)'**
  String get langPt;

  /// langDe
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get langDe;

  /// langHi
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get langHi;

  /// langAr
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langAr;

  /// langId
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get langId;

  /// langRu
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get langRu;

  /// moreLanguages
  ///
  /// In en, this message translates to:
  /// **'More languages'**
  String get moreLanguages;

  /// languageNoteWordTranslations
  ///
  /// In en, this message translates to:
  /// **'Word translations are shown in the ten main languages; other interface languages fall back to English.'**
  String get languageNoteWordTranslations;

  /// bigPreparing
  ///
  /// In en, this message translates to:
  /// **'Preparing the dictionary…'**
  String get bigPreparing;

  /// bigPlural
  ///
  /// In en, this message translates to:
  /// **'Plural: {plural}'**
  String bigPlural(String plural);

  /// bigInEnglish
  ///
  /// In en, this message translates to:
  /// **'In English: {gloss}'**
  String bigInEnglish(String gloss);

  /// bigSource
  ///
  /// In en, this message translates to:
  /// **'From the big dictionary (Wiktionary)'**
  String get bigSource;

  /// bigLearnedSource
  ///
  /// In en, this message translates to:
  /// **'Learned from the online dictionary'**
  String get bigLearnedSource;

  /// bigSearching
  ///
  /// In en, this message translates to:
  /// **'Searching the big dictionary…'**
  String get bigSearching;

  /// posAdverb
  ///
  /// In en, this message translates to:
  /// **'Adverb'**
  String get posAdverb;

  /// posArticle
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get posArticle;

  /// posConjunction
  ///
  /// In en, this message translates to:
  /// **'Conjunction'**
  String get posConjunction;

  /// posDeterminer
  ///
  /// In en, this message translates to:
  /// **'Determiner'**
  String get posDeterminer;

  /// posInterjection
  ///
  /// In en, this message translates to:
  /// **'Interjection'**
  String get posInterjection;

  /// posNumeral
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get posNumeral;

  /// posParticle
  ///
  /// In en, this message translates to:
  /// **'Particle'**
  String get posParticle;

  /// posPreposition
  ///
  /// In en, this message translates to:
  /// **'Preposition'**
  String get posPreposition;

  /// posPronoun
  ///
  /// In en, this message translates to:
  /// **'Pronoun'**
  String get posPronoun;

  /// posOther
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get posOther;

  /// bigDictTitle
  ///
  /// In en, this message translates to:
  /// **'Big dictionary'**
  String get bigDictTitle;

  /// bigDictCredits
  ///
  /// In en, this message translates to:
  /// **'The big dictionary of Italian words (over 100,000 words when complete) comes from Wiktionary, through kaikki.org, under the CC BY-SA 4.0 licence. The meanings in the ten languages were prepared for this app from the Wiktionary definitions.'**
  String get bigDictCredits;

  /// bigSearchingOnline
  ///
  /// In en, this message translates to:
  /// **'Searching online…'**
  String get bigSearchingOnline;

  /// bigNotAllowed
  ///
  /// In en, this message translates to:
  /// **'This word cannot be added to the dictionary.'**
  String get bigNotAllowed;

  /// bigNotFoundOnline
  ///
  /// In en, this message translates to:
  /// **'Not found online either: check how you wrote it.'**
  String get bigNotFoundOnline;

  /// rewardNoAdsLink
  ///
  /// In en, this message translates to:
  /// **'Remove ads for 1 hour (watch a video)'**
  String get rewardNoAdsLink;

  /// rewardNoAdsTitle
  ///
  /// In en, this message translates to:
  /// **'1 hour without ads'**
  String get rewardNoAdsTitle;

  /// rewardNoAdsSubtitle
  ///
  /// In en, this message translates to:
  /// **'Watch a short video: no ads for one hour.'**
  String get rewardNoAdsSubtitle;

  /// rewardNotAvailable
  ///
  /// In en, this message translates to:
  /// **'Video not available, try again later'**
  String get rewardNotAvailable;

  /// rewardGranted
  ///
  /// In en, this message translates to:
  /// **'Done! No ads for one hour.'**
  String get rewardGranted;

  /// rewardNotEarned
  ///
  /// In en, this message translates to:
  /// **'Video closed early: watch it to the end to remove the ads.'**
  String get rewardNotEarned;

  /// noAdsActiveTitle
  ///
  /// In en, this message translates to:
  /// **'Ads switched off'**
  String get noAdsActiveTitle;

  /// noAdsRemaining
  ///
  /// In en, this message translates to:
  /// **'No ads for another {minutes} min'**
  String noAdsRemaining(int minutes);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'it',
        'pa',
        'pt',
        'ru',
        'si',
        'ur',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'pa':
      {
        switch (locale.scriptCode) {
          case 'Arab':
            return AppLocalizationsPaArab();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'pa':
      return AppLocalizationsPa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'si':
      return AppLocalizationsSi();
    case 'ur':
      return AppLocalizationsUr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
