import 'package:flutter/material.dart';

import '/widgets/common/container.dart';
import '/widgets/common/text.dart';
import 'button.dart';

Widget personTile(
  Widget image,
  String title, {
  List<String> props = const [],
  bool hasFav = false,
  String desc = '',
  void Function()? action,
}) =>
    Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: ssCol([
          _header(image, title, props),
          const Divider(),
          _desc(desc),
          vSpacer(10),
          _action(action),
          vSpacer(8),
        ]),
      ),
    );

Row _header(Widget image, String title, List<String> props) => ssRow([
      image,
      hSpacer(15),
      ssCol([
        txt(title, bold: true),
        vSpacer(5),
        ...props.map((x) => Text(x)),
      ]),
      const Spacer(),
      _fav,
    ]);

Column _fav = scCol([
  const Icon(Icons.favorite, color: Colors.red),
  txt('19,999', size: 8),
]);

Text _desc(String desc) =>
    Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis);

FilledButton _action(void Function()? action) =>
    button(action, icon: Icons.chat, text: 'Chat');
