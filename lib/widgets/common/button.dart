import 'package:flutter/material.dart';

FilledButton button(
  void Function()? onPressed, {
  IconData? icon,
  String text = '',
}) {
  final List<Widget> children = [];
  if (icon != null) {
    children.add(
      Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
  children.add(
    Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
  return FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: Colors.blue[500],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    ),
  );
}
