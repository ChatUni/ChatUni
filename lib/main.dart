import 'package:chatuni/store/exam.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'globals.dart' as globals;
import 'router.dart';
import 'store/app.dart';
import 'store/auth.dart';
import 'store/tutors.dart';

void main() {
  // HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        Provider<App>(create: (_) => globals.app),
        Provider<Auth>(create: (_) => globals.auth),
        Provider<Exam>(create: (_) => globals.exam),
        Provider<Tutors>(create: (_) => Tutors()),
      ],
      child: MaterialApp.router(
        title: 'ChatUni',
        theme: ThemeData(
          fontFamily: 'Gotham',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
        scaffoldMessengerKey: globals.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
      ),
    ),
  );
}
