import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'globals.dart' as globals;
import 'router.dart';
import 'store/app.dart';
import 'store/auth.dart';
import 'store/tutors.dart';

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  globals.initListeners();
  runApp(
    MultiProvider(
      providers: [
        Provider<App>(create: (_) => App()),
        Provider<Auth>(create: (_) => Auth()),
        Provider<Tutors>(create: (_) => Tutors()),
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
