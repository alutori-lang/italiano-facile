// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'Suchen';

  @override
  String get tabToday => 'Heute';

  @override
  String get tabQuiz => 'Quiz';

  @override
  String get tabTopics => 'Themen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get myWords => 'Meine Wörter';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get done => 'Fertig';

  @override
  String get close => 'Schließen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get listen => 'Anhören';

  @override
  String get listenSlow => 'Langsam';

  @override
  String get explanation => 'Erklärung';

  @override
  String get exampleLabel => 'Beispiel';

  @override
  String get typeNoun => 'Nomen';

  @override
  String get typeVerb => 'Verb';

  @override
  String get typeAdjective => 'Adjektiv';

  @override
  String get typePhrase => 'Satz';

  @override
  String get searchHint => 'Italienisch, Englisch, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    final intl.NumberFormat wordsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wordsString = wordsNumberFormat.format(words);
    final intl.NumberFormat phrasesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String phrasesString = phrasesNumberFormat.format(phrases);

    return '$wordsString Wörter · $phrasesString Sätze';
  }

  @override
  String wordsAndPhrasesTotal(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString Wörter und Sätze';
  }

  @override
  String get recentSearches => 'Letzte Suchen';

  @override
  String get clearRecent => 'Löschen';

  @override
  String get noResults => 'Kein Wort gefunden';

  @override
  String get didYouMean => 'Meinten Sie…?';

  @override
  String get searchOnline => 'Online suchen';

  @override
  String get searchingOnline => 'Suche online…';

  @override
  String get offlineNotice =>
      'Sie sind offline. Alle Wörter in der App funktionieren weiterhin.';

  @override
  String get onlineResultTitle => 'Aus dem Wiktionary';

  @override
  String get addToMyWords => 'Zu meinen Wörtern';

  @override
  String get removeFromMyWords => 'Aus meinen Wörtern entfernen';

  @override
  String get myWordsEmpty =>
      'Noch keine gespeicherten Wörter. Nutzen Sie „Zu meinen Wörtern“ in der Suche.';

  @override
  String get quizOnMyWords => 'Quiz mit meinen Wörtern';

  @override
  String get todayTitle => 'Wörter des Tages';

  @override
  String todayProgress(int n, int total) {
    return 'Wort $n von $total';
  }

  @override
  String streakDays(int n) {
    return '$n Tage in Folge';
  }

  @override
  String get miniQuizCta => 'Mini-Quiz zu den Wörtern von heute';

  @override
  String get learnedToday => 'Heute gesehen';

  @override
  String get todayDone => 'Alle 10 Wörter gesehen. Kommen Sie morgen wieder!';

  @override
  String get quizPickCategory => 'Kategorie wählen';

  @override
  String get mixOfAll => 'Alles gemischt';

  @override
  String quizProgress(int n, int total) {
    return 'Frage $n von $total';
  }

  @override
  String get quizQuestionPrompt => 'Passt das Wort zum Bild?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'richtig';

  @override
  String get falsoHint => 'falsch';

  @override
  String get answerCorrect => 'Richtig!';

  @override
  String get answerWrong => 'Falsch';

  @override
  String get correctAnswerIs => 'Das richtige Wort ist:';

  @override
  String get quizResultTitle => 'Ihr Ergebnis';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'BESTANDEN';

  @override
  String get notPassed => 'NICHT BESTANDEN';

  @override
  String get passRule => 'Bestanden mit höchstens 2 Fehlern';

  @override
  String mistakesCount(int n) {
    return '$n Fehler';
  }

  @override
  String get noMistakes => 'Keine Fehler. Perfekt!';

  @override
  String get repeatMistakes => 'Fehler wiederholen';

  @override
  String get newQuiz => 'Neues Quiz';

  @override
  String bestScoreValue(int score, int total) {
    return 'Bestwert: $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'Diese Kategorie braucht mehr Wörter für ein Quiz.';

  @override
  String get topicsSubtitle => 'Nach Kategorie lernen';

  @override
  String nWords(int n) {
    return '$n Wörter';
  }

  @override
  String nLearned(int n) {
    return '$n gelernt';
  }

  @override
  String get flashcards => 'Lernkarten';

  @override
  String get quiz20 => 'Quiz 20';

  @override
  String get flashcardTapToFlip =>
      'Karte antippen, um die Übersetzung zu sehen';

  @override
  String get interfaceLanguage => 'App-Sprache';

  @override
  String get audioSpeed => 'Audiogeschwindigkeit';

  @override
  String get dailyReminder => 'Tägliche Erinnerung';

  @override
  String get reminderTime => 'Uhrzeit der Erinnerung';

  @override
  String get reminderBody => '10 neue italienische Wörter warten auf Sie.';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get resetProgress => 'Fortschritt zurücksetzen';

  @override
  String get resetProgressConfirm =>
      'Serie, Ergebnisse und gespeicherte Wörter löschen?';

  @override
  String get resetDone => 'Fortschritt zurückgesetzt';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get about => 'Über & Credits';

  @override
  String get adsConsentChange => 'Werbe-Einwilligung ändern';

  @override
  String get removeAds => 'Werbung entfernen';

  @override
  String get removeAdsBody =>
      'Eine Zahlung, nie wieder Werbung. Wörter, Themen und Quiz bleiben kostenlos.';

  @override
  String get buy => 'Kaufen';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get adsRemoved => 'Werbung entfernt. Danke!';

  @override
  String get purchasePending => 'Zahlung läuft…';

  @override
  String get purchaseError => 'Der Kauf ist nicht abgeschlossen worden.';

  @override
  String get nothingToRestore => 'Kein früherer Kauf gefunden.';

  @override
  String get webPurchaseNotice =>
      'Käufe sind in der Android- und iPhone-App verfügbar.';

  @override
  String get storeUnavailable => 'Der Store ist gerade nicht verfügbar.';

  @override
  String get voiceHelpTitle => 'Italienische Stimme installieren';

  @override
  String get voiceHelpBody =>
      'Ihr Telefon hat noch keine italienische Stimme. Öffnen Sie Einstellungen › System › Sprachen › Text-in-Sprache, wählen Sie die Google-Engine und installieren Sie Italienisch. Das Lesen der Wörter funktioniert trotzdem.';

  @override
  String get privacyBody =>
      'Diese App funktioniert offline und ohne Anmeldung. Ihr Fortschritt, Ihre gespeicherten Wörter und Einstellungen bleiben nur auf Ihrem Telefon. Wir erfassen niemals Namen, E-Mail oder Standort. Werbung kommt von Google AdMob und wird nur nach Ihrer Zustimmung im Einwilligungsformular gezeigt; Sie können Ihre Wahl in den Einstellungen jederzeit ändern. „Online suchen“ sendet nur das eingegebene Wort an das Wiktionary. Ab 13 Jahren.';

  @override
  String get aboutBody =>
      'Eine kleine, ehrliche App für Menschen, die in Italien leben: ein Wort suchen, täglich zehn neue lernen und sich wie bei der Führerscheinprüfung testen. Alles funktioniert offline, ohne Konto.';

  @override
  String get creditsBody =>
      'Übersetzungen und Beispielsätze wurden für diese App von Hand geschrieben und geprüft. Die Wortlisten wurden mit offenen Quellen abgeglichen: Wiktionary und Wikizionario (CC BY-SA 4.0), Tatoeba-Sätze (CC BY 2.0 FR) und Open Multilingual Wordnet. Die Bilder nutzen Google Noto Emoji (Apache 2.0). Die italienische Aussprache nutzt die Sprachausgabe Ihres Telefons.';

  @override
  String get dataCoverage => 'Wortliste dieser Version';

  @override
  String get mascotCheer => 'Bravo!';

  @override
  String get mascotTryAgain => 'Weiter so!';

  @override
  String get adsTestIdsNotice =>
      'Einrichtung nötig: Die Werbung nutzt noch Googles Test-IDs. Fügen Sie die echten AdMob-IDs ein, um zu verdienen.';

  @override
  String get demoBadge => 'Demo-Inhalt';

  @override
  String get topicGreetings => 'Begrüßung & Grundlagen';

  @override
  String get topicNumbers => 'Zahlen';

  @override
  String get topicColors => 'Farben';

  @override
  String get topicTime => 'Tage, Monate & Zeit';

  @override
  String get topicFamily => 'Familie';

  @override
  String get topicBody => 'Körper';

  @override
  String get topicHealth => 'Gesundheit & Arzt';

  @override
  String get topicPharmacy => 'Apotheke';

  @override
  String get topicFood => 'Essen';

  @override
  String get topicFruit => 'Obst';

  @override
  String get topicVegetables => 'Gemüse';

  @override
  String get topicDrinks => 'Getränke';

  @override
  String get topicCooking => 'Kochen';

  @override
  String get topicShopping => 'Supermarkt & Einkauf';

  @override
  String get topicMoney => 'Geld & Bank';

  @override
  String get topicHouse => 'Haus';

  @override
  String get topicKitchen => 'Küche';

  @override
  String get topicBathroom => 'Badezimmer';

  @override
  String get topicClothes => 'Kleidung & Schuhe';

  @override
  String get topicWeather => 'Wetter & Jahreszeiten';

  @override
  String get topicCity => 'Stadt & Orte';

  @override
  String get topicTransport => 'Verkehr & Wegbeschreibung';

  @override
  String get topicWork => 'Arbeit';

  @override
  String get topicJobs => 'Berufe';

  @override
  String get topicOffices => 'Behörden & Dokumente';

  @override
  String get topicSchool => 'Schule';

  @override
  String get topicAnimals => 'Tiere';

  @override
  String get topicNature => 'Natur';

  @override
  String get topicSport => 'Sport & Freizeit';

  @override
  String get topicFeelings => 'Gefühle';

  @override
  String get topicVerbs => 'Häufige Verben';

  @override
  String get topicAdjectives => 'Häufige Adjektive';

  @override
  String get topicPhrases => 'Nützliche Sätze';

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
  String get moreLanguages => 'Weitere Sprachen';

  @override
  String get languageNoteWordTranslations =>
      'Wortübersetzungen gibt es in den zehn Hauptsprachen; andere Oberflächensprachen nutzen Englisch.';

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
