import 'package:chatuni/models/ielts.dart';
import 'package:chatuni/store/ielts.dart';
import 'package:chatuni/utils/event.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/ielts/common.dart';
import 'package:flutter/material.dart';

Widget component() => obs<Ielts>((ielts) {
      listenToEvent(onCountdownEvent, (e) => print('time'));

      return ielts.component == null
          ? vSpacer(1)
          : ieltsScaffold(
              ielts.component!,
              [
                ...header(ielts.component!, ielts.part!.name),
                playButton(),
                vSpacer(12),
                ...ielts.isScoring
                    ? [spinner]
                    : [
                        ...body(ielts.part!.groups),
                        ...nav(ielts.isChecking),
                      ],
              ],
            );
    });

List<Widget> header(String comp, String part) => [
      title(),
      vSpacer(8),
      left(h3(comp)),
      vSpacer(6),
      left(h3(part)),
      vSpacer(12),
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
