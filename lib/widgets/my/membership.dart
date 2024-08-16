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

Text _special(double price) => Text(
      '特价 ¥$price',
      style: _whiteTitleStyle,
    );

Observer _priceGrid = obsc<Auth>(
  (auth, context) => vGrid(
    2,
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
/*
Observer paymentMethodDialog(int id) => obs<Auth>(
      (auth) => confirmDialog(
        '选择付款方式',
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

Observer paymentMethodDialog(int id) {
  return obsc<Auth>((auth, context) {
    return AlertDialog(
      title: Text('选择付款方式'),
      content: dropdown(
        paymentMethods,
        auth.setPaymentMethod,
      ),
      actions: [
        TextButton(
          child: Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('确认'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the first dialog
            
            // Show the second confirmation dialog
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) => AlertDialog(
                title: Text('确认支付?'),
                actions: [
                  TextButton(
                    child: Text('取消'),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                  TextButton(
                    child: Text('确认'),
                    onPressed: () {
                      auth.createPayment(id);
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  });
}
*/
Observer paymentMethodDialog(int id) => obsc<Auth>(
  (auth, context) => confirmDialog(
    '选择付款方式',
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
    () {
      // Close the first dialog
      Navigator.of(context).pop();
      // Delay slightly before showing the second dialog
      Future.delayed(Duration(milliseconds: 100), () {
        // Show the second confirmation dialog
        showDialog(
          context: context,
          builder: (_) => confirmBox(
            '确认支付?',
            () {
              auth.createPayment(id); // Proceed with payment
            },
          ),
        );
      });
    },
  ),
);