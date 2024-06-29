import 'package:chatuni/store/app.dart';
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

Widget tutors() => obs<Tutors>((tutors) {
      tutors.clearTutor();

      return scaffold(
        vContainer(
          [
            vSpacer(20),
            level(1),
            tutorList(1),
            vSpacer(10),
            level(2),
            tutorList(2),
          ],
          hAlign: CrossAxisAlignment.start,
          padding: 0,
        ),
        title: 'Tutors',
        routeGroup: RouteGroup.tutor,
      );
    });
