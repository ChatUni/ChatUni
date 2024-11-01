import 'dart:io';

import 'package:chatuni/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Recognizer {
  final SpeechToText _stt = SpeechToText();
  bool speechEnabled = false;
  String lastMsg = '';

  Future<void> _init() async {
    speechEnabled = await _stt.initialize();
  }

  Future<void> start(String lang) async {
    if (!speechEnabled) throw Exception('speech to text not enabled');
    await _stt.listen(onResult: onSpeechResult, localeId: lang);
  }

  Future<void> stop() async {
    if (!kIsWeb && Platform.isAndroid) {
      await wait(1000);
    }
    await _stt.stop();
  }

  void clear() {
    lastMsg = '';
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    var txt = result.recognizedWords;
    if (txt != '') lastMsg = txt;
  }

  Recognizer() {
    _init();
  }
}
