import 'package:json_annotation/json_annotation.dart';

part 'tutor.g.dart';

@JsonSerializable()
class Tutor {
  int id = 0;
  int type = 1;
  int level = 1;
  double speed = 1;
  String speed2 = '';
  String name = '';
  String gender = '';
  int icon = 0;
  String voice = '';
  String personality = '';
  String skill = '';
  String desc = '';
  String? locale = '';
  String? greetings = '';

  Tutor();

  factory Tutor.fromJson(Map<String, dynamic> json) => _$TutorFromJson(json);

  Map<String, dynamic> toJson() => _$TutorToJson(this);
}
