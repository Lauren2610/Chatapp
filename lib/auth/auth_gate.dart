import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mitch_chatapp/PAGES/home_page.dart';
import 'package:mitch_chatapp/PAGES/logister_parent.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //Userloggedin
              if (snapshot.hasData) {
                return HomePage();
              }
              //User havent log in
              else {
                return LogisterParent();
              }
            }));
  }
}
