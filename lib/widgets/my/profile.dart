import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '/store/app.dart';
import '/store/auth.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/menu.dart';
import '/widgets/common/text.dart';
import '/widgets/scaffold/scaffold.dart';
import '../common/container.dart';

Widget profile() => scaffold(
      vContainer(
        [
          vSpacer(10),
          _header,
          vSpacer(10),
          _profile,
          vSpacer(10),
          _settings,
        ],
      ),
      title: 'Profile',
      routeGroup: RouteGroup.my,
    );

Observer _header = obs<Auth>(
  (auth) => ssRow([
    const CircleAvatar(
      radius: 50,
      child: Icon(
        Icons.person,
        size: 75,
      ),
    ),
    hSpacer(20),
    ssCol([
      txt(auth.user?.name ?? '', size: 24, bold: true),
      const Icon(Icons.male),
    ]),
  ]),
);

Observer _profile = obs<Auth>(
  (auth) => vCard(
    [
      menuItemEdit(
        Icons.person,
        'Name: ${auth.user?.name}',
      ),
      menuItemEdit(Icons.email, 'Email: '),
      menuItemEdit(Icons.phone, 'Phone: ${auth.user?.phone}'),
    ],
  ),
);

Observer _settings = obsc<Auth>(
  (auth, context) => vCard([
    menuItem(
      Icons.payment,
      'Payment',
      onTap: () => context.go('/membership'),
    ),
    menuItem(Icons.verified_user, 'Security'),
    menuItem(Icons.history, 'History'),
    menuItem(Icons.logout, 'Logout', onTap: auth.logout),
  ]),
);
