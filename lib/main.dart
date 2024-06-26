import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'globals.dart' as globals;
import 'router.dart';
import 'store/auth.dart';
import 'store/tutors.dart';

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        Provider<Tutors>(create: (_) => Tutors()),
        Provider<Auth>(create: (_) => Auth()),
      ],
      child: MaterialApp.router(
        title: 'ChatUni',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
        scaffoldMessengerKey: globals.scaffoldMessengerKey,
      ),
    ),
  );
}
