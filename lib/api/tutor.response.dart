import 'package:json_annotation/json_annotation.dart';
import '../models/tutor.dart';

part 'tutor.response.g.dart';

@JsonSerializable()
class TutorsResponse {
  int status = 0;
  List<Tutor> result = [];

  TutorsResponse();

  factory TutorsResponse.fromJson(Map<String, dynamic> json) =>
      _$TutorsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TutorsResponseToJson(this);
}

@JsonSerializable()
class VoiceResult {
  String text = '';
  String voice = '';
  String url = '';

  VoiceResult();

  factory VoiceResult.fromJson(Map<String, dynamic> json) =>
      _$VoiceResultFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceResultToJson(this);
}

@JsonSerializable()
class VoiceResponse {
  int status = 0;
  VoiceResult result = VoiceResult();

  VoiceResponse();

  factory VoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$VoiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceResponseToJson(this);
}

@JsonSerializable()
class TransResult {
  String originaltext = '';
  String? audiofile = '';

  TransResult();

  factory TransResult.fromJson(Map<String, dynamic> json) =>
      _$TransResultFromJson(json);

  Map<String, dynamic> toJson() => _$TransResultToJson(this);
}

@JsonSerializable()
class TransResponse {
  String status = '';
  TransResult result = TransResult();

  TransResponse();

  factory TransResponse.fromJson(Map<String, dynamic> json) =>
      _$TransResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransResponseToJson(this);
}
