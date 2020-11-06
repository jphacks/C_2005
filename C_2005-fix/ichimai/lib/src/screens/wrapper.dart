import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/screens/authenticate/authenticate.dart';
import 'package:ichimai/src/screens/pages/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final referenceDatase = FirebaseDatabase.instance;
  int uid;
  @override
  Widget build(BuildContext context) {
    // StreamProvider.value로 받은 value(User타입)를 사용
    final user = Provider.of<UserData>(context);

    // DB에 유저가 접속중이 아님을 알림
    final ref = referenceDatase.reference().child('Users');
    // .child(user.generateAgoraUid().toString());

    if (user == null) {
      if (uid != null) {
        ref.child(uid.toString()).child('online').set(false).asStream();
      }

      return Authenticate();
    } else {
      uid = user.generateAgoraUid();
      // DB에 유저가 접속중임을 알림
      ref.child(uid.toString()).child('online').set(true).asStream();
      return Home();
    }
  }
}
