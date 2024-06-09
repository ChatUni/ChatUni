import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';
import '../../store/tutors.dart';

part 'face.g.dart';

@swidget
Widget face(BuildContext context) {
  final tutors = Provider.of<Tutors>(context);
  final tutor = tutors.tutor ?? tutors.tutors[0];

  final width = MediaQuery.of(context).size.width;
  const height = 400.0;
  final fit = width > 480 ? BoxFit.fitHeight : BoxFit.fitWidth;

  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: Observer(
      builder: (_) => Image.asset(
        'assets/images/${tutors.isReading ? 'gif' : 'tutoricons'}/${tutor.id}.${tutors.isReading ? 'gif' : 'png'}',
        width: width,
        height: height,
        fit: fit,
        alignment: Alignment.topCenter,
      ),
    ),
  );
}
