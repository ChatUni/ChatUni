import 'package:chatuni/widgets/common/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '/store/auth.dart';
import '/widgets/common/button.dart';
import '/widgets/common/input.dart';
import '/widgets/scaffold/scaffold.dart';

part 'login_body.g.dart';

@swidget
Widget loginBody(BuildContext context) {
  final auth = Provider.of<Auth>(context);

  return scaffold(
    Observer(
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/chatuni.png',
                ),
                input(
                  auth.setPhone,
                  labelText: 'Phone Number',
                  prefixIcon: Icons.phone,
                  //keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                input(
                  auth.setCode,
                  labelText: 'Verification Code',
                  prefixIcon: Icons.security,
                  suffixIcon: auth.isPhoneValid
                      ? auth.isSendingCode
                          ? Image.asset(
                              'assets/images/gif/dots.gif',
                              scale: 8,
                            )
                          : const Icon(Icons.send_to_mobile)
                      : null,
                  suffixAction: auth.isPhoneValid
                      ? () async {
                          await auth.sendCode();
                          snack('Code sent!');
                        }
                      : null,
                  //keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                button(
                  auth.isLoginEnabled
                      ? () async {
                          await auth.login();
                          snack('Login successful!');
                        }
                      : null,
                  text: auth.isLoggingIn ? '' : 'Login',
                  icon: auth.isLoggedIn ? Icons.alarm : null,
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
