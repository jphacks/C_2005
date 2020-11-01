import 'package:flutter/material.dart';
import 'package:ichimai/src/models/user.dart';

class AuthService extends ChangeNotifier {
  String _uid;
  String _name = '';

  User get user {
    if (_uid == null) {
      return null;
    } else {
      return User(uid: _uid, name: _name);
    }
  }

  void signIn(String uid, String name) {
    _uid = uid;
    _name = name;
    print('signed in');
    notifyListeners();
  }

  void signOut() {
    _uid = null;
    _name = '';
    print('signed out');
    notifyListeners();
  }
}
