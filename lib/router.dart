import 'package:chatuni/store/auth.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/ielts/component.dart';
import 'package:chatuni/widgets/ielts/exams.dart';
import 'package:chatuni/widgets/ielts/ielts_tests.dart';
import 'package:chatuni/widgets/ielts/result.dart';
import 'package:chatuni/widgets/my/history.dart';
import 'package:chatuni/widgets/my/login.dart';
import 'package:chatuni/widgets/my/profile.dart';
import 'package:chatuni/widgets/sat/sat_tests.dart';
import 'package:chatuni/widgets/sat/satcomponent.dart';
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
      path: '/scenario',
      builder: go(scenarios),
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
      path: '/ielts',
      builder: go(ieltsTests),
    ),
    GoRoute(
      path: '/ielts_component',
      builder: go(component),
    ),
    GoRoute(
      path: '/ielts_result',
      builder: go(result),
    ),
    GoRoute(
      path: '/sat',
      builder: go(satTests),
    ),
    GoRoute(
      path: '/sat_component',
      builder: go(satcomponent),
    ),
    GoRoute(
      path: '/sat_component1',
      builder: go(satcomponent1),
    ),
    GoRoute(
      path: '/ielts_sat_result',
      builder: (c, s) => resultSat(),
    ),
  ],
);
