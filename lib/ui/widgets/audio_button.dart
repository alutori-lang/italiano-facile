import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/voice_help_screen.dart';
import '../theme.dart';

/// The speaker button. It carries the reserved Italian red because it always
/// plays Italian, and it is big enough to tap comfortably (48dp).
class AudioButton extends StatelessWidget {
  const AudioButton({
    super.key,
    required this.text,
    this.slow = false,
    this.size = 48,
  });

  final String text;
  final bool slow;
  final double size;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final AppScope scope = AppScope.of(context);
    final String label = slow ? t.listenSlow : t.listen;

    // No Tooltip: the Semantics label already announces the button, and a
    // tooltip adds a long-press overlay and timers to a control the user taps
    // dozens of times per session.
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        key: ValueKey<String>('audio${slow ? '-slow' : ''}:$text'),
        onTap: () => _speak(context, scope),
        borderRadius: BorderRadius.circular(size),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.paper,
            shape: BoxShape.circle,
            border: Border.all(color: context.border),
          ),
          child: Icon(
            slow ? Icons.slow_motion_video_rounded : Icons.volume_up_rounded,
            size: size * 0.44,
            color: AppColors.italianRed,
          ),
        ),
      ),
    );
  }

  /// Speaks, then offers the install guide when the phone turns out to have
  /// no Italian voice. The guide is pushed, never awaited: the button must be
  /// ready again the moment the user taps the next word.
  Future<void> _speak(BuildContext context, AppScope scope) async {
    final NavigatorState navigator = Navigator.of(context);
    await scope.tts.speak(text, slow: slow || scope.settings.slowAudio);
    if (!scope.tts.italianVoiceAvailable && navigator.mounted) {
      navigator.push(
        MaterialPageRoute<void>(builder: (_) => const VoiceHelpScreen()),
      );
    }
  }
}

/// Normal plus slow speed, side by side.
class AudioButtonPair extends StatelessWidget {
  const AudioButtonPair({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AudioButton(text: text),
        const SizedBox(width: AppSpace.s),
        AudioButton(text: text, slow: true, size: 40),
      ],
    );
  }
}
