import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../config/app_config.dart';

/// Italian pronunciation through the phone's own text-to-speech engine.
///
/// Nothing is downloaded and no key is needed. If the device has no Italian
/// voice installed, [italianVoiceAvailable] turns false and the UI offers a
/// short guide; reading the words still works.
class TtsService extends ChangeNotifier {
  TtsService({FlutterTts? engine}) : _tts = engine ?? FlutterTts();

  final FlutterTts _tts;

  bool _ready = false;
  bool _italianVoiceAvailable = true;
  bool _speaking = false;

  bool get ready => _ready;
  bool get italianVoiceAvailable => _italianVoiceAvailable;
  bool get speaking => _speaking;

  static const double normalRate = 0.45;
  static const double slowRate = 0.25;

  Future<void> init() async {
    if (_ready) return;
    try {
      // On the web the list of languages is only known after the voices load.
      final dynamic available =
          await _tts.isLanguageAvailable(AppConfig.ttsLanguage);
      _italianVoiceAvailable = available == true;
      await _tts.setLanguage(AppConfig.ttsLanguage);
      await _tts.setSpeechRate(normalRate);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _ready = true;
    } catch (_) {
      // A missing engine must never break the app: the words still read fine.
      _ready = false;
      _italianVoiceAvailable = false;
    }
    notifyListeners();
  }

  /// Speaks [text] in Italian. [slow] uses the slower rate.
  Future<void> speak(String text, {bool slow = false}) async {
    if (text.trim().isEmpty) return;
    try {
      if (!_ready) await init();
      await _tts.setSpeechRate(slow ? slowRate : normalRate);
      await _tts.stop();
      _speaking = true;
      notifyListeners();
      await _tts.speak(text);
    } catch (_) {
      // A transient failure to speak says nothing about whether an Italian
      // voice is installed on the device — only `init`'s own check decides
      // that. Flipping it here on any speak error (a network hiccup, the
      // engine still warming up) wrongly sent the user to the "install a
      // voice" guide for problems that have nothing to do with a missing
      // voice.
    } finally {
      _speaking = false;
      notifyListeners();
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // Nothing to stop.
    }
    _speaking = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
