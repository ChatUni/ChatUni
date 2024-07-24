import 'package:chatuni/widgets/common/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/store/app.dart';
import '/store/auth.dart';
import '/widgets/common/button.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/input.dart';
import '/widgets/scaffold/scaffold.dart';

Widget login() => scaffold(
      vContainer(
        [
          vSpacer(40),
          _logo,
          vSpacer(40),
          _phoneInput,
          vSpacer(10),
          _emailInput,
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

Observer _emailInput = obs<Auth>(
  (auth) => input(
    auth.setEmail,
    labelText: 'Email',
    prefixIcon: const Icon(Icons.email),
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
            // snack('Code sent!');
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
            // snack('Login successful!');
          }
        : null,
    text: auth.isLoggingIn ? '' : 'Login',
    icon: auth.isLoggedIn ? Icons.alarm : null,
  ),
);
