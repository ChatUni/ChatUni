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
    () => router.go('/tutors'),
    isSelected: app.routeGroup == RouteGroup.tutor,
  );
  InkWell courseIcon = menuIcon(
    Icons.menu_book_rounded,
    'Exam',
    () => router.go('/exams'),
    // () => launch('https://en.chatuni.com.cn/#/level', isNewTab: true),
    isSelected: app.routeGroup == RouteGroup.course,
  );
  InkWell metaIcon = menuIcon(
    Icons.language,
    'Scene', // '元宇宙',
    () => router.go('/scenario'),
    // () => launch('https://chatuni.smartkit.vip/webgl/', isNewTab: false),
    isSelected: app.routeGroup == RouteGroup.scenario,
  );
  InkWell guideIcon = menuIcon(
    Icons.book_online_outlined,
    'Immigration', // '元宇宙',
    () => router.go('/immigration'),
    // () => launch('https://chatuni.smartkit.vip/webgl/', isNewTab: false),
    isSelected: app.routeGroup == RouteGroup.guide,
  );

  InkWell accountIcon = menuIcon(
    Icons.person,
    'My',
    () => router.go('/profile'),
    isSelected: app.routeGroup == RouteGroup.my,
  );
  InkWell invisibleIcon = menuIcon(Icons.menu, '', () {}, isPlaceholder: true);

  menuIcons.add(tutorIcon);
  menuIcons.add(courseIcon);
  if (app.showMic) menuIcons.add(invisibleIcon);
  menuIcons.add(guideIcon);
  menuIcons.add(metaIcon);
  menuIcons.add(accountIcon);

  return menuIcons;
}
