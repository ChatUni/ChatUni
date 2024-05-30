import 'package:json_annotation/json_annotation.dart';

part 'msg.g.dart';

@JsonSerializable()
class Msg {
  int id = 0;
  String text = '';
  String lang = '';
  bool isAI = false;
  String voice = '';
  String url = '';
  bool isReading = false;
  bool isWaiting = false;

  Msg();

  factory Msg.fromJson(Map<String, dynamic> json) => _$MsgFromJson(json);

  Map<String, dynamic> toJson() => _$MsgToJson(this);
}
