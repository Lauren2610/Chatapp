import 'package:flutter/material.dart';
import 'package:mitch_chatapp/PAGES/home_page.dart';
import 'package:mitch_chatapp/PAGES/settings_page.dart';
import 'package:mitch_chatapp/auth/auth_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  logout() {
    final _auth = AuthService();
    setState(() {
      _auth.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Center(
                      child: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ))),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  title: Text(
                    "H O M E",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                  title: Text(
                    "S E T T I N G S",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              onTap: () {
                logout();
              },
              title: Text(
                "L O G O U T",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              leading: Icon(Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
