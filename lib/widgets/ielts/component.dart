import 'package:chatuni/store/ielts.dart';
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
                playButton(),
                vSpacer(12),
                ...ielts.part!.groups.map((g) => group(g)),
                writeBoxAndAnswer(),
                speak(),
                prevNext(),
              ],
            ),
    );
