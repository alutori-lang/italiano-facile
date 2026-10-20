import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/topic.dart';
import '../models/word.dart';
import '../services/quiz_service.dart';
import '../ui/theme.dart';
import '../ui/widgets/screen_header.dart';
import 'quiz_play_screen.dart';

/// The quiz tab: pick a category, or "Mix of all".
class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final WordRepository repo = WordRepository.instance;
    final List<Topic> topics = repo.topicsWithWords;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ScreenHeader(
              title: t.tabQuiz,
              subtitle: t.passRule,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppSpace.xxl),
                children: <Widget>[
                  _CategoryTile(
                    id: 'mix',
                    label: t.mixOfAll,
                    emoji: '🎲',
                    accent: AppColors.italianRed,
                    count: repo.all.length,
                    onTap: () => _start(context, 'mix', t.mixOfAll, repo.all),
                  ),
                  const SizedBox(height: AppSpace.s),
                  ...topics.map((Topic topic) {
                    final List<Word> words = repo.byTopic(topic.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.s),
                      child: _CategoryTile(
                        id: topic.id,
                        label: topic.label(t),
                        emoji: topic.emoji,
                        accent: topic.accent,
                        count: words.length,
                        onTap: words.length >= QuizService.minWordsForQuiz
                            ? () => _start(
                                  context,
                                  topic.id,
                                  topic.label(t),
                                  words,
                                )
                            : null,
                        disabledNote: words.length < QuizService.minWordsForQuiz
                            ? t.quizNotEnoughWords
                            : null,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _start(
    BuildContext context,
    String categoryId,
    String label,
    List<Word> pool,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizPlayScreen(
          pool: pool,
          categoryId: categoryId,
          categoryLabel: label,
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.id,
    required this.label,
    required this.emoji,
    required this.accent,
    required this.count,
    this.onTap,
    this.disabledNote,
  });

  final String id;
  final String label;
  final String emoji;
  final Color accent;
  final int count;
  final VoidCallback? onTap;
  final String? disabledNote;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final int best = AppScope.of(context).progress.bestScore(id);

    return Opacity(
      opacity: onTap == null ? 0.55 : 1,
      child: Material(
        color: context.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.tile),
          side: BorderSide(color: context.border),
        ),
        child: InkWell(
          key: ValueKey<String>('quiz-category:$id'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.l),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        accent.withValues(alpha: context.isDark ? 0.28 : 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: AppSpace.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.texts.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        disabledNote ??
                            (best > 0
                                ? '${t.nWords(count)} · ${t.bestScoreValue(best, QuizService.questionsPerQuiz)}'
                                : t.nWords(count)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.texts.bodySmall,
                      ),
                    ],
                  ),
                ),
                MirroredIcon(
                  Icons.chevron_right_rounded,
                  color: context.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
