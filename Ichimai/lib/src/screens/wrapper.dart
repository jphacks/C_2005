import 'package:flutter/material.dart';
import 'package:ichimai/src/screens/authenticate/register.dart';
import 'package:ichimai/src/screens/pages/menu.dart';

class Wrapper extends StatelessWidget {
  bool signIn = false;

  @override
  Widget build(BuildContext context) {
    return signIn ? Menu() : Register();
  }
}
