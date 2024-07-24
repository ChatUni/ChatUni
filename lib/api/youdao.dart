import 'dart:convert';

import 'package:chatuni/env.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'api.dart';

const base = 'https://openapi.youdao.com/ttsapi';
final post = dioPost(base);
final headers = {
  'Content-Type': 'application/x-www-form-urlencoded',
};

var uuid = const Uuid();

Future ttsyd(String text, String voice) async {
  final r = await http.post(
    Uri.parse(base),
    headers: headers,
    body: buildForm(text, voice),
  );
  return r.bodyBytes;
}

Map<String, String> buildForm(String text, String voice) {
  final salt = uuid.v4();
  final curtime =
      (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();

  return {
    'q': text,
    'voiceName': voice,
    'appKey': Env.youdaoAppKey,
    'salt': salt,
    'curtime': curtime,
    'signType': 'v3',
    'sign': buildSign(text, salt, curtime),
  };
}

String buildSign(String q, String salt, String curtime) {
  String sign =
      Env.youdaoAppKey + buildInput(q) + salt + curtime + Env.youdaoAppSecret;
  return sha256.convert(utf8.encode(sign)).toString();
}

String buildInput(String q) {
  final len = q.length;
  return len <= 20
      ? q
      : '${q.substring(0, 10)}$len${q.substring(len - 10, len)}';
}
