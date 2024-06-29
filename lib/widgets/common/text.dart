import 'package:flutter/material.dart';

Text txt(
  String text, {
  bool bold = false,
  double size = 16,
  bool italic = false,
  Color color = Colors.black,
}) =>
    Text(
      text,
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: color,
      ),
    );

TextSpan txtSpan(
  String text, {
  bool bold = false,
  double size = 16,
  bool italic = false,
  Color color = Colors.black,
}) =>
    TextSpan(
      text: text,
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: color,
      ),
    );
