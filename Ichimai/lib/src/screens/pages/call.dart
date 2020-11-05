import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:ichimai/src/shared/settings.dart';
import 'package:permission_handler/permission_handler.dart';

//* 토큰, 채널을 인수로 입력받음
//* 연결동작과 통화중 페이지를 표시
//*

class CallPage extends StatefulWidget {
  final String token, channel;
  final int uid;

  const CallPage({Key key, this.token, this.channel, this.uid})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final referenceDatase = FirebaseDatabase.instance;

  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;
  int _totalVolume = 0;

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
    await PermissionHandler().requestPermissions(
      [PermissionGroup.microphone],
    );

    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();

    _addAgoraEventHandlers();
    await _engine.enableAudioVolumeIndication(500, 3, true);
    await _engine.joinChannel(widget.token, widget.channel, null, widget.uid);
    // * 데이터베이스에 채널 추가
    final ref =
        referenceDatase.reference().child('Channels').child(widget.channel);
    ref.child('token').set(widget.token).asStream();
    ref.child('starting at').set(DateTime.now().millisecondsSinceEpoch);
    // * 이벤트 추가
    final ref2 = referenceDatase
        .reference()
        .child('Channels')
        .onChildAdded
        .listen((event) {
      setState(() {
        print(event.snapshot.value);
      });
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    // Create RTC client instance
    _engine = await RtcEngine.create(APP_ID);
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
        setState(() {
          _totalVolume = totalVolume;
        });
      },
    ));
  }

  void _databaseUpdate() {}

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _volumePanel() {
    return Text('volume: $_totalVolume ');
  }

  Widget _users() {
    final ref = referenceDatase
        .reference()
        .child('Channels')
        .onChildAdded
        .listen((event) {
      print(event.snapshot.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.call_end),
        ),
        title: Text('Chennel: ${widget.channel}'),
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              // _viewRows(),
              _panel(),
              // _toolbar(),
              _volumePanel(),
            ],
          ),
        ),
      ),
    );
  }
}
