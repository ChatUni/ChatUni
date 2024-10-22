import 'package:chatuni/store/ielts.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/ielts/common.dart';
import 'package:flutter/material.dart';

Widget component() => obs<Ielts>(
      (ielts) => ielts.component == null
          ? vSpacer(1)
          : ieltsScaffold(
              ielts.component!,
              [
                title(),
                vSpacer(8),
                left(h3(ielts.component!)),
                vSpacer(6),
                left(h3(ielts.part!.name)),
                vSpacer(12),
                ielts.compIndex == 0 ? playButton() : vSpacer(1),
                vSpacer(12),
                ...ielts.part!.groups.map((g) => group(g)),
                ielts.compIndex == 2
                    ? ssCol([textArea(), vSpacer(16)])
                    : vSpacer(1),
                prevNext(),
              ],
            ),
    );

Widget playButton() => obs<Ielts>(
      (ielts) => button(
        ielts.isPlaying ? ielts.stop : ielts.play,
        icon: ielts.isPlaying ? Icons.stop : Icons.play_arrow,
        bgColor: ielts.isPlaying ? Colors.red : Colors.green,
      ),
    );

Widget textArea() => TextFormField(
      minLines: 6,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
    );
