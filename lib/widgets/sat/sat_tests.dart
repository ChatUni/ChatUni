import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/sat.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/widgets.dart';

Widget satTests() => scaffold(
      vContainer(
        [
          vSpacer(10),
          _tests(),
        ],
      ),
      title: 'SAT',
      routeGroup: RouteGroup.course,
    );

Widget _tests() => obs<Sat>(
      (sat) => button(
        () {
          sat.nextTest();

          //display
          router.go('/sat_component');
        },
        text: 'Sat Practice Test 1',
      ),
    );
