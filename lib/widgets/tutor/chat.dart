import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import '../../store/tutors.dart';
import '../../models/msg.dart';

part 'chat.g.dart';

final ScrollController msgsScrollController = ScrollController();

@swidget
Widget chat(BuildContext context) {
  final tutors = Provider.of<Tutors>(context);

  reaction((_) => tutors.msgs.length, (_) {
    msgsScrollController
        .jumpTo(msgsScrollController.position.maxScrollExtent + 100);
    // msgsScrollController.animateTo(
    //   msgsScrollController.position.maxScrollExtent + 100,
    //   duration: const Duration(milliseconds: 200),
    //   curve: Curves.fastOutSlowIn,
    // );
  });

  return Observer(
    builder: (_) => Expanded(
      child: ListView(
        controller: msgsScrollController,
        padding: const EdgeInsets.all(8),
        children: tutors.msgs.map((m) => MsgRow(m)).toList(),
      ),
    ),
  );
}

@swidget
Widget msgRow(BuildContext context, Msg m) {
  final tutors = Provider.of<Tutors>(context);
  return InkWell(
    onTap: () {
      tutors.read(m);
    },
    child: Row(
      mainAxisAlignment:
          m.isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: m.isWaiting
          ? [
              Image.asset(
                'assets/images/gif/dots.gif',
                width: 100,
                height: 50,
              ),
            ]
          : [
              msgDot(m, true),
              SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: Text(
                  ' ${m.text}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          m.isReading ? FontWeight.w800 : FontWeight.w500,
                      color: m.isAI ? Colors.black : Colors.indigo),
                  textAlign: m.isAI ? TextAlign.start : TextAlign.end,
                ),
              ),
              msgDot(m, false),
            ],
    ),
  );
}

Widget msgDot(Msg m, bool before) => Container(
      padding: const EdgeInsets.only(top: 4),
      child: before && m.url != ''
          ? const Icon(Icons.volume_up, size: 15, color: Colors.green)
          : Text(
              before ? (m.isAI ? '⬤ ' : '') : (m.isAI ? '' : ' ⬤'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w100,
                color: m.isAI ? Colors.green : Colors.blue[700],
              ),
            ),
    );
