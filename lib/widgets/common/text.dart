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

Text bold(String text) => txt(text, bold: true);

Text h1(String text) => txt(text, bold: true, size: 28);
Text h2(String text) => txt(text, bold: true, size: 24);
Text h3(String text) => txt(text, bold: true, size: 20);

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
