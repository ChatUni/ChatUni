import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/exam.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/widgets.dart';

Widget tests() => obs<Exam>(
      (exam) => scaffold(
        vContainer(
          [
            vSpacer(10),
            ccCol(
              exam.tests
                  .map(
                    (e) => pBox(bEdge(8))(
                      vCard([
                        pipe([bold, left, pBox(aEdge(8))])(
                          '${examConfig[exam.name]!['title']} ${e.key}',
                        ),
                        grid(
                          2,
                          e.value
                              .map(
                                (t) => button(
                                  () {
                                    exam.selectTest(t);
                                    router.go('/exam_component');
                                  },
                                  text: 'Test ${t.id}',
                                ),
                              )
                              .toList(),
                        ),
                      ]),
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
