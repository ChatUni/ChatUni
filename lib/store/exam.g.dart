// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Exam on _Exam, Store {
  Computed<List<Component>>? _$compsComputed;

  @override
  List<Component> get comps => (_$compsComputed ??=
          Computed<List<Component>>(() => super.comps, name: '_Exam.comps'))
      .value;
  Computed<List<String>>? _$compNamesComputed;

  @override
  List<String> get compNames =>
      (_$compNamesComputed ??= Computed<List<String>>(() => super.compNames,
              name: '_Exam.compNames'))
          .value;
  Computed<List<MapEntry<int, List<Test>>>>? _$testsComputed;

  @override
  List<MapEntry<int, List<Test>>> get tests => (_$testsComputed ??=
          Computed<List<MapEntry<int, List<Test>>>>(() => super.tests,
              name: '_Exam.tests'))
      .value;
  Computed<bool>? _$isCompSelectedComputed;

  @override
  bool get isCompSelected =>
      (_$isCompSelectedComputed ??= Computed<bool>(() => super.isCompSelected,
              name: '_Exam.isCompSelected'))
          .value;
  Computed<Part?>? _$partComputed;

  @override
  Part? get part =>
      (_$partComputed ??= Computed<Part?>(() => super.part, name: '_Exam.part'))
          .value;
  Computed<bool>? _$isPartSelectedComputed;

  @override
  bool get isPartSelected =>
      (_$isPartSelectedComputed ??= Computed<bool>(() => super.isPartSelected,
              name: '_Exam.isPartSelected'))
          .value;
  Computed<bool>? _$isFirstPartComputed;

  @override
  bool get isFirstPart => (_$isFirstPartComputed ??=
          Computed<bool>(() => super.isFirstPart, name: '_Exam.isFirstPart'))
      .value;
  Computed<bool>? _$isLastPartComputed;

  @override
  bool get isLastPart => (_$isLastPartComputed ??=
          Computed<bool>(() => super.isLastPart, name: '_Exam.isLastPart'))
      .value;
  Computed<int>? _$compIndexComputed;

  @override
  int get compIndex => (_$compIndexComputed ??=
          Computed<int>(() => super.compIndex, name: '_Exam.compIndex'))
      .value;
  Computed<Component>? _$nextComponentComputed;

  @override
  Component get nextComponent => (_$nextComponentComputed ??=
          Computed<Component>(() => super.nextComponent,
              name: '_Exam.nextComponent'))
      .value;
  Computed<Component>? _$prevComponentComputed;

  @override
  Component get prevComponent => (_$prevComponentComputed ??=
          Computed<Component>(() => super.prevComponent,
              name: '_Exam.prevComponent'))
      .value;
  Computed<bool>? _$isFirstCompComputed;

  @override
  bool get isFirstComp => (_$isFirstCompComputed ??=
          Computed<bool>(() => super.isFirstComp, name: '_Exam.isFirstComp'))
      .value;
  Computed<bool>? _$isLastCompComputed;

  @override
  bool get isLastComp => (_$isLastCompComputed ??=
          Computed<bool>(() => super.isLastComp, name: '_Exam.isLastComp'))
      .value;
  Computed<List<List<Part>>>? _$allCompsComputed;

  @override
  List<List<Part>> get allComps =>
      (_$allCompsComputed ??= Computed<List<List<Part>>>(() => super.allComps,
              name: '_Exam.allComps'))
          .value;
  Computed<List<Part>>? _$allPartsComputed;

  @override
  List<Part> get allParts => (_$allPartsComputed ??=
          Computed<List<Part>>(() => super.allParts, name: '_Exam.allParts'))
      .value;
  Computed<List<Question>>? _$allQuestionsComputed;

  @override
  List<Question> get allQuestions => (_$allQuestionsComputed ??=
          Computed<List<Question>>(() => super.allQuestions,
              name: '_Exam.allQuestions'))
      .value;
  Computed<List<Question>>? _$partQuestionsComputed;

  @override
  List<Question> get partQuestions => (_$partQuestionsComputed ??=
          Computed<List<Question>>(() => super.partQuestions,
              name: '_Exam.partQuestions'))
      .value;
  Computed<Question>? _$writeQuestionComputed;

  @override
  Question get writeQuestion =>
      (_$writeQuestionComputed ??= Computed<Question>(() => super.writeQuestion,
              name: '_Exam.writeQuestion'))
          .value;
  Computed<Component?>? _$writeComponentComputed;

  @override
  Component? get writeComponent => (_$writeComponentComputed ??=
          Computed<Component?>(() => super.writeComponent,
              name: '_Exam.writeComponent'))
      .value;
  Computed<List<Question>>? _$writeQuestionsComputed;

  @override
  List<Question> get writeQuestions => (_$writeQuestionsComputed ??=
          Computed<List<Question>>(() => super.writeQuestions,
              name: '_Exam.writeQuestions'))
      .value;
  Computed<Component?>? _$speakComponentComputed;

  @override
  Component? get speakComponent => (_$speakComponentComputed ??=
          Computed<Component?>(() => super.speakComponent,
              name: '_Exam.speakComponent'))
      .value;
  Computed<List<Question>>? _$speakQuestionsComputed;

  @override
  List<Question> get speakQuestions => (_$speakQuestionsComputed ??=
          Computed<List<Question>>(() => super.speakQuestions,
              name: '_Exam.speakQuestions'))
      .value;
  Computed<bool>? _$isLastQuestionComputed;

  @override
  bool get isLastQuestion =>
      (_$isLastQuestionComputed ??= Computed<bool>(() => super.isLastQuestion,
              name: '_Exam.isLastQuestion'))
          .value;
  Computed<int>? _$timeLimitComputed;

  @override
  int get timeLimit => (_$timeLimitComputed ??=
          Computed<int>(() => super.timeLimit, name: '_Exam.timeLimit'))
      .value;
  Computed<String>? _$timeLeftComputed;

  @override
  String get timeLeft => (_$timeLeftComputed ??=
          Computed<String>(() => super.timeLeft, name: '_Exam.timeLeft'))
      .value;
  Computed<bool>? _$isTimeLeftAlertComputed;

  @override
  bool get isTimeLeftAlert =>
      (_$isTimeLeftAlertComputed ??= Computed<bool>(() => super.isTimeLeftAlert,
              name: '_Exam.isTimeLeftAlert'))
          .value;

  late final _$nameAtom = Atom(name: '_Exam.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$allTestsAtom = Atom(name: '_Exam.allTests', context: context);

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

  late final _$testAtom = Atom(name: '_Exam.test', context: context);

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

  late final _$componentAtom = Atom(name: '_Exam.component', context: context);

  @override
  Component? get component {
    _$componentAtom.reportRead();
    return super.component;
  }

  @override
  set component(Component? value) {
    _$componentAtom.reportWrite(value, super.component, () {
      super.component = value;
    });
  }

  late final _$partIndexAtom = Atom(name: '_Exam.partIndex', context: context);

  @override
  int get partIndex {
    _$partIndexAtom.reportRead();
    return super.partIndex;
  }

  @override
  set partIndex(int value) {
    _$partIndexAtom.reportWrite(value, super.partIndex, () {
      super.partIndex = value;
    });
  }

  late final _$partsAtom = Atom(name: '_Exam.parts', context: context);

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

  late final _$groupAtom = Atom(name: '_Exam.group', context: context);

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
      Atom(name: '_Exam.questionIndex', context: context);

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

  late final _$isPlayingAtom = Atom(name: '_Exam.isPlaying', context: context);

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
      Atom(name: '_Exam.isRecording', context: context);

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
      Atom(name: '_Exam.isChecking', context: context);

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

  late final _$isScoringAtom = Atom(name: '_Exam.isScoring', context: context);

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

  late final _$countDownAtom = Atom(name: '_Exam.countDown', context: context);

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

  late final _$timeIsUpAtom = Atom(name: '_Exam.timeIsUp', context: context);

  @override
  bool get timeIsUp {
    _$timeIsUpAtom.reportRead();
    return super.timeIsUp;
  }

  @override
  set timeIsUp(bool value) {
    _$timeIsUpAtom.reportWrite(value, super.timeIsUp, () {
      super.timeIsUp = value;
    });
  }

  late final _$resultsAtom = Atom(name: '_Exam.results', context: context);

  @override
  List<Result> get results {
    _$resultsAtom.reportRead();
    return super.results;
  }

  @override
  set results(List<Result> value) {
    _$resultsAtom.reportWrite(value, super.results, () {
      super.results = value;
    });
  }

  late final _$resultAtom = Atom(name: '_Exam.result', context: context);

  @override
  Result? get result {
    _$resultAtom.reportRead();
    return super.result;
  }

  @override
  set result(Result? value) {
    _$resultAtom.reportWrite(value, super.result, () {
      super.result = value;
    });
  }

  late final _$rcAtom = Atom(name: '_Exam.rc', context: context);

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
      AsyncAction('_Exam.loadTests', context: context);

  @override
  Future<void> loadTests(String exam) {
    return _$loadTestsAsyncAction.run(() => super.loadTests(exam));
  }

  late final _$partSelectedAsyncAction =
      AsyncAction('_Exam.partSelected', context: context);

  @override
  Future<void> partSelected() {
    return _$partSelectedAsyncAction.run(() => super.partSelected());
  }

  late final _$startRecordingAsyncAction =
      AsyncAction('_Exam.startRecording', context: context);

  @override
  Future<void> startRecording() {
    return _$startRecordingAsyncAction.run(() => super.startRecording());
  }

  late final _$stopRecordingAsyncAction =
      AsyncAction('_Exam.stopRecording', context: context);

  @override
  Future<void> stopRecording(Question q) {
    return _$stopRecordingAsyncAction.run(() => super.stopRecording(q));
  }

  late final _$scoreAsyncAction = AsyncAction('_Exam.score', context: context);

  @override
  Future<dynamic> score() {
    return _$scoreAsyncAction.run(() => super.score());
  }

  late final _$loadResultsAsyncAction =
      AsyncAction('_Exam.loadResults', context: context);

  @override
  Future<dynamic> loadResults() {
    return _$loadResultsAsyncAction.run(() => super.loadResults());
  }

  late final _$saveTestResultAsyncAction =
      AsyncAction('_Exam.saveTestResult', context: context);

  @override
  Future<dynamic> saveTestResult() {
    return _$saveTestResultAsyncAction.run(() => super.saveTestResult());
  }

  late final _$_ExamActionController =
      ActionController(name: '_Exam', context: context);

  @override
  void selectTest(Test t) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.selectTest');
    try {
      return super.selectTest(t);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setComp(Component comp) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.setComp');
    try {
      return super.setComp(comp);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextComp(int step) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.nextComp');
    try {
      return super.nextComp(step);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextPart(int step) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.nextPart');
    try {
      return super.nextPart(step);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void firstPart() {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.firstPart');
    try {
      return super.firstPart();
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fill(int num, String answer) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.fill');
    try {
      return super.fill(num, answer);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void trueFalseSelect(Question q, String answer) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.trueFalseSelect');
    try {
      return super.trueFalseSelect(q, answer);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void singleSelect(Question q, String answer) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.singleSelect');
    try {
      return super.singleSelect(q, answer);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void multiSelect(Question q1, Question q2, String answer) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.multiSelect');
    try {
      return super.multiSelect(q1, q2, answer);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkAnswers(Component comp) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.checkAnswers');
    try {
      return super.checkAnswers(comp);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void play() {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.play');
    try {
      return super.play();
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stop() {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.stop');
    try {
      return super.stop();
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void write(String t) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.write');
    try {
      return super.write(t);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void playVideo(int num) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.playVideo');
    try {
      return super.playVideo(num);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextQuestion() {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.nextQuestion');
    try {
      return super.nextQuestion();
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadResult(Result result) {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.loadResult');
    try {
      return super.loadResult(result);
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startTimer() {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.startTimer');
    try {
      return super.startTimer();
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool updateTimer() {
    final _$actionInfo =
        _$_ExamActionController.startAction(name: '_Exam.updateTimer');
    try {
      return super.updateTimer();
    } finally {
      _$_ExamActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
allTests: ${allTests},
test: ${test},
component: ${component},
partIndex: ${partIndex},
parts: ${parts},
group: ${group},
questionIndex: ${questionIndex},
isPlaying: ${isPlaying},
isRecording: ${isRecording},
isChecking: ${isChecking},
isScoring: ${isScoring},
countDown: ${countDown},
timeIsUp: ${timeIsUp},
results: ${results},
result: ${result},
rc: ${rc},
comps: ${comps},
compNames: ${compNames},
tests: ${tests},
isCompSelected: ${isCompSelected},
part: ${part},
isPartSelected: ${isPartSelected},
isFirstPart: ${isFirstPart},
isLastPart: ${isLastPart},
compIndex: ${compIndex},
nextComponent: ${nextComponent},
prevComponent: ${prevComponent},
isFirstComp: ${isFirstComp},
isLastComp: ${isLastComp},
allComps: ${allComps},
allParts: ${allParts},
allQuestions: ${allQuestions},
partQuestions: ${partQuestions},
writeQuestion: ${writeQuestion},
writeComponent: ${writeComponent},
writeQuestions: ${writeQuestions},
speakComponent: ${speakComponent},
speakQuestions: ${speakQuestions},
isLastQuestion: ${isLastQuestion},
timeLimit: ${timeLimit},
timeLeft: ${timeLeft},
isTimeLeftAlert: ${isTimeLeftAlert}
    ''';
  }
}
