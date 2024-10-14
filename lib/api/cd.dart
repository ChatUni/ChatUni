import 'api.dart';

final get = dioGet(cuBase);

Future<String> cdVersion() async {
  final r = await get('cdVer');
  return r as String;
}
