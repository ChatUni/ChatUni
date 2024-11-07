import 'package:chatuni/widgets/ielts/component.dart';
import 'package:chatuni/widgets/ielts/exams.dart';
import 'package:chatuni/widgets/ielts/ielts_tests.dart';
import 'package:chatuni/widgets/ielts/result.dart';
import 'package:chatuni/widgets/sat/sat_tests.dart';
import 'package:chatuni/widgets/sat/satcomponent.dart';
import 'package:go_router/go_router.dart';

import 'widgets/my/account.dart';
import 'widgets/my/membership.dart';
import 'widgets/tutor/tutor.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (c, s) => tutors(false),
    ),
    GoRoute(
      path: '/scenario',
      builder: (c, s) => tutors(true),
    ),
    GoRoute(
      path: '/tutor',
      builder: (c, s) => tutor(),
    ),
    GoRoute(
      path: '/my',
      builder: (c, s) => account(),
    ),
    GoRoute(
      path: '/membership',
      builder: (c, s) => membership(),
    ),
    GoRoute(
      path: '/exams',
      builder: (c, s) => exams(),
    ),
    GoRoute(
      path: '/ielts',
      builder: (c, s) => ieltsTests(),
    ),
    GoRoute(
      path: '/ielts_component',
      builder: (c, s) => component(),
    ),
    GoRoute(
      path: '/ielts_result',
      builder: (c, s) => result(),
    ),
    GoRoute(
      path: '/sat',
      builder: (c, s) => satTests(),
    ),
    GoRoute(
      path: '/sat_component',
      builder: (c, s) => satcomponent(),
    ),
  ],
);
