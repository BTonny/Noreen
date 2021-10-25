import 'package:flutter/material.dart';
import 'package:noreen/main.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording({
    required BuildContext context,
    required Function(String text, String status) onResult,
    required Function(bool, String) onListening,
    //required Function(String) updateListeningStatus,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }
    String listeningStatus = "";
    bool _isAvailable = await _speech.initialize(
      onStatus: (status) {
        onListening(_speech.isListening, status);
      },
      onError: (e) {
        print("Error: $e");
        showSnack(context, "Failed to record speech, try again");
      },
    );
    if (_isAvailable) {
      _speech.statusListener = (String status) {
        listeningStatus = status;
      };
      _speech.listen(onResult: (value) => onResult(value.recognizedWords, listeningStatus));
    }

    return _isAvailable;
  }
}
