import 'package:chatuni/models/ielts.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

import '/api/course.dart';

part 'ielts.g.dart';

class Ielts = _Ielts with _$Ielts;

abstract class _Ielts with Store {
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
    part = t.listen[1];
    group = part!.groups.first;
  }

  @action
  void fill(String num, String answer) {
    final q = getQuestion(num);
    if (q != null) q.userAnswer = answer;
  }

  @action
  void checkAnswers() {
    isChecking = false;
    isChecking = true;
  }

  Question? getQuestion(String num) =>
      partQuestions.firstWhereOrNull((q) => q.number == int.parse(num));

  String? checkAnswer(String num) {
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
}
