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
  @override
  Widget build(BuildContext context) {
    // StreamProvider.value로 받은 value(User타입)를 사용
    final user = Provider.of<UserData>(context);

    // return either Home or Authenticate Widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
