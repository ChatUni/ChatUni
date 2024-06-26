import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/store/tutors.dart';

part 'navbar.g.dart';

Color selectedColor = Colors.blue;
Color nonSelectedColor = Colors.black45;

@swidget
Widget navBar(BuildContext context) {
  final tutors = Provider.of<Tutors>(context);
  return Observer(
    builder: (_) => BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 50,
      shape: tutors.isTutorSelected ? const CircularNotchedRectangle() : null,
      notchMargin: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buildIcons(context, tutors),
      ),
    ),
  );
}

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
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );

List<InkWell> buildIcons(BuildContext context, Tutors tutors) {
  List<InkWell> menuIcons = [];

  InkWell tutorIcon = menuIcon(
    Icons.school,
    '外教',
    () {
      tutors.clearTutor();
      context.go('/');
    },
    isSelected: true,
  );
  InkWell courseIcon = menuIcon(Icons.menu_book_rounded, '课程', () {});
  InkWell metaIcon = menuIcon(Icons.language, '元宇宙', () {});
  InkWell accountIcon = menuIcon(Icons.person, '我的', () {
    context.go('/my');
  });
  InkWell invisibleIcon = menuIcon(Icons.menu, '', () {}, isPlaceholder: true);

  menuIcons.add(tutorIcon);
  menuIcons.add(courseIcon);
  if (tutors.isTutorSelected) menuIcons.add(invisibleIcon);
  menuIcons.add(metaIcon);
  menuIcons.add(accountIcon);

  return menuIcons;
}
