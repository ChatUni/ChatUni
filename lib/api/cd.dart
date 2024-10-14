import 'api.dart';

final get = dioGet(cuBase);

Future<String> cdVersion() async {
  final r = await get('api', params: {'type': 'cdVer'});
  return r.toString();
}
