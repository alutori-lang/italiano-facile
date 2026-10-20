import 'package:flutter/material.dart';

import '../../models/topic.dart';
import '../../models/word.dart';
import '../theme.dart';

/// The picture for an entry.
///
/// Shows the emoji when the entry has one that really fits. When it does not,
/// it draws the topic icon in the topic colour instead — a wrong picture
/// would be worse than none, so no emoji is a valid answer and the
/// explanation underneath still carries the meaning.
class PictureBox extends StatelessWidget {
  const PictureBox({
    super.key,
    required this.word,
    this.size = 56,
    this.radius = AppRadii.box,
    this.heroTag,
  });

  final Word word;
  final double size;
  final double radius;

  /// When set, the picture flies between the list and the detail card.
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final Topic? topic = kTopicsById[word.topicId];
    final Color accent = topic?.accent ?? AppColors.muted;
    final String? emoji = word.emoji;

    final Widget box = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: emoji != null
            ? context.paper
            : accent.withValues(alpha: context.isDark ? 0.26 : 0.12),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: emoji != null
              ? context.border
              : accent.withValues(alpha: 0.35),
        ),
      ),
      child: emoji != null
          ? Text(
              emoji,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: size * 0.5),
            )
          : Icon(
              topic?.icon ?? Icons.menu_book_rounded,
              size: size * 0.46,
              color: accent,
            ),
    );
    final String? tag = heroTag;
    return tag == null ? box : Hero(tag: tag, child: box);
  }
}
