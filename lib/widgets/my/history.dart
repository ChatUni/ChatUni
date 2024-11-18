import 'package:chatuni/router.dart';
import 'package:chatuni/store/exam.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/store/app.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/menu.dart';
import '/widgets/scaffold/scaffold.dart';
import '../common/container.dart';

Widget history() => scaffold(
      vContainer(
        [
          vSpacer(10),
          _history,
        ],
      ),
      title: 'History',
      routeGroup: RouteGroup.my,
    );

Observer _history = obs<Exam>(
  (exam) => vCard(
    exam.results
        .map(
          (r) => menuItem(
            Icons.history,
            '${r.type.toUpperCase()} ${r.testId} ${dateString(r.date)}',
            onTap: () {
              exam.loadResult(r);
              router.go('/exam_result');
            },
          ),
        )
        .toList(),
  ),
);
