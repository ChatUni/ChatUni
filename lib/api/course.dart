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

Future<List<Test>> fetchsat() async {
  final r = await get('course', params: {'type': 'sat'});
  Test t = Test();
  t.id = '1-1';

  //final sections = (r as List)[0]['sections'];
  List<dynamic> sections = [];
  (r as List).forEach((element) {
    // sections.addAll(element['sections']);
  });
  //Part p1 = Part.fromJson(sections[0]);
  //Part p = Part.fromJson(sections[1]);
  sections.forEach((s) {
    t.write.add(Part.fromJson(s));
  });
  //t.speak.add(p1);
  //t.speak.addAll(sections.map((t1) => Part.fromJson(t1)).toList());
  return [t];
}

Future<List<Result>> fetchResults() async {
  final r = await get('course', params: {'type': 'results'});
  return (r as List).map((t) => Result.fromJson(t)).toList();
}

Future<String> writeScore(String txt) async =>
    await get('course', params: {'type': 'score', 'msg': txt});

Future<List<Test>> saveResult(Result result) async {
  result.date = DateTime.now().toUtc().toString();
  final r = await post(
    'course',
    params: {'type': 'saveResult'},
    data: {'result': result},
  );
  return (r as List).map((t) => Test.fromJson(t)).toList();
}
