// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Italiano Facile per Stranieri';

  @override
  String get tabSearch => '搜索';

  @override
  String get tabToday => '今天';

  @override
  String get tabQuiz => '测验';

  @override
  String get tabTopics => '主题';

  @override
  String get settingsTitle => '设置';

  @override
  String get myWords => '我的单词';

  @override
  String get back => '返回';

  @override
  String get next => '下一个';

  @override
  String get done => '完成';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get retry => '重试';

  @override
  String get listen => '朗读';

  @override
  String get listenSlow => '慢速';

  @override
  String get explanation => '解释';

  @override
  String get exampleLabel => '例句';

  @override
  String get typeNoun => '名词';

  @override
  String get typeVerb => '动词';

  @override
  String get typeAdjective => '形容词';

  @override
  String get typePhrase => '短语';

  @override
  String get searchHint => '意大利语、英语、اردو、বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words 个单词 · $phrases 个短语';
  }

  @override
  String get recentSearches => '最近的搜索';

  @override
  String get clearRecent => '清除';

  @override
  String get noResults => '未找到单词';

  @override
  String get didYouMean => '您是不是想找…？';

  @override
  String get searchOnline => '在线搜索';

  @override
  String get searchingOnline => '正在在线搜索…';

  @override
  String get offlineNotice => '你处于离线状态。应用内的所有单词仍可使用。';

  @override
  String get onlineResultTitle => '来自维基词典';

  @override
  String get addToMyWords => '添加到我的单词';

  @override
  String get removeFromMyWords => '从我的单词中移除';

  @override
  String get myWordsEmpty => '还没有收藏的单词。请在“搜索”中点“添加到我的单词”。';

  @override
  String get quizOnMyWords => '我的单词测验';

  @override
  String get todayTitle => '今天的单词';

  @override
  String todayProgress(int n, int total) {
    return '第 $n / $total 个单词';
  }

  @override
  String streakDays(int n) {
    return '连续 $n 天';
  }

  @override
  String get miniQuizCta => '今天单词的小测验';

  @override
  String get learnedToday => '今天已看';

  @override
  String get todayDone => '10 个单词都看完了，明天再来！';

  @override
  String get quizPickCategory => '选择一个类别';

  @override
  String get mixOfAll => '全部混合';

  @override
  String quizProgress(int n, int total) {
    return '第 $n / $total 题';
  }

  @override
  String get quizQuestionPrompt => '这个单词和图片相符吗？';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => '正确';

  @override
  String get falsoHint => '错误';

  @override
  String get answerCorrect => '正确！';

  @override
  String get answerWrong => '错误';

  @override
  String get correctAnswerIs => '正确的单词是：';

  @override
  String get quizResultTitle => '你的成绩';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => '通过';

  @override
  String get notPassed => '未通过';

  @override
  String get passRule => '错 2 题以内算通过';

  @override
  String mistakesCount(int n) {
    return '错 $n 题';
  }

  @override
  String get noMistakes => '全对，太棒了！';

  @override
  String get repeatMistakes => '重做错题';

  @override
  String get newQuiz => '新测验';

  @override
  String bestScoreValue(int score, int total) {
    return '最佳：$score/$total';
  }

  @override
  String get quizNotEnoughWords => '该类别的单词数量不足，无法测验。';

  @override
  String get topicsSubtitle => '按类别学习';

  @override
  String nWords(int n) {
    return '$n 个单词';
  }

  @override
  String nLearned(int n) {
    return '已掌握 $n 个';
  }

  @override
  String get flashcards => '单词卡';

  @override
  String get quiz20 => '20 题测验';

  @override
  String get flashcardTapToFlip => '点击卡片查看翻译';

  @override
  String get interfaceLanguage => '界面语言';

  @override
  String get audioSpeed => '朗读速度';

  @override
  String get dailyReminder => '每日提醒';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get reminderBody => '10 个新的意大利语单词在等你。';

  @override
  String get darkMode => '深色模式';

  @override
  String get resetProgress => '重置进度';

  @override
  String get resetProgressConfirm => '要删除连续天数、成绩和收藏的单词吗？';

  @override
  String get resetDone => '进度已重置';

  @override
  String get privacy => '隐私';

  @override
  String get about => '关于与致谢';

  @override
  String get adsConsentChange => '更改广告授权';

  @override
  String get removeAds => '去除广告';

  @override
  String get removeAdsBody => '一次付费，永久无广告。所有单词、主题和测验依旧免费。';

  @override
  String get buy => '购买';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get adsRemoved => '广告已去除，谢谢！';

  @override
  String get purchasePending => '支付进行中…';

  @override
  String get purchaseError => '购买未完成。';

  @override
  String get nothingToRestore => '未找到以往的购买记录。';

  @override
  String get webPurchaseNotice => '购买功能在 Android 和 iPhone 应用中提供。';

  @override
  String get storeUnavailable => '商店当前不可用。';

  @override
  String get voiceHelpTitle => '安装意大利语语音';

  @override
  String get voiceHelpBody => '你的手机还没有意大利语语音。打开 设置 › 系统 › 语言 › 文字转语音，选择 Google 引擎并安装意大利语。阅读单词仍然可用。';

  @override
  String get privacyBody => '本应用可离线使用，无需登录。你的学习进度、收藏单词和设置只保存在手机本地。我们绝不收集你的姓名、邮箱或位置。广告来自 Google AdMob，只有在你于授权表单中同意后才会显示；你可以随时在设置中更改选择。“在线搜索”仅把你输入的单词发送给维基词典。适合 13 岁以上。';

  @override
  String get aboutBody => '一款为在意大利生活的人做的小而实在的应用：查一个词，每天学十个新词，并像考驾照那样自测。全部离线可用，无需账号。';

  @override
  String get creditsBody => '本应用的翻译与例句均由人工撰写并校对。词表与开放来源逐条核对：Wiktionary 与 Wikizionario（CC BY-SA 4.0）、Tatoeba 例句（CC BY 2.0 FR）以及 Open Multilingual Wordnet。图片使用 Google Noto Emoji（Apache 2.0）。意大利语发音使用手机自带的文字转语音。';

  @override
  String get dataCoverage => '本版本的词表';

  @override
  String get mascotCheer => '太棒了！';

  @override
  String get mascotTryAgain => '继续加油！';

  @override
  String get adsTestIdsNotice => '需要设置：广告仍在使用 Google 的测试 ID。请填入真实的 AdMob ID 才能获得收入。';

  @override
  String get demoBadge => '演示内容';

  @override
  String get topicGreetings => '问候与基础';

  @override
  String get topicNumbers => '数字';

  @override
  String get topicColors => '颜色';

  @override
  String get topicTime => '日期与时间';

  @override
  String get topicFamily => '家庭';

  @override
  String get topicBody => '身体';

  @override
  String get topicHealth => '健康与就医';

  @override
  String get topicPharmacy => '药店';

  @override
  String get topicFood => '食物';

  @override
  String get topicFruit => '水果';

  @override
  String get topicVegetables => '蔬菜';

  @override
  String get topicDrinks => '饮料';

  @override
  String get topicCooking => '烹饪';

  @override
  String get topicShopping => '超市与购物';

  @override
  String get topicMoney => '金钱与银行';

  @override
  String get topicHouse => '家';

  @override
  String get topicKitchen => '厨房';

  @override
  String get topicBathroom => '浴室';

  @override
  String get topicClothes => '衣服与鞋';

  @override
  String get topicWeather => '天气与季节';

  @override
  String get topicCity => '城市与地点';

  @override
  String get topicTransport => '交通与问路';

  @override
  String get topicWork => '工作';

  @override
  String get topicJobs => '职业';

  @override
  String get topicOffices => '政府机构与证件';

  @override
  String get topicSchool => '学校';

  @override
  String get topicAnimals => '动物';

  @override
  String get topicNature => '自然';

  @override
  String get topicSport => '运动与休闲';

  @override
  String get topicFeelings => '情绪';

  @override
  String get topicVerbs => '常用动词';

  @override
  String get topicAdjectives => '常用形容词';

  @override
  String get topicPhrases => '实用短语';

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
  String get moreLanguages => '更多语言';

  @override
  String get languageNoteWordTranslations => '单词翻译提供十种主要语言；其他界面语言将回退为英语。';

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
  String get bigDictCredits => 'The big dictionary of Italian words (over 100,000 words when complete) comes from Wiktionary, through kaikki.org, under the CC BY-SA 4.0 licence. The meanings in the ten languages were prepared for this app from the Wiktionary definitions.';

  @override
  String get bigSearchingOnline => 'Searching online…';

  @override
  String get bigNotAllowed => 'This word cannot be added to the dictionary.';

  @override
  String get bigNotFoundOnline => 'Not found online either: check how you wrote it.';
}
