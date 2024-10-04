import 'package:chatuni/models/ielts.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

import '/api/course.dart';

part 'ielts.g.dart';

class Ielts = _Ielts with _$Ielts;

abstract class _Ielts with Store {
  @observable
  var allTests = ObservableList<Test>();

  @computed
  List<MapEntry<int, List<Test>>> get tests =>
      groupBy(allTests, (x) => int.parse(x.id.split('-').first))
          .entries
          .toList();

  @action
  Future<void> loadTests() async {
    allTests.clear();
    var ts = await fetchIelts();
    allTests.addAll(ts);
  }

  _Ielts() {
    loadTests();
  }
}
