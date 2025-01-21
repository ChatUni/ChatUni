import 'package:chatuni/store/exam.dart';
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

  bool get isSelected =>
      (q1.userAnswer != null && q1.userAnswer!.contains(key)) ||
      (q2.userAnswer != null && q2.userAnswer!.contains(key));

  bool get isActual =>
      (q1.answer != null && q1.answer!.contains(key)) ||
      (q2.answer != null && q2.answer!.contains(key));

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

const audioPrefixes = ['Listen to ', 'Now, listen to ', 'Now listen to '];

@JsonSerializable()
class Paragraph {
  String type = '';
  List<String> content = [];
  List<Question>? questions = [];
  String? maxChoice;

  bool get isScript => type == 'script';

  bool get isTrueFalse => type == 'bool';

  bool get isWriteQuestion => type == 'write';

  bool get isSpeakQuestion => type == 'speak';

  bool get hasAudio =>
      isScript &&
      content.isNotEmpty &&
      audioPrefixes.any(content[0].startsWith);

  bool get hasQuestions => questions != null && questions!.isNotEmpty;

  bool get isChoiceQuestion => type == 'choice' && hasQuestions;

  bool get isSharedChoice =>
      isChoiceQuestion &&
      questions!.every((q) => q.subject == null && q.choices == null);

  bool get isSingleChoice =>
      isChoiceQuestion &&
      questions!.every(
        (q) =>
            q.subject != null &&
            q.choices != null &&
            q.answer != null &&
            q.answer!.length == 1,
      );

  bool get isMultiChoice =>
      isChoiceQuestion &&
      questions!.every(
        (q) =>
            q.subject != null &&
            q.choices != null &&
            q.answer != null &&
            q.answer!.length > 1,
      );

  bool get isChoiceOnly =>
      isChoiceQuestion &&
      questions!.every(
        (q) =>
            (q.subject == null || q.subject!.isEmpty) &&
            q.choices != null &&
            q.choices!.isNotEmpty,
      );

  List<String> get nonChoiceContent =>
      content.where((x) => !isChoice(x)).toList();

  List<Choice> get choiceList => !isSharedChoice
      ? []
      : content
          .where(isChoice)
          .map((x) => getChoice(x, questions![0], questions![1]))
          .toList();

  String get questionNumbers =>
      'Q${questions![0].number}) Q${questions![1].number})';

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

  String get groupName =>
      name.startsWith('PART ') ? name.substring(6).trim() : name;

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
  List<Part>? read1 = [];
  List<Part>? read2 = [];
  List<Part>? write = [];
  List<Part>? speak = [];
  List<Part>? math1 = [];
  List<Part>? math2 = [];

  TestJ();

  List<Part> getComp(String comp) =>
      {
        'listen': listen,
        'read': read,
        'read1': read1,
        'read2': read2,
        'write': write,
        'speak': speak,
        'math1': math1,
        'math2': math2,
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
  String Function(Exam)? mp3Url;

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
