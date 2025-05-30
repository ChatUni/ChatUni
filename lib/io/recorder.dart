import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

const tempFile = 'temp.wav';
const prefix = 'file:///private';

class Recorder {
  final Record _recorder = Record();
  String path = '';

  bool get isIOS => !kIsWeb && Platform.isIOS;

  String get playPath =>
      isIOS && !path.startsWith(prefix) ? '$prefix$path' : path;

  Future<void> _init() async {
    // await _recorder.openRecorder();
    // await _requestMicPermission();
    final tempDir =
        kIsWeb ? '/' : await getTemporaryDirectory().then((r) => r.path);
    path = '$tempDir/$tempFile';
  }

  // Future<void> _requestMicPermission() async {
  //   PermissionStatus status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw Exception("Microphone permission not granted");
  //   }
  // }

  Future<void> start() async {
    // await _requestMicPermission();
    if (await _recorder.hasPermission()) {
      await _recorder.start(
        path: path,
        encoder: isIOS ? AudioEncoder.pcm16bit : AudioEncoder.wav,
        numChannels: 2,
        samplingRate: 16000,
      );
    }
    // await _recorder.startRecorder(toFile: path, codec: Codec.pcm16WAV);
  }

  Future<void> stop() async {
    final p = await _recorder.stop();
    if (p != null) {
      path = p;
    }
    // await _recorder.stopRecorder();
  }

  Recorder() {
    _init();
  }

  void dispose() {
    _recorder.dispose();
    // await _recorder.closeRecorder();
  }
}
