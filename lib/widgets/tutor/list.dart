import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '/store/tutors.dart';
import 'card.dart';

part 'list.g.dart';

@swidget
Widget tutorList(BuildContext context, int level) {
  final tutors = Provider.of<Tutors>(context);

  return SizedBox(
    height: 267,
    child: Observer(
      builder: (_) => ListView(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        children: tutors.tutors
            .where((t) => t.level == level)
            .map((t) => TutorCard(t))
            .toList(),
      ),
    ),
  );
}
