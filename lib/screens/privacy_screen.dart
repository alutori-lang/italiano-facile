import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../ui/theme.dart';
import '../ui/widgets/button_content.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(t.privacy)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.xl),
          children: <Widget>[
            Text(t.privacy, style: context.texts.titleLarge),
            const SizedBox(height: AppSpace.m),
            Text(t.privacyBody, style: context.texts.bodyMedium),
            if (AppConfig.privacyPolicyUrl.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpace.l),
              Text(
                AppConfig.privacyPolicyUrl,
                style: context.texts.bodySmall,
              ),
            ],
            if (AppConfig.supportEmail.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpace.l),
              Text(AppConfig.supportEmail, style: context.texts.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
