import '/models/msg.dart';
import '/models/tutor.dart';
import 'api.dart';

final get = dioGet(cuBase);
final post = dioPost(cuBase);
final vipPost = dioPost(vipBase);

Future<List<Tutor>> fetchTutors() async {
  final r = await get('tutor', params: {'type': 'tutors'});
  return (r as List).map((t) => Tutor.fromJson(t)).toList();
}

Future<String?> greeting(int id) async =>
    await get('tutor', params: {'type': 'greeting', 'id': id.toString()});

Future<Msg?> chat(Msg msg, Tutor tutor) async {
  var r = await post(
    'tutor',
    params: {'type': 'chat'},
    data: {
      'text': msg.text,
    },
  );
  return Msg()
    ..isAI = true
    ..text = r;
}

// Future<TransResult?> chatTrans(String path, int tutorId) async {
//   try {
//     var r = await dio.post(
//       '$base/aiteacher/chattrans',
//       data: FormData.fromMap({
//         'characterid': tutorId,
//         'file': MultipartFile.fromBytes(
//           await readAsBytes(path),
//           filename: 'blob',
//           contentType: MediaType('audio', 'wav'),
//         ),
//       }),
//       // options: Options(headers: {'Authorization': auth}),
//     );
//     return TransResponse.fromJson(r.data).result;
//   } catch (e) {
//     log(e.toString());
//     return null;
//   }
// }

Future<Msg?> chatVoice(Msg msg, Tutor tutor) async {
  var r = await vipPost(
    'aiteacher/chatvoice',
    data: {
      'characterid': tutor.id,
      'file': msg.text,
      'language': 'zh', // msg.lang,
      'speed': tutor.speed,
      'voiceid': tutor.voice,
      // 'sessionid': 6,
      // 'audiofile': file,
    },
    headers: headers,
  );
  if (r.statusCode != 200) return null;
  try {
    var vr = r.data['result'];
    return Msg()
      ..isAI = true
      ..text = vr['text']
      ..voice = vr['voice']
      ..url = vr['url'];
  } catch (e) {
    return null;
  }
}
