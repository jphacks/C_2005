import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ichimai/src/shared/settings.dart';

class Call extends StatefulWidget {
  final String token, channel;
  final int uid;

  const Call({Key key, this.token, this.channel, this.uid}) : super(key: key);

  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  final referenceDatase = FirebaseDatabase.instance;
  final _infoStrings = <String>[];
  RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  @override
  void dispose() {
    //* 데이터베이스에 채널 제거
    final ref =
        referenceDatase.reference().child('Channels').child(widget.channel);

    ref.remove();

    // clear users

    // destroy sdk
    _engine.disableAudio();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();

    _addAgoraEventHandlers();
    await _engine.enableAudioVolumeIndication(500, 3, true);
    await _engine.joinChannel(widget.token, widget.channel, null, widget.uid);
    // * 데이터베이스에 채널 추가
    final ref =
        referenceDatase.reference().child('Channels').child(widget.channel);
    ref.child('token').set(widget.token).asStream();
    ref.child('starting at').set(DateTime.now().millisecondsSinceEpoch);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
        });
      },
      audioVolumeIndication: (speakers, totalVolume) {
        //! 볼륨과 사용자 감지
        /*
        setState(() {
          _totalVolume = totalVolume;
        });
         */
      },
    ));
  }

  Future<void> _initAgoraRtcEngine() async {
    // Create RTC client instance
    _engine = await RtcEngine.create(APP_ID);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
