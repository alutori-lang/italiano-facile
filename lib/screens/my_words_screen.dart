import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/word.dart';
import '../services/quiz_service.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/word_card.dart';
import 'quiz_play_screen.dart';
import 'word_detail_screen.dart';

/// Words saved from Search, with their own quiz.
class MyWordsScreen extends StatelessWidget {
  const MyWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final AppScope scope = AppScope.of(context);
    final List<Word> words =
        WordRepository.instance.byIds(scope.progress.myWordIds);

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(t.myWords)),
      body: SafeArea(
        child: words.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.xl),
                  child: Text(
                    t.myWordsEmpty,
                    textAlign: TextAlign.center,
                    style: context.texts.bodyMedium,
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpace.xl,
                      0,
                      AppSpace.xl,
                      AppSpace.m,
                    ),
                    child: FilledButton(
                      key: const ValueKey<String>('my-words-quiz'),
                      onPressed: words.length >= QuizService.minWordsForQuiz
                          ? () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => QuizPlayScreen(
                                    pool: words,
                                    categoryId: 'my_words',
                                    categoryLabel: t.myWords,
                                    questionCount:
                                        words.length >= 20 ? 20 : words.length,
                                  ),
                                ),
                              )
                          : null,
                      child: ButtonContent(
                        icon: Icons.quiz_rounded,
                        label: words.length >= QuizService.minWordsForQuiz
                            ? t.quizOnMyWords
                            : t.quizNotEnoughWords,
                      ),
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
