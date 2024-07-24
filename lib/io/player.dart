import 'dart:async';

//import 'package:audioplayers/audioplayers.dart';
import 'package:chatuni/utils/event.dart';
import 'package:just_audio/just_audio.dart';

const onPlayingEvent = 'AudioPlayer_Playing';

class Player {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String url) async {
    //await _player.play(UrlSource(url));
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> playBytes(List<int> bytes) async {
    //await _player.play(BytesSource(bytes));
    await _player.setAudioSource(MyCustomSource(bytes));
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Player() {
    // _player.onPlayerStateChanged
    //     .listen((e) => raiseEvent(onPlayingEvent, e == PlayerState.playing));
    _player.playerStateStream.listen((e) {
      if (e.processingState == ProcessingState.ready) {
        raiseEvent(onPlayingEvent, true);
      }
      if (e.processingState == ProcessingState.completed) {
        raiseEvent(onPlayingEvent, false);
      }
    });
  }

  void dispose() {
    disposeEvent(onPlayingEvent);
    _player.dispose();
  }
}

class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
