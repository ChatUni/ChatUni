import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

import '../scaffold/scaffold.dart';
import 'chat.dart';
import 'face.dart';

part 'tutor_body.g.dart';

@swidget
Widget tutorBody(BuildContext context) => scaffold(
      Observer(
        builder: (_) => const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Face(), Chat(), SizedBox(height: 80)],
        ),
      ),
    );
