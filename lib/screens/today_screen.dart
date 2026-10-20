import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/word.dart';
import '../services/daily_words_service.dart';
import '../services/progress_service.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/screen_header.dart';
import '../ui/widgets/word_card.dart';
import 'quiz_play_screen.dart';
import 'settings_screen.dart';

/// Ten words a day, different for every user, swiped one card at a time.
class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key, this.demoWords});

  /// Used by screenshot mode so the screen can be shown already filled.
  final List<Word>? demoWords;

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  static const DailyWordsService _daily = DailyWordsService();

  final PageController _pages = PageController();
  List<Word> _words = const <Word>[];
  int _index = 0;
  bool _prepared = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_prepared) {
      _prepared = true;
      _prepare();
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _prepare() async {
    if (widget.demoWords != null) {
      setState(() => _words = widget.demoWords!);
      return;
    }
    final ProgressService progress = AppScope.of(context).progress;
    final DateTime now = DateTime.now();
    final String day = ProgressService.dayKey(now);

    List<Word> words =
        WordRepository.instance.byIds(progress.todayIdsFor(day));
    if (words.length < DailyWordsService.wordsPerDay) {
      words = _daily.pick(
        all: WordRepository.instance.all,
        seen: progress.seenWordIds,
        personalId: progress.personalId,
        dayKey: day,
      );
      await progress.storeToday(
        day,
        words.map((Word w) => w.id).toList(growable: false),
      );
      await progress.markSeen(words.map((Word w) => w.id));
    }
    await progress.touchStreak(now);
    if (!mounted) return;
    setState(() {
      _words = words;
      _index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final AppScope scope = AppScope.of(context);
    final bool done = _words.isNotEmpty && _index >= _words.length - 1;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ScreenHeader(
              title: t.todayTitle,
              subtitle: _words.isEmpty
                  ? null
                  : t.todayProgress(_index + 1, _words.length),
              trailing: HeaderPill(
                key: const ValueKey<String>('streak-pill'),
                label: t.streakDays(scope.progress.streak),
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.italianRed,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
            ),
            if (_words.isEmpty)
              Expanded(
                child: Center(
                  child: Text(t.todayDone, style: context.texts.bodyMedium),
                ),
              )
            else
              Expanded(
                child: PageView.builder(
                  key: const ValueKey<String>('today-pager'),
                  controller: _pages,
                  itemCount: _words.length,
                  onPageChanged: (int index) {
                    setState(() => _index = index);
                    AppScope.of(context).progress.setTodaySeenIndex(index);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final Word word = _words[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.l),
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          onTap: () => AppScope.of(context).tts.speak(word.it),
                          child: WordCard(
                            word: word,
                            highlight: index == _index,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_words.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.l),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: done
                          ? FilledButton(
                              key: const ValueKey<String>('today-mini-quiz'),
                              onPressed: _startMiniQuiz,
                              child: ButtonContent(
                                icon: Icons.quiz_rounded,
                                label: t.miniQuizCta,
                              ),
                            )
                          : OutlinedButton(
                              key: const ValueKey<String>('today-next'),
                              onPressed: () => _pages.nextPage(
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOut,
                              ),
                              child: ButtonContent(
                                icon: Icons.arrow_forward_rounded,
                                label: t.next,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _startMiniQuiz() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          pool: _words,
          categoryId: 'today',
          categoryLabel: AppLocalizations.of(context).todayTitle,
          questionCount: 10,
        ),
      ),
    );
  }
}
