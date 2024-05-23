import 'package:flutter/material.dart';
import 'widgets/tutorpage.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'main.g.dart';

void main() {
  runApp(const MyApp());
}

@swidget
Widget myApp(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TutorsPage(),
    );
