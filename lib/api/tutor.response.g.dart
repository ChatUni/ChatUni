// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor.response.dart';

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

TransResult _$TransResultFromJson(Map<String, dynamic> json) => TransResult()
  ..originaltext = json['originaltext'] as String
  ..audiofile = json['audiofile'] as String?;

Map<String, dynamic> _$TransResultToJson(TransResult instance) =>
    <String, dynamic>{
      'originaltext': instance.originaltext,
      'audiofile': instance.audiofile,
    };

TransResponse _$TransResponseFromJson(Map<String, dynamic> json) =>
    TransResponse()
      ..status = json['status'] as String
      ..result = TransResult.fromJson(json['result'] as Map<String, dynamic>);

Map<String, dynamic> _$TransResponseToJson(TransResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };
