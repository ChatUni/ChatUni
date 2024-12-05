import 'package:json_annotation/json_annotation.dart';

part 'exam.g.dart';

RegExp _choicePattern = RegExp(r'^(<.+>)?([A-Z])[.)]? (.+)$');

bool isChoice(String s) => _choicePattern.hasMatch(s);

Choice getChoice(String s, Question q1, Question q2) {
  final m = _choicePattern.firstMatch(s.replaceAll('"', ''));
  return Choice(m!.group(2)!, m.group(3)!, q1, q2);
}

class Choice {
  String key;
  String value;
  Question q1;
  Question q2;

  bool get isSelected => q1.userAnswer == key || q2.userAnswer == key;

  bool get isActual => q1.answer == key || q2.answer == key;

  bool get isCorrect => isSelected && isActual;

  bool get isWrong => isSelected && !isActual;

  Choice(this.key, this.value, this.q1, this.q2);
}

@JsonSerializable()
class Question {
  int number = 0;
  String? answer = '';
  String? userAnswer = '';
  String? score;
  String? subject = '';
  List<String>? choices = [];
  List<String>? images = [];
  int? comp;

  List<Choice> get choiceList =>
      (choices ?? []).map((x) => getChoice(x, this, this)).toList();

  bool get isCorrect => userAnswer == answer;

  bool isActual(String a) => a == answer;

  Question();

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Paragraph {
  String type = '';
  List<String> content = [];
  List<Question>? questions = [];

  bool get isTrueFalse => type == 'bool';

  bool get isMultiChoice =>
      type == 'choice' &&
      (questions ?? []).every((q) => q.subject == null && q.choices == null);

  bool get isSingleChoice =>
      type == 'choice' &&
      (questions ?? []).every((q) => q.subject != null && q.choices != null);

  List<String> get nonChoiceContent =>
      content.where((x) => !isChoice(x)).toList();

  List<Choice> get choiceList => !isMultiChoice
      ? []
      : content
          .where(isChoice)
          .map((x) => getChoice(x, questions![0], questions![1]))
          .toList();

  String get questionNumbers =>
      '${questions![0].number} and ${questions![1].number}.';

  Paragraph();

  factory Paragraph.fromJson(Map<String, dynamic> json) =>
      _$ParagraphFromJson(json);

  Map<String, dynamic> toJson() => _$ParagraphToJson(this);
}

@JsonSerializable()
class Group {
  String name = '';
  int from = 0;
  int to = 0;
  List<Paragraph> paragraphs = [];

  Group();

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class Part {
  String name = '';
  int from = 0;
  int to = 0;
  List<Group> groups = [];

  Part();

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);

  Map<String, dynamic> toJson() => _$PartToJson(this);
}

@JsonSerializable()
class TestJ {
  String id = '';
  List<Part>? listen = [];
  List<Part>? read = [];
  List<Part>? write = [];
  List<Part>? speak = [];
  List<Part>? math = [];

  TestJ();

  List<Part> getComp(String comp) =>
      {
        'listen': listen,
        'read': read,
        'write': write,
        'speak': speak,
        'math': math,
      }[comp] ??
      [];

  factory TestJ.fromJson(Map<String, dynamic> json) => _$TestJFromJson(json);

  Map<String, dynamic> toJson() => _$TestJToJson(this);
}

class Component {
  String name = '';
  String title = '';
  int timeLimit = 0;
  List<Part> parts = [];

  bool get isListen => name == 'listen';
  bool get isWrite => name == 'write';
  bool get isSpeak => name == 'speak';
  bool get isQA => !isWrite && !isSpeak;

  Component(this.name, this.title, this.timeLimit);
}

class Test {
  String id = '';
  List<Component> components = [];

  Test(this.id);
}

@JsonSerializable()
class Result {
  String userId = '';
  String testId = '';
  String type = '';
  String date = '';
  List<Question> questions = [];

  Result();

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
