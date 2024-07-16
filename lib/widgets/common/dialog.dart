import 'package:chatuni/router.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:flutter/material.dart';

Future dialog(BuildContext context, Widget d) => showDialog(
      context: context,
      builder: (_) => d,
    );

SimpleDialog confirmDialog(
  String title,
  List<Widget> children,
  void Function() onConfirm,
) =>
    SimpleDialog(
      title: Text(title),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      children: [
        ...children,
        vSpacer(10),
        ecRow([
          SimpleDialogOption(
            onPressed: () => router.pop(),
            child: txt('取消', color: Colors.blueAccent, bold: true),
          ),
          SimpleDialogOption(
            onPressed: () {
              onConfirm();
              router.pop();
            },
            child: txt('确定', color: Colors.blueAccent, bold: true),
          ),
        ]),
      ],
    );
