import 'package:chatuni/models/exam.dart';
import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/exam.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';

Widget result() => obs<Exam>(
      (exam) => scaffold(
        vContainer(
          [
            vSpacer(10),
            h1('Test Results'),
            ...exam.comps.map(_compResult),
            vSpacer(80),
          ],
          scroll: true,
        ),
        title: exam.name,
        routeGroup: RouteGroup.exam,
        bgColor: Colors.white,
      ),
    );

Widget _compResult(Component comp) => obs<Exam>(
      (exam) => ccCol(
        [
          vSpacer(8),
          left(h3(comp.title)),
          _score(comp),
          _incorrect(comp),
          vSpacer(8),
          _checkAnswerButton(comp),
          vSpacer(8),
        ],
      ),
    );

Widget _score(Component comp) => obs<Exam>(
      (exam) => comp.isWrite
          ? ssCol(
              lidx(exam.writeQuestions)
                  .map(
                    (i) => _row(
                      'Task ${i + 1} Score',
                      exam.writeQuestions[i].score ?? '',
                    ),
                  )
                  .toList(),
            )
          : comp.isSpeak
              ? ssCol(
                  lidx(comp.parts)
                      .expand<Widget>(
                        (i) => exam.isIelts
                            ? _ieltsSpeakScore(exam, comp, i)
                            : exam.isToefl
                                ? _toeflSpeakScore(exam, comp, i)
                                : [],
                      )
                      .toList(),
                )
              : _row(
                  'Score',
                  '${exam.numOfCorrect(comp)}/${exam.getCompQuestions(comp).length}',
                ),
    );

List<Widget> _ieltsSpeakScore(Exam exam, Component comp, int i) => [
      h4('Part ${i + 1}'),
      ...exam
          .getPartQuestions(comp.parts[i])
          .where(
            (q) => exam.partIndex == 1 ? q.number == 0 : true,
          )
          .map(
            (q) => _row(
              'Question ${q.number} Score',
              q.score ?? '',
            ),
          ),
    ];

List<Widget> _toeflSpeakScore(Exam exam, Component comp, int i) => [
      _row(
        'Part ${i + 1} Score',
        exam.getPartQuestions(comp.parts[i])[0].score ?? '',
      ),
    ];

Widget _incorrect(Component comp) => obs<Exam>(
      (exam) => comp.isQA
          ? ssCol([
              bold('Incorrect Questions:'),
              ...exam.incorrectQuestions(comp).entries.map(
                    (x) => _row(x.key, x.value.map((i) => 'Q$i').join(', ')),
                  ),
            ])
          : vSpacer(1),
    );

Widget _checkAnswerButton(Component comp) => obs<Exam>(
      (exam) => button(
        () {
          exam.checkAnswers(comp);
          exam.firstPart();
          router.go('/exam_component');
        },
        text: 'Check Answers',
      ),
    );

Widget _row(String title, String content) => ssRow([
      txt('$title: '),
      grow(txt(content, color: Colors.red, bold: true)),
    ]);
