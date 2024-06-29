import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/models/msg.dart';
import '/store/tutors.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';

Observer msgRow(Msg m) => obsc<Tutors>(
      (tutors, context) => tap(
        () => tutors.read(m),
        Row(
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
                        fontWeight: tutors.isReading && m.isReading
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: m.isAI ? Colors.black : Colors.indigo,
                      ),
                      textAlign: m.isAI ? TextAlign.start : TextAlign.end,
                    ),
                  ),
                  msgDot(m, false),
                ],
        ),
      ),
    );

Widget msgDot(Msg m, bool before) => pBox(tEdge(4))(
      before && m.url != ''
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
