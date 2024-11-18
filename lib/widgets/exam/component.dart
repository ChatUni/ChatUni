import 'package:chatuni/models/exam.dart';
import 'package:chatuni/store/exam.dart';
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
                ...header(exam.component!.title, exam.part!.name),
                playButton(),
                vSpacer(12),
                ...exam.isScoring
                    ? [spinner]
                    : [
                        ...body(exam.part!.groups),
                        ...nav(exam.isChecking),
                      ],
              ],
            );
    });

List<Widget> header(String comp, String part) => [
      title(),
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

List<Widget> body(List<Group> groups) => [
      ...groups.map(group),
      writeBoxAndAnswer(),
      speak(),
    ];

List<Widget> nav(bool isChecking) => [
      prevNext(),
      vSpacer(8),
      showResult(isChecking),
    ];
