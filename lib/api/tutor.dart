import '/models/msg.dart';
import '/models/tutor.dart';
import 'api.dart';

final get = dioGet(cuBase);
final post = dioPost(cuBase);

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

// Future<Msg?> chatVoice(Msg msg, Tutor tutor) async {
//   var r = await dio.post(
//     '$base/aiteacher/chatvoice',
//     data: {
//       'characterid': tutor.id.toString(),
//       'file': msg.text,
//       'language': msg.lang,
//       'speed': tutor.speed.toString(),
//       'voiceid': tutor.voice,
//       // 'sessionid': 6,
//       // 'audiofile': file,
//     },
//     // options: Options(headers: {'Authorization': auth}),
//   );
//   if (r.statusCode != 200) return null;
//   try {
//     var vr = VoiceResponse.fromJson(r.data);
//     return Msg()
//       ..isAI = true
//       ..text = vr.result.text
//       ..voice = vr.result.voice
//       ..url = vr.result.url;
//   } catch (e) {
//     return null;
//   }
// }
