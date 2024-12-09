import 'package:chatuni/globals.dart';
import 'package:chatuni/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
    // menuItem(
    //   Icons.payment,
    //   'Payment',
    //   onTap: () => context.go('/membership'),
    // ),
    menuItem(Icons.verified_user, 'Security'),
    menuItem(
      Icons.history,
      'History',
      onTap: () async {
        await exam.loadResults();
        router.go('/history');
      },
    ),
    menuItem(Icons.logout, 'Logout', onTap: auth.logout),
    menuItem(
      Icons.delete,
      'Delete Account',
      color: Colors.red,
      onTap: () => _deleteAccount(context, auth),
    ),
  ]),
);

void _deleteAccount(BuildContext context, Auth auth) async {
  final bool? confirm = await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Do you want to delete your account?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // no
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), // yes
          child: const Text('Yes'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    auth.logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted successfully')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deletion canceled')),
    );
  }
}
