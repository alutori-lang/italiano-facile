// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Italian Words: Learn & Play';

  @override
  String get tabSearch => 'Поиск';

  @override
  String get tabToday => 'Сегодня';

  @override
  String get tabQuiz => 'Тест';

  @override
  String get tabTopics => 'Темы';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get myWords => 'Мои слова';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get done => 'Готово';

  @override
  String get close => 'Закрыть';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get retry => 'Повторить';

  @override
  String get listen => 'Слушать';

  @override
  String get listenSlow => 'Медленно';

  @override
  String get explanation => 'Объяснение';

  @override
  String get exampleLabel => 'Пример';

  @override
  String get typeNoun => 'Существительное';

  @override
  String get typeVerb => 'Глагол';

  @override
  String get typeAdjective => 'Прилагательное';

  @override
  String get typePhrase => 'Фраза';

  @override
  String get searchHint => 'Итальянский, английский, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words слов · $phrases фраз';
  }

  @override
  String get recentSearches => 'Недавние запросы';

  @override
  String get clearRecent => 'Очистить';

  @override
  String get noResults => 'Слово не найдено';

  @override
  String get didYouMean => 'Возможно, вы имели в виду…?';

  @override
  String get searchOnline => 'Искать в интернете';

  @override
  String get searchingOnline => 'Поиск в интернете…';

  @override
  String get offlineNotice =>
      'Вы не в сети. Все слова в приложении по-прежнему работают.';

  @override
  String get onlineResultTitle => 'Из Викисловаря';

  @override
  String get addToMyWords => 'Добавить в мои слова';

  @override
  String get removeFromMyWords => 'Убрать из моих слов';

  @override
  String get myWordsEmpty =>
      'Пока нет сохранённых слов. Нажмите «Добавить в мои слова» в поиске.';

  @override
  String get quizOnMyWords => 'Тест по моим словам';

  @override
  String get todayTitle => 'Слова дня';

  @override
  String todayProgress(int n, int total) {
    return 'Слово $n из $total';
  }

  @override
  String streakDays(int n) {
    return '$n дней подряд';
  }

  @override
  String get miniQuizCta => 'Мини-тест по словам дня';

  @override
  String get learnedToday => 'Просмотрено сегодня';

  @override
  String get todayDone => 'Все 10 слов просмотрены. Возвращайтесь завтра!';

  @override
  String get quizPickCategory => 'Выберите категорию';

  @override
  String get mixOfAll => 'Всё вместе';

  @override
  String quizProgress(int n, int total) {
    return 'Вопрос $n из $total';
  }

  @override
  String get quizQuestionPrompt => 'Слово соответствует картинке?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'верно';

  @override
  String get falsoHint => 'неверно';

  @override
  String get answerCorrect => 'Верно!';

  @override
  String get answerWrong => 'Неверно';

  @override
  String get correctAnswerIs => 'Правильное слово:';

  @override
  String get quizResultTitle => 'Ваш результат';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'СДАНО';

  @override
  String get notPassed => 'НЕ СДАНО';

  @override
  String get passRule => 'Сдано при 2 ошибках или меньше';

  @override
  String mistakesCount(int n) {
    return '$n ошибок';
  }

  @override
  String get noMistakes => 'Без ошибок. Отлично!';

  @override
  String get repeatMistakes => 'Повторить ошибки';

  @override
  String get newQuiz => 'Новый тест';

  @override
  String bestScoreValue(int score, int total) {
    return 'Лучший: $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'Для теста в этой категории нужно больше слов.';

  @override
  String get topicsSubtitle => 'Учитесь по категориям';

  @override
  String nWords(int n) {
    return '$n слов';
  }

  @override
  String nLearned(int n) {
    return '$n изучено';
  }

  @override
  String get flashcards => 'Карточки';

  @override
  String get quiz20 => 'Тест 20';

  @override
  String get flashcardTapToFlip => 'Нажмите карточку, чтобы увидеть перевод';

  @override
  String get interfaceLanguage => 'Язык приложения';

  @override
  String get audioSpeed => 'Скорость речи';

  @override
  String get dailyReminder => 'Ежедневное напоминание';

  @override
  String get reminderTime => 'Время напоминания';

  @override
  String get reminderBody => 'Вас ждут 10 новых итальянских слов.';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get resetProgress => 'Сбросить прогресс';

  @override
  String get resetProgressConfirm =>
      'Удалить серию, результаты и сохранённые слова?';

  @override
  String get resetDone => 'Прогресс сброшен';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get about => 'О приложении';

  @override
  String get adsConsentChange => 'Изменить согласие на рекламу';

  @override
  String get removeAds => 'Убрать рекламу';

  @override
  String get removeAdsBody =>
      'Один платёж — и больше никакой рекламы. Все слова, темы и тесты остаются бесплатными.';

  @override
  String get buy => 'Купить';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get adsRemoved => 'Реклама убрана. Спасибо!';

  @override
  String get purchasePending => 'Платёж обрабатывается…';

  @override
  String get purchaseError => 'Покупка не прошла.';

  @override
  String get nothingToRestore => 'Прежних покупок не найдено.';

  @override
  String get webPurchaseNotice =>
      'Покупки доступны в приложении для Android и iPhone.';

  @override
  String get storeUnavailable => 'Магазин сейчас недоступен.';

  @override
  String get voiceHelpTitle => 'Установите итальянский голос';

  @override
  String get voiceHelpBody =>
      'На телефоне ещё нет итальянского голоса. Откройте Настройки › Система › Языки › Синтез речи, выберите движок Google и установите итальянский. Читать слова можно и так.';

  @override
  String get privacyBody =>
      'Приложение работает без интернета и без входа в аккаунт. Прогресс, сохранённые слова и настройки остаются только на вашем телефоне. Мы никогда не собираем имя, e-mail или местоположение. Реклама — от Google AdMob и показывается только после вашего согласия в форме; изменить выбор можно в настройках. «Искать в интернете» отправляет в Викисловарь только введённое слово. Для 13+.';

  @override
  String get aboutBody =>
      'Небольшое честное приложение для тех, кто живёт в Италии: найдите слово, выучите десять новых каждый день и проверьте себя, как на экзамене по вождению. Всё работает без интернета и без аккаунта.';

  @override
  String get creditsBody =>
      'Переводы и примеры предложений написаны и проверены вручную для этого приложения. Списки слов сверялись с открытыми источниками: Wiktionary и Wikizionario (CC BY-SA 4.0), предложения Tatoeba (CC BY 2.0 FR) и Open Multilingual Wordnet. Картинки — Google Noto Emoji (Apache 2.0). Итальянское произношение использует синтез речи телефона.';

  @override
  String get dataCoverage => 'Список слов в этой версии';

  @override
  String get mascotCheer => 'Молодец!';

  @override
  String get mascotTryAgain => 'Продолжайте!';

  @override
  String get adsTestIdsNotice =>
      'Нужна настройка: реклама пока использует тестовые id Google. Вставьте настоящие id AdMob, чтобы получать доход.';

  @override
  String get demoBadge => 'Демо-содержимое';

  @override
  String get topicGreetings => 'Приветствия и основы';

  @override
  String get topicNumbers => 'Числа';

  @override
  String get topicColors => 'Цвета';

  @override
  String get topicTime => 'Дни, месяцы и время';

  @override
  String get topicFamily => 'Семья';

  @override
  String get topicBody => 'Тело';

  @override
  String get topicHealth => 'Здоровье и врач';

  @override
  String get topicPharmacy => 'Аптека';

  @override
  String get topicFood => 'Еда';

  @override
  String get topicFruit => 'Фрукты';

  @override
  String get topicVegetables => 'Овощи';

  @override
  String get topicDrinks => 'Напитки';

  @override
  String get topicCooking => 'Готовка';

  @override
  String get topicShopping => 'Супермаркет и покупки';

  @override
  String get topicMoney => 'Деньги и банк';

  @override
  String get topicHouse => 'Дом';

  @override
  String get topicKitchen => 'Кухня';

  @override
  String get topicBathroom => 'Ванная';

  @override
  String get topicClothes => 'Одежда и обувь';

  @override
  String get topicWeather => 'Погода и времена года';

  @override
  String get topicCity => 'Город и места';

  @override
  String get topicTransport => 'Транспорт и направления';

  @override
  String get topicWork => 'Работа';

  @override
  String get topicJobs => 'Профессии';

  @override
  String get topicOffices => 'Учреждения и документы';

  @override
  String get topicSchool => 'Школа';

  @override
  String get topicAnimals => 'Животные';

  @override
  String get topicNature => 'Природа';

  @override
  String get topicSport => 'Спорт и отдых';

  @override
  String get topicFeelings => 'Чувства';

  @override
  String get topicVerbs => 'Частые глаголы';

  @override
  String get topicAdjectives => 'Частые прилагательные';

  @override
  String get topicPhrases => 'Полезные фразы';

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
  String get moreLanguages => 'Другие языки';

  @override
  String get languageNoteWordTranslations =>
      'Переводы слов доступны на десяти основных языках; остальные языки интерфейса используют английский.';

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
