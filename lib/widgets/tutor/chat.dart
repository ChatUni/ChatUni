import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '/store/tutors.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import 'msg.dart';

final ScrollController msgsScrollController = ScrollController();

Widget chat() => obs<Tutors>(
      (tutors) {
        reaction((_) => tutors.msgs.length, (_) {
          msgsScrollController
              .jumpTo(msgsScrollController.position.maxScrollExtent + 100);
          // msgsScrollController.animateTo(
          //   msgsScrollController.position.maxScrollExtent + 100,
          //   duration: const Duration(milliseconds: 200),
          //   curve: Curves.fastOutSlowIn,
          // );
        });

        return Expanded(
          child: ListView(
            controller: msgsScrollController,
            padding: aEdge(8),
            children: tutors.msgs.map((m) => msgRow(m)).toList(),
          ),
        );
      },
    );
