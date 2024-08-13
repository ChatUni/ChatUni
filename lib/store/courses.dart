import 'package:chatuni/models/course.dart';
import 'package:mobx/mobx.dart';

import '/api/course.dart';

part 'courses.g.dart';

class Courses = _Courses with _$Courses;

abstract class _Courses with Store {
  @observable
  List<Listening> listenings = [];

  @action
  Future<void> loadListenings(CourseType type) async {
    listenings.clear();
    var ts = await fetchListenings(type);
    listenings.addAll(ts);
  }
}
