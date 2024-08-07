import 'package:chatuni/widgets/common/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '/store/tutors.dart';
import '/widgets/common/hoc.dart';

Widget face() => obsc<Tutors>((tutors, context) {
      final tutor = tutors.tutor ?? tutors.tutors[0];

      final width = MediaQuery.of(context).size.width;
      const height = 400.0;

      return cBox(Colors.white)(
        tutors.isAvatar
            ? SizedBox(
                width: width,
                height: height,
                // child: RTCVideoView(
                //   tutors.getRTCRenderer(),
                //   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                // ),
                child: InAppWebView(
                  initialSettings: InAppWebViewSettings(
                    mediaPlaybackRequiresUserGesture: false,
                    allowsInlineMediaPlayback: true,
                  ),
                  initialUrlRequest: URLRequest(
                    url: WebUri(
                      'https://chatuni.netlify.app/d-id.html?id=${tutor.id}',
                    ),
                  ),
                ),
              )
            : Image.asset(
                'assets/images/${tutors.isReading ? 'gif' : 'tutoricons'}/${tutor.id}.${tutors.isReading ? 'gif' : 'png'}',
                width: width,
                height: height,
                fit: width > 480 ? BoxFit.fitHeight : BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
      );
    });
