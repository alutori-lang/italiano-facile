import 'dart:math';

import 'package:flutter/material.dart';

import '../config/screenshot_screens.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/word.dart';
import '../services/quiz_service.dart';
import 'home_shell.dart';
import 'quiz_play_screen.dart';
import 'quiz_result_screen.dart';
import 'settings_screen.dart';
import 'today_screen.dart';

/// Opens one representative screen directly, filled with realistic demo
/// content, for the web build with ?ember_screen=N. Splash, onboarding and
/// any "configuration needed" notice are skipped. Normal launches never come
/// through here.
class ScreenshotHost extends StatelessWidget {
  const ScreenshotHost({super.key, required this.screen});

  final ScreenshotScreen screen;

  static List<Word> _demoWords(int count) {
    final List<Word> all = WordRepository.instance.all;
    const List<String> preferred = <String>[
      'il pomodoro',
      'la fermata dell\'autobus',
      'parlare',
      'le scarpe',
      'il permesso di soggiorno',
      'la banana',
      'il medico',
      'andare',
      'lo zucchero',
      'Quanto costa?',
    ];
    final List<Word> picked = <Word>[];
    for (final String id in preferred) {
      final Word? word = WordRepository.instance.byId(id);
      if (word != null) picked.add(word);
    }
    for (final Word word in all) {
      if (picked.length >= count) break;
      if (!picked.contains(word)) picked.add(word);
    }
    return picked.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    switch (screen) {
      case ScreenshotScreen.search:
        return const HomeShell();
      case ScreenshotScreen.today:
        return Scaffold(body: TodayScreen(demoWords: _demoWords(10)));
      case ScreenshotScreen.quizQuestion:
        return QuizPlayScreen(
          pool: WordRepository.instance.byTopic('fruit'),
          categoryId: 'fruit',
          categoryLabel: t.topicFruit,
          random: Random(7),
        );
      case ScreenshotScreen.quizResult:
        final List<Word> fruit = WordRepository.instance.byTopic('fruit');
        final List<QuizQuestion> questions =
            const QuizService().build(fruit, random: Random(3));
        final List<bool> answers = <bool>[
          for (int i = 0; i < questions.length; i++)
            // One deliberate mistake, so the result shows the PASSED state
            // together with a short mistake list.
            i == 4 ? !questions[i].isTrue : questions[i].isTrue,
        ];
        return QuizResultScreen(
          result: const QuizService().score(questions, answers),
          pool: fruit,
          categoryId: 'fruit',
          categoryLabel: t.topicFruit,
        );
      case ScreenshotScreen.topics:
        return const HomeShell(initialTab: 3);
      case ScreenshotScreen.settings:
        return const SettingsScreen();
    }
  }
}
