import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobx/mobx.dart';
import '../models/tutor.dart';
import '../models/msg.dart';
import '../api.dart';
import '../io/recorder.dart';
import '../io/player.dart';
import '../io/recognizer.dart';

part 'tutors.g.dart';

class Tutors = _Tutors with _$Tutors;

const useLocalRecognition = kIsWeb;

abstract class _Tutors with Store {
  final Recorder _recorder = Recorder();
  final Player _player = Player();
  final Recognizer _stt = Recognizer();

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
  }

  @action
  Future<void> selectTutor(Tutor t) async {
    tutor = t;
    final msg = await loadMsg(
      true,
      () => greeting(t.id),
    );
    if (msg != null) {
      await addAIMsg(Msg()
        ..text = msg
        ..isAI = true);
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
      await _stt.stop();
      if (_stt.lastMsg != '') {
        await voice(TransResult()..originaltext = _stt.lastMsg);
        _stt.clear();
      }
    } else {
      await _recorder.stop();
      await _player.play(_recorder.playPath);
      await trans();
    }
  }

  @action
  Future<void> read(Msg m) async {
    if (isReading) {
      await _player.stop();
      m.isReading = false;
    } else {
      if (m.url != '') {
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
    msgs.add(Msg()
      ..isWaiting = true
      ..isAI = isAI);
  }

  Future<T> loadMsg<T>(bool isAI, Future<T> Function() api) async {
    addLoadingMsg(isAI);
    final r = await api();
    msgs.removeLast();
    return r;
  }

  Future<void> voice(TransResult result) async {
    Msg msg = addMsg(result.originaltext);
    Msg? aiMsg = await loadMsg(
      true,
      () => chatVoice(msg, tutor!, result.audiofile),
    );
    await addAIMsg(aiMsg);
  }

  Future<void> trans() async {
    TransResult? transResult = await loadMsg(
      false,
      () => chatTrans(_recorder.path, tutor!.id),
    );
    if (transResult != null && transResult.originaltext != '') {
      await voice(transResult);
    }
  }

  void onPlaying(bool isPlaying) {
    isReading = isPlaying;
    if (!isPlaying) {
      msgs.forEach((m) {
        m.isReading = false;
      });
    }
  }

  _Tutors() {
    loadTutors();
    _player.onPlaying.listen(onPlaying);
  }

  void dispose() {
    _player.dispose();
    _recorder.dispose();
  }
}
