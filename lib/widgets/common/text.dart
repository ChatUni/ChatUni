import 'package:flutter/material.dart';

Text txt(
  String text, {
  bool bold = false,
  double size = 16,
  bool italic = false,
  Color color = Colors.black,
  TextDecoration decoration = TextDecoration.none,
}) =>
    Text(
      text,
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: color,
        decoration: decoration,
      ),
    );

Text bold(String text) => txt(text, bold: true);
Text italic(String text) => txt(text, italic: true);

Text h1(String text) => txt(text, bold: true, size: 28);
Text h2(String text) => txt(text, bold: true, size: 24);
Text h3(String text) => txt(text, bold: true, size: 20);
Text h4(String text) => txt(text, bold: true, size: 16);
Text h5(String text) => txt(text, bold: true, size: 12);
Text h6(String text) => txt(text, bold: true, size: 8);

Text h2under(String text) =>
    txt(text, bold: true, size: 24, decoration: TextDecoration.underline);
Text h3under(String text) =>
    txt(text, bold: true, size: 20, decoration: TextDecoration.underline);

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
