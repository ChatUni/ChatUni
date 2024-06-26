import 'package:chatuni/widgets/common/person_tile.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/models/tutor.dart';
import '/store/tutors.dart';

part 'card.g.dart';

@swidget
Widget tutorCard(BuildContext context, Tutor tutor) {
  final tutors = Provider.of<Tutors>(context);

  return SizedBox(
    width: 325,
    child: personTile(
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
      bottomMargin: 0,
    ),
  );
}
