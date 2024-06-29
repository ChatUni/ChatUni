import 'package:go_router/go_router.dart';

import 'widgets/my/account.dart';
import 'widgets/my/membership.dart';
import 'widgets/tutor/tutor.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (c, s) => tutors(),
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
  ],
);
