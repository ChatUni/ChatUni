import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/common/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '/store/tutors.dart';
import '/widgets/common/hoc.dart';

Widget face() => obs<Tutors>((tutors) {
      final tutor = tutors.tutor ?? tutors.tutors[0];

      final height = Window.isDesktop() ? Window.height : 400.0;

      return cBox(Colors.white)(
        tutors.isAvatar
            ? box(
                Window.width, height,
                // RTCVideoView(
                //   tutors.getRTCRenderer(),
                //   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                // ),
                InAppWebView(
                  initialSettings: InAppWebViewSettings(
                    mediaPlaybackRequiresUserGesture: false,
                    allowsInlineMediaPlayback: true,
                  ),
                  initialUrlRequest: URLRequest(
                    url: WebUri(tutors.avatarUrl),
                  ),
                ),
              )
            : Image.asset(
                'assets/images/${tutors.isReading ? 'gif' : 'tutoricons'}/${tutor.id}.${tutors.isReading ? 'gif' : 'png'}',
                width: Window.width,
                height: height,
                fit: Window.width > 480 ? BoxFit.fitHeight : BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
      );
    });
