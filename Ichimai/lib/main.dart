import 'package:flutter/material.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/screens/wrapper.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imaichi no Ichimai',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (BuildContext context) => AuthService(),
        child: Wrapper(),
      ),
    );
  }
}
