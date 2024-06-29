import 'package:chatuni/widgets/common/container.dart';
import 'package:flutter/material.dart';

import '/store/tutors.dart';
import '/widgets/common/hoc.dart';

Widget face() => obsc<Tutors>((tutors, context) {
      final tutor = tutors.tutor ?? tutors.tutors[0];

      final width = MediaQuery.of(context).size.width;
      const height = 400.0;
      final fit = width > 480 ? BoxFit.fitHeight : BoxFit.fitWidth;

      return cBox(Colors.white)(
        Image.asset(
          'assets/images/${tutors.isReading ? 'gif' : 'tutoricons'}/${tutor.id}.${tutors.isReading ? 'gif' : 'png'}',
          width: width,
          height: height,
          fit: fit,
          alignment: Alignment.topCenter,
        ),
      );
    });
