// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ielts.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Ielts on _Ielts, Store {
  late final _$testsAtom = Atom(name: '_Ielts.tests', context: context);

  @override
  ObservableList<Test> get tests {
    _$testsAtom.reportRead();
    return super.tests;
  }

  @override
  set tests(ObservableList<Test> value) {
    _$testsAtom.reportWrite(value, super.tests, () {
      super.tests = value;
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
tests: ${tests}
    ''';
  }
}
