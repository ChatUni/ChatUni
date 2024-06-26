import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '/store/tutors.dart';

part 'topbar.g.dart';

List<String> langs = ['en', 'zh'];

@swidget
Widget topBar(BuildContext context) {
  final tutors = Provider.of<Tutors>(context);
  return Observer(
    builder: (_) => AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            width: 80,
          ),
          Expanded(
            child: Text(
              tutors.isTutorSelected ? tutors.tutor!.name : 'Tutors',
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
      flexibleSpace: Container(decoration: headerImg()),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      actions: tutors.isTutorSelected ? tutorActions(tutors) : tutorsActions(),
    ),
  );
}

BoxDecoration headerImg() => const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/header.png'),
        fit: BoxFit.cover,
      ),
    );

List<Widget> tutorsActions() => const [
      IconButton(
        onPressed: null,
        icon: Icon(Icons.search, color: Colors.white),
      ),
      IconButton(
        onPressed: null,
        icon: Icon(Icons.bookmark, color: Colors.white),
      ),
    ];

List<Widget> tutorActions(Tutors tutors) => [
      Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButton(
          value: tutors.lang,
          items: langs
              .map(
                (e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())),
              )
              .toList(),
          onChanged: (l) {
            if (l != null) tutors.setLang(l);
          },
          underline: null,
        ),
      ),
    ];
