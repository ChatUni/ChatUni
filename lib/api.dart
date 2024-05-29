import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'store/tutors.dart';

part 'api.g.dart';

String base = 'https://chat.smartkit.vip';
String auth =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjEwLCJwaG9uZSI6IjEiLCJpYXQiOjE3MTU1OTU0OTQsImV4cCI6MTcxODE4NzQ5NH0.z_KEKFYmC9pNfkzBGZ5AoPCYcyY5bTT2BdUsdr-En6M';
// String base = 'https://www.mogaverse.xyz';
// String auth =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjYsInBob25lIjoiMTczMDI4MTE2MzAiLCJpYXQiOjE3MTYyNTk2MjIsImV4cCI6MTcxODg1MTYyMn0.fuMMDshFxmdTpPiDP5vVT3YlWe9qqS9O76mxBNUEJlU';

final dio = Dio();

Future<List<Tutor>> fetchTutors() async {
  final r = await dio.get('$base/aiteacher/foreignteacherlist');
  TutorsResponse tr = TutorsResponse.fromJson(r.data);
  return tr.result;
}

Future<TransResult?> chatTrans(String path, int tutorId) async {
  try {
    var r = await dio.post(
      '$base/aiteacher/chattrans',
      data: FormData.fromMap({
        'characterid': tutorId,
        'file': await MultipartFile.fromFile(
          path,
          filename: 'blob',
          contentType: MediaType('audio', 'wav'),
        ),
      }),
      options: Options(headers: {'Authorization': auth}),
    );
    return TransResponse.fromJson(r.data).result;
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Future<Msg?> chatVoice(Msg msg, Tutor tutor, String? file) async {
  var r = await dio.post('$base/aiteacher/chatvoice',
      data: {
        "characterid": tutor.id.toString(),
        'file': msg.text,
        'language': msg.lang,
        'speed': tutor.speed.toString(),
        'voiceid': tutor.voice,
        // 'sessionid': 6,
        // 'audiofile': file,
      },
      options: Options(headers: {'Authorization': auth}));
  if (r.statusCode != 200) return null;
  try {
    var vr = VoiceResponse.fromJson(r.data);
    return Msg()
      ..isAI = true
      ..text = vr.result.text
      ..voice = vr.result.voice
      ..url = vr.result.url;
  } catch (e) {
    return null;
  }
}

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
