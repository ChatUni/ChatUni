import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/exam.dart';
import 'package:chatuni/store/tutors.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:flutter/material.dart';

List<String> langs = ['en', 'zh'];

Widget topBar() => obs<App>(
      (app) => AppBar(
        title: Row(
          children: [
            tap(
              () => router.go('/'),
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                width: 80,
              ),
            ),
            Expanded(
              child: Text(
                app.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(5, 5),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(decoration: _headerImg),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions:
            _actions, // tutors.isTutorSelected ? tutorActions(tutors) : tutorsActions(),
      ),
    );

BoxDecoration _headerImg = const BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/header.png'),
    fit: BoxFit.cover,
  ),
);

List<Widget> _actions = [
  obs<Exam>(
    (exam) => pBox(rEdge(8))(
      txt(
        '${exam.timeLeft}${exam.rc > 0 ? '' : ''}',
        color: exam.isTimeLeftAlert ? Colors.red : Colors.white,
        bold: true,
      ),
    ),
  ),
  IconButton(
    onPressed: () => router.go('/profile'),
    icon: const Icon(Icons.person, color: Colors.white),
  ),
  // const IconButton(
  //   onPressed: null,
  //   icon: Icon(Icons.search, color: Colors.white),
  // ),
  // IconButton(
  //   onPressed: () {},
  //   icon: const Icon(Icons.bookmark, color: Colors.white),
  // ),
];

List<Widget> tutorActions() => [
      obs<Tutors>(
        (tutors) => Container(
          margin: aEdge(12),
          padding: hEdge(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton(
            value: tutors.lang,
            items: langs
                .map(
                  (e) =>
                      DropdownMenuItem(value: e, child: Text(e.toUpperCase())),
                )
                .toList(),
            onChanged: (l) {
              if (l != null) tutors.setLang(l);
            },
            underline: null,
          ),
        ),
      ),
    ];
