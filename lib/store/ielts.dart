import 'package:chatuni/io/player.dart';
import 'package:chatuni/models/ielts.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

import '/api/course.dart';

part 'ielts.g.dart';

class Ielts = _Ielts with _$Ielts;

abstract class _Ielts with Store {
  final Player _player = Player();

  @observable
  var allTests = ObservableList<Test>();

  @observable
  Test? test;

  @observable
  Part? part;

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
  List<Question> get partQuestions => part == null
      ? []
      : part!.groups
          .expand((g) => g.paragraphs)
          .expand<Question>((p) => p.questions ?? [])
          .toList();

  @action
  Future<void> loadTests() async {
    allTests.clear();
    var ts = await fetchIelts();
    allTests.addAll(ts);
  }

  @action
  void selectTest(Test t) {
    test = t;
    part = t.listen.first;
    partSelected();
  }

  @action
  void nextPart(int step) {
    if (test == null) {
      part = null;
    } else if (part == null) {
      part = test!.listen.first;
    } else {
      var idx = test!.listen.indexWhere((p) => p.name == part!.name);
      part = test!.listen[(idx + step).clamp(0, test!.listen.length)];
      partSelected();
    }
  }

  @action
  void partSelected() {
    group = part!.groups.first;
    isChecking = false;
    isPlaying = false;
  }

  @action
  void fill(int num, String answer) {
    final q = getQuestion(num);
    if (q != null) q.userAnswer = answer;
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
    isChecking = false;
    isChecking = true;
  }

  @action
  void play() {
    _player.play('assets/mp3/ielts/18-1-1.mp3');
    isPlaying = true;
  }

  @action
  void stop() {
    _player.stop();
    isPlaying = false;
  }

  Question? getQuestion(int num) =>
      partQuestions.firstWhereOrNull((q) => q.number == num);

  String? checkAnswer(int num) {
    final q = getQuestion(num);
    return q == null
        ? 'No such question'
        : q.userAnswer == null || q.userAnswer == ''
            ? 'Not answered yet'
            : q.userAnswer != q.answer
                ? 'Incorrect'
                : null;
  }

  _Ielts() {
    loadTests();
  }

  void dispose() {
    _player.dispose();
  }
}
