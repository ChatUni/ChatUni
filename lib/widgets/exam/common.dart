import 'package:chatuni/models/exam.dart';
import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/exam.dart';
import 'package:chatuni/utils/const.dart' as consts;
import 'package:chatuni/utils/utils.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/dropdown.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/input.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

var tagHandlers = Map.fromIterables(
  tags,
  [
    h1,
    h3under,
    h3under,
    h4,
    bold,
    italic,
    txt,
    (String x) => Image.network(x.startsWith('http') ? x : cdImg(x)),
    (String x) => playButton(),
  ],
);

Widget examScaffold(String title, List<Widget> ws) => scaffold(
      vContainer(
        [
          vSpacer(10),
          ...ws,
          vSpacer(100),
        ],
        padding: 20,
        scroll: true,
      ),
      title: title,
      routeGroup: RouteGroup.exam,
      bgColor: Colors.white,
    );

Image spinner = Image.asset(
  'assets/images/gif/dots.gif',
  width: 200,
  height: 100,
);

Widget playButton() => obs<Exam>(
      (exam) => button(
        exam.isPlaying ? exam.stop : exam.play,
        icon: exam.isPlaying ? Icons.stop : Icons.play_arrow,
        bgColor: exam.isPlaying ? Colors.red : Colors.green,
      ),
    );

Widget content(String s) => obs<Exam>((exam) {
      final (content, tag) = exam.contentTag(s);
      final (num, s1, s2) = exam.parseFill(content);

      return num > -1
          ? fillQuestion(num, s1!, s2!)
          : left(
              tag != null ? tagHandlers[tag]!(content) : txt(content),
            );
    });

Widget fillQuestion(
  int num,
  String s1,
  String s2,
) =>
    obs<Exam>(
      (exam) => scRow([
        bold('Q$num)'), //${exam.rc < 0 ? '' : ''}'),
        hSpacer(8),
        ...s1.isNotEmpty ? [txt(s1), hSpacer(8)] : [hSpacer(0)],
        grow(
          exam.getParagraphForQuestion(num)?.maxChoice != null
              ? dropdownbtn(
                  range(
                    65,
                    exam.getParagraphForQuestion(num)!.maxChoice!.codeUnitAt(0),
                  ).map(String.fromCharCode).toList(),
                  exam.getQuestion(num)?.userAnswer,
                  (t) => exam.fill(num, t, refresh: true),
                )
              : fillInput(
                  (t) => exam.fill(num, t),
                  exam.getQuestion(num)?.userAnswer,
                  exam.isChecking ? exam.checkAnswer(num) : null,
                ),
        ),
        hSpacer(8),
        txt(s2),
        hSpacer(8),
      ]),
    );

Widget fillInput(
  void Function(String) onChanged,
  String? userAnswer,
  String? error,
) =>
    input(
      onChanged,
      initialValue: userAnswer,
      style: InputStyle.underline,
      isDense: true,
      error: error,
    );

Widget group(Group g) => obs<Exam>(
      (exam) => ssCol([
        g.groupName.isNotEmpty ? bold(g.groupName) : vSpacer(0),
        ...g.paragraphs.expand((p) => paragraph(p, exam)),
      ]),
    );

List<Widget> paragraph(Paragraph p, Exam exam) {
  Iterable<Widget> ps = [];
  if (p.isSharedChoice) {
    ps = [
      bold(p.questionNumbers),
      ...p.nonChoiceContent.map(content),
      vSpacer(8),
      ssRow([
        txt('Q10)', bold: true, color: Colors.white),
        vSpacer(4),
        grow(ssCol(p.choiceList.map(shareChoice).toList())),
      ]),
      vSpacer(16),
    ];
  } else if (p.isSingleChoice || p.isChoiceOnly) {
    ps = p.questions!.map((q) => choice(q, false, exam.isChecking));
  } else if (p.isMultiChoice) {
    ps = p.questions!.map((q) => choice(q, true, exam.isChecking));
  } else if (p.isTrueFalse) {
    ps = lidx(p.questions!).expand(
      (i) => trueFalse(
        p.questions![i],
        numAndTitle(p.content[i]).$2,
        exam.isChecking,
      ),
    );
  } else if (p.hasAudio) {
    ps = [content(p.content[0]), vSpacer(12), playButton()];
  } else if (p.isWriteQuestion) {
    ps = [
      content(p.questions![0].subject!.trim()),
      vSpacer(8),
      writeBoxAndAnswer(p.questions![0]),
    ];
  } else if (p.isSpeakQuestion) {
    final ps1 = p.questions![0].subject != null
        ? [content(p.questions![0].subject!)]
        : p.content.map(content);
    ps = exam.isToefl
        ? [
            ...ps1,
            vSpacer(12),
            recordAnswerButton(p.questions![0], false),
          ]
        : ps;
  } else if (!p.isScript) {
    ps = p.content.map(content);
  }
  return ps.isEmpty ? [] : [...ps, vSpacer(12)];
}

