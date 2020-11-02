import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ichimai/src/screens/pages/call.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Future<String> getToken() async {
    final response = await http.get(
        'http://oram.kr/jphacks/getToken/RtcTokenBuilderSample.php?channelName=asdf&uid=-1744234330');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu - ')),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('Generate Token'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Generate token'),
                    ),
                    body: Container(),
                  );
                }));
              },
            ),
            ListTile(
              title: Text('Connect'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return CallPage();
                }));
              },
            ),
            ListTile(
                title: Text('Menu 3'),
                onTap: () async {
                  await getToken().then((value) => print(value));
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