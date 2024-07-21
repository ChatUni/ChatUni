import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TextToSpeech {
  final FlutterTts _tts = FlutterTts();
  final StreamController<TtsState> _onTtsStateController =
      StreamController<TtsState>();
  var voices = [];

  Stream<TtsState> get onTtsState => _onTtsStateController.stream;

  Future<void> _init() async {
    if (!kIsWeb) {
      await _tts.setSharedInstance(true);
    }
    await _initVoice();
  }

  Future<void> _initVoice() async {
    if (voices.isEmpty) {
      voices = await _tts.getVoices;
      print(json.encode(voices));
    }
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
    double rate = 1,
    double pitch = 1.0,
  ]) async {
    _initVoice();
    if (voices.isNotEmpty) {
      final names = name.split(',');
      final locales = locale.split(',');
      final voice = voices.firstWhere(
        (v) =>
            names.any((n) => v['name'].contains(n)) &&
            locales.any((l) => v['locale'].contains(l)),
        orElse: () => voices[0],
      );
      print(voice);
      await _tts.setVoice({'name': voice['name'], 'locale': voice['locale']});
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(pitch);
    }
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
