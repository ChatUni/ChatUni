import 'package:flutter/material.dart';

import '/widgets/common/container.dart';
import 'text.dart';

ButtonStyleButton button(
  void Function()? onPressed, {
  IconData? icon,
  String text = '',
  Color bgColor = Colors.blue,
  bool outline = false,
  double size = 16,
}) {
  final radius = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  final List<Widget> children = [];

  if (icon != null) {
    children.addAll([
      Icon(icon, color: Colors.white),
      hSpacer(10),
    ]);
  }

  children.add(
    txt(text, color: outline ? Colors.black : Colors.white, size: size),
  );

  return outline
      ? OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: radius,
          ),
          child: ccRow(children),
        )
      : FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: bgColor,
            shape: radius,
          ),
          child: ccRow(children),
        );
}
