import 'package:flutter/material.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:ichimai/src/shared/loading.dart';
import 'package:ichimai/src/shared/theme.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({key, this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign up to Ichimai'),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) {
                      if (val != null) {
                        return val.isEmpty ? 'Enter an email' : null;
                      }
                    },
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                      // 패스워드
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) {
                        if (val != null) {
                          return val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null;
                        }
                      },
                      onChanged: (val) {
                        setState(() => password = val);
                      }),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      // 로그인 버튼
                      color: Colors.pink[400],
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        //
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'please supply a valid email';
                              loading = false;
                            });
                          }
                        }
                      }),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ]),
              ),
            ),
          );
  }
}
