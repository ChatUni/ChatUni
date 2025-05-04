import 'package:chatuni/globals.dart';
import 'package:chatuni/io/player.dart';
import 'package:chatuni/io/recognizer.dart';
import 'package:chatuni/io/videoplayer.dart';
import 'package:chatuni/models/exam.dart';
import 'package:chatuni/utils/const.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

import '/api/course.dart';

part 'exam.g.dart';

class Exam = _Exam with _$Exam;

final examConfig = {
  'Ielts': {
    'title': 'IELTS Academy',
    'components': [
      Component('listen', 'Listening', 0),
      Component('read', 'Reading', 3600),
      Component('write', 'Writing', 3600),
      Component('speak', 'Speaking', 0),
    ],
    'mp3Url': (Exam exam) => '${exam.test!.id}-${exam.partIndex + 1}',
  },
  'TOEFL': {
    'title': 'TOEFL',
    'components': [
      Component('listen', 'Listening', 0),
      Component('read', 'Reading', 0),
      Component('write', 'Writing', 0),
      Component('speak', 'Speaking', 0),
    ],
    'mp3Url': (Exam exam) =>
        '${exam.test!.id}-${exam.compIndex + 1}-${exam.partIndex + 1}',
  },
  'SAT': {
    'title': 'SAT Practice Test',
    'components': [
      Component('read1', 'Read & Write 1', 3600),
      Component('read2', 'Read & Write 2', 3600),
      Component('math1', 'Math 1', 3600),
      Component('math2', 'Math 2', 3600),
    ],
  },
  'JLPT': {
    'title': 'Japanese Language Proficiency Test',
    'components': [
      Component('test', '', 3600),
    ],
  },
};

const List<String> tags = [
  'h1',
  'h2',
  'h3',
  'h4',
  'b',
  'i',
  'ul',
  'img',
  'mp3',
];
const int _timeAlert = 5 * 60;

const onCountdownEvent = 'Exam_Countdown';

abstract class _Exam with Store {
  final Player _player = Player();
  final VideoPlayer _videoPlayer = VideoPlayer();
  // final Recorder _recorder = Recorder();
  final Recognizer _stt = Recognizer();
  int _tid = 0;

  get videoControllers => _videoPlayer.controllers;

  @observable
  String name = '';

  @observable
  var allTests = ObservableList<Test>();

  @observable
  Test? test;

  @observable
  Component? component;

  @observable
  int partIndex = 0;

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
  int countDown = 0;

  @observable
  bool timeIsUp = false;

  @observable
  List<Result> results = [];

  @observable
  Result? result;

  @observable
  Map<int, Map<String, List<ExQuestion>>> explains = {};

  @observable
  bool isExplain = false;

  @observable
  int rc = 0;

  @computed
  bool get isIelts => name == 'Ielts';

  @computed
  bool get isToefl => name == 'TOEFL';

  @computed
  bool get hasFixedAudio =>
      (isIelts && component != null && component!.isListen) ||
      (isToefl && component != null && component!.isSpeak && partIndex == 0);

  @computed
  List<Component> get comps => test == null ? [] : test!.components;

  @computed
  List<String> get compNames => comps.map((c) => c.name).toList();

  // @computed
  // List<MapEntry<int, List<Test>>> get tests =>
  //     groupBy(allTests, (x) => int.parse(x.id.split('-').first))
  //         .entries
  //         .toList();

  @computed
  bool get isCompSelected =>
      test != null && component != null && parts.isNotEmpty;

  @computed
  Part? get part => parts.isNotEmpty ? parts[partIndex] : null;

  @computed
  bool get isPartSelected => isCompSelected && part != null;

  @computed
  bool get isFirstPart => partIndex == 0;

  @computed
  bool get isLastPart => isPartSelected && partIndex == parts.length - 1;

  @computed
  int get compIndex => isCompSelected ? comps.indexOf(component!) : -1;

  @computed
  Component get nextComponent => comps[nextCompIndex(1)];

  @computed
  Component get prevComponent => comps[nextCompIndex(-1)];

  @computed
  bool get isFirstComp => compIndex == 0;

  @computed
  bool get isLastComp => isCompSelected && compIndex == comps.length - 1;

  @computed
  List<List<Part>> get allComps =>
      test == null ? [] : test!.components.map((c) => c.parts).toList();

  @computed
  List<Part> get allParts => allComps.expand((c) => c).toList();

  @computed
  List<Question> get allQuestions => comps.expand(getCompQuestions).toList();

  @computed
  List<Question> get partQuestions => getPartQuestions(part);

