import 'package:flutter/material.dart';
import 'package:ichimai/src/models/user.dart';
import 'package:ichimai/src/screens/authenticate/register.dart';
import 'package:ichimai/src/screens/pages/menu.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (BuildContext context, AuthService service, Widget child) {
        if (service.user == null) {
          return Register();
        } else {
          return Menu();
        }
      },
    );
  }
}
