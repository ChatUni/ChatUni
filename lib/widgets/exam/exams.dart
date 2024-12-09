import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/exam.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';

Widget exams() => obs<Exam>(
      (exam) => scaffold(
        vContainer(
          [
            vSpacer(10),
            ...examConfig.keys.map(
              (e) => pBox(bEdge(8))(
                button(
                  () async {
                    await exam.loadTests(e);
                    router.go('/exam_tests');
                  },
                  text: e.toUpperCase(),
                  bgColor: Colors.white,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        title: 'Exams',
        routeGroup: RouteGroup.exam,
      ),
    );
