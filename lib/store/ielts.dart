import 'package:chatuni/io/player.dart';
import 'package:chatuni/io/recognizer.dart';
import 'package:chatuni/io/videoplayer.dart';
import 'package:chatuni/models/ielts.dart';
import 'package:chatuni/utils/const.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

import '/api/course.dart';

part 'ielts.g.dart';

class Ielts = _Ielts with _$Ielts;

const List<String> tags = ['h1', 'h2', 'h3', 'h4', 'b', 'i', 'ul', 'img'];
const List<String> comps = ['Listening', 'Reading', 'Writing', 'Speaking'];

abstract class _Ielts with Store {
  final Player _player = Player();
  final VideoPlayer _videoPlayer = VideoPlayer();
  // final Recorder _recorder = Recorder();
  final Recognizer _stt = Recognizer();

  get videoControllers => _videoPlayer.controllers;

  @observable
  var allTests = ObservableList<Test>();

  @observable
  Test? test;

  @observable
  String? component;

  @observable
  Part? part;

  @observable
  List<Part> parts = [];

  @observable
  Group? group;

  @observable
  int questionIndex = 0;

  @observable
  bool isPlaying = false;

  @observable
  bool isRecording = false;

  @observable
  bool isChecking = false;

  @observable
  bool isScoring = false;

  @observable
  int rc = 0;

  @computed
  List<MapEntry<int, List<Test>>> get tests =>
      groupBy(allTests, (x) => int.parse(x.id.split('-').first))
          .entries
          .toList();

  @computed
  bool get isCompSelected =>
      test != null && component != null && parts.isNotEmpty;

  @computed
  bool get isPartSelected => isCompSelected && part != null;

  @computed
  int get partIndex =>
      isPartSelected ? parts.indexWhere((p) => p.name == part!.name) : -1;

  @computed
  bool get isFirstPart => partIndex == 0;

  @computed
  bool get isLastPart => isPartSelected && partIndex == parts.length - 1;

  @computed
  int get compIndex => isCompSelected ? comps.indexOf(component!) : -1;

  @computed
  String get nextComponent => comps[nextCompIndex(1)];

  @computed
  String get prevComponent => comps[nextCompIndex(-1)];

  @computed
  bool get isFirstComp => compIndex == 0;

  @computed
  bool get isLastComp => isCompSelected && compIndex == comps.length - 1;

  @computed
  List<List<Part>> get allComps =>
      test == null ? [] : [test!.listen, test!.read, test!.write, test!.speak];

  @computed
  List<Part> get allParts => allComps.expand((c) => c).toList();

  @computed
  List<Question> get partQuestions => getPartQuestions(part);

  @computed
  Question get writeQuestion => getQuestion(partIndex + 1)!;

  @computed
  List<Question> get writeQuestions =>
      test!.write.expand(getPartQuestions).toList();

  @computed
  List<Question> get speakQuestions =>
      test!.speak.expand(getPartQuestions).toList();

  @computed
  bool get isLastQuestion => questionIndex == partQuestions.length - 1;

  @action
  Future<void> loadTests() async {
    allTests.clear();
    var ts = await fetchIelts();
    allTests.addAll(ts);
  }

  @action
  void selectTest(Test t) {
    test = t;
<<<<<<< HEAD
    part = t.listen[1];
    group = part!.groups.first;
=======
    _resetTest();
    setComp(0);
    isChecking = false;
>>>>>>> 8468654325068d43b91c353b51e1dee963bc0e6d
  }

  @action
  void setComp(int idx) {
    if (test == null) {
      component = null;
    } else {
      component = comps[idx];
      parts = allComps[idx];
      firstPart();
    }
  }

  @action
  void nextComp(int step) => setComp(nextCompIndex(step));

  @action
  void nextPart(int step) {
    if (test == null || parts.isEmpty) {
      part = null;
    } else if (part == null) {
      part = parts.first;
    } else {
      part = parts[(partIndex + step).clamp(0, parts.length - 1)];
      partSelected();
    }
    rc++;
  }

  @action
  void firstPart() {
    if (parts.isNotEmpty) {
      part = parts.first;
      partSelected();
    }
  }

  @action
  Future<void> partSelected() async {
    group = part!.groups.first;
    // isChecking = false;
    isPlaying = false;
    if (compIndex == 3) {
      questionIndex = 0;
      if (partIndex != 1) {
        await _videoPlayer.setUrls(
          partQuestions
              .map((q) => cdMp4('${test!.id}-${partIndex + 1}-${q.number}'))
              .toList(),
        );
      }
    }
  }

  @action
  void fill(int num, String answer) {
    final q = getQuestion(num);
    if (q != null) q.userAnswer = answer;
  }

  @action
  void trueFalseSelect(Question q, String answer) {
    q.userAnswer = answer;
    rc++;
  }

