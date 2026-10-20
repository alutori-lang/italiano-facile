import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/topic.dart';
import '../models/word.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/word_card.dart';

/// The detail view reached by tapping a word anywhere in the app. It is the
/// same card as in Search, opened full width with a shared-element transition
/// on the picture.
class WordDetailScreen extends StatelessWidget {
  const WordDetailScreen({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final Topic? topic = kTopicsById[word.topicId];
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          topic?.label(t) ?? t.appTitle,
          style: context.texts.titleMedium,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.xl,
            AppSpace.s,
            AppSpace.xl,
            AppSpace.xxl,
          ),
          children: <Widget>[
            WordCard(
              word: word,
              highlight: true,
              heroTag: 'word-picture:${word.id}',
            ),
          ],
        ),
      ),
    );
  }
}
