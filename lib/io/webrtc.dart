import 'dart:async';

import 'package:chatuni/api/d-id.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

const answerPrefix = 'chat/answer:';
const streamStarted = 'stream/started';

class WebRTC {
  late final RTCPeerConnection? _pc;
  late final RTCDataChannel? _dc;
  late final RTCSessionDescription? _sd;
  Map<String, dynamic> _config = {};
  String _streamId = '';
  String _sessionId = '';
  final String _agentId = 'agt_JdGCtniN';
  final String _chatId = 'cht_Z_pWInxNKerieAZ376ZWs';
  final remoteRenderer = RTCVideoRenderer();

  Future createPC(String img) async {
    // var stream = await navigator.mediaDevices.getUserMedia(
    //   {'video': true, 'audio': true},
    // );
    // remoteRenderer.srcObject = stream;

    _config = await createStream(img);
    _streamId = _config['id'];
    _sessionId = _config['session_id'];
    _sd = RTCSessionDescription(
      _config['offer']['sdp'],
      _config['offer']['type'],
    );
    print(_sd?.sdp);
    // _sd?.sdp = _sd.sdp?.replaceAll('H264', 'VP8');
    _pc = await createPeerConnection(_config);
    if (_pc != null) {
      _pc.onIceCandidate = _onIceCandidate;
      _pc.onTrack = _onTrack;
      _pc.onDataChannel = (d) => d.onMessage = (e) => print(e.text);
      // _pc.onAddStream
      await _pc.setRemoteDescription(_sd!);
      final answer = await _pc.createAnswer();
      print(answer.sdp);
      await _pc.setLocalDescription(answer);
      await startStream(_sessionId, _streamId, answer.toMap());

      _dc = await _pc.createDataChannel(
        'JanusDataChannel',
        RTCDataChannelInit(),
      );
      if (_dc != null) {
        print('dc created');
        _dc.onMessage = (e) {
          print(e.text);
        };
      }
    }
  }

  Future sendMsg(String msg) async {
    await sendToChat(_sessionId, _streamId, _agentId, _chatId, msg);
  }

  void _onIceCandidate(RTCIceCandidate ice) {
    _pc?.addCandidate(ice);
    submitNetworkInfo(
      _sessionId,
      _streamId,
      ice.candidate,
      ice.sdpMid,
      ice.sdpMLineIndex,
    );
  }

  void _onTrack(RTCTrackEvent event) {
    // Timer.periodic(const Duration(seconds: 1), (t) async {
    //   final stats = await _pc?.getStats(event.track);
    //   print(stats?.map((s) => '${s.values['type']} - ${s.values['kind']}'));
    // });
    remoteRenderer.srcObject = event.streams[0];
  }

  WebRTC() {
    remoteRenderer.initialize();
  }
}
