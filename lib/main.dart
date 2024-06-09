import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './store/tutors.dart';
import 'router.dart';

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [Provider<Tutors>(create: (_) => Tutors())],
    child: MaterialApp.router(
      title: 'ChatUni',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    ),
  ));
}
