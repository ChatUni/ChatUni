import 'package:chatuni/io/player.dart';
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
  bool isPlaying = false;

  @observable
  bool isChecking = false;

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

  @action
  Future<void> loadTests() async {
    allTests.clear();
    var ts = await fetchIelts();
    allTests.addAll(ts);
  }

  @action
  void selectTest(Test t) {
    test = t;
    _resetTest();
    setComp(0);
    isChecking = false;
  }

  @action
  void setComp(int idx) {
    if (test == null) {
      component = null;
    } else {
      component = comps[component == null ? 0 : idx];
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
  }

  @action
  void firstPart() {
    if (parts.isNotEmpty) {
      part = parts.first;
      partSelected();
    }
  }

  @action
  void partSelected() {
    group = part!.groups.first;
    // isChecking = false;
    isPlaying = false;
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
  void checkAnswers() {
    setComp(0);
    isChecking = true;
  }

  @action
  void play() {
    _player.play(cdMp3('18-1-1'));
    isPlaying = true;
  }

  @action
  void stop() {
    _player.stop();
    isPlaying = false;
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

  void _resetTest() {
    allParts.forEach(
      (p) => getPartQuestions(p).forEach((q) => q.userAnswer = null),
    );
  }

  _Ielts() {
    loadTests();
  }

  void dispose() {
    _player.dispose();
  }
}
