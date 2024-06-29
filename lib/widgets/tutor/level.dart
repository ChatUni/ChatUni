import 'package:flutter/material.dart';

import '/widgets/common/container.dart';
import '/widgets/common/text.dart';

Container level(int level) => pBox(hEdge(4))(
      Card(
        child: pBox(hEdge(8))(
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: txt('⬤ ', size: 8, color: Colors.blue),
                ),
                txtSpan('Level $level', bold: true, color: Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
