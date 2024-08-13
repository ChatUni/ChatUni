// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Courses on _Courses, Store {
  late final _$listeningsAtom =
      Atom(name: '_Courses.listenings', context: context);

  @override
  List<Listening> get listenings {
    _$listeningsAtom.reportRead();
    return super.listenings;
  }

  @override
  set listenings(List<Listening> value) {
    _$listeningsAtom.reportWrite(value, super.listenings, () {
      super.listenings = value;
    });
  }

  late final _$loadListeningsAsyncAction =
      AsyncAction('_Courses.loadListenings', context: context);

  @override
  Future<void> loadListenings(CourseType type) {
    return _$loadListeningsAsyncAction.run(() => super.loadListenings(type));
  }

  @override
  String toString() {
    return '''
listenings: ${listenings}
    ''';
  }
}
