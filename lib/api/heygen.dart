import 'package:chatuni/env.dart';

import 'api.dart';

const base = 'https://api.heygen.com/v1';
final post = dioPost(base);
final headers = {
  'Content-Type': 'application/json',
  'x-api-key': Env.heygenApiKey,
};

Future<String> createToken() async {
  final r = await post(
    'streaming.create_token',
    headers: headers,
  );
  return r['data']['token'];
}

Future<String> newSession() async {
  final r = await post(
    'streaming.new',
    headers: headers,
    data: {
      'quality': 'high',
      'avatar_name': 'Angela-inblackskirt-20220820',
      'voice': {
        'voice_id': '00c8fd447ad7480ab1785825978a2215',
      },
    },
  );
  return r['data']['session_id'];
}
