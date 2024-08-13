import 'package:ably_flutter/ably_flutter.dart';
import 'package:chatuni/env.dart';

class Ably {
  late Realtime realtime;
  late RealtimeChannel channel;

  Future<void> _init() async {
    realtime = Realtime(options: ClientOptions(key: Env.ablyAppKey));
    channel = realtime.channels.get('did');
  }

  Future<void> listen(String name, void Function(Object?) cb) async {
    channel.subscribe(name: name).listen((msg) => cb(msg.data));
  }

  Future<void> send(String name, Object? data) async {
    await channel.publish(
      name: name,
      data: data,
    );
  }

  Ably() {
    _init();
  }
}
