import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'userid')
  String id = '0';
  String? nickname;
  String phone = '';
  String sex = '0';
  String? email;
  String token = '';
  @JsonKey(name: 'usageduration')
  String used = '0';
  @JsonKey(name: 'remainingduration')
  String remain = '0';
  @JsonKey(name: 'giftduration')
  String gift = '0';

  String get name => nickname == null || nickname == '' ? 'Guest' : nickname!;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
