import 'dart:io';

import 'package:chatuni/api/openai.dart';
import 'package:chatuni/api/youdao.dart';
import 'package:chatuni/io/websocket.dart';
import 'package:chatuni/utils/event.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '/api/tutor.dart';
import '/io/player.dart';
import '/io/recognizer.dart';
import '/io/tts.dart';
import '/models/msg.dart';
import '/models/tutor.dart';

part 'tutors.g.dart';

class Tutors = _Tutors with _$Tutors;

const useLocalRecognition = true;
const useLocalTextToSpeech = false;
const useMidLayerTts = false;

abstract class _Tutors with Store {
  // final Recorder _recorder = Recorder();
  final Player _player = Player();
  final Recognizer _stt = Recognizer();
  // final TextToSpeech _tts = TextToSpeech();
  // final _rtc = WebRTC();
  final Ably ably = Ably();

  @observable
  bool isRecording = false;

  @observable
  bool isReading = false;

  @observable
  bool isScenario = false;

  @observable
  var tutors = ObservableList<Tutor>();

  @observable
  Tutor? tutor;

  @observable
  var msgs = ObservableList<Msg>();

  @observable
  String lang = 'en';

  @computed
  bool get isTutorSelected => tutor != null;

  @computed
  bool get isAvatar => isTutorSelected && tutor!.level == 0;

  @action
  Future<void> loadTutors() async {
    tutors.clear();
    var ts = await fetchTutors();
    tutors.addAll(ts);
  }

  @action
  Future<void> selectTutor(Tutor t) async {
    tutor = t;
    // await _tts.setVoice(t.voice, t.locale ?? 'en-US', t.speed);
    // _rtc.createPC(
    //   'https://create-images-results.d-id.com/google-oauth2|115115236146534848384/upl_HJNFFUCs2NaEGsfiZ1ecN/image.jpeg',
    // );
    if (isAvatar) {
      addLoadingMsg(true);
    } else {
      final msg = t.greetings;
      if (msg != null) {
        await addAIMsg(
          Msg()
            ..text = msg
            ..isAI = true,
        );
      }
    }
  }

  @action
  void clearTutor() {
    tutor = null;
    msgs.clear();
  }

  @action
  void setLang(String l) {
    lang = l;
  }

  @action
  void setScenario(bool s) {
    isScenario = s;
  }

  @action
  Future<void> startRecording() async {
    if (useLocalRecognition) {
      await _stt.start(lang);
    } else {
      // await _recorder.start();
    }
    isRecording = true;
  }

  @action
  Future<void> stopRecording() async {
    isRecording = false;
    if (useLocalRecognition) {
      if (!kIsWeb && Platform.isAndroid) {
        await Future.delayed(const Duration(seconds: 1));
      }
      await _stt.stop();
      if (_stt.lastMsg != '') {
        await voice(_stt.lastMsg);
        _stt.clear();
      }
    } else {
      // await _recorder.stop();
      //await _player.play(_recorder.playPath);
      //await trans();
    }
  }

  @action
  Future<void> read(Msg m) async {
    if (!m.isAI || isAvatar) return;
    if (isReading) {
      if (useLocalTextToSpeech) {
        // await _tts.stop();
      } else {
        await _player.stop();
      }
      m.isReading = false;
    } else {
      if (useLocalTextToSpeech) {
        // if (m.text != '') {
        //   await _tts.speak(m.text);
        //   m.isReading = true;
        // }
      } else {
        if (m.url != '') {
          await _player.play(m.url);
          m.isReading = true;
        } else {
          addLoadingMsg(true);
          final bytes = await ttsyd(m.text, tutor!.voice);
          msgs.removeLast();
          await _player.playBytes(bytes);
          m.isReading = true;
        }
      }
    }
  }

  Msg addMsg(String text) {
    var msg = Msg()
      ..text = text
      ..lang = lang;
    msgs.add(msg);
    return msg;
  }

  Future<void> addAIMsg(Msg? aiMsg) async {
    if (aiMsg != null) {
      removeLoadingMsg();
      msgs.add(aiMsg);
      if (!isAvatar) await read(aiMsg);
    }
  }

  void addLoadingMsg(bool isAI) {
    msgs.add(
      Msg()
        ..isWaiting = true
        ..isAI = isAI,
    );
  }

  void removeLoadingMsg() {
    if (msgs.isNotEmpty && msgs.last.isWaiting) {
      msgs.removeLast();
    }
  }

  Future<T> loadMsg<T>(bool isAI, Future<T> Function() api) async {
    addLoadingMsg(isAI);
    final r = await api();
    msgs.removeLast();
    return r;
  }

  Future<void> voice(String text) async {
    Msg msg = addMsg(text);
    if (isAvatar) {
      // _rtc.sendMsg(msg.text);
      addLoadingMsg(true);
      ably.send('q', text);
    } else {
      Msg? aiMsg = await loadMsg(
        true,
        () => (useMidLayerTts ? chatVoice(msg, tutor!) : chatComplete(msgs)),
      );
      await addAIMsg(aiMsg);
    }
  }

  // Future<void> trans() async {
  //   TransResult? transResult = await loadMsg(
  //     false,
  //     () => chatTrans(_recorder.path, tutor!.id),
  //   );
  //   if (transResult != null && transResult.originaltext != '') {
  //     await voice(transResult.originaltext);
  //   }
  // }

  // getVoices() => _tts.voices
  //     .where((v) => v['locale'] == 'en-US')
  //     .map((v) => v['name'])
  //     .join(',');

  // getRTCRenderer() => _rtc.remoteRenderer;

  void _onPlaying(bool isPlaying) {
    print(isPlaying ? 'Started talking' : 'Finished talking');
    isReading = isPlaying;
    if (!isPlaying) {
      for (var m in msgs) {
        m.isReading = false;
      }
    }
  }

  void _onTtsState(TtsState state) {
    isReading = state == TtsState.playing;
    if (!isReading) {
      for (var m in msgs) {
        m.isReading = false;
      }
    }
  }

  _Tutors() {
    loadTutors();
    listenToEvent(onPlayingEvent, _onPlaying);
    // _tts.onTtsState.listen(_onTtsState);
    ably.listen(
      'a',
      (msg) => addAIMsg(
        Msg()
          ..text = msg.toString()
          ..isAI = true,
      ),
    );
  }

  void dispose() {
    _player.dispose();
    // _recorder.dispose();
  }
}