List<Widget> trueFalse(Question q, String c, bool isChecking) => [
      ssRow([
        explainCol(q.number, isChecking),
        hSpacer(8),
        grow(content(c)),
      ]),
      vSpacer(4),
      box(
        null,
        24,
        ssRow([
          txt('Q${q.number})', bold: true, color: Colors.white),
          hSpacer(8),
          trueFalseButton('TRUE', q),
          hSpacer(8),
          trueFalseButton('FALSE', q),
          hSpacer(8),
          trueFalseButton('NOT GIVEN', q),
        ]),
      ),
      vSpacer(16),
    ];

Widget trueFalseButton(String text, Question q) => obs<Exam>(
      (exam) => button(
        () => exam.trueFalseSelect(q, text),
        text: '$text${exam.rc < 0 ? '' : ''}',
        size: 10,
        padding: 10,
        outline: !(exam.isChecking && q.isActual(text) || q.userAnswer == text),
        bgColor: exam.isChecking
            ? q.isActual(text)
                ? const Color(consts.Colors.darkGreen)
                : Colors.red
            : const Color(consts.Colors.darkBlue),
      ),
    );

Widget choice(Question q, bool isMulti, bool isChecking) => ssRow([
      //q.subject != null && q.subject!.isNotEmpty
      explainCol(q.number, isChecking),
      hSpacer(4),
      grow(
        ssCol([
          bold(q.subject ?? ''),
          ...(q.images ?? []).map(tagHandlers['img']!),
          ...q.choiceList.map(
            (c) => obs<Exam>(
              (exam) => tap(
                () =>
                    (isMulti ? exam.multiSelect : exam.singleSelect)(q, c.key),
                txt(
                  '${c.key}. ${c.value}${exam.rc < 0 ? '' : ''}',
                  color: Color(exam.choiceColor(c)),
                  bold: exam.boldChoice(c),
                ),
              ),
            ),
          ),
          vSpacer(16),
        ]),
      ),
    ]);

Widget shareChoice(Choice choice) => obs<Exam>(
      (exam) => tap(
        () => exam.shareSelect(choice.q1, choice.q2, choice.key),
        txt(
          '${choice.key}. ${choice.value}${exam.rc < 0 ? '' : ''}',
          color: Color(exam.choiceColor(choice)),
          bold: exam.boldChoice(choice),
        ),
      ),
    );

// Widget checkButton() => obs<Exam>(
//       (exam) => button(
//         exam.checkAnswers,
//         text: 'Check Answers',
//         bgColor: Colors.green,
//       ),
//     );

Widget prevNext() => obs<Exam>(
      (exam) => ccRow([
        grow(
          button(
            exam.isFirstPart ? null : () => exam.nextPart(-1),
            text: 'Prev Part',
          ),
        ),
        hSpacer(16),
        grow(
          button(
            exam.isLastPart
                ? exam.isChecking
                    ? null
                    : () async {
                        if (exam.isLastComp) {
                          await exam.score();
                          exam.saveTestResult();
                          router.go('/exam_result');
                        } else {
                          exam.nextComp(1);
                        }
                      }
                : () => exam.nextPart(1),
            text: exam.isLastPart
                ? exam.isLastComp
                    ? 'Finish'
                    : exam.nextComponent.title
                : 'Next Part',
          ),
        ),
      ]),
    );

Widget showResult(bool isChecking) => isChecking
    ? button(
        () => router.go('/exam_result'),
        text: 'Show Results',
        bgColor: Colors.orange,
      )
    : vSpacer(1);

Widget writeBox(
  void Function(String) onChanged,
  String? userAnswer,
) =>
    input(
      onChanged,
      initialValue: userAnswer ?? '',
      minLines: 20,
      maxLines: 20,
      keyboardType: TextInputType.multiline,
      style: InputStyle.outline,
    );

Widget analysis(String? t, bool isChecking) => isChecking && t != null
    ? ssCol([
        vSpacer(8),
        bold('Score and Analysis:'),
        txt(t),
      ])
    : vSpacer(1);

Widget writeBoxAndAnswer(Question q) => obs<Exam>(
      (exam) => exam.component!.isWrite
          ? ssCol([
              writeBox(
                (t) => exam.write(q, t),
                q.userAnswer,
              ),
              analysis(q.answer, exam.isChecking),
              // vSpacer(4),
              txt(exam.rc > 0 ? '' : ''),
            ])
          : vSpacer(1),
    );

