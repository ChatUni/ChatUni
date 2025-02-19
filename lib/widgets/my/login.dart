import 'package:chatuni/globals.dart';
import 'package:chatuni/router.dart';
import 'package:chatuni/widgets/common/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/store/app.dart';
import '/store/auth.dart';
import '/widgets/common/button.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/input.dart';
import '/widgets/common/snack.dart';
import '/widgets/scaffold/scaffold.dart';

Widget login() => scaffold(
      vContainer(
        [
          vSpacer(40),
          _logo,
          vSpacer(40),
          _phoneInput,
          vSpacer(10),
          _codeInput,
          vSpacer(20),
          _loginButton,
        ],
        padding: 50,
        scroll: true,
      ),
      title: 'Login',
      routeGroup: RouteGroup.my,
    );

Image _logo = Image.asset(
  'assets/images/chatuni.png',
);

Observer _phoneInput = obs<Auth>(
  (auth) => input(
    auth.setPhone,
    labelText: 'Phone Number',
    prefixIcon: pBox(lEdge(10))(
      dropdownButton(auth.countryCode, countryCodes, auth.setCountryCode),
    ), // Icons.phone,
    //keyboardType: TextInputType.phone,
  ),
);

Observer _codeInput = obs<Auth>(
  (auth) => input(
    auth.setCode,
    labelText: 'Verification Code',
    prefixIcon: const Icon(Icons.security),
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
);

Observer _loginButton = obs<Auth>(
  (auth) => button(
    auth.isLoginEnabled
        ? () async {
            await auth.login();
            snack('Login successful!');
            router.go(
              '/${app.singleApp.isEmpty ? 'tutors' : getRoute(app.singleApp)}',
            );
          }
        : null,
    text: auth.isLoggingIn ? '' : 'Login',
    icon: auth.isLoggedIn ? Icons.alarm : null,
  ),
);

String getRoute(String singleApp) =>
    app.singleApp.startsWith('Exam.') ? 'exam_tests' : app.singleApp;
