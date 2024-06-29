import 'package:chatuni/widgets/common/container.dart';
import 'package:flutter/material.dart';

import '/store/tutors.dart';
import '/widgets/common/hoc.dart';
import 'card.dart';

Widget tutorList(int level) => obs<Tutors>(
      (tutors) => SizedBox(
        height: 267,
        child: ListView(
          padding: aEdge(8),
          scrollDirection: Axis.horizontal,
          children: tutors.tutors
              .where((t) => t.level == level)
              .map((t) => tutorCard(t))
              .toList(),
        ),
      ),
    );
