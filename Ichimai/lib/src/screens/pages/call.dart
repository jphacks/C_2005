import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:ichimai/src/shared/settings.dart';
import 'package:ichimai/src/shared/theme.dart';
import 'package:provider/provider.dart';

final _firestore = FirebaseFirestore.instance;
String messageText;

class Call extends StatefulWidget {
  const Call({Key key, this.token, this.channel, this.uid}) : super(key: key);

  final String token, channel;
  final int uid;

  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  final referenceDatase = FirebaseDatabase.instance;

  RtcEngine _engine;
  final _infoStrings = <String>[];
  int _totalVolume = 0;
  List<String> _users = [];

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

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  void initialize() async {
    await _initAgoraRtcEngine().then((value) => _addAgoraEventHandlers());
    await _engine.enableAudioVolumeIndication(500, 3, true);
    await _engine.joinChannel(widget.token, widget.channel, null, widget.uid);
    // * 데이터베이스에 채널 추가
    final ref =
        referenceDatase.reference().child('Channels').child(widget.channel);
    ref.child('token').set(widget.token).asStream();
    ref.child('starting at').set(DateTime.now().millisecondsSinceEpoch);
    // *
    _users.add(widget.uid.toString());
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
          _users.add(uid.toString());
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid.toString());
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

  Future _initAgoraRtcEngine() async {
    // Create RTC client instance
    _engine = await RtcEngine.create(APP_ID);
  }

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

  Widget _userList() {
    List<Widget> userWidgets = [];
    _users.forEach((element) {
      userWidgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('$element ,'),
      ));
    });
    return Column(children: [
      Text('Online Players'),
      Row(
        children: userWidgets,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final chatMsgTextController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chennel: ${widget.channel}'),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              _userList(),
              // _viewRows(),
              _panel(),
              // ChatStream(channel: widget.channel)
            ],
          ),
        ),
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  const ChatStream({Key key, this.channel}) : super(key: key);

  final String channel;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    return StreamBuilder(
      stream: _firestore.collection(channel).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final msgText = message.data['text'];
            final msgSender = message.data['sender'];
            // final msgSenderEmail = message.data['senderemail'];
            final currentUser = user.name;

            // print('MSG'+msgSender + '  CURR'+currentUser);
            final msgBubble = MessageBubble(
                msgText: msgText,
                msgSender: msgSender,
                user: currentUser == msgSender);
            messageWidgets.add(msgBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        } else {
          return Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.msgText, this.msgSender, this.user});

  final String msgSender;
  final String msgText;
  final bool user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              msgSender,
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? Colors.blue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.blue,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
