// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorsResponse _$TutorsResponseFromJson(Map<String, dynamic> json) =>
    TutorsResponse()
      ..status = (json['status'] as num).toInt()
      ..result = (json['result'] as List<dynamic>)
          .map((e) => Tutor.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TutorsResponseToJson(TutorsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };

VoiceResult _$VoiceResultFromJson(Map<String, dynamic> json) => VoiceResult()
  ..text = json['text'] as String
  ..voice = json['voice'] as String
  ..url = json['url'] as String;

Map<String, dynamic> _$VoiceResultToJson(VoiceResult instance) =>
    <String, dynamic>{
      'text': instance.text,
      'voice': instance.voice,
      'url': instance.url,
    };

VoiceResponse _$VoiceResponseFromJson(Map<String, dynamic> json) =>
    VoiceResponse()
      ..status = (json['status'] as num).toInt()
      ..result = VoiceResult.fromJson(json['result'] as Map<String, dynamic>);

Map<String, dynamic> _$VoiceResponseToJson(VoiceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };
