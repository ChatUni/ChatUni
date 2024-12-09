import 'package:chatuni/globals.dart';
import 'package:chatuni/router.dart';
import 'package:flutter/material.dart';

import '/store/app.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/text.dart';

Color selectedColor = Colors.blue;
Color nonSelectedColor = Colors.black45;

Widget navBar() => obs<App>(
      (app) => BottomAppBar(
        padding: hEdge(30),
        height: 50,
        shape: app.showMic ? const CircularNotchedRectangle() : null,
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buildIcons(app),
        ),
      ),
    );

InkWell menuIcon(
  IconData icon,
  String text,
  void Function() onPress, {
  bool isSelected = false,
  bool isPlaceholder = false,
}) =>
    InkWell(
      onTap: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isPlaceholder
                ? Colors.transparent
                : isSelected
                    ? selectedColor
                    : nonSelectedColor,
          ),
          txt(text, size: 12),
        ],
      ),
    );

List<InkWell> buildIcons(App app) {
  List<InkWell> menuIcons = [];

  InkWell tutorIcon = menuIcon(
    Icons.school,
    'Tutor',
    () => goto('tutors'),
    isSelected: app.routeGroup == RouteGroup.tutor,
  );
  InkWell courseIcon = menuIcon(
    Icons.edit_note_rounded,
    'Exam',
    () => goto('exams'),
    // () => launch('https://en.chatuni.com.cn/#/level', isNewTab: true),
    isSelected: app.routeGroup == RouteGroup.exam,
  );
  InkWell metaIcon = menuIcon(
    Icons.menu_book_rounded,
    'Course', // '元宇宙',
    () => goto('course'),
    isSelected: app.routeGroup == RouteGroup.course,
  );
  InkWell accountIcon = menuIcon(
    Icons.book_online_outlined,
    'Immigration',
    () => goto('immigration'),
    // Icons.person,
    // 'My',
    // () => router.go('/profile'),
    isSelected: app.routeGroup == RouteGroup.my,
  );
  InkWell invisibleIcon = menuIcon(Icons.menu, '', () {}, isPlaceholder: true);

  menuIcons.add(tutorIcon);
  menuIcons.add(courseIcon);
  if (app.showMic) menuIcons.add(invisibleIcon);
  menuIcons.add(metaIcon);
  menuIcons.add(accountIcon);

  return menuIcons;
}

void goto(String route) {
  exam.cancelTimer();
  router.go('/$route');
}
