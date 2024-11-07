import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';

const _exams = ['IELTS', 'SAT'];

Widget exams() => scaffold(
      vContainer(
        [
          vSpacer(10),
          ..._exams.map(
            (e) => pBox(bEdge(8))(
              button(
                () {
                  router.go('/${e.toLowerCase()}');
                },
                text: e,
                bgColor: Colors.white,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      title: 'Exams',
      routeGroup: RouteGroup.course,
    );
