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
  void Function() onConfirm, {
  bool hasCancel = true,
}) =>
    SimpleDialog(
      title: Text(title),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      children: [
        ...children,
        vSpacer(10),
        ecRow([
          hasCancel
              ? SimpleDialogOption(
                  onPressed: () => router.pop(),
                  child: txt('Cancel', color: Colors.blueAccent, bold: true),
                )
              : hSpacer(1),
          SimpleDialogOption(
            onPressed: () {
              onConfirm();
              router.pop();
            },
            child: txt('OK', color: Colors.blueAccent, bold: true),
          ),
        ]),
      ],
    );

AlertDialog alert(String msg) => AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(msg),
          ],
        ),
      ),
    );
