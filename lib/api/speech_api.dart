import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording({
    required Function(String text) onResult,
  }) async {
    final _isAvailable = await _speech.initialize();

    if (_isAvailable) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    }

    return _isAvailable;
  }
}
