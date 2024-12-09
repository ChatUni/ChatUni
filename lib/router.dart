import 'package:chatuni/store/auth.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/course/course.dart';
import 'package:chatuni/widgets/exam/component.dart';
import 'package:chatuni/widgets/exam/exams.dart';
import 'package:chatuni/widgets/exam/result.dart';
import 'package:chatuni/widgets/exam/tests.dart';
import 'package:chatuni/widgets/immigration/guide.dart';
import 'package:chatuni/widgets/my/history.dart';
import 'package:chatuni/widgets/my/login.dart';
import 'package:chatuni/widgets/my/profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/my/membership.dart';
import 'widgets/sat/result.dart';
import 'widgets/tutor/tutor.dart';

Widget Function(BuildContext, GoRouterState) go(Widget Function() builder) =>
    (c, s) => obs<Auth>((auth) => auth.isLoggedIn ? builder() : login());

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: go(tutors),
    ),
    GoRoute(
      path: '/tutors',
      builder: go(tutors),
    ),
    GoRoute(
      path: '/tutor',
      builder: go(tutor),
    ),
    GoRoute(
      path: '/login',
      builder: go(login),
    ),
    GoRoute(
      path: '/profile',
      builder: go(profile),
    ),
    GoRoute(
      path: '/membership',
      builder: go(membership),
    ),
    GoRoute(
      path: '/history',
      builder: go(history),
    ),
    GoRoute(
      path: '/exams',
      builder: go(exams),
    ),
    GoRoute(
      path: '/exam_tests',
      builder: go(tests),
    ),
    GoRoute(
      path: '/exam_component',
      builder: go(component),
    ),
    GoRoute(
      path: '/exam_result',
      builder: go(result),
    ),
    GoRoute(
      path: '/immigration',
      builder: go(immigration),
    ),
    GoRoute(
      path: '/course',
      builder: go(course),
    ),
    GoRoute(
      path: '/sat_component1',
      builder: go(satcomponent1),
    ),
    GoRoute(
      path: '/ielts_sat_result',
      builder: (c, s) => resultSat(),
    ),
    GoRoute(
      path: '/immigration',
      builder: go(immigration),
    ),
  ],
);
