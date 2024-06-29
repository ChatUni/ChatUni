import 'package:chatuni/widgets/common/container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/models/tutor.dart';
import '/store/tutors.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/person_tile.dart';

Widget tutorCard(Tutor tutor) => obsc<Tutors>(
      (tutors, context) => SizedBox(
        width: 327,
        child: pBox(aEdge(4))(
          personTile(
            Image.asset(
              'assets/images/tutoricons/${tutor.id}.png',
              height: 100,
            ),
            tutor.name,
            props: [tutor.skill, '语速 ${tutor.speed2}', tutor.personality],
            hasFav: true,
            desc: tutor.desc,
            action: () {
              tutors.selectTutor(tutor);
              context.go('/tutor');
            },
            //bottomMargin: 0,
          ),
        ),
      ),
    );