Widget speakVideo() => obs<Exam>((exam) {
      if (!exam.isIelts || !exam.component!.isSpeak) return vSpacer(1);
      final c = exam.videoControllers[exam.questionIndex];
      final q = exam.partQuestions[exam.questionIndex];
      return ssCol(
        exam.partIndex == 1
            ? [
                recordAnswerButton(q, exam.isChecking),
                analysis(q.answer, exam.isChecking),
                vSpacer(8),
              ]
            : [
                center(AspectRatio(aspectRatio: 1.778, child: VideoPlayer(c))),
                speakQuestion(q),
                nextQuestionButton(q),
                analysis(q.answer, exam.isChecking),
                vSpacer(8),
              ],
      );
    });

Widget speakAudio() => obs<Exam>((exam) {
      if (!exam.isToefl || !exam.component!.isSpeak) return vSpacer(1);
      final q = exam.partQuestions[0];
      return ssCol([
        analysis(q.answer, exam.isChecking),
        vSpacer(8),
      ]);
    });

Widget speakQuestion(Question q) => obs<Exam>(
      (exam) => pBox(vEdge(16))(
        ccCol([
          scRow([
            bold('Q${q.number}: '),
            hSpacer(8),
            grow(playVideoButton(q, exam.isChecking)),
          ]),
          vSpacer(16),
          recordAnswerButton(q, exam.isChecking),
        ]),
      ),
    );

Widget playVideoButton(Question q, bool isChecking) => obs<Exam>(
      (exam) => button(
        isChecking ? null : () => exam.playVideo(q.number),
        icon: Icons.play_arrow,
        text: 'Listen',
        bgColor: Colors.teal,
      ),
    );

Widget recordAnswerButton(Question q, bool isChecking) => obs<Exam>(
      (exam) => button(
        isChecking
            ? null
            : exam.isRecording
                ? () => exam.stopRecording(q)
                : exam.startRecording,
        icon: Icons.mic,
        text: exam.isRecording
            ? 'Stop'
            : q.userAnswer == null
                ? 'Answer'
                : 'Retake',
        bgColor: exam.isRecording ? Colors.red : Colors.green,
        isCircle: true,
        padding: 48,
        iconTextSpaing: 0,
      ),
    );

Widget nextQuestionButton(Question q) => obs<Exam>(
      (exam) => button(
        exam.isLastQuestion ? null : exam.nextQuestion,
        icon: Icons.arrow_forward,
        text: 'Next Question',
        bgColor: Colors.blue,
      ),
    );

Widget explainButton() => obs<Exam>(
      (exam) => IconButton(
        onPressed: () => exam.getExplain(),
        icon: const Icon(Icons.live_help, color: Colors.orange),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(0),
      ),
    );

Widget explainCol(int number, bool isChecking, {bool hideNumber = false}) =>
    ssCol([
      number > 0
          ? hideNumber
              ? txt('Q$number)', bold: true, color: Colors.white)
              : bold('Q$number)')
          : hSpacer(1),
      isChecking ? explainButton() : hSpacer(1),
    ]);

Widget exQuestion(ExQuestion q) => ssRow([
      bold('Q${q.num})'),
      hSpacer(4),
      grow(
        ssCol(
          [
            q.question != null ? txt(q.question!) : bold('Answer: ${q.answer}'),
            ...q.options == null || q.options!.isEmpty
                ? q.answer != null
                    ? [
                        bold('Answer:'),
                        txt(q.answer!),
                      ]
                    : []
                : lidx(q.options!).map(
                    (i) => txt(
                      '${q.hasOptionKey ? '' : '${String.fromCharCode(65 + i)}. '}${q.options![i]}',
                      color: q.isCorrect(i)
                          ? const Color(consts.Colors.darkGreen)
                          : Colors.black,
                      bold: q.isCorrect(i),
                    ),
                  ),
            vSpacer(8),
            ...q.explanation == null
                ? []
                : [
                    bold('Explanation:'),
                    txt(q.explanation!),
                  ],
            vSpacer(8),
          ],
        ),
      ),
    ]);

Widget explanation() => obs<Exam>(
      (exam) => exam.explain == null
          ? vSpacer(1)
          : ssCol([
              left(h2('AI Explanation')),
              ...lidx(exam.explain!['questions'] ?? []).map(
                (i) => exQuestion(exam.explain!['questions']![i]),
              ),
              vSpacer(16),
              ...exam.explain!['similar'] == null
                  ? []
                  : [
                      left(h2('Similar Questions')),
                      ...lidx(exam.explain!['similar'] ?? []).map(
                        (i) => exQuestion(exam.explain!['similar']![i]),
                      ),
                    ],
            ]),
    );
