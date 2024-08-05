import 'package:chatuni/widgets/common/snack.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

import '/models/user.dart';
import 'api.dart';

Map<String, DateTime> _otpTimestamps = {};

bool canSendOtp(String phone) {
  if (_otpTimestamps.containsKey(phone)) {
    DateTime lastSent = _otpTimestamps[phone]!;
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

  return true;
}

Future<String?> sendCodeToPhone(String phone, [String type = '1']) async {
  final error = validatePhoneNumber(phone);
  if (error != null) {
    snack('Please enter a valid number');
    return null;
  }

  if (!canSendOtp(phone)) {
    snack('Please wait 60 seconds before requesting another OTP.');
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
    _otpTimestamps[phone] = DateTime.now();
    snack('Code sent to phone number!');
    return r['result'];
  } else {
    snack('Failed to send OTP. Please try again.');
  }

  return null;
}

Future<String?> sendCodeToEmail(String email, [String type = '2']) async {
  final error = validateEmail(email);
  if (error != null) {
    snack('Please enter a valid email');
  } else {
    // snack('Code sent!');
    var r = await post(
      'login/authcode',
      data: emailData(email),
      headers: headers,
    );
    print(r);
    snack('Code sent to email!');
    return r['result'];
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
  snack('Login successful!');
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
  snack('Login successful!');
  return User.fromJson(r['result']);
}

// Timer(Duration(seconds: 3), () {
//   print("Yeah, this line is printed after 3 seconds");
// });
