import 'package:json_annotation/json_annotation.dart';

part 'ielts.g.dart';

RegExp _choicePattern = RegExp(r'^(<.+>)?([A-Z])\.? (.+)$');

bool isChoice(String s) => _choicePattern.hasMatch(s);

Choice getChoice(String s, Question q1, Question q2) {
  final m = _choicePattern.firstMatch(s);
  return Choice(m!.group(2)!, m.group(3)!, q1, q2);
}

class Choice {
  String key;
  String value;
  Question q1;
  Question q2;

  bool get isSelected => q1.userAnswer == key || q2.userAnswer == key;

  bool get isActual => q1.answer == key || q2.answer == key;

  bool get isCorrect =>
      q1.answer == q1.userAnswer && q1.answer == key ||
      (q2.answer == q2.userAnswer && q2.answer == key);

  bool get isWrong =>
      q1.answer != q1.userAnswer && q1.userAnswer == key ||
      (q2.answer != q2.userAnswer && q2.userAnswer == key);

  Choice(this.key, this.value, this.q1, this.q2);
}

@JsonSerializable()
class Question {
  int number = 0;
  String? answer = '';
  String? userAnswer = '';
  String? subject = '';
  List<String>? choices = [];

  List<Choice> get choiceList =>
      (choices ?? []).map((x) => getChoice(x, this, this)).toList();

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
class Test {
  String id = '';
  List<Part> listen = [];

  Test();

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

  Map<String, dynamic> toJson() => _$TestToJson(this);
}
