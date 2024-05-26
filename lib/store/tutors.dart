import 'dart:convert';
import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:audioplayers/audioplayers.dart' as AP;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../api.dart';

part 'tutors.g.dart';

class Tutors = _Tutors with _$Tutors;

const useLocalRecognition = true;

abstract class _Tutors with Store {
  SpeechToText stt = SpeechToText();
  AP.AudioPlayer player = AP.AudioPlayer();
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  String audioPath = '';
  bool speechEnabled = false;
  String lastMsg = '';

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
  void selectTutor(Tutor t) {
    tutor = t;
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
      if (!speechEnabled) await initSpeech();
      await stt.listen(onResult: onSpeechResult, localeId: lang);
    } else {
      await requestMicPermission();
      await recorder.startRecorder(toFile: audioPath, codec: Codec.pcm16WAV);
    }
    isRecording = true;
  }

  @action
  Future<void> stopRecording() async {
    isRecording = false;
    if (useLocalRecognition) {
      await stt.stop();
      if (lastMsg != '') {
        await voice(lastMsg);
        lastMsg = '';
      }
    } else {
      await recorder.stopRecorder();
      await trans();
    }
  }

  @action
  Future<void> read(Msg m) async {
    if (isReading) {
      await player.stop();
      m.isReading = false;
    } else {
      if (m.url != '') {
        await player.setSourceUrl(m.url);
        m.isReading = true;
        player.resume();
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

  void addLoadingMsg(bool isAI) {
    msgs.add(Msg()
      ..isWaiting = true
      ..isAI = isAI);
  }

  Future<void> voice(String text) async {
    Msg msg = addMsg(text);
    addLoadingMsg(true);
    Msg? aiMsg = await chatVoice(msg, tutor!);
    msgs.removeLast();
    if (aiMsg != null) {
      msgs.add(aiMsg);
      await read(aiMsg);
    }
  }

  Future<void> trans() async {
    addLoadingMsg(false);
    String recognized = await chatTrans(audioPath, tutor!.id);
    msgs.removeLast();
    if (recognized != '') await voice(recognized);
  }

  Future<void> initSpeech() async {
    speechEnabled = await stt.initialize();
  }

  Future<void> initRecorder() async {
    await recorder.openRecorder();
    final tempDir = await getTemporaryDirectory();
    audioPath = '${tempDir.path}/temp.wav';
    await requestMicPermission();
  }

  Future<void> requestMicPermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    var txt = result.recognizedWords;
    if (txt != '') lastMsg = txt;
  }

  _Tutors() {
    initRecorder();

    loadTutors();

    player.onPlayerStateChanged.listen((e) {
      if (e == AP.PlayerState.playing) {
        isReading = true;
      } else {
        isReading = false;
        msgs.forEach((m) {
          m.isReading = false;
        });
      }
    });
  }

  void dispose() {
    player.dispose();
    //recorder.dispose();
    recorder.closeRecorder();
  }
}

@JsonSerializable()
class Tutor {
  int id = 0;
  int type = 1;
  int level = 1;
  double speed = 1;
  String speed2 = "";
  String name = "";
  String gender = "";
  int icon = 0;
  String voice = "";
  String personality = "";
  String skill = "";
  String desc = "";

  Tutor();

  factory Tutor.fromJson(Map<String, dynamic> json) => _$TutorFromJson(json);

  Map<String, dynamic> toJson() => _$TutorToJson(this);
}

@JsonSerializable()
class Msg {
  int id = 0;
  String text = '';
  String lang = '';
  bool isAI = false;
  String voice = '';
  String url = '';
  bool isReading = false;
  bool isWaiting = false;

  Msg();

  factory Msg.fromJson(Map<String, dynamic> json) => _$MsgFromJson(json);

  Map<String, dynamic> toJson() => _$MsgToJson(this);
}