  @computed
  Question get writeQuestion => getQuestion(partIndex + 1)!;

  @computed
  Component? get writeComponent =>
      test?.components.firstWhereOrNull((c) => c.name == 'write');

  @computed
  List<Question> get writeQuestions =>
      writeComponent?.parts.expand(getPartQuestions).toList() ?? [];

  @computed
  Component? get speakComponent =>
      test?.components.firstWhereOrNull((c) => c.name == 'speak');

  @computed
  List<Question> get speakQuestions =>
      speakComponent?.parts.expand(getPartQuestions).toList() ?? [];

  @computed
  bool get isLastQuestion => questionIndex == partQuestions.length - 1;

  @computed
  int get timeLimit =>
      isChecking || component == null ? 0 : component!.timeLimit;

  @computed
  String get timeLeft => timeLimit > 0
      ? RegExp('^\\d{1,2}:(\\d+):(\\d+)\\.')
          .firstMatch(Duration(seconds: countDown).toString())!
          .groups([1, 2]).join(':')
      : '';

  @computed
  bool get isTimeLeftAlert => countDown < _timeAlert;

  @computed
  Map<String, List<ExQuestion>>? get explain => explains[partIndex];

  @computed
  String get part2text => part == null
      ? ''
      : part!.groups
          .expand((g) => g.paragraphs.expand(paragraph2text))
          .join('\n');

  @action
  Future<void> loadTests(String exam) async {
    name = exam;
    allTests.clear();
    var ts = await fetchExam(name);
    allTests.addAll(ts);
  }

  @action
  void selectTest(Test t) {
    test = t;
    _resetTest();
    setComp(test!.components[0]);
    isChecking = false;
  }

  @action
  void setComp(Component comp) {
    if (test == null) {
      component = null;
    } else {
      component = comp;
      parts = comp.parts;
      startTimer();
      firstPart();
    }
  }

  @action
  void nextComp(int step) => setComp(comps[nextCompIndex(step)]);

  @action
  void nextPart(int step) {
    if (test == null || parts.isEmpty) {
      partIndex = 0;
    } else {
      partIndex = (partIndex + step).clamp(0, parts.length - 1);
      partSelected();
    }
    rc++;
  }

  @action
  void firstPart() {
    if (parts.isNotEmpty) {
      partIndex = 0;
      partSelected();
    }
  }

