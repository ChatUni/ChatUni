import 'package:chatuni/globals.dart';
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
import 'widgets/tutor/tutor.dart';

Widget Function(BuildContext, GoRouterState) go(
  Widget Function() builder, {
  String? singleApp,
}) =>
    (c, s) => obs<Auth>((auth) {
          if (singleApp != null && singleApp.startsWith('Exam.')) {
            app.singleApp = singleApp;
            exam.loadTests(singleApp.substring(5));
          }
          // Check for auto login feature flag or normal login state
          return (auth.isLoggedIn || auth.autoLoginEnabled)
              ? builder()
              : login();
        });

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: go(exams),
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
      path: '/resource',
      builder: go(immigration),
    ),
    GoRoute(
      path: '/course',
      builder: go(course),
    ),
    GoRoute(
      path: '/ielts',
      builder: go(tests, singleApp: 'Exam.Ielts'),
    ),
    GoRoute(
      path: '/toefl',
      builder: go(tests, singleApp: 'Exam.TOEFL'),
    ),
    GoRoute(
      path: '/sat',
      builder: go(tests, singleApp: 'Exam.SAT'),
    ),
  ],
);
