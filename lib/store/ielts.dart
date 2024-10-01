import 'package:chatuni/models/ielts.dart';
import 'package:mobx/mobx.dart';

import '/api/course.dart';

part 'ielts.g.dart';

class Ielts = _Ielts with _$Ielts;

abstract class _Ielts with Store {
  @observable
  var tests = ObservableList<Test>();

  @action
  Future<void> loadTests() async {
    tests.clear();
    var ts = await fetchIelts();
    tests.addAll(ts);
  }

  _Ielts() {
    loadTests();
  }
}
