import '/models/course.dart';
import 'api.dart';

final get = dioGet(cuBase);
final post = dioPost(cuBase);
final vipPost = dioPost(vipBase);

enum CourseType { ielts, middle, high }

Future<List<Listening>> fetchListenings(CourseType type) async {
  final r = await get(type.toString());
  return (r as List).map((t) => Listening.fromJson(t)).toList();
}
