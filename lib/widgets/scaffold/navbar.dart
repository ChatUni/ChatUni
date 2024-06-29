import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/store/app.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/text.dart';

Color selectedColor = Colors.blue;
Color nonSelectedColor = Colors.black45;

Widget navBar() => obsc<App>(
      (app, context) => BottomAppBar(
        padding: hEdge(30),
        height: 50,
        shape: app.showMic ? const CircularNotchedRectangle() : null,
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buildIcons(app, context),
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

List<InkWell> buildIcons(App app, BuildContext context) {
  List<InkWell> menuIcons = [];

  InkWell tutorIcon = menuIcon(
    Icons.school,
    '外教',
    () => context.go('/'),
    isSelected: app.routeGroup == RouteGroup.tutor,
  );
  InkWell courseIcon = menuIcon(
    Icons.menu_book_rounded,
    '课程',
    () {},
    isSelected: app.routeGroup == RouteGroup.course,
  );
  InkWell metaIcon = menuIcon(
    Icons.language,
    '元宇宙',
    () {},
    isSelected: app.routeGroup == RouteGroup.meta,
  );
  InkWell accountIcon = menuIcon(
    Icons.person,
    '我的',
    () => context.go('/my'),
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
