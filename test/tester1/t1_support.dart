// Tester 1 helpers: "every button and every screen".
//
// Owned by Tester 1. The builder does not edit this folder.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_app_651/data/word_repository.dart';
import 'package:simple_flutter_app_651/l10n/app_localizations.dart';
import 'package:simple_flutter_app_651/models/learner_language.dart';
import 'package:simple_flutter_app_651/models/word.dart';
import 'package:simple_flutter_app_651/screens/voice_help_screen.dart';
import 'package:simple_flutter_app_651/services/settings_controller.dart';

import '../support/pump_app.dart';

export '../support/pump_app.dart';

/// One phone + theme combination every screen is checked on.
class T1Config {
  const T1Config(this.name, this.size, this.dark);
  final String name;
  final Size size;
  final bool dark;
  @override
  String toString() => name;
}

const Size kSmallPhone = Size(360, 640);
const Size kBigPhone = Size(430, 932);

const List<T1Config> kConfigs = <T1Config>[
  T1Config('360x640 light', kSmallPhone, false),
  T1Config('360x640 dark', kSmallPhone, true),
  T1Config('430x932 light', kBigPhone, false),
  T1Config('430x932 dark', kBigPhone, true),
];

/// The interface is always Italian.
final AppLocalizations it = lookupAppLocalizations(const Locale('it'));

/// The interface locale that stands for a translation language (same order).
Locale localeFor(LearnerLanguage lang) => AppLocales.primary[lang.index];

String tagFor(LearnerLanguage lang) => AppLocales.tag(localeFor(lang));

int builtInWordCount = 0;
bool jsonDictionaryLoaded = false;

/// Loads assets/dict/words.json the same way main() does, so topics have
/// their real words. Call from setUpAll.
Future<void> loadDictionary() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  builtInWordCount = WordRepository.instance.all.length;
  await WordRepository.load();
  jsonDictionaryLoaded = WordRepository.instance.all.length > builtInWordCount;
}

/// Starts the real app. [lang] null means first launch (no language chosen).
Future<TestHarness> startApp(
  WidgetTester tester,
  T1Config config, {
  LearnerLanguage? lang = LearnerLanguage.english,
  Map<String, Object> prefs = const <String, Object>{},
}) {
  return pumpApp(
    tester,
    size: config.size,
    locale: lang == null ? null : localeFor(lang),
    initialPrefs: <String, Object>{
      if (config.dark) 'dark_mode': true,
      ...prefs,
    },
  );
}

Finder byKey(String key) => find.byKey(ValueKey<String>(key));

/// Fails on any exception / overflow reported so far.
void expectClean(WidgetTester tester, String where) {
  final Object? error = tester.takeException();
  expect(error, isNull, reason: 'exception/overflow at: $where -> $error');
}

/// The screen of [type] is up and shows at least one piece of text.
void expectScreen(Type type, {String? why}) {
  expect(find.byType(type), findsOneWidget,
      reason: why ?? '$type did not open (dead button?)');
  expect(
    find.descendant(of: find.byType(type), matching: find.byType(Text)),
    findsWidgets,
    reason: '$type is empty',
  );
}

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(byKey(key));
  await tester.pumpAndSettle();
}

/// Real tap on the AppBar back arrow.
Future<void> backArrow(WidgetTester tester) async {
  expect(find.byType(BackButton), findsWidgets, reason: 'no back arrow');
  await tester.tap(find.byType(BackButton).last);
  await tester.pumpAndSettle();
}

/// Recorded calls to the text-to-speech plugin channel.
final List<MethodCall> ttsCalls = <MethodCall>[];

/// Whether the fake phone has an Italian TTS voice.
bool ttsHasItalian = true;

/// Fakes the flutter_tts plugin so the speaker buttons can be checked:
/// call from setUp.
void installTtsMock({bool hasItalian = true}) {
  ttsHasItalian = hasItalian;
  ttsCalls.clear();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('flutter_tts'),
          (MethodCall call) async {
    ttsCalls.add(call);
    if (call.method == 'isLanguageAvailable') return ttsHasItalian;
    return 1;
  });
}

List<String> get spokenTexts => ttsCalls
    .where((MethodCall c) => c.method == 'speak')
    .map((MethodCall c) => c.arguments is Map
        ? (c.arguments as Map<dynamic, dynamic>)['text'] as String
        : c.arguments as String)
    .toList();

