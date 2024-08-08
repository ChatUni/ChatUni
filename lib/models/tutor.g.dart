// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutor _$TutorFromJson(Map<String, dynamic> json) => Tutor()
  ..id = (json['id'] as num).toInt()
  ..type = (json['type'] as num).toInt()
  ..level = (json['level'] as num).toInt()
  ..speed = (json['speed'] as num).toDouble()
  ..speed2 = json['speed2'] as String
  ..name = json['name'] as String
  ..gender = json['gender'] as String
  ..icon = (json['icon'] as num).toInt()
  ..voice = json['voice'] as String
  ..personality = json['personality'] as String
  ..skill = json['skill'] as String
  ..desc = json['desc'] as String
  ..locale = json['locale'] as String?
  ..greetings = json['greetings'] as String?;

Map<String, dynamic> _$TutorToJson(Tutor instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'level': instance.level,
      'speed': instance.speed,
      'speed2': instance.speed2,
      'name': instance.name,
      'gender': instance.gender,
      'icon': instance.icon,
      'voice': instance.voice,
      'personality': instance.personality,
      'skill': instance.skill,
      'desc': instance.desc,
      'locale': instance.locale,
      'greetings': instance.greetings,
    };
