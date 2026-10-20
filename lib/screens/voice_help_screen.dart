import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';

/// Shown when the phone has no Italian text-to-speech voice. The app keeps
/// working: the words are still there to read.
class VoiceHelpScreen extends StatelessWidget {
  const VoiceHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(t.voiceHelpTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.italianRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadii.box),
                ),
                child: const Icon(
                  Icons.record_voice_over_rounded,
                  color: AppColors.italianRed,
                  size: 30,
                ),
              ),
              const SizedBox(height: AppSpace.l),
              Text(t.voiceHelpTitle, style: context.texts.titleLarge),
              const SizedBox(height: AppSpace.m),
              Text(t.voiceHelpBody, style: context.texts.bodyMedium),
              const SizedBox(height: AppSpace.xl),
              FilledButton(
                key: const ValueKey<String>('voice-help-close'),
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(t.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
