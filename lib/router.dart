import 'package:go_router/go_router.dart';
import 'widgets/tutor/tutor_body.dart';
import 'widgets/tutor/tutors_body.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (c, s) => const TutorsBody(),
    ),
    GoRoute(
      path: '/tutor',
      builder: (c, s) => const TutorBody(),
    ),
  ],
);
