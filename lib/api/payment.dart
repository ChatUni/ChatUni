import '/models/pricing.dart';
import 'api.dart';

final get = dioGet(vipBase2);
final post = dioPost(vipBase2);
final headers = {
  'Content-Type': 'application/json',
  'Authorization':
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjksInBob25lIjoiMTcxMDE4MzI3MjIiLCJpYXQiOjE3MTg2MTY4ODYsImV4cCI6MTcyMTIwODg4Nn0.gPZYtavTYIOSo_Dhpkcup1ae_3grI3RiZs_IpjI-3NM',
};

Future createPayorder(int id) async {
  final r = await post(
    'pay/createpayorder',
    headers: headers,
    data: {
      'method': 'Alipay', // 'Wechat',
      'scenariocode': 'ONLINE_WAP',
      'id': id,
    },
  );
  return r['result'];
}

Future<List<Pricing>> getPriceList() async {
  final r = await get(
    'pay/getpricelist',
    headers: headers,
  );
  return (r['result'] as List).map((t) => Pricing.fromJson(t)).toList();
}
