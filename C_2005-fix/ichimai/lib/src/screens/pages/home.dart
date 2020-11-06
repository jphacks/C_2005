import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/screens/pages/call.dart';
import 'package:ichimai/src/screens/pages/search.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:ichimai/src/services/connect.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final referenceDatase = FirebaseDatabase.instance;

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('Search'),
              onTap: () async {
                // * GPS 좌표 설정
                await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high)
                    .then((position) {
                  referenceDatase
                      .reference()
                      .child('Users')
                      .child(user.generateAgoraUid().toString())
                      .child('la')
                      .set(position.latitude);
                  referenceDatase
                      .reference()
                      .child('Users')
                      .child(user.generateAgoraUid().toString())
                      .child('lo')
                      .set(position.longitude);
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Search();
                }));
              },
            ),
            ListTile(
              title: Text('Connect'),
              onTap: () async {
                String channel = 'test3';
                await ConnectionService().getToken(user, channel).then((value) {
                  // print('channel "$channel"');
                  // print('a token is generated. ');
                  // print(value);
                  // print('uid: ${user.generateAgoraUid()}');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return CallPage(
                      token: value,
                      channel: channel,
                      uid: user.generateAgoraUid(),
                    );
                  }));
                });
              },
            ),
            ListTile(
                title: Text('Menu 3'),
                onTap: () async {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  print(position);
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () async {
          await _auth.signOut();
        },
      ),
    );
  }
}
