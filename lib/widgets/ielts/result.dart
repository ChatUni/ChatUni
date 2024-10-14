import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/ielts.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';

Widget result() => scaffold(
      vContainer(
        [
          vSpacer(10),
          _result(),
        ],
      ),
      title: 'Ielts',
      routeGroup: RouteGroup.course,
      bgColor: Colors.white,
    );

Widget _result() => obs<Ielts>(
      (ielts) => ccCol([
        h1('Test Result'),
        button(
          () {
            ielts.checkAnswers();
            ielts.firstPart();
            router.go('/listening');
          },
          text: 'Check Answers',
        ),
      ]),
    );
