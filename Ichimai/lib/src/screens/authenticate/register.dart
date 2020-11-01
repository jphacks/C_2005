import 'package:flutter/material.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:ichimai/src/shared/theme.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  @override
  Widget build(BuildContext context) {
    var service = Provider.of<AuthService>(context);

    var sizedbox = SizedBox(height: 20.0);

    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SafeArea(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  sizedbox,
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Name'),
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),
                  ),
                  sizedbox,
                  RaisedButton(
                    child: Text('Sign In'),
                    onPressed: () {
                      if (/*_formKey.currentState.validate()*/ true) {
                        service.signIn('1234', name);
                      }
                    },
                  )
                ],
              ))),
    );
  }
}
