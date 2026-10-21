import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../models/learner_language.dart';
import '../models/word.dart';
import '../services/quiz_service.dart';
import '../ui/theme.dart';
import '../ui/widgets/audio_button.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/mascot.dart';
import '../ui/widgets/picture_box.dart';
import 'quiz_result_screen.dart';

/// One true/false question at a time, like the driving-licence test.
///
/// The layout deliberately puts the picture first and large, with the Italian
/// word under it and the two big answer buttons at the bottom — a different
/// arrangement from the search card, where the picture is small and beside the
/// word.
class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({
    super.key,
    required this.pool,
    required this.categoryId,
    required this.categoryLabel,
    this.questionCount = QuizService.questionsPerQuiz,
    this.fixedQuestions,
    this.random,
  });

  final List<Word> pool;
  final String categoryId;
  final String categoryLabel;
  final int questionCount;

  /// Lets screenshot mode and tests pin the exact questions.
  final List<QuizQuestion>? fixedQuestions;
  final Random? random;

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  static const QuizService _service = QuizService();

  late List<QuizQuestion> _questions;
  final List<bool> _answers = <bool>[];
  int _index = 0;
  bool? _lastAnswerCorrect;

  @override
  void initState() {
    super.initState();
    _questions = widget.fixedQuestions ??
        _service.build(
          widget.pool,
          count: widget.questionCount,
          random: widget.random,
        );
  }

  QuizQuestion get _current => _questions[_index];

  Future<void> _answer(bool answeredTrue) async {
    if (_lastAnswerCorrect != null) return;
    final QuizQuestion question = _current;
    final bool correct = _service.isAnswerCorrect(question, answeredTrue);
    final AppScope scope = AppScope.of(context);
    _answers.add(answeredTrue);
    await scope.progress
        .recordAnswer(question.pictureWord.id, correct: correct);
    if (!mounted) return;
    setState(() => _lastAnswerCorrect = correct);
    if (!correct) {
      // On a mistake the right word is read out loud straight away. The
      // feedback is already on screen, so a slow speech engine never holds
      // up the quiz.
      unawaited(scope.tts.speak(question.correction.it));
    }
  }

  void _next() {
    if (_index + 1 >= _questions.length) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _lastAnswerCorrect = null;
    });
  }

  void _finish() {
    final QuizResult result = _service.score(_questions, _answers);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => QuizResultScreen(
          result: result,
          pool: widget.pool,
          categoryId: widget.categoryId,
          categoryLabel: widget.categoryLabel,
          questionCount: widget.questionCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: AppBarTitle(widget.categoryLabel)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.xl),
            child: Text(
              t.quizNotEnoughWords,
              textAlign: TextAlign.center,
              style: context.texts.bodyMedium,
            ),
          ),
        ),
      );
    }

    final QuizQuestion question = _current;
    final bool answered = _lastAnswerCorrect != null;
    final LearnerLanguage lang = AppScope.languageOf(context);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          widget.categoryLabel,
          style: context.texts.titleMedium,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_index + 1) / _questions.length,
            minHeight: 4,
            backgroundColor: context.border,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.italianRed,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
          child: Column(
            children: <Widget>[
              const SizedBox(height: AppSpace.m),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  t.quizProgress(_index + 1, _questions.length),
                  style: context.texts.bodySmall,
                ),
              ),
              const SizedBox(height: AppSpace.l),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        t.quizQuestionPrompt,
                        textAlign: TextAlign.center,
                        style: context.texts.bodyMedium,
                      ),
                      const SizedBox(height: AppSpace.l),
                      PictureBox(
                        key: ValueKey<String>(
                          'quiz-picture:${question.pictureWord.id}',
                        ),
                        word: question.pictureWord,
                        size: 140,
                        radius: AppRadii.card,
                      ),
                      const SizedBox(height: AppSpace.l),
                      Text(
                        question.shownWord.it,
                        textAlign: TextAlign.center,
                        style: context.texts.displaySmall?.copyWith(
                          color: AppColors.italianRed,
                        ),
                      ),
                      const SizedBox(height: AppSpace.m),
                      AudioButtonPair(text: question.shownWord.it),
                      if (answered) ...<Widget>[
                        const SizedBox(height: AppSpace.l),
                        _Feedback(
                          correct: _lastAnswerCorrect!,
                          question: question,
                          lang: lang,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!answered)
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _AnswerButton(
                        label: t.vero,
                        hint: t.veroHint,
                        filled: true,
                        onPressed: () => _answer(true),
                        buttonKey: const ValueKey<String>('answer-vero'),
                      ),
                    ),
                    const SizedBox(width: AppSpace.m),
                    Expanded(
                      child: _AnswerButton(
                        label: t.falso,
                        hint: t.falsoHint,
                        filled: false,
                        onPressed: () => _answer(false),
                        buttonKey: const ValueKey<String>('answer-falso'),
                      ),
                    ),
                  ],
                )
              else
                FilledButton(
                  key: const ValueKey<String>('quiz-next'),
                  onPressed: _next,
                  child: ButtonContent(
                    icon: Icons.arrow_forward_rounded,
                    label: _index + 1 >= _questions.length ? t.done : t.next,
                  ),
                ),
              const SizedBox(height: AppSpace.l),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.hint,
    required this.filled,
    required this.onPressed,
    required this.buttonKey,
  });

  final String label;
  final String hint;
  final bool filled;
  final VoidCallback onPressed;
  final Key buttonKey;

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: context.texts.titleLarge?.copyWith(
            color: filled ? Colors.white : AppColors.italianRed,
          ),
        ),
        Text(
          hint,
          style: context.texts.labelSmall?.copyWith(
            color: filled ? Colors.white70 : context.muted,
          ),
        ),
      ],
    );

    // VERO and FALSO are Italian words, so they carry the reserved red: the
    // chosen state fills it, the other outlines it.
    if (filled) {
      return FilledButton(
        key: buttonKey,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.italianRed,
          minimumSize: const Size.fromHeight(68),
        ),
        onPressed: onPressed,
        child: content,
      );
    }
    return OutlinedButton(
      key: buttonKey,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(68),
        side: const BorderSide(color: AppColors.italianRed, width: 1.6),
      ),
      onPressed: onPressed,
      child: content,
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({
    required this.correct,
    required this.question,
    required this.lang,
  });

  final bool correct;
  final QuizQuestion question;
  final LearnerLanguage lang;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final Color colour = correct ? AppColors.correct : AppColors.wrong;

    return Container(
      key: const ValueKey<String>('quiz-feedback'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.l),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: context.isDark ? 0.22 : 0.10),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colour.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: <Widget>[
          Mascot(
            mood: correct ? MascotMood.happy : MascotMood.sad,
            size: 64,
            message: correct ? t.mascotCheer : t.mascotTryAgain,
          ),
          const SizedBox(height: AppSpace.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: colour,
                size: 20,
              ),
              const SizedBox(width: AppSpace.s),
              Flexible(
                child: Text(
                  correct ? t.answerCorrect : t.answerWrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.labelLarge?.copyWith(color: colour),
                ),
              ),
            ],
          ),
          if (!correct) ...<Widget>[
            const SizedBox(height: AppSpace.m),
            Text(t.correctAnswerIs, style: context.texts.bodySmall),
            const SizedBox(height: AppSpace.xs),
            Text(
              question.correction.it,
              textAlign: TextAlign.center,
              style: context.texts.titleLarge?.copyWith(
                color: AppColors.italianRed,
              ),
            ),
            Text(
              question.correction.translation(lang),
              textDirection: lang.textDirection,
              textAlign: TextAlign.center,
              style: context.texts.bodySmall,
            ),
            const SizedBox(height: AppSpace.s),
            AudioButton(text: question.correction.it),
          ],
        ],
      ),
    );
  }
}
