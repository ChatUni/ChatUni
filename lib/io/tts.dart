import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TextToSpeech {
  final FlutterTts _tts = FlutterTts();
  final StreamController<TtsState> _onTtsStateController =
      StreamController<TtsState>();

  Stream<TtsState> get onTtsState => _onTtsStateController.stream;

  Future<void> _init() async {
    await _tts.setSharedInstance(true);
    //final voices = await _tts.getVoices;
    //print(json.encode(voices));
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> setVoice(
    String name,
    String locale, [
    double rate = 0.5,
    double pitch = 1.0,
  ]) async {
    await _tts.setVoice({'name': name, 'locale': locale});
    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);
  }

  TextToSpeech() {
    _init();
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
