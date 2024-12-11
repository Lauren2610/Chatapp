import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mitch_chatapp/Components/my_drawer.dart';
import 'package:mitch_chatapp/PAGES/blocked_user_page.dart';
import 'package:mitch_chatapp/auth/auth_service.dart';
import 'package:mitch_chatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final String name = _auth.getCurrentUser()!.email.toString();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        title: Text("SETTINGS"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            child: Text(name.split("").first),
          ),
          Text(
            name,
            style: TextStyle(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Colors.black),
          ),
          SizedBox(
            height: 50,
          ),
          _buildDarkMode(context),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BlockedUserPage()));
              },
              child: _buildBlockedUserBox(context))
        ],
      ),
    );
  }

  Padding _buildBlockedUserBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.block),
              Text("Blocked Users"),
              Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildDarkMode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        padding: EdgeInsets.all(20),
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.dark_mode),
              Text("Dark Mode"),
              CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: true)
                      .isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
