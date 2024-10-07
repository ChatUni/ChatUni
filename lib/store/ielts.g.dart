// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ielts.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Ielts on _Ielts, Store {
  Computed<List<MapEntry<int, List<Test>>>>? _$testsComputed;

  @override
  List<MapEntry<int, List<Test>>> get tests => (_$testsComputed ??=
          Computed<List<MapEntry<int, List<Test>>>>(() => super.tests,
              name: '_Ielts.tests'))
      .value;
  Computed<List<Question>>? _$partQuestionsComputed;

  @override
  List<Question> get partQuestions => (_$partQuestionsComputed ??=
          Computed<List<Question>>(() => super.partQuestions,
              name: '_Ielts.partQuestions'))
      .value;

  late final _$allTestsAtom = Atom(name: '_Ielts.allTests', context: context);

  @override
  ObservableList<Test> get allTests {
    _$allTestsAtom.reportRead();
    return super.allTests;
  }

  @override
  set allTests(ObservableList<Test> value) {
    _$allTestsAtom.reportWrite(value, super.allTests, () {
      super.allTests = value;
    });
  }

  late final _$testAtom = Atom(name: '_Ielts.test', context: context);

  @override
  Test? get test {
    _$testAtom.reportRead();
    return super.test;
  }

  @override
  set test(Test? value) {
    _$testAtom.reportWrite(value, super.test, () {
      super.test = value;
    });
  }

  late final _$partAtom = Atom(name: '_Ielts.part', context: context);

  @override
  Part? get part {
    _$partAtom.reportRead();
    return super.part;
  }

  @override
  set part(Part? value) {
    _$partAtom.reportWrite(value, super.part, () {
      super.part = value;
    });
  }

  late final _$groupAtom = Atom(name: '_Ielts.group', context: context);

  @override
  Group? get group {
    _$groupAtom.reportRead();
    return super.group;
  }

  @override
  set group(Group? value) {
    _$groupAtom.reportWrite(value, super.group, () {
      super.group = value;
    });
  }

  late final _$isPlayingAtom = Atom(name: '_Ielts.isPlaying', context: context);

  @override
  bool get isPlaying {
    _$isPlayingAtom.reportRead();
    return super.isPlaying;
  }

  @override
  set isPlaying(bool value) {
    _$isPlayingAtom.reportWrite(value, super.isPlaying, () {
      super.isPlaying = value;
    });
  }

  late final _$isCheckingAtom =
      Atom(name: '_Ielts.isChecking', context: context);

  @override
  bool get isChecking {
    _$isCheckingAtom.reportRead();
    return super.isChecking;
  }

  @override
  set isChecking(bool value) {
    _$isCheckingAtom.reportWrite(value, super.isChecking, () {
      super.isChecking = value;
    });
  }

  late final _$loadTestsAsyncAction =
      AsyncAction('_Ielts.loadTests', context: context);

  @override
  Future<void> loadTests() {
    return _$loadTestsAsyncAction.run(() => super.loadTests());
  }

  late final _$_IeltsActionController =
      ActionController(name: '_Ielts', context: context);

  @override
  void selectTest(Test t) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.selectTest');
    try {
      return super.selectTest(t);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fill(String num, String answer) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.fill');
    try {
      return super.fill(num, answer);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkAnswers() {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.checkAnswers');
    try {
      return super.checkAnswers();
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
allTests: ${allTests},
test: ${test},
part: ${part},
group: ${group},
isPlaying: ${isPlaying},
isChecking: ${isChecking},
tests: ${tests},
partQuestions: ${partQuestions}
    ''';
  }
}
