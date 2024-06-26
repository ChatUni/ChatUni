import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '/store/tutors.dart';

part 'fab.g.dart';

@swidget
Widget fabMic(BuildContext context) {
  final tutors = Provider.of<Tutors>(context);
  return Observer(
    builder: (_) => tutors.isTutorSelected
        ? SizedBox(
            height: 80,
            width: 80,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: tutors.isRecording
                    ? tutors.stopRecording
                    : tutors.startRecording,
                shape: const CircleBorder(),
                backgroundColor: tutors.isRecording ? Colors.red : Colors.green,
                child: const Icon(Icons.mic, size: 30),
              ),
            ),
          )
        : const SizedBox.shrink(),
  );
}
