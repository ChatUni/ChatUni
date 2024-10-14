import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/ielts.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/widgets.dart';

Widget test() => scaffold(
      vContainer(
        [
          vSpacer(10),
          _tests(),
        ],
      ),
      title: 'Ielts',
      routeGroup: RouteGroup.course,
    );

Widget _tests() => obs<Ielts>(
      (ielts) => ccCol(
        ielts.tests
            .map(
              (e) => vCard([
                pipe([bold, left, pBox(aEdge(8))])('IELTS Academy ${e.key}'),
                grid(
                  2,
                  e.value
                      .map(
                        (t) => button(
                          () {
                            ielts.selectTest(t);
                            router.go('/listening');
                          },
                          text: 'Test ${t.id}',
                        ),
                      )
                      .toList(),
                ),
              ]),
            )
            .toList(),
      ),
    );
