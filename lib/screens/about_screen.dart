import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../data/word_repository.dart';
import '../l10n/app_localizations.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/mascot.dart';

/// About, credits and the open-source licences the word data is checked
/// against.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final WordRepository repo = WordRepository.instance;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(t.about)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.xl),
          children: <Widget>[
            const Center(child: Mascot(mood: MascotMood.idle, size: 88)),
            const SizedBox(height: AppSpace.l),
            Text(
              t.appTitle,
              textAlign: TextAlign.center,
              style: context.texts.titleLarge,
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              AppConfig.appVersion,
              textAlign: TextAlign.center,
              style: context.texts.bodySmall,
            ),
            const SizedBox(height: AppSpace.xl),
            Text(t.aboutBody, style: context.texts.bodyMedium),
            const SizedBox(height: AppSpace.xl),
            Text(t.dataCoverage.toUpperCase(), style: context.texts.labelSmall),
            const SizedBox(height: AppSpace.xs),
            Text(
              t.wordsAndPhrases(repo.wordCount, repo.phraseCount),
              style: context.texts.bodyMedium,
            ),
            const SizedBox(height: AppSpace.xl),
            Text(t.about.toUpperCase(), style: context.texts.labelSmall),
            const SizedBox(height: AppSpace.xs),
            Text(t.creditsBody, style: context.texts.bodyMedium),
            const SizedBox(height: AppSpace.xl),
            Text(
              t.bigDictTitle.toUpperCase(),
              style: context.texts.labelSmall,
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              t.bigDictCredits,
              key: const ValueKey<String>('about-big-dictionary'),
              style: context.texts.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
