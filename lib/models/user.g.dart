// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['userid'] as String
  ..nickname = json['nickname'] as String?
  ..phone = json['phone'] as String
  ..sex = json['sex'] as String
  ..email = json['email'] as String?
  ..token = json['token'] as String
  ..used = json['usageduration'] as String
  ..remain = json['remainingduration'] as String
  ..gift = json['giftduration'] as String;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userid': instance.id,
      'nickname': instance.nickname,
      'phone': instance.phone,
      'sex': instance.sex,
      'email': instance.email,
      'token': instance.token,
      'usageduration': instance.used,
      'remainingduration': instance.remain,
      'giftduration': instance.gift,
    };
