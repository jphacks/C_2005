import 'package:flutter/material.dart';
import 'package:ichimai/src/services/auth.dart';
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
            MenuTile(
              title: 'Menu 1',
            ),
            MenuTile(
              title: 'Menu 2',
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
