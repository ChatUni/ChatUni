import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/device.dart';
import 'package:chatuni/widgets/tutor/level.dart';
import 'package:flutter/material.dart';

import '/store/tutors.dart';
import '/widgets/common/hoc.dart';
import 'card.dart';

Widget hTutorListRow(int level) => obs<Tutors>(
      (tutors) => hList(
        tutors.levelTutors(level).map((t) => tutorCard(t)).toList(),
      ),
    );

Widget hTutorList() => vContainer(
      [
        vSpacer(20),
        level('Level 1'),
        hTutorListRow(1),
        vSpacer(10),
        level('Level 2'),
        hTutorListRow(2),
        vSpacer(80),
      ],
      hAlign: CrossAxisAlignment.start,
      padding: 0,
      scroll: true,
    );

Widget vTutorList(bool isScenario) => obs<Tutors>((tutors) {
      final cards = (isScenario ? tutors.scenarioTutors : tutors.langTutors)
          .map((t) => tutorCard(t))
          .toList();

      return cards.isEmpty
          ? vSpacer(10)
          : Window.isMobile()
              ? vList(cards, bottom: 60)
              : grid(Window.isDesktop() ? 4 : 2, cards, bottom: 50);
    });
