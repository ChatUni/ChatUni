// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Msg _$MsgFromJson(Map<String, dynamic> json) => Msg()
  ..id = (json['id'] as num).toInt()
  ..text = json['text'] as String
  ..lang = json['lang'] as String
  ..isAI = json['isAI'] as bool
  ..voice = json['voice'] as String
  ..url = json['url'] as String
  ..isReading = json['isReading'] as bool
  ..isWaiting = json['isWaiting'] as bool;

Map<String, dynamic> _$MsgToJson(Msg instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'lang': instance.lang,
      'isAI': instance.isAI,
      'voice': instance.voice,
      'url': instance.url,
      'isReading': instance.isReading,
      'isWaiting': instance.isWaiting,
    };
