import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/app_localizations.dart';
import '../../models/big_entry.dart';
import '../../models/learner_language.dart';
import '../theme.dart';
import 'audio_button.dart';

/// Part of speech in Italian ("Nome", "Verbo", "Aggettivo", "Avverbio"…).
String posLabel(AppLocalizations t, String pos) {
  switch (pos) {
    case 'noun':
    case 'name':
      return t.typeNoun;
    case 'verb':
      return t.typeVerb;
    case 'adj':
      return t.typeAdjective;
    case 'adv':
      return t.posAdverb;
    case 'article':
      return t.posArticle;
    case 'conj':
      return t.posConjunction;
    case 'det':
      return t.posDeterminer;
    case 'intj':
      return t.posInterjection;
    case 'num':
      return t.posNumeral;
    case 'particle':
      return t.posParticle;
    case 'prep':
      return t.posPreposition;
    case 'pron':
      return t.posPronoun;
    case 'phrase':
      return t.typePhrase;
    default:
      return t.posOther;
  }
}

/// The small book icon big-dictionary entries show where curated words show
/// their picture: there is no hand-picked picture for them.
class BigEntryIcon extends StatelessWidget {
  const BigEntryIcon({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.paper,
        borderRadius: BorderRadius.circular(AppRadii.box),
        border: Border.all(color: context.border),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: size * 0.46,
        color: context.muted,
      ),
    );
  }
}

/// A big-dictionary result in Search: the Italian word with its article, the
/// part of speech, the meaning in the chosen language, and the speaker.
class BigEntryCard extends StatelessWidget {
  const BigEntryCard({super.key, required this.entry, this.onTap});

  final BigEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final LearnerLanguage lang = AppScope.languageOf(context);
    final String meaning = entry.translation(lang);

    return Card(
      key: ValueKey<String>('big:${entry.id}'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: BorderSide(color: context.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.l),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const BigEntryIcon(size: 48),
              const SizedBox(width: AppSpace.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entry.headword,
                      style: context.texts.titleLarge?.copyWith(
                        color: AppColors.italianRed,
                      ),
                    ),
                    if (meaning.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 2),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          meaning,
                          textDirection: lang.textDirection,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: context.texts.titleMedium,
                        ),
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      posLabel(t, entry.pos),
                      style: context.texts.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.s),
              AudioButton(text: entry.headword, size: 44),
            ],
          ),
        ),
      ),
    );
  }
}
