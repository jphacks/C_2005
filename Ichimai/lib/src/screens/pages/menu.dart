import 'package:flutter/material.dart';
import 'package:ichimai/src/screens/pages/call.dart';
import 'package:ichimai/src/services/auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var service = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthService>(builder: (context, service, child) {
          return Text('Menu - ' + service.user.name);
        }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('Generate Token'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Generate token'),
                    ),
                    body: Container(),
                  );
                }));
              },
            ),
            ListTile(
              title: Text('Connect'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return CallPage();
                }));
              },
            ),
            MenuTile(
              title: 'Menu 3',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () {
          service.signOut();
        },
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final String title;

  const MenuTile({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {},
    );
  }
}
