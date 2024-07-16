import 'package:url_launcher/url_launcher.dart';

List<int> range(int from, int to) =>
    Iterable<int>.generate(to - from + 1).map((x) => x + from).toList();

Future<void> launch(String url, {bool isNewTab = true}) => launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );

T log<T>(T t, [String msg = '']) {
  print(msg);
  print(t);
  return t;
}
