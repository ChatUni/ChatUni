import 'dart:convert';

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
import 'package:flutter/material.dart';

var tagHandlers = Map.fromIterables(
  tags,
  [
    h1,
    h2,
    h3,
    h4,
    bold,
    italic,
    txt,
    (String x) {
      print(x);
      return Image.network(cdImg(x));
      return x.contains('base64')
          ? Image.memory(base64Decode(x))
          : Image.network(cdImg(x));
    },
  ],
);

Widget ieltsScaffold(String comp, List<Widget> ws) => scaffold(
      vContainer(
        [
          vSpacer(10),
          ...ws,
          vSpacer(60),
        ],
        padding: 20,
        scroll: true,
      ),
      title: comp,
      routeGroup: RouteGroup.course,
      bgColor: Colors.white,
    );

Widget title() =>
    obs<Ielts>((ielts) => center(h1('Test ${ielts.test!.id.split('-')[1]}')));

Widget content(String s) => obs<Ielts>((ielts) {
      final (content, tag) = ielts.contentTag(s);
      final (num, s1, s2) = ielts.parseFill(content);

      return num > -1
          ? fillQuestion(num, s1!, s2!)
          : tag != null
              ? tagHandlers[tag]!(content)
              : txt(content);
    });

Widget fillQuestion(
  int num,
  String s1,
  String s2,
) =>
    obs<Ielts>(
      (ielts) => scRow([
        txt(s1),
        hSpacer(8),
        grow(
          fillInput(
            (t) => ielts.fill(num, t),
            ielts.getQuestion(num)?.userAnswer,
            ielts.isChecking ? ielts.checkAnswer(num) : null,
          ),
        ),
        hSpacer(8),
        txt(s2),
      ]),
    );

Widget fillInput(
  void Function(String) onChanged,
  String? userAnswer,
  String? error,
) =>
    input(
      onChanged,
      initialValue: userAnswer,
      style: InputStyle.underline,
      isDense: true,
      error: error,
    );

Widget group(Group g) => ssCol(
      g.paragraphs.expand((p) => paragraph(p)).toList(),
    );

List<Widget> paragraph(Paragraph p) {
  Iterable<Widget> ps = [];
  if (p.isMultiChoice) {
    ps = [
      bold(p.questionNumbers),
      ...p.nonChoiceContent.map((c) => content(c)),
      vSpacer(8),
      ...p.choiceList.map(multiChoice),
    ];
  } else if (p.isSingleChoice) {
    ps = p.questions!.expand(singleChoice);
  } else if (p.isTrueFalse) {
    ps = lidx(p.questions!)
        .expand((i) => trueFalse(p.questions![i], p.content[i]));
  } else {
    ps = p.content.map((c) => content(c));
  }
  return [...ps, vSpacer(12)];
}

List<Widget> trueFalse(Question q, String c) => [
      content(c),
      vSpacer(4),
      box(
        null,
        24,
        ssRow([
          trueFalseButton('TRUE', q),
          hSpacer(8),
          trueFalseButton('FALSE', q),
          hSpacer(8),
          trueFalseButton('NOT GIVEN', q),
        ]),
      ),
      vSpacer(8),
    ];

Widget trueFalseButton(String text, Question q) => obs<Ielts>(
      (ielts) => button(
        () => ielts.trueFalseSelect(q, text),
        text: '$text${ielts.rc < 0 ? '' : ''}',
        size: 10,
        outline:
            !(ielts.isChecking && q.isActual(text) || q.userAnswer == text),
        bgColor: ielts.isChecking
            ? q.isActual(text)
                ? Colors.green
                : Colors.red
            : Colors.blue,
      ),
    );

List<Widget> singleChoice(Question q) => [
      bold('${q.number}. ${q.subject!}'),
      ...q.choiceList.map(
        (c) => obs<Ielts>(
          (ielts) => tap(
            () => ielts.singleSelect(q, c.key),
            txt(
              '${c.key} ${c.value}${ielts.rc < 0 ? '' : ''}',
              color: Color(ielts.choiceColor(c)),
              bold: ielts.boldChoice(c),
            ),
          ),
        ),
      ),
      vSpacer(8),
    ];

Widget multiChoice(Choice choice) => obs<Ielts>(
      (ielts) => tap(
        () => ielts.multiSelect(choice.q1, choice.q2, choice.key),
        txt(
          '${choice.key} ${choice.value}${ielts.rc < 0 ? '' : ''}',
          color: Color(ielts.choiceColor(choice)),
          bold: ielts.boldChoice(choice),
        ),
      ),
    );

Widget checkButton() => obs<Ielts>(
      (ielts) => button(
        ielts.checkAnswers,
        text: 'Check Answers',
        bgColor: Colors.green,
      ),
    );

Widget prevNext() => obs<Ielts>(
      (ielts) => ccRow([
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
                ? () {
                    if (ielts.isLastComp) {
                      router.go('/ielts_result');
                    } else {
                      ielts.nextComp(1);
                    }
                  }
                : () => ielts.nextPart(1),
            text: ielts.isLastPart
                ? ielts.isLastComp
                    ? 'Finish'
                    : ielts.nextComponent
                : 'Next Part',
          ),
        ),
      ]),
    );
