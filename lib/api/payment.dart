import 'api.dart';

const base = 'http://52.37.231.249:9010';
final get = dioGet(base);
final post = dioPost(base);
final headers = {
  'Content-Type': 'application/json',
  'Authorization':
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjksInBob25lIjoiMTcxMDE4MzI3MjIiLCJpYXQiOjE3MTg2MTY4ODYsImV4cCI6MTcyMTIwODg4Nn0.gPZYtavTYIOSo_Dhpkcup1ae_3grI3RiZs_IpjI-3NM',
};

Future createPayorder() async {
  final r = await post(
    'pay/createpayorder',
    headers: headers,
    data: {
      'method': 'Wechat',
      'scenariocode': 'ONLINE_WAP',
      'id': 1,
    },
  );
  return r['result'];
}

Future getPriceList() async {
  final r = await get(
    'pay/getpricelist',
    headers: headers,
  );
  return r['result'];
}
