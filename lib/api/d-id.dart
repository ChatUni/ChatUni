import '/env.dart';
import 'api.dart';

const base = 'https://api.d-id.com';
final post = dioPost(base);
final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Basic ${Env.dIdApiKey}',
};

Future createStream(String img) async {
  final r = await post(
    'talks/streams',
    headers: headers,
    data: {
      'source_url': img,
    },
  );
  return r;
}

Future startStream(
  String sessionId,
  String streamId,
  dynamic answer,
) async {
  final r = await post(
    'talks/streams/$streamId/sdp',
    headers: headers,
    data: {
      'answer': answer,
      'session_id': sessionId,
    },
  );
  return r;
}

Future submitNetworkInfo(
  String sessionId,
  String streamId, [
  String? candidate = '',
  String? sdpMid = '',
  int? sdpMLineIndex = 0,
]) async {
  final r = await post(
    'talks/streams/$streamId/ice',
    headers: headers,
    data: {
      'candidate': candidate,
      'sdpMid': sdpMid,
      'sdpMLineIndex': sdpMLineIndex,
      'session_id': sessionId,
    },
  );
  return r;
}

Future sendToChat(
  String sessionId,
  String streamId,
  String agentId,
  String chatId,
  String msg,
) async {
  final r = await post(
    'agents/$agentId/chat/$chatId',
    headers: headers,
    data: {
      'streamId': streamId,
      'sessionId': sessionId,
      'messages': [
        {
          'role': 'user',
          'content': msg,
          'created_at':
              'Sat Aug 03 2024 18:19:29 GMT-0700 (Pacific Daylight Time)', // DateTime.now().toString(),
        }
      ],
    },
  );
  return r;
}
