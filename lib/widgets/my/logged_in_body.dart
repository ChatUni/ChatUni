import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '/store/auth.dart';
import '/widgets/scaffold/scaffold.dart';

part 'logged_in_body.g.dart';

@swidget
Widget loggedInBody(BuildContext context) {
  final auth = Provider.of<Auth>(context);

  return scaffold(
    Observer(
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 75,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.user?.name ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.male),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  menuItemEdit(
                    Icons.person,
                    'Name: ${auth.user?.name}',
                  ),
                  menuItemEdit(Icons.email, 'Email: '),
                  menuItemEdit(Icons.phone, 'Phone: ${auth.user?.phone}'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  menuItem(Icons.payment, 'Payment'),
                  menuItem(Icons.verified_user, 'Security'),
                  menuItem(Icons.history, 'History'),
                  menuItem(Icons.logout, 'Logout', onTap: auth.logout),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

ListTile menuItem(
  IconData icon,
  String text, {
  bool isEdit = false,
  void Function()? onTap,
}) =>
    ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: Icon(isEdit ? Icons.edit : Icons.forward),
      onTap: onTap,
    );

ListTile menuItemEdit(IconData icon, String text) =>
    menuItem(icon, text, isEdit: true);
