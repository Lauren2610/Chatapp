import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mitch_chatapp/Components/my_drawer.dart';
import 'package:mitch_chatapp/Components/user_tile.dart';
import 'package:mitch_chatapp/PAGES/chat_page.dart';
import 'package:mitch_chatapp/auth/auth_service.dart';
import 'package:mitch_chatapp/auth/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  ChatService _chatService = ChatService();
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          title: Text(
            "HOME",
          ),
        ),
        drawer: MyDrawer(),
        body: buildStreamBuilder());
  }

  Widget buildStreamBuilder() {
    return StreamBuilder(
        stream: _chatService.getUsersStreamExceptBlcoked(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting");
            return Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }

          return ListView(
              children: snapshot.data!
                  .map<Widget>(
                      (userData) => buildUserListItem(userData, context))
                  .toList());
        });
  }

  Widget buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        name: userData["email"].toString(),
        ontap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverEmail: userData["email"],
                        receiverId: userData["uid"],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}