  @action
  void singleSelect(Question q, String answer) {
    if (q.userAnswer == answer) {
      q.userAnswer = null;
    } else {
      q.userAnswer = answer;
    }
    rc++;
  }

  @action
  void multiSelect(Question q1, Question q2, String answer) {
    if (q1.userAnswer == null) {
      q1.userAnswer = answer;
    } else if (q2.userAnswer == null) {
      final r = q1.userAnswer!.compareTo(answer);
      if (r < 0) {
        q2.userAnswer = answer;
      } else if (r > 0) {
        q2.userAnswer = q1.userAnswer;
        q1.userAnswer = answer;
      } else {
        q1.userAnswer = null;
      }
    } else {
      if (q1.userAnswer == answer) q1.userAnswer = null;
      if (q2.userAnswer == answer) q2.userAnswer = null;
    }
    rc++;
  }

  @action
  void checkAnswers(int idx) {
    setComp(idx);
    isChecking = true;
  }

  @action
  void play() {
    _player.play(cdMp3('${test!.id}-${partIndex + 1}'));
    isPlaying = true;
  }

  @action
  void stop() {
    _player.stop();
    isPlaying = false;
  }

  @action
  Future<void> startRecording() async {
    // _recorder.start();
    await _stt.start('en');
    isRecording = true;
  }

  @action
  Future<void> stopRecording(Question q) async {
    //await _recorder.stop();
    await _stt.stop();
    if (_stt.lastMsg != '') {
      q.userAnswer = _stt.lastMsg;
      _stt.clear();
    }
    isRecording = false;
    //await _player.play(_recorder.playPath);
  }

  @action
  void write(String t) {
    writeQuestion.userAnswer = t;
  }

  @action
  void playVideo(int num) {
    _videoPlayer.play(num - 1);
  }

  @action
  void nextQuestion() {
    questionIndex = (questionIndex + 1).clamp(0, partQuestions.length - 1);
  }

  @action
  Future score() async {
    isScoring = true;
    for (var q in [...writeQuestions, ...speakQuestions]) {
      if (q.userAnswer != null && q.userAnswer != '') {
        q.answer = await writeScore(q.userAnswer!);
        final m = RegExp('Score: (\\d+)').firstMatch(q.answer!);
        if (m != null) q.score = m.group(1);
      }
    }
    isScoring = false;
  }

  List<Question> getPartQuestions(Part? part) => part == null
      ? []
      : part.groups
          .expand((g) => g.paragraphs)
          .expand<Question>((p) => p.questions ?? [])
          .toList();

  Question? getQuestion(int num) =>
      getPartQuestions(part).firstWhereOrNull((q) => q.number == num);

  String? checkAnswer(int num) {
    final q = getQuestion(num);
    return q == null
        ? 'No such question'
        : q.userAnswer != q.answer
            ? q.answer
            : null;
  }

  int nextCompIndex(int step) => (compIndex + step).clamp(0, comps.length - 1);

  List<Question> allQuestions(int comp) =>
      allComps[comp].expand(getPartQuestions).toList();

  int numOfCorrect(int comp) =>
      allQuestions(comp).where((q) => q.answer == q.userAnswer).length;

  List<int> incorrectQuestions(int comp) => allQuestions(comp)
      .where((q) => q.answer != q.userAnswer)
      .map((q) => q.number)
      .toList();

  int choiceColor(Choice c) => isChecking
      ? c.isWrong
          ? Colors.red
          : c.isActual
              ? Colors.green
              : Colors.black
      : c.isSelected
          ? Colors.blue
          : Colors.black;

  bool boldChoice(Choice c) => isChecking && c.isActual || c.isSelected;

  (String, String?) contentTag(String s) {
    final tag = tags.firstWhereOrNull((t) => s.startsWith('<$t>'));
    return (tag != null ? s.replaceFirst('<$tag>', '') : s, tag);
  }

  (int, String?, String?) parseFill(String s) {
    RegExp re = RegExp(r'(\d{1,2}).*?([\._…]{6,})');
    final match = re.firstMatch(s);
    if (match == null) return (-1, null, null);
    final num = int.parse(match.group(1)!);
    final blank = match.group(2)!;
    final ss = s.split(blank);
    return (num, ss[0], ss[1]);
  }

  void _createQuestions() {
    lidx(test!.write).forEach((i) {
      final g = test!.write[i].groups[0];
      if (g.paragraphs.last.type != 'write') {
        g.paragraphs.add(
          Paragraph()
            ..type = 'write'
            ..content = []
            ..questions = [
              Question()..number = i + 1,
            ],
        );
      }
    });
  }

  void _resetTest() {
    _createQuestions();
    allParts.forEach(
      (p) => getPartQuestions(p).forEach((q) => q.userAnswer = null),
    );
    // writeQuestions[0].userAnswer = 'How is you doing';
    // writeQuestions[1].userAnswer = 'you do good';
  }

  _Ielts() {
    loadTests();
  }

  void dispose() {
    _player.dispose();
  }
}
