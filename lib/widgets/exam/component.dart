import 'package:chatuni/store/exam.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/dialog.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/exam/common.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

Widget component() => obsc<Exam>((exam, context) {
      // listenToEvent(
      //   onCountdownEvent,
      //   (e) => print(
      //     'time is up',
      //   ), // dialog(context, confirmDialog('Time is up.', [], () {})),
      // );
      when(
        (_) => exam.timeIsUp,
        () {
          if (exam.timeIsUp) {
            dialog(
              context,
              confirmDialog(
                'Time is up.',
                [],
                () => exam.nextComp(1),
                hasCancel: false,
              ),
            );
            exam.timeIsUp = false;
          }
        },
      );
      return exam.component == null
          ? vSpacer(1)
          : examScaffold(
              exam.name,
              [
                ...header(
                  exam.test!.idTitle,
                  exam.component!.title,
                  '${exam.part!.name}${exam.rc < 0 ? '' : ''}',
                ),
                ...exam.isScoring
                    ? [spinner]
                    : exam.isExplain
                        ? explain(exam)
                        : [...body(exam), ...nav(exam.isChecking)],
              ],
            );
    });

List<Widget> header(String title, String comp, String part) => [
      center(h1(title)),
      vSpacer(8),
      left(h3(comp)),
      vSpacer(6),
      ...(part.isEmpty
          ? []
          : [
              left(h3(part)),
              vSpacer(12),
            ]),
    ];

List<Widget> body(Exam exam) => [
      ...exam.hasFixedAudio ? [playButton(), vSpacer(12)] : [vSpacer(1)],
      ...exam.part!.groups.map(group),
      //writeBoxAndAnswer(),
      speakVideo(),
      speakAudio(),
    ];

List<Widget> explain(Exam exam) => [
      explanation(),
      button(
        exam.exitExplain,
        icon: Icons.arrow_back,
        text: 'Back to result',
        bgColor: Colors.blue,
      ),
    ];

List<Widget> nav(bool isChecking) => [
      prevNext(),
      vSpacer(8),
      showResult(isChecking),
    ];
