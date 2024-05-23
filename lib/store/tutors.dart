import 'dart:convert';
import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../api.dart';

part 'tutors.g.dart';

class Tutors = _Tutors with _$Tutors;

const useLocalRecognition = false;

abstract class _Tutors with Store {
  SpeechToText stt = SpeechToText();
  AudioPlayer player = AudioPlayer();
  Record recorder = Record();
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
      if (await recorder.hasPermission()) {
        await recorder.start();
      }
    }
    isRecording = true;
  }

  @action
  Future<void> stopRecording() async {
    isRecording = false;
    if (useLocalRecognition) {
      await stt.stop();
      if (lastMsg != '') {
        await chat(lastMsg);
        lastMsg = '';
      }
    } else {
      String? path = await recorder.stop();
      log(path ?? '');
      if (path != null) {
        audioPath = path;
        // player.play(UrlSource(path));
        String trans = await chatTrans(path);
        if (trans != '') await chat(trans);
      }
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

  Future<void> chat(String text) async {
    var msg = Msg()
      ..text = text
      ..lang = lang;
    msgs.add(msg);
    msgs.add(Msg()
      ..isWaiting = true
      ..isAI = true);
    Msg? aiMsg = await chatVoice(msg, tutor!);
    msgs.removeLast();
    if (aiMsg != null) {
      msgs.add(aiMsg);
      await read(aiMsg);
    }
  }

  Future<void> initSpeech() async {
    speechEnabled = await stt.initialize();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    var txt = result.recognizedWords;
    if (txt != '') lastMsg = txt;
  }

  _Tutors() {
    loadTutors();

    player.onPlayerStateChanged.listen((e) {
      if (e == PlayerState.playing) {
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
    recorder.dispose();
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
