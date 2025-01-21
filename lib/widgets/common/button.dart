import 'package:flutter/material.dart';

import '/widgets/common/container.dart';
import 'text.dart';

ButtonStyleButton button(
  void Function()? onPressed, {
  IconData? icon,
  String text = '',
  Color bgColor = Colors.blue,
  Color color = Colors.white,
  bool outline = false,
  double size = 16,
  bool isCircle = false,
  double padding = 0,
  double iconTextSpaing = 10,
}) {
  final shape = isCircle
      ? const CircleBorder()
      : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        );

  final List<Widget> children = [];

  if (icon != null) {
    children.addAll([
      Icon(icon, color: Colors.white),
      hSpacer(iconTextSpaing),
    ]);
  }

  children.add(
    txt(text, color: outline ? Colors.black : color, size: size),
  );

  return outline
      ? OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: shape,
            padding: aEdge(padding),
          ),
          child: ccRow(children),
        )
      : FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: bgColor,
            shape: shape,
            padding: aEdge(padding),
          ),
          child: ccRow(children),
        );
}
