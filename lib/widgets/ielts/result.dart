import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/ielts.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';

Widget result() => scaffold(
      vContainer(
        [
          vSpacer(10),
          _result(),
          vSpacer(50),
        ],
        scroll: true,
      ),
      title: 'Ielts',
      routeGroup: RouteGroup.course,
      bgColor: Colors.white,
    );

Widget _result() => ccCol([
      h1('Test Results'),
      _compResult(0),
      _compResult(1),
      _compResult(2),
      _compResult(3),
      vSpacer(16),
    ]);

Widget _compResult(int comp) => ccCol(
      [
        vSpacer(8),
        left(h3(comps[comp])),
        _score(comp),
        _incorrect(comp),
        vSpacer(8),
        _checkAnswerButton(comp),
        vSpacer(8),
      ],
    );

Widget _score(int comp) => obs<Ielts>(
      (ielts) => comp < 2
          ? _row(
              'Score',
              '${ielts.numOfCorrect(comp)}/${ielts.getCompQuestions(comp).length}',
            )
          : comp == 2
              ? ssCol(
                  lidx(ielts.writeQuestions)
                      .map(
                        (i) => _row(
                          'Task ${i + 1} Score',
                          ielts.writeQuestions[i].score ?? '',
                        ),
                      )
                      .toList(),
                )
              : ssCol(
                  lidx(ielts.test!.speak)
                      .expand(
                        (i) => [
                          h4('Part ${i + 1}'),
                          ...ielts
                              .getPartQuestions(ielts.test!.speak[i])
                              .where(
                                (q) =>
                                    ielts.partIndex == 1 ? q.number == 0 : true,
                              )
                              .map(
                                (q) => _row(
                                  'Question ${q.number} Score',
                                  q.score ?? '',
                                ),
                              ),
                        ],
                      )
                      .toList(),
                ),
    );

Widget _incorrect(int comp) => obs<Ielts>(
      (ielts) => comp < 2
          ? _row(
              'Incorrect Questions',
              ielts.incorrectQuestions(comp).map((x) => 'Q$x').join(', '),
            )
          : vSpacer(1),
    );

Widget _checkAnswerButton(int idx) => obs<Ielts>(
      (ielts) => button(
        () {
          ielts.checkAnswers(idx);
          ielts.firstPart();
          router.go('/ielts_component');
        },
        text: 'Check Answers',
      ),
    );

Widget _row(String title, String content) => ssRow([
      txt('$title: '),
      grow(txt(content, color: Colors.red, bold: true)),
    ]);
