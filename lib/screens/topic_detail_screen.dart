import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/topic.dart';
import '../models/word.dart';
import '../services/quiz_service.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/word_card.dart';
import 'flashcards_screen.dart';
import 'quiz_play_screen.dart';
import 'word_detail_screen.dart';

/// The full word list of one category, with Flashcards and Quiz 20 on top and
/// a small "words learned" counter.
class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final List<Word> words = WordRepository.instance.byTopic(topic.id);
    final AppScope scope = AppScope.of(context);
    final int learned =
        scope.progress.learnedInTopic(words.map((Word w) => w.id));
    final bool canQuiz = words.length >= QuizService.minWordsForQuiz;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(topic.label(t))),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.xl,
                0,
                AppSpace.xl,
                AppSpace.m,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${t.nWords(words.length)} · ${t.nLearned(learned)}',
                    style: context.texts.bodySmall,
                  ),
                  const SizedBox(height: AppSpace.m),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          key: const ValueKey<String>('topic-flashcards'),
                          onPressed: words.isEmpty
                              ? null
                              : () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => FlashcardsScreen(
                                        words: words,
                                        title: topic.label(t),
                                      ),
                                    ),
                                  ),
                          child: ButtonContent(
                            icon: Icons.style_rounded,
                            label: t.flashcards,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpace.m),
                      Expanded(
                        child: FilledButton(
                          key: const ValueKey<String>('topic-quiz'),
                          onPressed: canQuiz
                              ? () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => QuizPlayScreen(
                                        pool: words,
                                        categoryId: topic.id,
                                        categoryLabel: topic.label(t),
                                      ),
                                    ),
                                  )
                              : null,
                          child: ButtonContent(
                            icon: Icons.quiz_rounded,
                            label: t.quiz20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.xl,
                  0,
                  AppSpace.xl,
                  AppSpace.xxl,
                ),
                itemCount: words.length,
                itemBuilder: (BuildContext context, int index) {
                  final Word word = words[index];
                  return WordRow(
                    word: word,
                    learned: scope.progress.isLearned(word.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => WordDetailScreen(word: word),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
