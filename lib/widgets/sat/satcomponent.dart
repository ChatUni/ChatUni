import 'package:chatuni/models/ielts.dart';
import 'package:chatuni/store/sat.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/ielts/common.dart';
import 'package:flutter/material.dart';

Widget satcomponent() => obs<Sat>(
      (sat) => sat.component == null
          ? vSpacer(1)
          : ieltsScaffold(
              sat.part!.name.split('-')[0], //sat.component!,
              [
                //...header(sat.component!, sat.part!.name),
                vSpacer(12),
                ...sat.isScoring
                    ? [spinner]
                    : [
                        ...body(sat.part!.groups),
                        ...nav(sat.isChecking),
                      ],
              ],
            ),
    );

Widget satcomponent1() => obs<Sat>(
      (sat) => sat.component == null
          ? vSpacer(1)
          : ieltsScaffold(
              sat.part!.name.split('-')[0], //sat.component!,
              [
                //...header(sat.component!, sat.part!.name),
                vSpacer(12),
                ...sat.isScoring
                    ? [spinner]
                    : [
                        ...body(sat.part!.groups),
                        ...nav(sat.isChecking),
                      ],
              ],
            ),
    );

List<Widget> header(String comp, String part) => [
      //title(),
      vSpacer(8),
      //left(h3('SAT')),
      //vSpacer(6),
      left(h3(part)),
      vSpacer(12),
    ];

List<Widget> body(List<Group> g) => [
      ...g.map(group),
      writeBoxAndAnswer(),
    ];

List<Widget> nav(bool isChecking) => [
      prevNextSat(),
      vSpacer(8),
      showSatResult(isChecking),
    ];
