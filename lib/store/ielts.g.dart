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
  Computed<bool>? _$isCompSelectedComputed;

  @override
  bool get isCompSelected =>
      (_$isCompSelectedComputed ??= Computed<bool>(() => super.isCompSelected,
              name: '_Ielts.isCompSelected'))
          .value;
  Computed<bool>? _$isPartSelectedComputed;

  @override
  bool get isPartSelected =>
      (_$isPartSelectedComputed ??= Computed<bool>(() => super.isPartSelected,
              name: '_Ielts.isPartSelected'))
          .value;
  Computed<int>? _$partIndexComputed;

  @override
  int get partIndex => (_$partIndexComputed ??=
          Computed<int>(() => super.partIndex, name: '_Ielts.partIndex'))
      .value;
  Computed<bool>? _$isFirstPartComputed;

  @override
  bool get isFirstPart => (_$isFirstPartComputed ??=
          Computed<bool>(() => super.isFirstPart, name: '_Ielts.isFirstPart'))
      .value;
  Computed<bool>? _$isLastPartComputed;

  @override
  bool get isLastPart => (_$isLastPartComputed ??=
          Computed<bool>(() => super.isLastPart, name: '_Ielts.isLastPart'))
      .value;
  Computed<int>? _$compIndexComputed;

  @override
  int get compIndex => (_$compIndexComputed ??=
          Computed<int>(() => super.compIndex, name: '_Ielts.compIndex'))
      .value;
  Computed<String>? _$nextComponentComputed;

  @override
  String get nextComponent =>
      (_$nextComponentComputed ??= Computed<String>(() => super.nextComponent,
              name: '_Ielts.nextComponent'))
          .value;
  Computed<String>? _$prevComponentComputed;

  @override
  String get prevComponent =>
      (_$prevComponentComputed ??= Computed<String>(() => super.prevComponent,
              name: '_Ielts.prevComponent'))
          .value;
  Computed<bool>? _$isFirstCompComputed;

  @override
  bool get isFirstComp => (_$isFirstCompComputed ??=
          Computed<bool>(() => super.isFirstComp, name: '_Ielts.isFirstComp'))
      .value;
  Computed<bool>? _$isLastCompComputed;

  @override
  bool get isLastComp => (_$isLastCompComputed ??=
          Computed<bool>(() => super.isLastComp, name: '_Ielts.isLastComp'))
      .value;
  Computed<List<List<Part>>>? _$allCompsComputed;

  @override
  List<List<Part>> get allComps =>
      (_$allCompsComputed ??= Computed<List<List<Part>>>(() => super.allComps,
              name: '_Ielts.allComps'))
          .value;
  Computed<List<Part>>? _$allPartsComputed;

  @override
  List<Part> get allParts => (_$allPartsComputed ??=
          Computed<List<Part>>(() => super.allParts, name: '_Ielts.allParts'))
      .value;
  Computed<List<Question>>? _$partQuestionsComputed;

  @override
  List<Question> get partQuestions => (_$partQuestionsComputed ??=
          Computed<List<Question>>(() => super.partQuestions,
              name: '_Ielts.partQuestions'))
      .value;
  Computed<Question>? _$writeQuestionComputed;

  @override
  Question get writeQuestion =>
      (_$writeQuestionComputed ??= Computed<Question>(() => super.writeQuestion,
              name: '_Ielts.writeQuestion'))
          .value;
  Computed<List<Question>>? _$writeQuestionsComputed;

  @override
  List<Question> get writeQuestions => (_$writeQuestionsComputed ??=
          Computed<List<Question>>(() => super.writeQuestions,
              name: '_Ielts.writeQuestions'))
      .value;
  Computed<List<Question>>? _$speakQuestionsComputed;

  @override
  List<Question> get speakQuestions => (_$speakQuestionsComputed ??=
          Computed<List<Question>>(() => super.speakQuestions,
              name: '_Ielts.speakQuestions'))
      .value;
  Computed<bool>? _$isLastQuestionComputed;

  @override
  bool get isLastQuestion =>
      (_$isLastQuestionComputed ??= Computed<bool>(() => super.isLastQuestion,
              name: '_Ielts.isLastQuestion'))
          .value;
  Computed<bool>? _$hasTimerComputed;

  @override
  bool get hasTimer => (_$hasTimerComputed ??=
          Computed<bool>(() => super.hasTimer, name: '_Ielts.hasTimer'))
      .value;
  Computed<String>? _$timeLeftComputed;

  @override
  String get timeLeft => (_$timeLeftComputed ??=
          Computed<String>(() => super.timeLeft, name: '_Ielts.timeLeft'))
      .value;
  Computed<bool>? _$isTimeLeftAlertComputed;

  @override
  bool get isTimeLeftAlert =>
      (_$isTimeLeftAlertComputed ??= Computed<bool>(() => super.isTimeLeftAlert,
              name: '_Ielts.isTimeLeftAlert'))
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

  late final _$componentAtom = Atom(name: '_Ielts.component', context: context);

  @override
  String? get component {
    _$componentAtom.reportRead();
    return super.component;
  }

  @override
  set component(String? value) {
    _$componentAtom.reportWrite(value, super.component, () {
      super.component = value;
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

  late final _$partsAtom = Atom(name: '_Ielts.parts', context: context);

  @override
  List<Part> get parts {
    _$partsAtom.reportRead();
    return super.parts;
  }

  @override
  set parts(List<Part> value) {
    _$partsAtom.reportWrite(value, super.parts, () {
      super.parts = value;
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

  late final _$questionIndexAtom =
      Atom(name: '_Ielts.questionIndex', context: context);

  @override
  int get questionIndex {
    _$questionIndexAtom.reportRead();
    return super.questionIndex;
  }

  @override
  set questionIndex(int value) {
    _$questionIndexAtom.reportWrite(value, super.questionIndex, () {
      super.questionIndex = value;
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

  late final _$isRecordingAtom =
      Atom(name: '_Ielts.isRecording', context: context);

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

  late final _$isScoringAtom = Atom(name: '_Ielts.isScoring', context: context);

  @override
  bool get isScoring {
    _$isScoringAtom.reportRead();
    return super.isScoring;
  }

  @override
  set isScoring(bool value) {
    _$isScoringAtom.reportWrite(value, super.isScoring, () {
      super.isScoring = value;
    });
  }

  late final _$countDownAtom = Atom(name: '_Ielts.countDown', context: context);

  @override
  int get countDown {
    _$countDownAtom.reportRead();
    return super.countDown;
  }

  @override
  set countDown(int value) {
    _$countDownAtom.reportWrite(value, super.countDown, () {
      super.countDown = value;
    });
  }

  late final _$rcAtom = Atom(name: '_Ielts.rc', context: context);

  @override
  int get rc {
    _$rcAtom.reportRead();
    return super.rc;
  }

  @override
  set rc(int value) {
    _$rcAtom.reportWrite(value, super.rc, () {
      super.rc = value;
    });
  }

  late final _$loadTestsAsyncAction =
      AsyncAction('_Ielts.loadTests', context: context);

  @override
  Future<void> loadTests() {
    return _$loadTestsAsyncAction.run(() => super.loadTests());
  }

  late final _$partSelectedAsyncAction =
      AsyncAction('_Ielts.partSelected', context: context);

  @override
  Future<void> partSelected() {
    return _$partSelectedAsyncAction.run(() => super.partSelected());
  }

  late final _$startRecordingAsyncAction =
      AsyncAction('_Ielts.startRecording', context: context);

  @override
  Future<void> startRecording() {
    return _$startRecordingAsyncAction.run(() => super.startRecording());
  }

  late final _$stopRecordingAsyncAction =
      AsyncAction('_Ielts.stopRecording', context: context);

  @override
  Future<void> stopRecording(Question q) {
    return _$stopRecordingAsyncAction.run(() => super.stopRecording(q));
  }

  late final _$scoreAsyncAction = AsyncAction('_Ielts.score', context: context);

  @override
  Future<dynamic> score() {
    return _$scoreAsyncAction.run(() => super.score());
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
  void setComp(int idx) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.setComp');
    try {
      return super.setComp(idx);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextComp(int step) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.nextComp');
    try {
      return super.nextComp(step);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextPart(int step) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.nextPart');
    try {
      return super.nextPart(step);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void firstPart() {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.firstPart');
    try {
      return super.firstPart();
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fill(int num, String answer) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.fill');
    try {
      return super.fill(num, answer);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void trueFalseSelect(Question q, String answer) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.trueFalseSelect');
    try {
      return super.trueFalseSelect(q, answer);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void singleSelect(Question q, String answer) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.singleSelect');
    try {
      return super.singleSelect(q, answer);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void multiSelect(Question q1, Question q2, String answer) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.multiSelect');
    try {
      return super.multiSelect(q1, q2, answer);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkAnswers(int idx) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.checkAnswers');
    try {
      return super.checkAnswers(idx);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void play() {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.play');
    try {
      return super.play();
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stop() {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.stop');
    try {
      return super.stop();
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void write(String t) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.write');
    try {
      return super.write(t);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void playVideo(int num) {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.playVideo');
    try {
      return super.playVideo(num);
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextQuestion() {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.nextQuestion');
    try {
      return super.nextQuestion();
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startTimer() {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.startTimer');
    try {
      return super.startTimer();
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool updateTimer() {
    final _$actionInfo =
        _$_IeltsActionController.startAction(name: '_Ielts.updateTimer');
    try {
      return super.updateTimer();
    } finally {
      _$_IeltsActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
allTests: ${allTests},
test: ${test},
component: ${component},
part: ${part},
parts: ${parts},
group: ${group},
questionIndex: ${questionIndex},
isPlaying: ${isPlaying},
isRecording: ${isRecording},
isChecking: ${isChecking},
isScoring: ${isScoring},
countDown: ${countDown},
rc: ${rc},
tests: ${tests},
isCompSelected: ${isCompSelected},
isPartSelected: ${isPartSelected},
partIndex: ${partIndex},
isFirstPart: ${isFirstPart},
isLastPart: ${isLastPart},
compIndex: ${compIndex},
nextComponent: ${nextComponent},
prevComponent: ${prevComponent},
isFirstComp: ${isFirstComp},
isLastComp: ${isLastComp},
allComps: ${allComps},
allParts: ${allParts},
partQuestions: ${partQuestions},
writeQuestion: ${writeQuestion},
writeQuestions: ${writeQuestions},
speakQuestions: ${speakQuestions},
isLastQuestion: ${isLastQuestion},
hasTimer: ${hasTimer},
timeLeft: ${timeLeft},
isTimeLeftAlert: ${isTimeLeftAlert}
    ''';
  }
}
