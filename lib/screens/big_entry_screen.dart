import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../models/big_entry.dart';
import '../models/learner_language.dart';
import '../ui/theme.dart';
import '../ui/widgets/audio_button.dart';
import '../ui/widgets/big_entry_card.dart';
import '../ui/widgets/button_content.dart';

/// Detail of a big-dictionary word: the word with its article, part of
/// speech, the meaning in the chosen language, plural, the English gloss in
/// small print and the Wiktionary example when there is one.
class BigEntryScreen extends StatelessWidget {
  const BigEntryScreen({super.key, required this.entry});

  final BigEntry entry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final LearnerLanguage lang = AppScope.languageOf(context);
    final String meaning = entry.translation(lang);
    final String? plural = entry.pl;
    final String? gloss = entry.gloss;
    final String? exIt = entry.exIt;
    final String? exEn = entry.exEn;

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(t.bigDictTitle, style: context.texts.titleMedium),
      ),
      body: SafeArea(
        child: ListView(
          key: const ValueKey<String>('big-entry-detail'),
          padding: const EdgeInsets.fromLTRB(
            AppSpace.xl,
            AppSpace.s,
            AppSpace.xl,
            AppSpace.xxl,
          ),
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.card),
                side: const BorderSide(color: AppColors.italianRed, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.l + 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const BigEntryIcon(size: 64),
                        const SizedBox(width: AppSpace.l),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                entry.headword,
                                style: context.texts.displaySmall?.copyWith(
                                  color: AppColors.italianRed,
                                ),
                              ),
                              const SizedBox(height: AppSpace.xs),
                              if (meaning.isNotEmpty)
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    meaning,
                                    textDirection: lang.textDirection,
                                    style: context.texts.titleMedium,
                                  ),
                                ),
                              const SizedBox(height: AppSpace.xs),
                              Text(
                                posLabel(t, entry.pos),
                                style: context.texts.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.m),
                    AudioButtonPair(text: entry.headword),
                    if (plural != null && plural != entry.it) ...<Widget>[
                      const SizedBox(height: AppSpace.m),
                      Text(t.bigPlural(plural),
                          style: context.texts.bodyMedium),
                    ],
                    if (lang != LearnerLanguage.english &&
                        gloss != null) ...<Widget>[
                      const SizedBox(height: AppSpace.s),
                      Text(t.bigInEnglish(gloss),
                          style: context.texts.bodySmall),
                    ],
                    if (exIt != null) ...<Widget>[
                      const SizedBox(height: AppSpace.m),
                      Divider(height: 1, color: context.border),
                      const SizedBox(height: AppSpace.m),
                      Container(
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
                            Text(t.exampleLabel.toUpperCase(),
                                style: context.texts.labelSmall),
                            const SizedBox(height: AppSpace.xs),
                            Text(
                              _clean(exIt),
                              style: context.texts.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (exEn != null) ...<Widget>[
                              const SizedBox(height: AppSpace.xs),
                              Text(_clean(exEn),
                                  style: context.texts.bodySmall),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpace.m),
                    Text(
                      entry.learned ? t.bigLearnedSource : t.bigSource,
                      style: context.texts.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Wiktionary marks verse line breaks with ¶.
  static String _clean(String s) =>
      s.replaceAll(RegExp(r'\s*¶\s*'), ' / ').trim();
}
