import 'package:chatuni/widgets/common/snack.dart';

import '/models/user.dart';
import 'api.dart';

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
      'type': '1',
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
  print(r['result']);

  if (r['result'] == 'Code valid') {
    return true;
  } else {
    return false;
  }
}

Future<String?> sendCodeToPhone(String phone, [String type = '1']) async {
  final error = validatePhoneNumber(phone);
  if (error != null) {
    snack('Please enter a valid number');
  } else {
    var r = await post(
      'login/authcode',
      data: phoneData(phone),
      headers: headers,
    );

    return r['result'];
  }
  return null;
}

Future<String?> sendCodeToEmail(String email, [String type = '1']) async {
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
