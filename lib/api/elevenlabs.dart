import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api.dart';

const base = 'https://api.elevenlabs.io/v1';
final post = dioPost(base);
final headers = {
  'Accept': 'audio/mpeg',
  'Content-Type': 'application/json',
  'xi-api-key': 'sk_a36cf48b18267cb52d1a861bda592227e582eec79e608500',
};
const model = 'eleven_turbo_v2_5';

Future tts11(String text, String voice) async {
  final r = await http.post(
    Uri.parse('$base/text-to-speech/$voice'),
    headers: headers,
    body: json.encode({
      'model_id': model,
      'text': text,
      'voice_settings': {
        'stability': .15,
        'similarity_boost': .75,
      },
    }),
  );
  return r.bodyBytes;
}
