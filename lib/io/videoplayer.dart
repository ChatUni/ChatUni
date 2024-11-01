import 'dart:async';

// import 'package:chatuni/utils/event.dart';
import 'package:video_player/video_player.dart';

const onVideoPlayingEvent = 'VideoPlayer_Playing';

class VideoPlayer {
  List<VideoPlayerController> controllers = [];

  Future<void> setUrls(List<String> urls) async {
    controllers = urls
        .map(
          (url) => VideoPlayerController.networkUrl(
            Uri.parse(url),
          ),
        )
        .toList();
    for (var c in controllers) {
      await c.initialize();
    }
  }

  Future<void> play(int n) async {
    controllers[n].play();
  }

  Future<void> stop(int n) async {
    await controllers[n].pause();
  }

  void clear() {
    controllers.clear();
  }

  VideoPlayer() {
    // setUrl(url);
    // _player.onPlayerStateChanged
    //     .listen((e) => raiseEvent(onPlayingEvent, e == PlayerState.playing));
  }

  void dispose() {
    controllers.forEach((c) => c.dispose());
  }
}
