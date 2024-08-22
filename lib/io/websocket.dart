import 'dart:convert';

import 'package:ably_flutter/ably_flutter.dart';
import 'package:chatuni/env.dart';
import 'package:chatuni/utils/js_no_impl.dart'
    if (dart.library.html) 'package:chatuni/utils/js.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

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

void pusherListen(
  String channel,
  String event,
  void Function(String) onEvent,
) async {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  await pusher.init(
    apiKey: Env.pusherAppKey,
    cluster: 'us3',
  );
  await pusher.connect();
  await pusher.subscribe(
    channelName: channel,
    onEvent: (e) {
      // cl('Flutter pusher in - $e');
      if (e.eventName == event) {
        if (e.data is String) {
          onEvent(jsonDecode(e.data)['msg']);
        } else {
          onEvent(pusherParse(e.data));
        }
      }
    },
  );
}
