import 'package:chatuni/globals.dart';
import 'package:url_launcher/url_launcher.dart';

Function pipe(List<Function> fns) => (x) => fns.fold(x, (p, c) => c(p));

Function compose(List<Function> fns) =>
    (x) => fns.reversed.fold(x, (p, c) => c(p));

List<int> range(int from, int to) =>
    Iterable<int>.generate(to - from + 1).map((x) => x + from).toList();

List<int> lidx(List l) => range(0, l.length - 1);

bool notNull(x) => x != null;

Future<void> launch(String url, {bool isNewTab = true}) => launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );

T log<T>(T t, [String msg = '']) {
  print(msg);
  print(t);
  return t;
}

String cdImg(String name) =>
    'https://res.cloudinary.com/daqc8bim3/image/upload/v$cdVer/$name';
String cdMp3(String name) =>
    'https://res.cloudinary.com/daqc8bim3/video/upload/v$cdVer/$name.mp3';
