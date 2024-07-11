import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatuni/utils/event.dart';

const onPlayingEvent = 'AudioPlayer_Playing';

class Player {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String url) async {
    await _player.play(UrlSource(url));
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Player() {
    _player.onPlayerStateChanged
        .listen((e) => raiseEvent(onPlayingEvent, e == PlayerState.playing));
  }

  void dispose() {
    disposeEvent(onPlayingEvent);
    _player.dispose();
  }
}
