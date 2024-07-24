import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

const cuBase = 'https://chatuni.netlify.app/.netlify/functions';
//  'http://10.0.0.72:701/.netlify/functions';
const vipBase = 'https://chat.smartgo.fun'; // 'https://chat.smartkit.vip';
const vipBase2 = 'http://52.37.231.249:9010';

final headers = {
  'Content-Type': 'application/json',
  'Authorization':
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOjE4LCJwaG9uZSI6IjEiLCJpYXQiOjE3MjEwOTQzMzAsImV4cCI6MTcyMzY4NjMzMH0.hhFhcMvCFr752WUj94dwbfXIwLKG73390Bm_CkAFf44',
};

final _dio = Dio();

final dioGet = (String base) => (
      String func, {
      Map<String, String> params = const {},
      Map<String, String> headers = const {},
    }) async {
      final r = await _dio.get(
        buildUrl(base, func, params),
        options: Options(headers: headers),
      );
      return r.data;
    };

final dioPost = (String base) => (
      String func, {
      Map<String, dynamic> data = const {},
      Map<String, String> params = const {},
      Map<String, String> headers = const {},
    }) async {
      final r = await _dio.post(
        buildUrl(base, func, params),
        data: data,
        options: Options(headers: headers),
      );
      return r.data;
    };

String buildUrl(
  String base,
  String func, [
  Map<String, String> params = const {},
]) {
  String url = base;
  if (func.isNotEmpty) url += '/$func';
  if (params.isNotEmpty) {
    url += '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }
  print(url);
  return url;
}

Future<Uint8List> readAsBytes(String path) async {
  if (path.startsWith('blob:')) {
    final response = await http.get(Uri.parse(path));
    return response.bodyBytes;
  } else {
    return await File.fromUri(Uri.parse(path)).readAsBytes();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
}
