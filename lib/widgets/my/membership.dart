import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/store/app.dart';
import '/store/auth.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import '/widgets/scaffold/scaffold.dart';

Widget membership() => obs<Auth>(
      (auth) {
        auth.getPrices();

        return scaffold(
          vContainer(
            [
              vSpacer(20),
              _title,
              vSpacer(20),
              _priceGrid,
              vSpacer(20),
              _benefit,
              vSpacer(100),
            ],
            padding: 20,
          ),
          title: 'Payment',
          routeGroup: RouteGroup.my,
        );
      },
    );

const _titleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

TextStyle _whiteTitleStyle = _titleStyle.copyWith(color: Colors.white);

const _subtitleStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

Observer _title = obs<Auth>(
  (auth) => ccRow(
    [
      Text(
        '我的VIP(剩余${auth.user?.remain ?? 0}小时)',
        style: _whiteTitleStyle,
      ),
    ],
  ),
);

Text _priceDesc(String desc) => Text(
      '$desc VIP',
      style: _titleStyle,
    );

Text _special(int price) => Text(
      '特价 ¥$price',
      style: _whiteTitleStyle,
    );

Observer _priceGrid = obs<Auth>(
  (auth) => vGrid(
    2,
    2,
    auth.priceList
        .map(
          (x) => tap(
            () => auth.createPayment(x.id),
            v2Card(
              _priceDesc(x.description),
              _special(x.special),
              color2: Colors.lightBlueAccent,
            ),
          ),
        )
        .toList(),
    spacing: 20,
  ),
);

Text _benefitHeader = const Text(
  '会员权益',
  style: _titleStyle,
);

Row _benefitItem = scRow([
  const Text(
    '无限对话',
    style: _titleStyle,
  ),
  const Text(
    '(闲聊学习，趣味场景)',
    style: _subtitleStyle,
  ),
  const Spacer(),
  const CircleAvatar(
    radius: 20,
    backgroundColor: Colors.lightGreen,
    child: Icon(Icons.check),
  ),
]);

Card _benefit = tCard(
  _benefitHeader,
  [_benefitItem, _benefitItem],
  color: Colors.lightGreenAccent,
);
