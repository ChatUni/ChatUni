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

  late final _$loadTestsAsyncAction =
      AsyncAction('_Ielts.loadTests', context: context);

  @override
  Future<void> loadTests() {
    return _$loadTestsAsyncAction.run(() => super.loadTests());
  }

  @override
  String toString() {
    return '''
allTests: ${allTests},
tests: ${tests}
    ''';
  }
}
