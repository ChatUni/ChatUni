import 'dart:async';

import 'package:chatuni/globals.dart';
import 'package:url_launcher/url_launcher.dart';

Map<int, Timer> _timers = {};

Function pipe(List<Function> fns) => (x) => fns.fold(x, (p, c) => c(p));

Function compose(List<Function> fns) =>
    (x) => fns.reversed.fold(x, (p, c) => c(p));

List<int> range(int from, int to) =>
    Iterable<int>.generate(to - from + 1).map((x) => x + from).toList();

List<int> lidx(List l) => range(0, l.length - 1);

bool notNull(x) => x != null;

Future<void> wait(int ms) => Future.delayed(Duration(milliseconds: ms));

Future<void> launch(String url, {bool isNewTab = true}) => launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );

T log<T>(T t, [String msg = '']) {
  print(msg);
  print(t);
  return t;
}

int timer(int sec, bool Function() update) {
  final n = _timers.length + 1;
  final t = Timer.periodic(Duration(seconds: sec), (_) {
    if (update()) stopTimer(n);
  });
  _timers[n] = t;
  return n;
}

void stopTimer(int tid) {
  _timers[tid]?.cancel();
  _timers.remove(tid);
}

Map<String, List<String>> _cdTypes = {
  'img': ['image', ''],
  'mp3': ['video', '.mp3'],
  'mp4': ['video', '.mp4'],
};
String Function(String) _cd(List<String> type) => (String name) =>
    'https://res.cloudinary.com/daqc8bim3/${type[0]}/upload/v$cdVer/$name${type[1]}';
String Function(String) cdImg = _cd(_cdTypes['img']!);
String Function(String) cdMp3 = _cd(_cdTypes['mp3']!);
String Function(String) cdMp4 = _cd(_cdTypes['mp4']!);

String dateString(String utc) {
  final d = DateTime.parse(utc).toLocal().toString();
  return d.substring(0, d.length - 4);
}

(int, String) numAndTitle(String s) {
  final re = RegExp(r'^(\d{1,2})\.? (.*)$');
  final match = re.firstMatch(s);
  return match == null
      ? (-1, s)
      : (int.parse(match.group(1)!), match.group(2)!);
}