  @action
  Future<void> partSelected() async {
    group = part!.groups.first;
    // isChecking = false;
    isPlaying = false;
    if (isIelts && component!.isSpeak) {
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
  void fill(int num, String answer, {refresh = false}) {
    final q = getQuestion(num);
    if (q != null) q.userAnswer = answer;
    if (refresh) rc++;
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
  void multiSelect(Question q, String answer) {
    final l = q.answer!.length;
    if (q.userAnswer == null) {
      q.userAnswer = answer;
    } else if (q.userAnswer!.contains(answer)) {
      q.userAnswer = q.userAnswer!.replaceFirst(answer, '');
    } else if (q.userAnswer!.length < l) {
      q.userAnswer = '${q.userAnswer}$answer'.split('').sorted().join('');
    }
    print(q.userAnswer);
    rc++;
  }

  @action
  void shareSelect(Question q1, Question q2, String answer) {
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
  void checkAnswers(Component comp) {
    setComp(comp);
    isChecking = true;
  }

  @action
  void play() {
    if (test!.mp3Url != null) {
      _player.play(cdMp3(test!.mp3Url!(this as Exam)));
      isPlaying = true;
    }
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
  void write(Question q, String t) {
    q.userAnswer = t;
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
        final m = RegExp('Score:\\*\\* (\\d+)').firstMatch(q.answer!);
        if (m != null) q.score = m.group(1);
      }
    }
    isScoring = false;
  }

  @action
  Future loadResults() async {
    results = await fetchResults(auth.user!.id);
  }

  @action
  void loadResult(Result result) {
    final t = allTests.firstWhere((x) => x.id == result.testId);
    selectTest(t);
    result.questions.forEach((q) {
      final q1 = getCompQuestions(comps[q.comp!])
          .firstWhere((x) => x.number == q.number);
      q1.userAnswer = q.userAnswer;
      q1.score = q.score;
    });
  }

  @action
  Future saveTestResult() async {
    final qs = allQuestions
        .where(
          (q) =>
              q.userAnswer != null &&
              q.answer != null &&
              q.userAnswer != q.answer,
        )
        .map(
          (q) => Question()
            ..number = q.number
            ..score = q.score
            ..answer = q.answer
            ..userAnswer = q.userAnswer,
        )
        .toList();
    final result = Result()
      ..userId = auth.user!.id
      ..type = name
      ..testId = test!.id
      ..questions = qs;
    await saveResult(result);
  }

  @action
  void startTimer() {
    cancelTimer();
    if (timeLimit > 0) {
      countDown = timeLimit;
      _tid = timer(1, updateTimer);
    }
  }

  @action
  void cancelTimer() {
    if (_tid > 0) stopTimer(_tid);
  }

  @action
  bool updateTimer() {
    if (countDown > 0) {
      countDown--;
      //rc++;
    }
    if (countDown == 0) {
      _tid = 0;
      timeIsUp = true;
      //nextComp(1);
      return true;
    }
    return false;
  }

  @action
  Future<void> getExplain() async {
    isExplain = true;
    if (explains[partIndex] == null) {
      isScoring = true;
      explains[partIndex] = await fetchExplain(part2text);
      //final r = await chatComplete([Msg()..text = part2text]);
      //print(r);
      isScoring = false;
    }
    rc++;
  }

  @action
  void exitExplain() {
    isExplain = false;
    rc++;
  }

  List<Paragraph> getPartParagraphs(Part? part) =>
      part == null ? [] : part.groups.expand((g) => g.paragraphs).toList();

  List<Question> getPartQuestions(Part? part) => getPartParagraphs(part)
      .expand<Question>((p) => p.questions ?? [])
      .toList();

  Question? getQuestion(int num) =>
      getPartQuestions(part).firstWhereOrNull((q) => q.number == num);

  Paragraph? getParagraphForQuestion(int num) => getPartParagraphs(part)
      .firstWhereOrNull((p) => (p.questions ?? []).any((q) => q.number == num));

  String? checkAnswer(int num) {
    final q = getQuestion(num);
    return q == null
        ? 'No such question'
        : q.userAnswer != q.answer
            ? q.answer
            : null;
  }

  int nextCompIndex(int step) => (compIndex + step).clamp(0, comps.length - 1);

  List<Question> getCompQuestions(Component comp) =>
      comp.parts.expand(getPartQuestions).toList();

  int numOfCorrect(Component comp) =>
      getCompQuestions(comp).where((q) => q.answer == q.userAnswer).length;

  Map<String, List<int>> incorrectQuestions(Component comp) => {
        for (var p in comp.parts)
          p.name: getPartQuestions(p)
              .where((q) => q.answer != q.userAnswer)
              .map((q) => q.number)
              .toList(),
      };

  int choiceColor(Choice c) => isChecking
      ? c.isWrong
          ? Colors.red
          : c.isActual
              ? Colors.darkGreen
              : Colors.black
      : c.isSelected
          ? Colors.darkBlue
          : Colors.black;

  bool boldChoice(Choice c) => isChecking && c.isActual || c.isSelected;

  (String, String?) contentTag(String s) {
    final tag = tags.firstWhereOrNull((t) => s.startsWith('<$t>'));
    return (tag != null ? s.replaceFirst('<$tag>', '') : s, tag);
  }

  (int, String?, String?) parseFill(String s) {
    final startsWithNumber = s.isNotEmpty && int.tryParse(s[0]) != null;
    RegExp re = RegExp(
      startsWithNumber
          ? r'^(\d{1,2})(.*?)[\._…]{6,}(.*)$'
          : r'^(.*)(\d{1,2})[\._…]{6,}(.*)$',
    );
    final match = re.firstMatch(s);
    if (match == null) return (-1, null, null);
    final num = int.parse(match.group(startsWithNumber ? 1 : 2)!);
    return (
      num,
      match.group(startsWithNumber ? 2 : 1)!.trim(),
      match.group(3)!.trim()
    );
  }

  List<String> paragraph2text(Paragraph p) => [
        ...p.content,
        ...(p.questions ?? []).expand(question2text),
      ];

  List<String> question2text(Question q) => [
        'Q${q.number}) ${q.subject ?? ''}',
        ...(q.choices ?? []),
      ];

  void _createQuestions() {
    if (isIelts && writeComponent != null) {
      lidx(writeComponent!.parts).forEach((i) {
        final g = writeComponent!.parts[i].groups[0];
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
  }

  void _resetTest() {
    _createQuestions();
    allParts.forEach(
      (p) => getPartQuestions(p).forEach((q) => q.userAnswer = null),
    );
  }

  _Exam() {
    if (app.singleApp.isNotEmpty) {
      loadTests(app.singleApp);
    }
  }

  void dispose() {
    _player.dispose();
  }
}
