import 'package:collection/collection.dart';
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
          if (tutors.msgs.length > 8 ||
              tutors.msgs.map((m) => m.text.length).sum > 300) {
            msgsScrollController
                .jumpTo(msgsScrollController.position.maxScrollExtent + 100);
          }
          // msgsScrollController.animateTo(
          //   msgsScrollController.position.maxScrollExtent + 100,
          //   duration: const Duration(milliseconds: 200),
          //   curve: Curves.fastOutSlowIn,
          // );
        });

        return grow(
          1,
          ListView(
            controller: msgsScrollController,
            padding: edge(8, 8, 8, 100),
            children: tutors.msgs.map((m) => msgRow(m)).toList(),
          ),
        );
      },
    );
