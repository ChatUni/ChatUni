import 'dart:io';

import 'package:chatuni/api/openai.dart';
import 'package:chatuni/api/payment.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/tutor.dart';
import '../io/player.dart';
import '../io/recognizer.dart';
import '../io/recorder.dart';
import '../io/tts.dart';
import '../models/msg.dart';
import '../models/tutor.dart';

part 'tutors.g.dart';

class Tutors = _Tutors with _$Tutors;

const useLocalRecognition = true;
const useLocalTextToSpeech = true;

abstract class _Tutors with Store {
  final Recorder _recorder = Recorder();
  final Player _player = Player();
  final Recognizer _stt = Recognizer();
  final TextToSpeech _tts = TextToSpeech();

  @observable
  bool isRecording = false;

  @observable
  bool isReading = false;

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

  @action
  Future<void> loadTutors() async {
    tutors.clear();
    var ts = await fetchTutors();
    tutors.addAll(ts);
    var t = await getPriceList();
    print(t);
    t = await createPayorder();
    print(t['payurl']);
    await launchUrl(Uri.parse(t['payurl']));
  }

  @action
  Future<void> selectTutor(Tutor t) async {
    tutor = t;
    await _tts.setVoice(t.voice, t.locale ?? 'en-US', t.speed);
    final msg = await loadMsg(
      true,
      () => greeting(t.id),
    );
    if (msg != null) {
      await addAIMsg(
        Msg()
          ..text = msg
          ..isAI = true,
      );
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
  Future<void> startRecording() async {
    if (useLocalRecognition) {
      await _stt.start(lang);
    } else {
      await _recorder.start();
    }
    isRecording = true;
  }

  @action
  Future<void> stopRecording() async {
    isRecording = false;
    if (useLocalRecognition) {
      if (Platform.isAndroid) await Future.delayed(const Duration(seconds: 1));
      await _stt.stop();
      if (_stt.lastMsg != '') {
        await voice(_stt.lastMsg);
        _stt.clear();
      }
    } else {
      await _recorder.stop();
      //await _player.play(_recorder.playPath);
      //await trans();
    }
  }

  @action
  Future<void> read(Msg m) async {
    if (!m.isAI) return;
    if (isReading) {
      useLocalTextToSpeech ? await _tts.stop() : await _player.stop();
      m.isReading = false;
    } else {
      if (useLocalTextToSpeech && m.text != '') {
        await _tts.speak(m.text);
        m.isReading = true;
      } else if (!useLocalTextToSpeech && m.url != '') {
        await _player.play(m.url);
        m.isReading = true;
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
      msgs.add(aiMsg);
      await read(aiMsg);
    }
  }

  void addLoadingMsg(bool isAI) {
    msgs.add(
      Msg()
        ..isWaiting = true
        ..isAI = isAI,
    );
  }

  Future<T> loadMsg<T>(bool isAI, Future<T> Function() api) async {
    addLoadingMsg(isAI);
    final r = await api();
    msgs.removeLast();
    return r;
  }

  Future<void> voice(String text) async {
    Msg msg = addMsg(text);
    Msg? aiMsg = await loadMsg(
      true,
      () => chatComplete(msgs), // chat(msg, tutor!),
    );
    await addAIMsg(aiMsg);
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

  void onPlaying(bool isPlaying) {
    isReading = isPlaying;
    if (!isPlaying) {
      for (var m in msgs) {
        m.isReading = false;
      }
    }
  }

  void onTtsState(TtsState state) {
    isReading = state == TtsState.playing;
    if (!isReading) {
      for (var m in msgs) {
        m.isReading = false;
      }
    }
  }

  _Tutors() {
    loadTutors();
    _player.onPlaying.listen(onPlaying);
    _tts.onTtsState.listen(onTtsState);
  }

  void dispose() {
    _player.dispose();
    _recorder.dispose();
  }
}
