import 'dart:async';

import 'package:chatuni/utils/event.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

import '/models/user.dart';
import 'api.dart';

const codeSent = 'Code sent successfully!';
const otp = 'Please wait 60 seconds before requesting another OTP.';
const login = 'Logged in successfully!';
const validNumber = 'Please enter a valid number';
const validEmail = 'Please enter a valid email';

Map<String, DateTime> _otpTimestampsphone = {};
Map<String, DateTime> _otpTimestampsemail = {};

bool canSendOtpphone(String phone) {
  if (_otpTimestampsphone.containsKey(phone)) {
    DateTime lastSent = _otpTimestampsphone[phone]!;
    return DateTime.now().difference(lastSent).inSeconds >= 60;
  }
  return true;
}

bool canSendOtpEmail(String email) {
  if (_otpTimestampsemail.containsKey(email)) {
    DateTime lastSent = _otpTimestampsemail[email]!;
    return DateTime.now().difference(lastSent).inSeconds >= 60;
  }
  return true;
}

OtpTimerButtonController controller = OtpTimerButtonController();

_requestOtp() {
  controller.loading();
  Future.delayed(const Duration(seconds: 60), () {
    controller.startTimer();
  });
}

final post = dioPost(vipBase);
final headers = {
  'Content-Type': 'application/json',
  // 'Authorization':
  //    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjksInBob25lIjoiMTcxMDE4MzI3MjIiLCJpYXQiOjE3MTg2MTY4ODYsImV4cCI6MTcyMTIwODg4Nn0.gPZYtavTYIOSo_Dhpkcup1ae_3grI3RiZs_IpjI-3NM',
};

// Future<List<Tutor>> getToken() async {
//   final r = await get('tutor', params: {'type': 'tutors'});
//   return (r as List).map((t) => Tutor.fromJson(t)).toList();
// }

final phoneData =
    (String phone) => {'countrycode': '+1', 'identifier': phone, 'type': '1'};

final emailData = (String email) => {
      'identifier': email,
      'type': '2',
    };

String? validatePhoneNumber(String phoneNumber) {
  final RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  if (!regex.hasMatch(phoneNumber)) {
    return 'Enter a valid phone number';
  }
  return null;
}

String? validateEmail(String value) {
  RegExp regex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  if (!regex.hasMatch(value)) {
    return 'Enter Valid Email';
  }
  return null;
}

Future<bool> validateOTP(String phone, String code) async {
  var r = await post(
    'login/verify_code',
    data: {
      'phone': phone,
      'code': code,
    },
    headers: headers,
  );

  // bool result = resultChecker();
  // if ()
  return true;
}

Future<String?> sendCodeToPhone(String phone, [String type = '1']) async {
  final error = validatePhoneNumber(phone);
  if (error != null) {
    // snack('Please enter a valid number');
    raiseEvent(validNumber, true);
    return null;
  }

  if (!canSendOtpphone(phone)) {
    raiseEvent(otp, true);
    // snack('Please wait 60 seconds before requesting another OTP.');
    return null;
  }

  // send OTP
  var r = await post(
    'login/authcode',
    data: phoneData(phone),
    headers: headers,
  );

  if (r != null && r.containsKey('result')) {
    // update the timestamp for OTP sent
    _otpTimestampsphone[phone] = DateTime.now();
    // snack('Code sent to phone number!');
    raiseEvent(validNumber, false);
    raiseEvent(codeSent, true);
    raiseEvent(otp, false);
    return r['result'];
  } else {
    raiseEvent(codeSent, false);
    // snack('Failed to send OTP. Please try again.');
  }

  return null;
}

Future<String?> sendCodeToEmail(String email, [String type = '2']) async {
  final error = validateEmail(email);
  if (error != null) {
    raiseEvent(validEmail, true);
    // snack('Please enter a valid email');
  }

  if (!canSendOtpEmail(email)) {
    raiseEvent(otp, true);
    // snack('Please wait 60 seconds before requesting another OTP.');
    return null;
  }

  // send otp
  var r = await post(
    'login/authcode',
    data: emailData(email),
    headers: headers,
  );

  if (r != null && r.containsKey('result')) {
    // update the timestamp for OTP sent
    _otpTimestampsemail[email] = DateTime.now();
    // snack('Code sent to phone number!');
    raiseEvent(validEmail, false);
    raiseEvent(codeSent, true);
    return r['result'];
  } else {
    raiseEvent(codeSent, false);
    // snack('Failed to send OTP. Please try again.');
  }

  return null;
}

Future<User?> loginWithPhoneCode(String phone, String code) async {
  var r = await post(
    'login/login',
    data: {
      ...phoneData(phone),
      'phone': phone,
      'code': code,
      'system': 3,
    },
    headers: headers,
  );
  // snack('Login successful!');
  raiseEvent(login, true);
  return User.fromJson(r['result']);
}

Future<User?> loginWithEmailCode(String email, String code) async {
  var r = await post(
    'login/login',
    data: {
      ...emailData(email),
      'phone': email,
      'code': code,
      'system': 3,
    },
    headers: headers,
  );
  raiseEvent(login, true);
  // snack('Login successful!');
  return User.fromJson(r['result']);
}
