import 'package:chatuni/store/app.dart';
import 'package:chatuni/widgets/tutor/card.dart';
import 'package:flutter/material.dart';

import '/store/tutors.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import '/widgets/scaffold/scaffold.dart';
import 'chat.dart';
import 'face.dart';
import 'level.dart';
import 'list.dart';

Widget tutor() => scaffold(
      vContainer(
        [
          face(),
          chat(),
          vSpacer(80),
        ],
        padding: 0,
      ),
      title: 'Tutor',
      showMic: true,
      routeGroup: RouteGroup.tutor,
    );

Widget tutors(bool isScenario) => obs<Tutors>((tutors) {
      tutors.clearTutor();
      tutors.setScenario(isScenario);

      return scaffold(
        isScenario
            ? ListView(
                padding: aEdge(8),
                scrollDirection: Axis.vertical,
                children: tutors.tutors
                    .where((t) => t.level == 10)
                    .map((t) => tutorCard(t))
                    .toList(),
              )
            : vContainer(
                [
                  vSpacer(20),
                  level('Level 1'),
                  tutorList(1),
                  vSpacer(10),
                  level('Level 2'),
                  tutorList(2),
                  level('Customized'),
                  tutorList(0),
                  vSpacer(80),
                ],
                hAlign: CrossAxisAlignment.start,
                padding: 0,
                scroll: true,
              ),
        title: 'Tutors',
        routeGroup: RouteGroup.tutor,
      );
    });
