import 'package:chatuni/utils/const.dart' as consts;
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:flutter/material.dart';

DropdownButton<String> dropdownButton(
  String value,
  List<String> values,
  void Function(String) onSelected,
) =>
    DropdownButton<String>(
      onChanged: (v) => onSelected(v ?? ''),
      value: value == '' ? values.first : value,
      items: values
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
    );

DropdownMenu<String> dropdown(
  List<String> values,
  void Function(String) onSelected,
) =>
    DropdownMenu<String>(
      onSelected: (v) => onSelected(v ?? ''),
      initialSelection: values.first,
      dropdownMenuEntries: values
          .map(
            (v) => DropdownMenuEntry(value: v, label: v),
          )
          .toList(),
      expandedInsets: hEdge(15),
      //inputDecorationTheme: const InputDecorationTheme(isCollapsed: true),
    );

DropdownButton<String> dropdownbtn(
  List<String> values,
  String? value,
  void Function(String) onSelected,
) =>
    DropdownButton<String>(
      onChanged: (v) => onSelected(v ?? ''),
      value: value,
      items: values
          .map(
            (v) => DropdownMenuItem<String>(value: v, child: txt(v)),
          )
          .toList(),
      isExpanded: true,
      style: const TextStyle(color: Color(consts.Colors.darkBlue)),
    );

PopupMenuButton<String> popupMenu(
  List<String> values,
  void Function(String) onSelected,
) =>
    PopupMenuButton<String>(
      onSelected: onSelected,
      initialValue: values.first,
      itemBuilder: (_) => values
          .map((v) => PopupMenuItem<String>(value: v, child: Text(v)))
          .toList(),
    );
