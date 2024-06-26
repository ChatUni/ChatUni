import 'package:flutter/material.dart';

import 'button.dart';

Widget personTile(
  Widget image,
  String title, {
  List<String> props = const [],
  bool hasFav = false,
  String desc = '',
  void Function()? action,
  double? bottomMargin,
}) {
  final header = [
    image,
    const SizedBox(width: 15),
    Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ...props.map((x) => Text(x)),
      ],
    ),
  ];
  if (hasFav) {
    header.addAll([
      const Spacer(),
      const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.favorite, color: Colors.red),
          Text(
            '19,999',
            style: TextStyle(fontSize: 8),
          ),
        ],
      ),
    ]);
  }
  List<Widget> col = [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: header,
    ),
  ];
  if (desc != '') {
    col.addAll([
      const Divider(),
      Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
    ]);
  }
  if (action != null) {
    col.addAll([
      const SizedBox(height: 10),
      button(
        action,
        icon: Icons.chat,
        text: 'Chat',
      ),
    ]);
  }
  return Container(
    padding: const EdgeInsets.all(4),
    child: Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, bottomMargin ?? 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: col,
        ),
      ),
    ),
  );
}
