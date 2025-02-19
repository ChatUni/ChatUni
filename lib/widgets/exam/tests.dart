import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/exam.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';

Widget tests() => obs<Exam>(
      (exam) => scaffold(
        vContainer(
          [
            vSpacer(10),
            ccCol(
              exam.allTests
                  .map(
                    (t) => pBox(bEdge(8))(
                      button(
                        () async {
                          exam.selectTest(t);
                          router.go('/exam_component');
                        },
                        text: t.idTitle,
                        bgColor: Colors.white,
                        color: Colors.black,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        title: exam.name,
        routeGroup: RouteGroup.exam,
      ),
    );
