import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/screens/authenticate/register_test.dart';
import 'package:ichimai/src/screens/authenticate/sign_in_test.dart';
import 'package:ichimai/src/screens/pages/home.dart';
import 'package:ichimai/src/screens/wrapper.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Fail to connect firebase');
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserData>.value(
            // User타입 value를 listen하는 StreamProvider
            value: AuthService().user,
            child: MaterialApp(
              home: Wrapper(),
              routes: {
                '/signup':(context)=>ChatterSignUp(),
                '/login':(context)=>ChatterLogin(),
                '/home':(context)=>Home(),
              },
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}
