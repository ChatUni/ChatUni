import 'package:chatuni/store/app.dart';
import 'package:chatuni/widgets/common/device.dart';
import 'package:flutter/material.dart';

import '/store/tutors.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import '/widgets/scaffold/scaffold.dart';
import 'chat.dart';
import 'face.dart';
import 'list.dart';

Widget tutor() => obs<Tutors>(
      (tutors) => scaffold(
        Window.isPortrait()
            ? vContainer([face(), chat()], padding: 0)
            : csRow(
                [
                  growN(3)(face()),
                  growN(7)(scCol([chat()])),
                ],
              ),
        title: 'Tutor',
        showMic: true,
        routeGroup: tutors.isScenario ? RouteGroup.scenario : RouteGroup.tutor,
      ),
    );

Widget tutors(bool isScenario) => obs<Tutors>((tutors) {
      tutors.clearTutor();
      tutors.setScenario(isScenario);

      return scaffold(
        vTutorList(isScenario),
        title: 'Tutors',
        routeGroup: isScenario ? RouteGroup.scenario : RouteGroup.tutor,
      );
    });