/// Taps a speaker and checks Italian TTS really spoke [expectText] (the text
/// is read from the speaker's key when omitted), at slow rate for slow ones.
Future<void> tapSpeaker(WidgetTester tester, Finder speaker,
    {String? expectText}) async {
  expect(speaker, findsWidgets, reason: 'speaker button missing');
  final Widget w = tester.widget(speaker.first);
  final String key = w.key is ValueKey<String>
      ? (w.key! as ValueKey<String>).value
      : '';
  final bool slow = key.startsWith('audio-slow:');
  final String text = expectText ?? key.substring(key.indexOf(':') + 1);
  ttsCalls.clear();
  await tester.ensureVisible(speaker.first);
  await tester.pumpAndSettle();
  await tester.tap(speaker.first);
  await tester.pumpAndSettle();
  expect(spokenTexts, contains(text),
      reason: 'speaker "$key" did not speak "$text" (dead button?)');
  final List<double> rates = ttsCalls
      .where((MethodCall c) => c.method == 'setSpeechRate')
      .map((MethodCall c) => (c.arguments as num).toDouble())
      .toList();
  if (slow) {
    expect(rates, contains(0.25), reason: 'slow speaker not slow');
  }
  if (!ttsHasItalian) {
    expect(find.byType(VoiceHelpScreen), findsOneWidget,
        reason: 'no Italian voice but no install guide');
    await tapKey(tester, 'voice-help-close');
    expect(find.byType(VoiceHelpScreen), findsNothing,
        reason: 'voice-help close button did nothing');
  } else {
    expect(find.byType(VoiceHelpScreen), findsNothing);
  }
}

String _keyValue(Widget w) => (w.key! as ValueKey<String>).value;

Finder keyPrefix(String prefix) => find.byWidgetPredicate(
      (Widget w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith(prefix),
    );

/// Answers the question on screen, right or wrong on purpose, checks the
/// feedback and taps Next/Done.
Future<void> answerQuestion(
  WidgetTester tester, {
  required bool correctly,
  LearnerLanguage lang = LearnerLanguage.english,
}) async {
  final String pictureId =
      _keyValue(tester.widget(keyPrefix('quiz-picture:'))).substring(13);
  final String shown =
      _keyValue(tester.widget(keyPrefix('audio:').first)).substring(6);
  final bool isTrue = pictureId == shown;
  final bool sayTrue = correctly ? isTrue : !isTrue;
  await tester.tap(byKey(sayTrue ? 'answer-vero' : 'answer-falso'));
  await tester.pumpAndSettle();
  expect(byKey('quiz-feedback'), findsOneWidget,
      reason: 'answer button did nothing');
  if (correctly) {
    expect(find.text(it.answerCorrect), findsOneWidget);
  } else {
    expect(find.text(it.answerWrong), findsOneWidget);
    expect(find.text(it.correctAnswerIs), findsOneWidget);
    final Word right = WordRepository.instance.byId(pictureId)!;
    expect(find.text(right.translation(lang)), findsWidgets,
        reason: 'wrong answer must show the right word translated');
  }
  await tester.tap(byKey('quiz-next'));
  await tester.pumpAndSettle();
}

/// Answers a whole quiz of [count] questions with [wrong] mistakes first.
Future<void> playQuiz(
  WidgetTester tester, {
  required int count,
  int wrong = 0,
  LearnerLanguage lang = LearnerLanguage.english,
}) async {
  for (int i = 0; i < count; i++) {
    expect(find.text(it.quizProgress(i + 1, count)), findsOneWidget,
        reason: 'question ${i + 1}/$count not shown');
    await answerQuestion(tester, correctly: i >= wrong, lang: lang);
    expectClean(tester, 'quiz question ${i + 1}');
  }
}

/// Scrolls the vertical list of [screen] until [finder] is built, then makes
/// it really visible.
Future<void> scrollTo(WidgetTester tester, Type screen, Finder finder,
    {double delta = 250}) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: find
          .descendant(
            of: find.byType(screen),
            matching: find.byWidgetPredicate((Widget w) =>
                w is Scrollable && w.axisDirection == AxisDirection.down),
          )
          .first,
    );
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
}

/// Lets real (non-fake) async work finish — plugin channel replies — then
/// settles the frames.
Future<void> settleReal(WidgetTester tester) async {
  for (int i = 0; i < 10; i++) {
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
  }
}

/// True when [finder] is inside the visible screen area.
bool onScreen(WidgetTester tester, Finder finder) {
  if (finder.evaluate().isEmpty) return false;
  final Rect r = tester.getRect(finder.first);
  final Size s = tester.view.physicalSize / tester.view.devicePixelRatio;
  return r.bottom > 0 && r.top < s.height && r.right > 0 && r.left < s.width;
}
