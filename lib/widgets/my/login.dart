import 'package:chatuni/router.dart';
import 'package:chatuni/widgets/common/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

import '/store/app.dart';
import '/store/auth.dart';
import '/widgets/common/button.dart';
import '/widgets/common/container.dart';
import '/widgets/common/hoc.dart';
import '/widgets/common/input.dart';
import '/widgets/scaffold/scaffold.dart';

OtpTimerButtonController OTPcontroller = OtpTimerButtonController();

// _requestOtp() {
//   OTPcontroller.loading();
//   Future.delayed(const Duration(seconds: 60), () {
//     OTPcontroller.startTimer();
//   });
// }

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
          // _loginWithEmail(router),
          Builder(builder: (context) => _loginWithEmail()),
        ],
        padding: 50,
        scroll: true,
      ),
      title: 'Login',
      routeGroup: RouteGroup.my,
    );

Widget emailLoginPage() => scaffold(
      vContainer(
        [
          vSpacer(40),
          _logo,
          vSpacer(40),
          _emailInput,
          vSpacer(10),
          _ecodeInput,
          vSpacer(20),
          _eloginButton,
        ],
        padding: 50,
        scroll: true,
      ),
      title: 'Email Login',
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
  ),
);

Observer _codeInput = obs<Auth>(
  (auth) => input(
    auth.setCode,
    labelText: 'Verification Code',
    prefixIcon: const Icon(Icons.security),
    suffixIcon: auth.isPhoneValid && !auth.hasSentCodeBefore
        ? OtpTimerButton(
            controller: OTPcontroller,
            onPressed: () async {
              await auth.sendCode();
              OTPcontroller.loading();
              Future.delayed(const Duration(seconds: 60), () {
                OTPcontroller.startTimer();
              });
            },
            text: const Text('Send OTP'),
            duration: 0, // seconds
          )
        : auth.isPhoneValid && auth.hasSentCodeBefore
            ? const Icon(
                Icons.send_to_mobile,
              )
            : null,
    suffixAction: null,
  ),
);

// Observer _codeInput = obs<Auth>(
//   (auth) => input(
//     auth.setCode,
//     labelText: 'Verification Code',
//     prefixIcon: const Icon(Icons.security),
//     suffixIcon: auth.isPhoneValid
//         ? auth.isSendingCode
//             ? Image.asset(
//                 'assets/images/gif/dots.gif',
//                 scale: 8,
//               )
//             : const Icon(Icons.send_to_mobile)
//         : null,
//     suffixAction: auth.isPhoneValid
//         ? () async {
//             await auth.sendCode();
//           }
//         : null,
//     //keyboardType: TextInputType.number,
//   ),
// );

Observer _ecodeInput = obs<Auth>(
  (auth) => input(
    auth.setCode,
    labelText: 'Verification Code',
    prefixIcon: const Icon(Icons.security),
    suffixIcon: auth.isEmailValid
        ? auth.isSendingCode
            ? Image.asset(
                'assets/images/gif/dots.gif',
                scale: 8,
              )
            : const Icon(Icons.send_to_mobile)
        : null,
    suffixAction: auth.isEmailValid
        ? () async {
            await auth.esendCode();
            router.go('/membership');
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

Observer _eloginButton = obs<Auth>(
  (auth) => button(
    auth.isemailLoginEnabled
        ? () async {
            await auth.elogin();
            // snack('Login successful!');
          }
        : null,
    text: auth.isLoggingIn ? '' : 'Login',
    icon: auth.isLoggedIn ? Icons.alarm : null,
  ),
);

Widget _loginWithEmail() => TextButton(
      onPressed: () {
        router.go('/emailLogin');
      },
      child: const Text(
        'Login with Email',
        style: TextStyle(color: Colors.blue),
      ),
    );
