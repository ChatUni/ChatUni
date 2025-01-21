import 'package:chatuni/models/exam.dart';
import 'package:chatuni/store/exam.dart';

import 'api.dart';

final get = dioGet(cuBase);
final post = dioPost(cuBase);
final vipPost = dioPost(vipBase);

enum CourseType { ielts, middle, high }

Future<List<Test>> fetchExam(String exam) async {
  final r = await get('course', params: {'type': exam.toLowerCase()});
  final tests = (r as List).map((t) => TestJ.fromJson(t)).toList();
  final cfg = examConfig[exam]!;
  final comps = cfg['components'] as List<Component>;
  final mp3Url = cfg['mp3Url'];
  return tests
      .map(
        (t) => Test(t.id)
          ..mp3Url = mp3Url == null ? null : mp3Url as String Function(Exam)
          ..components = comps
              .map(
                (c) => Component(c.name, c.title, c.timeLimit)
                  ..parts = t.getComp(c.name),
              )
              .toList(),
      )
      .toList();
}

// Future<List<Test>> fetchsat() {
//   Test t = Test();
//   t.id = '1-1';
//   final sections = (r as List)[0]['sections'];
//   //Part p1 = Part.fromJson(sections[0]);
//   //Part p = Part.fromJson(sections[1]);
//   sections.forEach((s) {
//     t.read.add(Part.fromJson(s));
//   });
//   //t.speak.add(p1);
//   //t.speak.addAll(sections.map((t1) => Part.fromJson(t1)).toList());
//   return [t];
// }

Future<List<Result>> fetchResults(String userId) async {
  final r = await get(
    'course',
    params: {'type': 'results', 'userId': userId},
  );
  return (r as List).map((t) => Result.fromJson(t)).toList();
}

Future<String> writeScore(String txt) async =>
    await get('course', params: {'type': 'score', 'msg': txt});

Future<Result> saveResult(Result result) async {
  result.date = DateTime.now().toUtc().toString();
  final r = await post(
    'course',
    params: {'type': 'saveResult'},
    data: {'result': result},
  );
  return result;
}
