// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice()
  ..id = (json['id'] as num).toInt()
  ..question = json['question'] as String
  ..answers =
      (json['answers'] as List<dynamic>).map((e) => e as String).toList()
  ..correctAnswer = (json['correctAnswer'] as num).toInt();

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answers': instance.answers,
      'correctAnswer': instance.correctAnswer,
    };

Listening _$ListeningFromJson(Map<String, dynamic> json) => Listening()
  ..id = (json['id'] as num).toInt()
  ..mp3 = json['mp3'] as String
  ..questions = (json['questions'] as List<dynamic>)
      .map((e) => Choice.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ListeningToJson(Listening instance) => <String, dynamic>{
      'id': instance.id,
      'mp3': instance.mp3,
      'questions': instance.questions,
    };
