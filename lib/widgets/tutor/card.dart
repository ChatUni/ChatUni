import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/models/tutor.dart';
import '/store/tutors.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/person_tile.dart';

Widget tutorCard(Tutor tutor) => obsc<Tutors>(
      (tutors, context) => personTile(
        Image.asset(
          'assets/images/tutoricons/${tutor.id}.png',
          height: 100,
        ),
        tutor.name,
        props: [
          tutor.skill,
          'Talking Speed ${tutor.speed2}',
          tutor.personality
        ],
        hasFav: true,
        desc: tutor.desc,
        action: () {
          tutors.selectTutor(tutor);
          context.go('/tutor');
        },
        //bottomMargin: 0,
      ),
    );
