import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TextToSpeech {
  final FlutterTts _tts = FlutterTts();
  final StreamController<TtsState> _onTtsStateController =
      StreamController<TtsState>();

  Stream<TtsState> get onTtsState => _onTtsStateController.stream;

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  TextToSpeech() {
    _tts.setStartHandler(() {
      _onTtsStateController.add(TtsState.playing);
    });
    _tts.setCompletionHandler(() {
      _onTtsStateController.add(TtsState.stopped);
    });
    _tts.setCancelHandler(() {
      _onTtsStateController.add(TtsState.stopped);
    });
  }

  void dispose() {
    _onTtsStateController.close();
  }
}
