import 'package:chatuni/widgets/common/dialog.dart';
import 'package:chatuni/widgets/common/dropdown.dart';
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
        'My VIP(${auth.user?.remain ?? 0} hours remaining)', // '我的VIP(剩余0小时)'
        style: _whiteTitleStyle,
      ),
    ],
  ),
);

Text _priceDesc(String desc) => Text(
      '$desc VIP',
      style: _titleStyle,
    );

Text _special(double price) => Text(
      'Special ¥$price',
      style: _whiteTitleStyle,
    );

Observer _priceGrid = obsc<Auth>(
  (auth, context) => grid(
    2,
    auth.priceList
        .map(
          (x) => tap(
            () => dialog(context, paymentMethodDialog(x.id)),
            v2Card(
              _priceDesc(x.description),
              _special(x.special.toDouble()),
              color2: Colors.lightBlueAccent,
            ),
          ),
        )
        .toList(),
    spacing: 20,
  ),
);

Text _benefitHeader = const Text(
  'Member Benefits', // '会员权益'
  style: _titleStyle,
);

Row _benefitItem = scRow([
  const Text(
    'Unlimited Chat',
    style: _titleStyle,
  ),
  const Text(
    '(Casual Chat, Hobby Scene)', // '(闲聊学习，趣味场景)',
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

Observer paymentMethodDialog(int id) => obs<Auth>(
      (auth) => confirmDialog(
        'Choose payment method', // '选择付款方式',
        [
          ccRow([
            Expanded(
              child: dropdown(
                paymentMethods,
                auth.setPaymentMethod,
              ),
            ),
          ]),
        ],
        () => auth.createPayment(id),
      ),
    );
