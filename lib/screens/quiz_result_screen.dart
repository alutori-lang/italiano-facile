import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../models/learner_language.dart';
import '../models/word.dart';
import '../services/quiz_service.dart';
import '../ui/theme.dart';
import '../ui/widgets/audio_button.dart';
import '../ui/widgets/banner_ad_slot.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/mascot.dart';
import '../ui/widgets/picture_box.dart';
import 'quiz_play_screen.dart';

/// Score out of twenty, PASSED only with at most two mistakes, the list of
/// mistakes with the right words, and the two retry buttons.
class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({
    super.key,
    required this.result,
    required this.pool,
    required this.categoryId,
    required this.categoryLabel,
    this.questionCount = QuizService.questionsPerQuiz,
  });

  final QuizResult result;
  final List<Word> pool;
  final String categoryId;
  final String categoryLabel;
  final int questionCount;

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool _saved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_saved) return;
    _saved = true;
    final AppScope scope = AppScope.of(context);
    scope.progress.saveBestScore(widget.categoryId, widget.result.correct);
    // One interstitial after a finished quiz, subject to the frequency cap.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scope.ads.maybeShowInterstitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final QuizResult result = widget.result;
    final LearnerLanguage lang = AppScope.languageOf(context);
    final Color stateColour =
        result.passed ? AppColors.correct : AppColors.wrong;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(t.quizResultTitle)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.xl,
                  AppSpace.s,
                  AppSpace.xl,
                  AppSpace.xl,
                ),
                children: <Widget>[
                  Mascot(
                    mood: result.passed ? MascotMood.happy : MascotMood.sad,
                    size: 88,
                  ),
                  const SizedBox(height: AppSpace.l),
                  // The score is the largest thing on the screen.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      t.scoreOutOf(result.correct, result.total),
                      textAlign: TextAlign.center,
                      style: context.texts.displaySmall?.copyWith(
                        fontSize: 56,
                        height: 1,
                        color: context.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpace.m),
                  // Pass / fail is shown by colour AND by an icon and words.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        result.passed
                            ? Icons.verified_rounded
                            : Icons.replay_circle_filled_rounded,
                        color: stateColour,
                        size: 26,
                      ),
                      const SizedBox(width: AppSpace.s),
                      Flexible(
                        child: Text(
                          result.passed ? t.passed : t.notPassed,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.texts.titleLarge?.copyWith(
                            color: stateColour,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.xs),
                  Text(
                    t.passRule,
                    textAlign: TextAlign.center,
                    style: context.texts.bodySmall,
                  ),
                  const SizedBox(height: AppSpace.xl),
                  if (result.mistakes.isEmpty)
                    Text(
                      t.noMistakes,
                      textAlign: TextAlign.center,
                      style: context.texts.bodyMedium,
                    )
                  else ...<Widget>[
                    Text(
                      t.mistakesCount(result.mistakes.length),
                      style: context.texts.labelSmall,
                    ),
                    const SizedBox(height: AppSpace.s),
                    // Indexed, not keyed by word: a quiz over a small topic
                    // can easily ask about — and get wrong — the same word
                    // more than once, so two rows may share a word here.
                    for (int i = 0; i < result.mistakes.length; i++)
                      _MistakeRow(
                        key: ValueKey<String>(
                          'mistake:$i:${result.mistakes[i].pictureWord.id}',
                        ),
                        question: result.mistakes[i],
                        lang: lang,
                      ),
                  ],
                  const SizedBox(height: AppSpace.xl),
                  if (result.mistakes.isNotEmpty)
                    OutlinedButton(
                      key: const ValueKey<String>('repeat-mistakes'),
                      onPressed: _repeatMistakes,
                      child: ButtonContent(
                        icon: Icons.refresh_rounded,
                        label: t.repeatMistakes,
                      ),
                    ),
                  if (result.mistakes.isNotEmpty)
                    const SizedBox(height: AppSpace.m),
                  FilledButton(
                    key: const ValueKey<String>('new-quiz'),
                    onPressed: _newQuiz,
                    child: ButtonContent(
                      icon: Icons.play_arrow_rounded,
                      label: t.newQuiz,
                    ),
                  ),
                ],
              ),
            ),
            const BannerAdSlot(),
          ],
        ),
      ),
    );
  }

  void _repeatMistakes() {
    final List<Word> pool = widget.result.mistakes
        .map((QuizQuestion q) => q.pictureWord)
        .toList(growable: false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          pool: pool.length >= 2 ? pool : widget.pool,
          categoryId: widget.categoryId,
          categoryLabel: widget.categoryLabel,
          questionCount: widget.result.mistakes.length.clamp(2, 20),
        ),
      ),
    );
  }

  void _newQuiz() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          pool: widget.pool,
          categoryId: widget.categoryId,
          categoryLabel: widget.categoryLabel,
          questionCount: widget.questionCount,
        ),
      ),
    );
  }
}

class _MistakeRow extends StatelessWidget {
  const _MistakeRow({super.key, required this.question, required this.lang});

  final QuizQuestion question;
  final LearnerLanguage lang;

  @override
  Widget build(BuildContext context) {
    final Word right = question.correction;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.s),
      padding: const EdgeInsets.all(AppSpace.m),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: <Widget>[
          PictureBox(word: right, size: 44, radius: 14),
          const SizedBox(width: AppSpace.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  right.it,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.titleLarge?.copyWith(
                    color: AppColors.italianRed,
                  ),
                ),
                Text(
                  right.translation(lang),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.bodySmall,
                ),
              ],
            ),
          ),
          AudioButton(text: right.it, size: 44),
        ],
      ),
    );
  }
}
