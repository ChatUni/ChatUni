import 'package:chatuni/models/exam.dart';
import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/exam.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
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
    h2,
    h3,
    h4,
    bold,
    italic,
    txt,
    (String x) => Image.network(cdImg(x)),
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

Widget title() => obs<Exam>((exam) => center(h1('Test ${exam.test!.id}')));

Widget playButton() => obs<Exam>(
      (exam) => exam.component!.isListen
          ? button(
              exam.isPlaying ? exam.stop : exam.play,
              icon: exam.isPlaying ? Icons.stop : Icons.play_arrow,
              bgColor: exam.isPlaying ? Colors.red : Colors.green,
            )
          : vSpacer(1),
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
        txt(s1),
        hSpacer(8),
        grow(
          fillInput(
            (t) => exam.fill(num, t),
            exam.getQuestion(num)?.userAnswer,
            exam.isChecking ? exam.checkAnswer(num) : null,
          ),
        ),
        hSpacer(8),
        txt(s2),
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

Widget group(Group g) => ssCol(
      g.paragraphs.expand(paragraph).toList(),
    );

List<Widget> paragraph(Paragraph p) {
  Iterable<Widget> ps = [];
  if (p.isMultiChoice) {
    ps = [
      bold(p.questionNumbers),
      ...p.nonChoiceContent.map(content),
      vSpacer(8),
      ...p.choiceList.map(multiChoice),
    ];
  } else if (p.isSingleChoice) {
    ps = p.questions!.expand(singleChoice);
  } else if (p.isTrueFalse) {
    ps = lidx(p.questions!)
        .expand((i) => trueFalse(p.questions![i], p.content[i]));
  } else {
    ps = p.content.map(content);
  }
  return [...ps, vSpacer(12)];
}

List<Widget> trueFalse(Question q, String c) => [
      content(c),
      vSpacer(4),
      box(
        null,
        24,
        ssRow([
          trueFalseButton('TRUE', q),
          hSpacer(8),
          trueFalseButton('FALSE', q),
          hSpacer(8),
          trueFalseButton('NOT GIVEN', q),
        ]),
      ),
      vSpacer(8),
    ];

Widget trueFalseButton(String text, Question q) => obs<Exam>(
      (exam) => button(
        () => exam.trueFalseSelect(q, text),
        text: '$text${exam.rc < 0 ? '' : ''}',
        size: 10,
        outline: !(exam.isChecking && q.isActual(text) || q.userAnswer == text),
        bgColor: exam.isChecking
            ? q.isActual(text)
                ? Colors.green
                : Colors.red
            : Colors.blue,
      ),
    );

List<Widget> singleChoice(Question q) => [
      bold('${q.number}. ${q.subject!}'),
      ...(q.images ?? []).map(tagHandlers['img']!),
      ...q.choiceList.map(
        (c) => obs<Exam>(
          (exam) => tap(
            () => exam.singleSelect(q, c.key),
            txt(
              '${c.key} ${c.value}${exam.rc < 0 ? '' : ''}',
              color: Color(exam.choiceColor(c)),
              bold: exam.boldChoice(c),
            ),
          ),
        ),
      ),
      vSpacer(8),
    ];

Widget multiChoice(Choice choice) => obs<Exam>(
      (exam) => tap(
        () => exam.multiSelect(choice.q1, choice.q2, choice.key),
        txt(
          '${choice.key} ${choice.value}${exam.rc < 0 ? '' : ''}',
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

Widget writeBoxAndAnswer() => obs<Exam>(
      (exam) => exam.component!.isWrite
          ? ssCol([
              writeBox(
                exam.write,
                exam.writeQuestion.userAnswer,
              ),
              analysis(exam.writeQuestion.answer, exam.isChecking),
              vSpacer(16),
              txt(exam.rc > 0 ? '' : ''),
            ])
          : vSpacer(1),
    );

Widget speak() => obs<Exam>((exam) {
      if (!exam.component!.isSpeak) return vSpacer(1);
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

Widget speakQuestion(Question q) => obs<Exam>(
      (exam) => pBox(vEdge(8))(
        scRow([
          bold('Q${q.number}: '),
          hSpacer(8),
          grow(playVideoButton(q, exam.isChecking)),
          hSpacer(8),
          grow(recordAnswerButton(q, exam.isChecking)),
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
