// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => 'Buscar';

  @override
  String get tabToday => 'Hoje';

  @override
  String get tabQuiz => 'Quiz';

  @override
  String get tabTopics => 'Temas';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get myWords => 'Minhas palavras';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próximo';

  @override
  String get done => 'Pronto';

  @override
  String get close => 'Fechar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get listen => 'Ouvir';

  @override
  String get listenSlow => 'Lento';

  @override
  String get explanation => 'Explicação';

  @override
  String get exampleLabel => 'Exemplo';

  @override
  String get typeNoun => 'Substantivo';

  @override
  String get typeVerb => 'Verbo';

  @override
  String get typeAdjective => 'Adjetivo';

  @override
  String get typePhrase => 'Frase';

  @override
  String get searchHint => 'Italiano, inglês, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    final intl.NumberFormat wordsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String wordsString = wordsNumberFormat.format(words);
    final intl.NumberFormat phrasesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String phrasesString = phrasesNumberFormat.format(phrases);

    return '$wordsString palavras · $phrasesString frases';
  }

  @override
  String wordsAndPhrasesTotal(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString palavras e frases';
  }

  @override
  String get recentSearches => 'Buscas recentes';

  @override
  String get clearRecent => 'Limpar';

  @override
  String get noResults => 'Nenhuma palavra encontrada';

  @override
  String get didYouMean => 'Você quis dizer…?';

  @override
  String get searchOnline => 'Pesquisar online';

  @override
  String get searchingOnline => 'Pesquisando online…';

  @override
  String get offlineNotice =>
      'Você está offline. Todas as palavras do app continuam funcionando.';

  @override
  String get onlineResultTitle => 'Do Wikcionário';

  @override
  String get addToMyWords => 'Adicionar às minhas palavras';

  @override
  String get removeFromMyWords => 'Remover das minhas palavras';

  @override
  String get myWordsEmpty =>
      'Ainda não há palavras salvas. Use “Adicionar às minhas palavras” na Busca.';

  @override
  String get quizOnMyWords => 'Quiz das minhas palavras';

  @override
  String get todayTitle => 'As palavras de hoje';

  @override
  String todayProgress(int n, int total) {
    return 'Palavra $n de $total';
  }

  @override
  String streakDays(int n) {
    return '$n dias seguidos';
  }

  @override
  String get miniQuizCta => 'Mini-quiz das palavras de hoje';

  @override
  String get learnedToday => 'Visto hoje';

  @override
  String get todayDone => 'Você viu as 10 palavras. Volte amanhã!';

  @override
  String get quizPickCategory => 'Escolha uma categoria';

  @override
  String get mixOfAll => 'Mistura de tudo';

  @override
  String quizProgress(int n, int total) {
    return 'Pergunta $n de $total';
  }

  @override
  String get quizQuestionPrompt => 'A palavra combina com a imagem?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'verdadeiro';

  @override
  String get falsoHint => 'falso';

  @override
  String get answerCorrect => 'Correto!';

  @override
  String get answerWrong => 'Errado';

  @override
  String get correctAnswerIs => 'A palavra certa é:';

  @override
  String get quizResultTitle => 'Seu resultado';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'APROVADO';

  @override
  String get notPassed => 'NÃO APROVADO';

  @override
  String get passRule => 'Aprova com no máximo 2 erros';

  @override
  String mistakesCount(int n) {
    return '$n erros';
  }

  @override
  String get noMistakes => 'Sem erros. Perfeito!';

  @override
  String get repeatMistakes => 'Repetir os erros';

  @override
  String get newQuiz => 'Novo quiz';

  @override
  String bestScoreValue(int score, int total) {
    return 'Melhor: $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'Esta categoria precisa de mais palavras para o quiz.';

  @override
  String get topicsSubtitle => 'Aprenda por categoria';

  @override
  String nWords(int n) {
    return '$n palavras';
  }

  @override
  String nLearned(int n) {
    return '$n aprendidas';
  }

  @override
  String get flashcards => 'Cartões';

  @override
  String get quiz20 => 'Quiz 20';

  @override
  String get flashcardTapToFlip => 'Toque no cartão para ver a tradução';

  @override
  String get interfaceLanguage => 'Idioma do app';

  @override
  String get audioSpeed => 'Velocidade do áudio';

  @override
  String get dailyReminder => 'Lembrete diário';

  @override
  String get reminderTime => 'Hora do lembrete';

  @override
  String get reminderBody => '10 novas palavras italianas esperam por você.';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get resetProgress => 'Apagar progresso';

  @override
  String get resetProgressConfirm =>
      'Apagar sequência, pontuações e palavras salvas?';

  @override
  String get resetDone => 'Progresso apagado';

  @override
  String get privacy => 'Privacidade';

  @override
  String get about => 'Sobre e créditos';

  @override
  String get adsConsentChange => 'Alterar consentimento de anúncios';

  @override
  String get removeAds => 'Remover anúncios';

  @override
  String get removeAdsBody =>
      'Um único pagamento, nunca mais anúncios. Palavras, temas e quizzes continuam grátis.';

  @override
  String get buy => 'Comprar';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get adsRemoved => 'Anúncios removidos. Obrigado!';

  @override
  String get purchasePending => 'Pagamento em andamento…';

  @override
  String get purchaseError => 'A compra não foi concluída.';

  @override
  String get nothingToRestore => 'Nenhuma compra anterior encontrada.';

  @override
  String get webPurchaseNotice =>
      'As compras estão disponíveis no app Android e iPhone.';

  @override
  String get storeUnavailable => 'A loja não está disponível agora.';

  @override
  String get voiceHelpTitle => 'Instale a voz italiana';

  @override
  String get voiceHelpBody =>
      'Seu telefone ainda não tem voz italiana. Abra Configurações › Sistema › Idiomas › Conversão de texto em voz, escolha o mecanismo do Google e instale o italiano. Ler as palavras funciona do mesmo jeito.';

  @override
  String get privacyBody =>
      'Este app funciona offline e não pede login. Seu progresso, palavras salvas e configurações ficam apenas no seu telefone. Nunca coletamos seu nome, e-mail ou localização. Os anúncios vêm do Google AdMob e só aparecem depois de você aceitar no formulário de consentimento; pode mudar a escolha nas Configurações. “Pesquisar online” envia ao Wikcionário apenas a palavra digitada. Para 13+.';

  @override
  String get aboutBody =>
      'Um app pequeno e honesto para quem vive na Itália: busque uma palavra, aprenda dez novas por dia e teste-se como na prova de direção. Tudo funciona offline, sem conta.';

  @override
  String get creditsBody =>
      'As traduções e as frases de exemplo são escritas e revisadas à mão para este app. As listas de palavras foram comparadas com fontes abertas: Wiktionary e Wikizionario (CC BY-SA 4.0), frases do Tatoeba (CC BY 2.0 FR) e Open Multilingual Wordnet. As imagens usam Google Noto Emoji (Apache 2.0). A pronúncia italiana usa a conversão de texto em voz do telefone.';

  @override
  String get dataCoverage => 'Lista de palavras desta versão';

  @override
  String get mascotCheer => 'Bravo!';

  @override
  String get mascotTryAgain => 'Continue!';

  @override
  String get adsTestIdsNotice =>
      'Configuração necessária: os anúncios ainda usam os ids de teste do Google. Cole os ids reais do AdMob para ganhar.';

  @override
  String get demoBadge => 'Conteúdo de demonstração';

  @override
  String get topicGreetings => 'Saudações e básicos';

  @override
  String get topicNumbers => 'Números';

  @override
  String get topicColors => 'Cores';

  @override
  String get topicTime => 'Dias, meses e horas';

  @override
  String get topicFamily => 'Família';

  @override
  String get topicBody => 'Corpo';

  @override
  String get topicHealth => 'Saúde e médico';

  @override
  String get topicPharmacy => 'Farmácia';

  @override
  String get topicFood => 'Comida';

  @override
  String get topicFruit => 'Frutas';

  @override
  String get topicVegetables => 'Legumes';

  @override
  String get topicDrinks => 'Bebidas';

  @override
  String get topicCooking => 'Cozinhar';

  @override
  String get topicShopping => 'Supermercado e compras';

  @override
  String get topicMoney => 'Dinheiro e banco';

  @override
  String get topicHouse => 'Casa';

  @override
  String get topicKitchen => 'Cozinha';

  @override
  String get topicBathroom => 'Banheiro';

  @override
  String get topicClothes => 'Roupas e sapatos';

  @override
  String get topicWeather => 'Tempo e estações';

  @override
  String get topicCity => 'Cidade e lugares';

  @override
  String get topicTransport => 'Transporte e direções';

  @override
  String get topicWork => 'Trabalho';

  @override
  String get topicJobs => 'Profissões';

  @override
  String get topicOffices => 'Repartições e documentos';

  @override
  String get topicSchool => 'Escola';

  @override
  String get topicAnimals => 'Animais';

  @override
  String get topicNature => 'Natureza';

  @override
  String get topicSport => 'Esporte e tempo livre';

  @override
  String get topicFeelings => 'Sentimentos';

  @override
  String get topicVerbs => 'Verbos comuns';

  @override
  String get topicAdjectives => 'Adjetivos comuns';

  @override
  String get topicPhrases => 'Frases úteis';

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
  String get moreLanguages => 'Mais idiomas';

  @override
  String get languageNoteWordTranslations =>
      'As traduções das palavras estão nos dez idiomas principais; os outros idiomas da interface usam inglês.';

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
