import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class Player {
  final AudioPlayer _player = AudioPlayer();
  final StreamController<bool> _onPlayingController = StreamController<bool>();

  Stream<bool> get onPlaying => _onPlayingController.stream;

  Future<void> play(String url) async {
    await _player.play(UrlSource(url));
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Player() {
    _player.onPlayerStateChanged.listen((e) {
      _onPlayingController.add(e == PlayerState.playing);
    });
  }

  void dispose() {
    _onPlayingController.close();
    _player.dispose();
  }
}
