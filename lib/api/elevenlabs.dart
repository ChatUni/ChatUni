import 'dart:convert';

import 'package:http/http.dart' as http;

import '/env.dart';
import 'api.dart';

const base = 'https://api.elevenlabs.io/v1';
final post = dioPost(base);
final headers = {
  'Accept': 'audio/mpeg',
  'Content-Type': 'application/json',
  'xi-api-key': Env.elevenlabsApiKey,
};
const model = 'eleven_monolingual_v1';

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
