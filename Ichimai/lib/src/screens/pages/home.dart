import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ichimai/src/models/channel.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/screens/pages/call.dart';
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
    final user = Provider.of<UserData>(context);
    return SafeArea(
      child: Scaffold(
        body: ChannelList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          onPressed: () async {
            ConnectionService()
                .getToken(
                    user, user.name.replaceAll('@', '').replaceAll('.', ''))
                .then((value) {
              print(value);
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return Call(
                  token: value,
                  channel: user.name.replaceAll('@', '').replaceAll('.', ''),
                  uid: user.generateAgoraUid(),
                );
              }));
            });
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
  Position position;

  void updateList(DataSnapshot snapshot) {
    Channel newChannel =
        Channel(name: snapshot.key, token: snapshot.value['token']);

    setState(() {
      list.add(newChannel);
    });
  }

  void initiate() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
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

            list.add(Channel(
                name: key,
                token: smallData['token'],
                latitude: smallData['la'],
                longitude: smallData['lo']));
          });

          list.sort((a, b) => Geolocator.distanceBetween(a.latitude,
                  a.longitude, position.latitude, position.longitude)
              .compareTo(Geolocator.distanceBetween(b.latitude, b.longitude,
                  position.latitude, position.longitude)));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(list[index].name),
                subtitle: Text(Geolocator.distanceBetween(
                        list[index].latitude,
                        list[index].longitude,
                        position.latitude,
                        position.longitude)
                    .toString()),
                onTap: () {
                  ConnectionService()
                      .getToken(user,
                          user.name.replaceAll('@', '').replaceAll('.', ''))
                      .then((value) {
                    print(value);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Call(
                        token: list[index].token,
                        channel: list[index]
                            .name
                            .replaceAll('@', '')
                            .replaceAll('.', ''),
                        uid: user.generateAgoraUid(),
                      );
                    }));
                  });
                },
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
