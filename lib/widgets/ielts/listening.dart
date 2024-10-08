import 'package:chatuni/models/ielts.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/ielts.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/input.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

const styles = {'h1': h1, 'h2': h2, 'b': bold};

Widget listening() => scaffold(
      vContainer(
        [
          vSpacer(10),
          _part(),
          vSpacer(60),
        ],
        padding: 20,
        scroll: true,
      ),
      title: 'Listening',
      routeGroup: RouteGroup.my,
      bgColor: Colors.white,
    );

Widget _part() => obs<Ielts>((ielts) {
      final p = ielts.part!;

      return ssCol([
        center(h1('Test 1')),
        vSpacer(8),
        h3('Listen'),
        vSpacer(6),
        h3(p.name),
        vSpacer(12),
        button(() {}, icon: Icons.play_arrow),
        vSpacer(12),
        ...ielts.part!.groups.map((g) => _group(g)),
        button(
          ielts.checkAnswers,
          text: 'Check Answers',
          bgColor: Colors.green,
        ),
        vSpacer(12),
        ccRow([
          grow(button(() {}, text: 'Prev Part')),
          hSpacer(16),
          grow(button(() {}, text: 'Next Part')),
        ]),
      ]);
    });

Widget _group(Group g) => ssCol(
      g.paragraphs.map((p) => _paragraph(p)).expand((p) => p).toList(),
    );

List<Widget> _paragraph(Paragraph p) {
  if (p.type == 'choice' && p.questions!.every((q) => q.choices == null)) {
    return [
      ...p.content.map(
        (c) => Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Checkbox(
                value: false, // Replace with the actual value
                onChanged: (bool? value) {
                  // Handle checkbox value change
                },
              ),
              Text(c),
            ],
          ),
        ),
      ),
    ];
  } else if (p.type == 'choice' &&
      p.questions!.every((q) => q.choices != null)) {
    return [
      ...?p.questions?.map(
        (q) => Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: h3(q.subject.toString()),
            ),
            ...?q.choices?.map(
              (choice) => _multiple(choice),
            ),
            vSpacer(12),
          ],
        ),
      ),
      vSpacer(25),
    ];
  } else if (p.type == 'fill') {
    return [
      ...p.content.map((f) => _content(f)),
      vSpacer(25),
    ];
  } else {
    return [
      ...p.content.map((s) => h2(s)),
    ];
  }
}

Align _multiple(String choice) => Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Checkbox(
            value: false, // Replace with the actual value
            onChanged: (bool? value) {
              value = true;
            },
          ),
          Text(choice),
        ],
      ),
    );

Widget _choice(String s) => obs<Ielts>((ielts) {
      final key = styles.keys.firstWhereOrNull((k) => s.startsWith('<$k>'));
      if (key != null) return styles[key]!(s.replaceFirst('<$key>', ''));
      RegExp re = RegExp(r'(\d{1,2}).*?([\._…]{6,})');
      final match = re.firstMatch(s);
      if (match != null) {
        final num = match.group(1)!;
        final blank = match.group(2)!;
        final ss = s.split(blank);
        return scRow([
          txt(ss[0]),
          hSpacer(8),
          grow(
            input(
              (context) => tap,
              isDense: true,
              error: ielts.isChecking ? ielts.checkAnswer(num) : null,
            ),
          ),
          hSpacer(8),
          txt(ss[1]),
        ]);
      }
      return txt(s);
    });

Widget _content(String s) => obs<Ielts>((ielts) {
      final key = styles.keys.firstWhereOrNull((k) => s.startsWith('<$k>'));
      if (key != null) return styles[key]!(s.replaceFirst('<$key>', ''));
      RegExp re = RegExp(r'(\d{1,2}).*?([\._…]{6,})');
      final match = re.firstMatch(s);
      if (match != null) {
        final num = match.group(1)!;
        final blank = match.group(2)!;
        final ss = s.split(blank);
        return scRow([
          txt(ss[0]),
          hSpacer(8),
          grow(
            input(
              (t) => ielts.fill(num, t),
              style: InputStyle.underline,
              isDense: true,
              error: ielts.isChecking ? ielts.checkAnswer(num) : null,
            ),
          ),
          hSpacer(8),
          txt(ss[1]),
        ]);
      }
      return txt(s);
    });
