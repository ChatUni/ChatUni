// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutors.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Tutors on _Tutors, Store {
  Computed<bool>? _$isTutorSelectedComputed;

  @override
  bool get isTutorSelected =>
      (_$isTutorSelectedComputed ??= Computed<bool>(() => super.isTutorSelected,
              name: '_Tutors.isTutorSelected'))
          .value;

  late final _$isRecordingAtom =
      Atom(name: '_Tutors.isRecording', context: context);

  @override
  bool get isRecording {
    _$isRecordingAtom.reportRead();
    return super.isRecording;
  }

  @override
  set isRecording(bool value) {
    _$isRecordingAtom.reportWrite(value, super.isRecording, () {
      super.isRecording = value;
    });
  }

  late final _$isReadingAtom =
      Atom(name: '_Tutors.isReading', context: context);

  @override
  bool get isReading {
    _$isReadingAtom.reportRead();
    return super.isReading;
  }

  @override
  set isReading(bool value) {
    _$isReadingAtom.reportWrite(value, super.isReading, () {
      super.isReading = value;
    });
  }

  late final _$tutorsAtom = Atom(name: '_Tutors.tutors', context: context);

  @override
  ObservableList<Tutor> get tutors {
    _$tutorsAtom.reportRead();
    return super.tutors;
  }

  @override
  set tutors(ObservableList<Tutor> value) {
    _$tutorsAtom.reportWrite(value, super.tutors, () {
      super.tutors = value;
    });
  }

  late final _$tutorAtom = Atom(name: '_Tutors.tutor', context: context);

  @override
  Tutor? get tutor {
    _$tutorAtom.reportRead();
    return super.tutor;
  }

  @override
  set tutor(Tutor? value) {
    _$tutorAtom.reportWrite(value, super.tutor, () {
      super.tutor = value;
    });
  }

  late final _$msgsAtom = Atom(name: '_Tutors.msgs', context: context);

  @override
  ObservableList<Msg> get msgs {
    _$msgsAtom.reportRead();
    return super.msgs;
  }

  @override
  set msgs(ObservableList<Msg> value) {
    _$msgsAtom.reportWrite(value, super.msgs, () {
      super.msgs = value;
    });
  }

  late final _$langAtom = Atom(name: '_Tutors.lang', context: context);

  @override
  String get lang {
    _$langAtom.reportRead();
    return super.lang;
  }

  @override
  set lang(String value) {
    _$langAtom.reportWrite(value, super.lang, () {
      super.lang = value;
    });
  }

  late final _$loadTutorsAsyncAction =
      AsyncAction('_Tutors.loadTutors', context: context);

  @override
  Future<void> loadTutors() {
    return _$loadTutorsAsyncAction.run(() => super.loadTutors());
  }

  late final _$selectTutorAsyncAction =
      AsyncAction('_Tutors.selectTutor', context: context);

  @override
  Future<void> selectTutor(Tutor t) {
    return _$selectTutorAsyncAction.run(() => super.selectTutor(t));
  }

  late final _$startRecordingAsyncAction =
      AsyncAction('_Tutors.startRecording', context: context);

  @override
  Future<void> startRecording() {
    return _$startRecordingAsyncAction.run(() => super.startRecording());
  }

  late final _$stopRecordingAsyncAction =
      AsyncAction('_Tutors.stopRecording', context: context);

  @override
  Future<void> stopRecording() {
    return _$stopRecordingAsyncAction.run(() => super.stopRecording());
  }

  late final _$readAsyncAction = AsyncAction('_Tutors.read', context: context);

  @override
  Future<void> read(Msg m) {
    return _$readAsyncAction.run(() => super.read(m));
  }

  late final _$_TutorsActionController =
      ActionController(name: '_Tutors', context: context);

  @override
  void clearTutor() {
    final _$actionInfo =
        _$_TutorsActionController.startAction(name: '_Tutors.clearTutor');
    try {
      return super.clearTutor();
    } finally {
      _$_TutorsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLang(String l) {
    final _$actionInfo =
        _$_TutorsActionController.startAction(name: '_Tutors.setLang');
    try {
      return super.setLang(l);
    } finally {
      _$_TutorsActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isRecording: ${isRecording},
isReading: ${isReading},
tutors: ${tutors},
tutor: ${tutor},
msgs: ${msgs},
lang: ${lang},
isTutorSelected: ${isTutorSelected}
    ''';
  }
}
