import 'package:flutter/material.dart';

import '/store/app.dart';
import '/widgets/scaffold/scaffold.dart';
import '../common/container.dart';

Widget course() => scaffold(
      vContainer(
        [grow(webView('https://en.chatuni.com.cn/#/level')), vSpacer(50)],
        padding: 0,
      ),
      title: 'Course',
      routeGroup: RouteGroup.course,
    );
