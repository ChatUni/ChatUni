import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/tutor.dart';
import '../models/msg.dart';

String base = 'https://chatuni.netlify.app/.netlify/functions';

final dio = Dio();

Future<R?> get<R>(String func, String type) async {
  final r = await dio.get<R>('$base/$func?type=$type');
  return r.data;
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
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
