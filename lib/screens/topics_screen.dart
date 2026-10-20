import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/topic.dart';
import '../models/word.dart';
import '../ui/theme.dart';
import '../ui/widgets/banner_ad_slot.dart';
import '../ui/widgets/screen_header.dart';
import 'topic_detail_screen.dart';

/// The dense, orderly category grid.
class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final WordRepository repo = WordRepository.instance;
    final List<Topic> topics = repo.topicsWithWords;

    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ScreenHeader(
                    title: t.tabTopics,
                    subtitle: t.topicsSubtitle,
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: AppSpace.xl),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSpace.m,
                        crossAxisSpacing: AppSpace.m,
                        mainAxisExtent: 148,
                      ),
                      itemCount: topics.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Topic topic = topics[index];
                        return _TopicTile(topic: topic);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BannerAdSlot(),
        ],
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final List<Word> words = WordRepository.instance.byTopic(topic.id);
    final int learned = AppScope.of(context)
        .progress
        .learnedInTopic(words.map((Word w) => w.id));

    return Material(
      color: context.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.tile),
        side: BorderSide(color: context.border),
      ),
      child: InkWell(
        key: ValueKey<String>('topic:${topic.id}'),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            // Nothing in the word list below is worth keeping alive while a
            // card, flashcard set or quiz is open on top of it — kept alive,
            // its words and translations stay in the tree (just invisible),
            // where they can collide with identical text on the screen above.
            maintainState: false,
            builder: (_) => TopicDetailScreen(topic: topic),
          ),
        ),
        borderRadius: BorderRadius.circular(AppRadii.tile),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.l + 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: topic.accent
                      .withValues(alpha: context.isDark ? 0.28 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(topic.emoji, style: const TextStyle(fontSize: 20)),
              ),
              const Spacer(),
              Text(
                topic.label(t),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.texts.labelLarge,
              ),
              const SizedBox(height: 2),
              Text(
                '${t.nWords(words.length)} · ${t.nLearned(learned)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.texts.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
