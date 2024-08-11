import '/models/course.dart';
import 'api.dart';

final get = dioGet(cuBase);
final post = dioPost(cuBase);
final vipPost = dioPost(vipBase);

Future<List<Listening>> fetchIelts() async {
  final r = await get('ielts');
  return (r as List).map((t) => Listening.fromJson(t)).toList();
}
