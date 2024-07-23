import '/models/pricing.dart';
import 'api.dart';

final get = dioGet(vipBase2);
final post = dioPost(vipBase2);

Future createPayorder(int id, String method) async {
  final r = await post(
    'pay/createpayorder',
    headers: headers,
    data: {
      'method': method,
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
