import 'dart:collection';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ichimai/src/models/channel.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/services/connect.dart';
import 'package:ichimai/src/shared/loading.dart';
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
          onPressed: () async {
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            print(position.toString());
          },
        ),
      ),
    );
  }
}

class ChannelList extends StatefulWidget {
  const ChannelList({Key key}) : super(key: key);
  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  DatabaseReference mDatabase = FirebaseDatabase().reference();
  List<Channel> list = [];

  void updateList(DataSnapshot snapshot) {
    Channel newChannel =
        Channel(name: snapshot.key, token: snapshot.value['token']);

    setState(() {
      list.add(newChannel);
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance
        .reference()
        .child('Channels')
        .onChildChanged
        .listen((event) {
      setState(() {
        print('list updated');
      });
      // updateList(event.snapshot);
    });
    return FutureBuilder(
      future: FirebaseDatabase.instance.reference().child('Channels').once(),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return null;
          }
          // updateList(snapshot.data);
          list = [];
          Map<String, dynamic> data = Map.from(snapshot.data.value);
          data.forEach((key, value) {
            Map<String, dynamic> smallData = Map.from(value);

            list.add(Channel(name: key, token: smallData['token']));
          });
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(list[index].name),
                subtitle: Text(list[index].token),
              );
            },
          );
        } else {
          return Loading();
        }
      },
    );
    // var subscription = FirebaseDatabase.instance
    //     .reference()
    //     .child('Channels')
    //     .onChildAdded
    //     .listen((event) {
    //   list.add(ConnectionService().getChannelsFromDatasnapshot(event.snapshot));
    // });
    // FirebaseDatabase.instance
    //     .reference()
    //     .child('Channels')
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   // Map<String, dynamic> channels = jsonDecode(snapshot.value.toString());
    //   // print(channels);
    //   Map<String, dynamic> data = Map.from(snapshot.value);
    //   data.forEach((key, value) {
    //     Map<String, dynamic> smallData = Map.from(value);

    //     list.add(Channel(name: key, token: smallData['token']));
    //   });
    // });
    // // list = [Channel(name: 'sample1', token: 'asdfaesadf')];
    // return ListView.builder(
    //   itemCount: list.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text(list[index].name),
    //       subtitle: Text(list[index].token),
    //     );
    //   },
    // );
  }
}
