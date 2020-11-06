<<<<<<< Updated upstream
=======
import 'dart:collection';
import 'dart:convert';

>>>>>>> Stashed changes
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ichimai/src/models/channel.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/services/connect.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChannelList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          onPressed: () {},
        ),
      ),
    );
  }
}

class ChannelList extends StatefulWidget {
  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  List<Channel> list = [];
  DatabaseReference mDatabase = FirebaseDatabase().reference();

  @override
  Widget build(BuildContext context) {
    // var subscription = FirebaseDatabase.instance
    //     .reference()
    //     .child('Channels')
    //     .onChildAdded
    //     .listen((event) {
    //   list.add(ConnectionService().getChannelsFromDatasnapshot(event.snapshot));
    // });
    FirebaseDatabase.instance
        .reference()
        .child('Channels')
        .once()
        .then((DataSnapshot snapshot) {
      // Map<String, dynamic> channels = jsonDecode(snapshot.value.toString());
      // print(channels);
      Map<String, dynamic> data = Map.from(snapshot.value);
      data.forEach((key, value) {
        Map<String, dynamic> smallData = Map.from(value);

        list.add(Channel(name: key, token: smallData['token']));
      });
    });
    // list = [Channel(name: 'sample1', token: 'asdfaesadf')];
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index].name),
          subtitle: Text(list[index].token),
        );
      },
    );
  }
}
