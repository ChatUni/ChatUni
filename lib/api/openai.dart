import '/env.dart';
import '/models/msg.dart';
import 'api.dart';

const base = 'https://api.openai.com/v1';
final post = dioPost(base);
final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ${Env.openaiApiKey}',
};
const model = 'gpt-3.5-turbo';

Future<Msg> chatComplete(List<Msg> msgs) async {
  final r = await post(
    'chat/completions',
    headers: headers,
    data: {
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a English tutor, correct user\'s grammar error if needed during conversation',
        },
        ...msgs.where((m) => m.text != '').map(
              (m) => {
                'role': m.isAI ? 'assistant' : 'user',
                'content': m.text,
              },
            ),
      ],
    },
  );
  return Msg()
    ..isAI = true
    ..text = r['choices'][0]['message']['content'];
}
