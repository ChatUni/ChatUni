import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

import '/widgets/scaffold/scaffold.dart';
import 'list.dart';

part 'tutors_body.g.dart';

@swidget
Widget tutorsBody(BuildContext context) => scaffold(
      Observer(
        builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            levelText(1),
            const TutorList(1),
            const SizedBox(height: 10),
            levelText(2),
            const TutorList(2),
          ],
        ),
      ),
    );

Container levelText(int level) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(
                    '⬤ ',
                    style: TextStyle(fontSize: 8, color: Colors.blue),
                  ),
                ),
                TextSpan(
                  text: 'Level $level',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
