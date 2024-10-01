import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/ielts.dart';
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
      routeGroup: RouteGroup.my,
    );

Widget _tests() => obs<Ielts>(
      (ielts) => ccCol(
        ielts.tests.map((x) => txt(x.id)).toList(),
      ),
    );
