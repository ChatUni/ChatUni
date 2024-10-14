import 'package:chatuni/models/ielts.dart';
import 'package:chatuni/router.dart';
import 'package:chatuni/store/app.dart';
import 'package:chatuni/store/ielts.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:chatuni/widgets/common/button.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/hoc.dart';
import 'package:chatuni/widgets/common/input.dart';
import 'package:chatuni/widgets/common/text.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

var styles = {
  'h1': h1,
  'h2': h2,
  'h3': h3,
  'h4': h3,
  'b': bold,
  'i': italic,
  'ul': txt,
  'img': (x) => Image.network(cdImg(x)),
};

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
      routeGroup: RouteGroup.course,
      bgColor: Colors.white,
    );

Widget _part() => obs<Ielts>((ielts) {
      final p = ielts.part!;

      return ssCol([
        center(h1('Test ${ielts.test!.id.split('-')[1]}')),
        vSpacer(8),
        h3('Listen'),
        vSpacer(6),
        h3(p.name),
        vSpacer(12),
        button(
          ielts.isPlaying ? ielts.stop : ielts.play,
          icon: ielts.isPlaying ? Icons.stop : Icons.play_arrow,
          bgColor: ielts.isPlaying ? Colors.red : Colors.green,
        ),
        vSpacer(12),
        ...ielts.part!.groups.map((g) => _group(g)),
        // button(
        //   ielts.checkAnswers,
        //   text: 'Check Answers',
        //   bgColor: Colors.green,
        // ),
        // vSpacer(12),
        ccRow([
          grow(
            button(
              ielts.isFirstPart ? null : () => ielts.nextPart(-1),
              text: 'Prev Part',
            ),
          ),
          hSpacer(16),
          grow(
            button(
              ielts.isLastPart
                  ? () => router.go('/ielts_result')
                  : () => ielts.nextPart(1),
              text: ielts.isLastPart ? 'Finish' : 'Next Part',
            ),
          ),
        ]),
      ]);
    });

Widget _group(Group g) => ssCol(
      g.paragraphs.expand((p) => _paragraph(p)).toList(),
    );

List<Widget> _paragraph(Paragraph p) {
  final ps = p.isMultiChoice
      ? [
          bold(p.questionNumbers),
          ...p.nonChoiceContent.map((c) => _content(c)),
          vSpacer(8),
          ...p.choiceList.map(_multiChoice),
        ]
      : p.isSingleChoice
          ? p.questions!.expand(_singleChoice)
          : p.content.map((c) => _content(c));
  return [...ps, vSpacer(12)];
}

//${c.isCorrect ? ' ✔' : c.isWrong ? ' ✘' : ''}
List<Widget> _singleChoice(Question q) => [
      bold('${q.number}. ${q.subject!}'),
      ...q.choiceList.map(
        (c) => obs<Ielts>(
          (ielts) => tap(
            () => ielts.singleSelect(q, c.key),
            txt(
              '${c.key} ${c.value}${ielts.rc < 0 ? '' : ''}',
              color: ielts.isChecking
                  ? c.isActual
                      ? c.isSelected
                          ? Colors.blue
                          : Colors.green
                      : c.isSelected
                          ? Colors.red
                          : Colors.black
                  : c.isSelected
                      ? Colors.blue
                      : Colors.black,
              bold: ielts.isChecking && c.isActual || c.isSelected,
            ),
          ),
        ),
      ),
      vSpacer(8),
    ];

Widget _multiChoice(Choice choice) => obs<Ielts>(
      (ielts) => tap(
        () => ielts.multiSelect(choice.q1, choice.q2, choice.key),
        txt(
          '${choice.key} ${choice.value}${ielts.rc < 0 ? '' : ''}',
          color: ielts.isChecking
              ? choice.isActual
                  ? choice.isSelected
                      ? Colors.blue
                      : Colors.green
                  : choice.isSelected
                      ? Colors.red
                      : Colors.black
              : choice.isSelected
                  ? Colors.blue
                  : Colors.black,
          bold: ielts.isChecking && choice.isActual || choice.isSelected,
        ),
      ),
    );

Widget _content(String s) => obs<Ielts>((ielts) {
      final key = styles.keys.firstWhereOrNull((k) => s.startsWith('<$k>'));
      if (key != null) s = s.replaceFirst('<$key>', '');

      RegExp re = RegExp(r'(\d{1,2}).*?([\._…]{6,})');
      final match = re.firstMatch(s);
      //if (match != null) print(match.groups([1, 2]));
      if (match != null) {
        final num = int.parse(match.group(1)!);
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

      return key != null ? styles[key]!(s) : txt(s);
    });
