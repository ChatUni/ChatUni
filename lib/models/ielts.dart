import 'package:json_annotation/json_annotation.dart';

part 'ielts.g.dart';

@JsonSerializable()
class Question {
  int number = 0;
  String? answer = '';
  String? subject = '';
  List<String>? choices = [];

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
