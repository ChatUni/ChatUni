import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../models/msg.dart';
import '../models/tutor.dart';
import 'api.dart';
import 'tutor.response.dart';

Future<List<Tutor>> fetchTutors() async {
  final r = await get<String>('tutor', 'tutors');
  return r == null ? [] : json.decode(r).map((t) => Tutor.fromJson(t));
}

Future<String?> greeting(int tutorId) async {
  try {
    var r = await dio.post(
      '$base/aiteacher/greeting',
      data: jsonEncode({
        'characterid': tutorId,
      }),
      // options: Options(headers: {'Authorization': auth}),
    );
    return r.data['result'];
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Future<TransResult?> chatTrans(String path, int tutorId) async {
  try {
    var r = await dio.post(
      '$base/aiteacher/chattrans',
      data: FormData.fromMap({
        'characterid': tutorId,
        'file': MultipartFile.fromBytes(
          await readAsBytes(path),
          filename: 'blob',
          contentType: MediaType('audio', 'wav'),
        ),
      }),
      // options: Options(headers: {'Authorization': auth}),
    );
    return TransResponse.fromJson(r.data).result;
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Future<Msg?> chatVoice(Msg msg, Tutor tutor) async {
  var r = await dio.post(
    // '$base/aiteacher/chatvoice',
    'https://chatuni.netlify.app/.netlify/functions/tutor?type=chat',
    data: {
      "characterid": tutor.id.toString(),
      'file': msg.text,
      'text': msg.text,
      'language': msg.lang,
      'speed': tutor.speed.toString(),
      'voiceid': tutor.voice,
      // 'sessionid': 6,
      // 'audiofile': file,
    },
    // options: Options(headers: {'Authorization': auth}),
  );
  if (r.statusCode != 200) return null;
  try {
    // var vr = VoiceResponse.fromJson(r.data);
    return Msg()
      ..isAI = true
      ..text = r.data;
    // ..text = vr.result.text
    // ..voice = vr.result.voice
    // ..url = vr.result.url;
  } catch (e) {
    return null;
  }
}
