import 'package:flutter/material.dart';

ListTile menuItem(
  IconData icon,
  String text, {
  bool isEdit = false,
  void Function()? onTap,
  Color color = Colors.black,
}) =>
    ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      trailing: Icon(isEdit ? Icons.edit : Icons.forward),
      onTap: onTap,
    );

ListTile menuItemEdit(IconData icon, String text) =>
    menuItem(icon, text, isEdit: true);
