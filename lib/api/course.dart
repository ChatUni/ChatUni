import 'package:chatuni/models/ielts.dart';

import 'api.dart';

final get = dioGet(cuBase);
final post = dioPost(cuBase);
final vipPost = dioPost(vipBase);

enum CourseType { ielts, middle, high }

Future<List<Test>> fetchIelts() async {
  final r = await get('course', params: {'type': 'ielts'});
  return (r as List).map((t) => Test.fromJson(t)).toList();
}
