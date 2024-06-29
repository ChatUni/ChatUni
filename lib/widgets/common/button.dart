import 'package:flutter/material.dart';

import '/widgets/common/container.dart';
import 'text.dart';

FilledButton button(
  void Function()? onPressed, {
  IconData? icon,
  String text = '',
  Color bgColor = Colors.blue,
}) {
  final List<Widget> children = [];

  if (icon != null) {
    children.addAll([
      Icon(icon, color: Colors.white),
      hSpacer(10),
    ]);
  }

  children.add(
    txt(text, color: Colors.white),
  );

  return FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: ccRow(children),
  );
}
