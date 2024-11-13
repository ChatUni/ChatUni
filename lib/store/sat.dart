import 'package:chatuni/io/player.dart';
import 'package:chatuni/io/recognizer.dart';
import 'package:chatuni/io/videoplayer.dart';
import 'package:chatuni/models/ielts.dart';
import 'package:chatuni/utils/const.dart';
import 'package:chatuni/utils/event.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

import '/api/course.dart';

part 'sat.g.dart';

// ignore: library_private_types_in_public_api
class Sat = _Sat with _$Sat;

// const List<String> tags = ['h1', 'h2', 'h3', 'h4', 'b', 'i', 'ul', 'img'];
const List<String> comps = [
  'Listening',
  'Reading and Writing', // Reading and Writing , Math
  'Writing',
  'Speaking',
];
const int _timeLimit = 10;
const int _timeAlert = 5;

const onCountdownEvent = 'SAT_Countdown';

abstract class _Sat with Store {
  final Player _player = Player();
  final VideoPlayer _videoPlayer = VideoPlayer();
  // final Recorder _recorder = Recorder();
  final Recognizer _stt = Recognizer();
  int currentIndex = 0;
  int _tid = 0;

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
  Paragraph? currentParagraph;

  @observable
  List<Part> parts = [];

  @observable
  List<Paragraph> paragraphs = [];

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
  int countDown = 0;

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
  bool get isLastPart =>
      (isPartSelected && partIndex == parts.length - 1) || parts.isEmpty;

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

  @computed
  bool get hasTimer => !isChecking && compIndex > 0 && compIndex < 3;

  @computed
  String get timeLeftSat => hasTimer
      ? RegExp('^\\d{1,2}:(\\d+):(\\d+)\\.')
          .firstMatch(Duration(seconds: countDown).toString())!
          .groups([1, 2]).join(':')
      : '';

  @computed
  bool get isTimeLeftAlertSat => countDown < _timeAlert;

  @action
  Future<void> loadTests() async {
    allTests.clear();
    var ts = await fetchsat();
    allTests.addAll(ts);
    //part = allTests[0].write.first;
  }

  @action
  void selectTest(Test t) {
    test = t;
    _resetTest();
    setComp(0);
    isChecking = false;
  }

  @action
  void nextTest() {
    print("""'Next Test' ${allTests.length}""");
    test = allTests[(currentIndex + 1) % allTests.length];

    test!.speak.forEach((s) {
      s.groups.forEach((g) {
        paragraphs.addAll(g.paragraphs);
      });
    });
    test!.speak.clear();
    int index = 0;
    paragraphs.forEach((para) {
      Group group1 = Group();
      group1.paragraphs = [para];
      Part part1 = Part();
      part1.name = index.toString();
      part1.groups = [group1];
      test!.speak.add(part1);
      index++;
    });
    //currentParagraph = part!.groups.write.paragraphs.first;
    part = test!.speak.first;
    _resetTest();
    setComp(3);
    isChecking = false;
  }

  @action
  void setComp(int idx) {
    if (test == null) {
      component = null;
    } else {
      component = comps[idx];
      parts = allComps[idx];
      startTimer();
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
        // await _videoPlayer.setUrls(
        //   partQuestions
        //       .map((q) => cdMp4('${test!.id}-${partIndex + 1}-${q.number}'))
        //       .toList(),
        // );
      }
    }
  }

  @action
  void nextParagraph(int step) {
    if (test == null || paragraphs.isEmpty) {
      currentParagraph = null;
    } else if (currentParagraph == null) {
      currentParagraph = paragraphs.first;
    } else {
      currentParagraph =
          paragraphs[(partIndex + step).clamp(0, paragraphs.length - 1)];
      partSelected();
    }
    rc++;
  }

  @action
  void firstParagraph() {
    if (paragraphs.isNotEmpty) {
      currentParagraph = paragraphs.first;
      paragraphSelected();
    }
  }

  @action
  Future<void> paragraphSelected() async {
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

  @action
  void startTimer() {
    if (_tid > 0) stopTimer(_tid);
    if (hasTimer) {
      countDown = _timeLimit;
      _tid = timer(1, updateTimer);
    }
  }

  @action
  bool updateTimer() {
    if (countDown > 0) {
      countDown--;
      rc++;
    }
    if (countDown == 0) {
      _tid = 0;
      raiseEvent(onCountdownEvent, true);
      nextComp(1);
      return true;
    }
    return false;
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

  // (String, String?) contentTag(String s) {
  //   final tag = tags.firstWhereOrNull((t) => s.startsWith('<$t>'));
  //   return (tag != null ? s.replaceFirst('<$tag>', '') : s, tag);
  // }

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

  _Sat() {
    loadTests();
  }

  void dispose() {
    _player.dispose();
  }
}
