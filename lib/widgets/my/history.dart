import 'package:chatuni/store/ielts.dart';
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

Observer _history = obs<Ielts>(
  (ielts) => vCard(
    ielts.results
        .map((r) => menuItem(Icons.logout, r.testId, onTap: () {}))
        .toList(),
  ),
);
