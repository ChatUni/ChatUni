import '/models/user.dart';
import 'api.dart';

final post = dioPost(vipBase);

// Future<List<Tutor>> getToken() async {
//   final r = await get('tutor', params: {'type': 'tutors'});
//   return (r as List).map((t) => Tutor.fromJson(t)).toList();
// }

final phoneData =
    (String phone) => {'countrycode': '+86', 'identifier': phone, 'type': '1'};

Future<String?> sendCodeToPhone(String phone, [String type = '1']) async {
  var r = await post(
    'login/authcode',
    data: phoneData(phone),
    headers: headers,
  );
  return r['result'];
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
  return User.fromJson(r['result']);
}
