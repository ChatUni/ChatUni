import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Choice {
  int id = 0;
  String question = '';
  List<String> answers = [];
  int correctAnswer = 0;

  Choice();

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}

@JsonSerializable()
class Listening {
  int id = 0;
  String mp3 = '';
  List<Choice> questions = [];

  Listening();

  factory Listening.fromJson(Map<String, dynamic> json) =>
      _$ListeningFromJson(json);

  Map<String, dynamic> toJson() => _$ListeningToJson(this);
}
