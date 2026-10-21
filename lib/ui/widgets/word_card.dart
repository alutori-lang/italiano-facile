import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/app_localizations.dart';
import '../../models/learner_language.dart';
import '../../models/topic.dart';
import '../../models/word.dart';
import '../theme.dart';
import 'audio_button.dart';
import 'picture_box.dart';

String wordTypeLabel(AppLocalizations t, WordType type) {
  switch (type) {
    case WordType.noun:
      return t.typeNoun;
    case WordType.verb:
      return t.typeVerb;
    case WordType.adjective:
      return t.typeAdjective;
    case WordType.phrase:
      return t.typePhrase;
  }
}

/// The full-width dictionary card: picture, Italian headword with its article,
/// audio, translation, the explanation directly under the picture block, the
/// example with its translation, and "Add to my words".
class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.word,
    this.highlight = false,
    this.showAddButton = true,
    this.onTap,
    this.heroTag,
  });

  final Word word;
  final bool highlight;
  final bool showAddButton;
  final VoidCallback? onTap;

  /// Shared-element tag for the picture, so it flies from the list to the
  /// detail card instead of the whole card jumping.
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final LearnerLanguage lang = AppScope.languageOf(context);
    final AppScope scope = AppScope.of(context);
    final Topic? topic = kTopicsById[word.topicId];
    final bool saved = scope.progress.isSaved(word.id);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: BorderSide(
          color: highlight ? AppColors.italianRed : context.border,
          width: highlight ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.l + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PictureBox(word: word, size: 64, heroTag: heroTag),
                  const SizedBox(width: AppSpace.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Level 1 — the Italian word, in the reserved red.
                        Text(
                          word.it,
                          style: context.texts.displaySmall?.copyWith(
                            color: AppColors.italianRed,
                          ),
                        ),
                        const SizedBox(height: AppSpace.xs),
                        // Level 2 — the translation, neutral ink.
                        Text(
                          word.translation(lang),
                          textDirection: lang.textDirection,
                          style: context.texts.titleMedium,
                        ),
                        const SizedBox(height: AppSpace.xs),
                        // Level 4 — metadata.
                        Text(
                          wordTypeLabel(t, word.type),
                          style: context.texts.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.m),
              AudioButtonPair(text: word.it),
              const SizedBox(height: AppSpace.m),
              Divider(height: 1, color: context.border),
              const SizedBox(height: AppSpace.m),
              // Level 3 — the explanation always shows, so entries without a
              // good picture are still clear.
              Text(
                word.explanation(lang),
                textDirection: lang.textDirection,
                style: context.texts.bodyMedium,
              ),
              const SizedBox(height: AppSpace.m),
              _ExampleBlock(word: word, lang: lang, label: t.exampleLabel),
              const SizedBox(height: AppSpace.m),
              Wrap(
                spacing: AppSpace.s,
                runSpacing: AppSpace.s,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  if (topic != null)
                    _TopicBadge(topic: topic, label: topic.label(t)),
                  if (showAddButton)
                    TextButton.icon(
                      key: ValueKey<String>('save:${word.id}'),
                      onPressed: () => scope.progress.toggleSaved(word.id),
                      icon: Icon(
                        saved ? Icons.check_rounded : Icons.add_rounded,
                        size: 18,
                      ),
                      label: Text(
                        saved ? t.removeFromMyWords : t.addToMyWords,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExampleBlock extends StatelessWidget {
  const _ExampleBlock({
    required this.word,
    required this.lang,
    required this.label,
  });

  final Word word;
  final LearnerLanguage lang;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.l,
        vertical: AppSpace.m,
      ),
      decoration: BoxDecoration(
        color: context.paper,
        borderRadius: BorderRadius.circular(AppRadii.box - 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label.toUpperCase(), style: context.texts.labelSmall),
          const SizedBox(height: AppSpace.xs),
          Text(
            word.example,
            style: context.texts.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            word.exampleTranslation(lang),
            textDirection: lang.textDirection,
            style: context.texts.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _TopicBadge extends StatelessWidget {
  const _TopicBadge({required this.topic, required this.label});

  final Topic topic;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.m,
        vertical: AppSpace.xs + 1,
      ),
      decoration: BoxDecoration(
        color: topic.accent.withValues(alpha: context.isDark ? 0.28 : 0.12),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.texts.labelSmall?.copyWith(color: context.ink),
      ),
    );
  }
}

/// The compact row used in topic lists and My Words: picture, Italian word,
/// translation, speaker. Emphasis is reversed from the big card — here the
/// picture is small and the list scans vertically.
class WordRow extends StatelessWidget {
  const WordRow({
    super.key,
    required this.word,
    required this.onTap,
    this.learned = false,
  });

  final Word word;
  final VoidCallback onTap;
  final bool learned;

  @override
  Widget build(BuildContext context) {
    final LearnerLanguage lang = AppScope.languageOf(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.s),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        border: Border.all(color: context.border),
      ),
      child: InkWell(
        key: ValueKey<String>('row:${word.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.m),
          child: Row(
            children: <Widget>[
              PictureBox(word: word, size: 44, radius: 14),
              const SizedBox(width: AppSpace.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      word.it,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.texts.titleLarge?.copyWith(
                        color: AppColors.italianRed,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      word.translation(lang),
                      textDirection: lang.textDirection,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.texts.bodySmall,
                    ),
                  ],
                ),
              ),
              if (learned)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpace.s),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: AppColors.correct,
                  ),
                ),
              AudioButton(text: word.it, size: 44),
            ],
          ),
        ),
      ),
    );
  }
}
