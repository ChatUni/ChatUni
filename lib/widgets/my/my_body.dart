import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '/store/auth.dart';
import 'logged_in_body.dart';
import 'login_body.dart';

part 'my_body.g.dart';

@swidget
Widget myBody(BuildContext context) {
  final auth = Provider.of<Auth>(context);
  return Observer(
    builder: (_) => auth.isLoggedIn ? const LoggedInBody() : const LoginBody(),
  );
}
