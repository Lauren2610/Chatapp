import 'package:flutter/material.dart';
import 'package:mitch_chatapp/Components/user_tile.dart';
import 'package:mitch_chatapp/auth/auth_service.dart';
import 'package:mitch_chatapp/auth/chat_service.dart';

class BlockedUserPage extends StatefulWidget {
  BlockedUserPage({Key? key}) : super(key: key);

  @override
  State<BlockedUserPage> createState() => _BlockedUserPageState();
}

class _BlockedUserPageState extends State<BlockedUserPage> {
  final ChatService chatService = ChatService();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showUnblockBox(BuildContext context, String userId) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Unblock User"),
              content: Text("You sure you wanna unlock this user?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      chatService.unblockUser(userId);

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User Unblocked!")));
                    },
                    child: Text("Unblock")),
              ],
            );
          });
    }

    String userId = authService.getCurrentUser()!.uid;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          title: Text("Blocked Users"),
        ),
        body: StreamBuilder(
            stream: chatService.getAllBlockedUsersSream(userId),
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
              final blockedUsers = snapshot.data ?? [];
              if (blockedUsers.isEmpty) {
                return Center(
                  child: Text(
                    "There is no blocked user.",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: blockedUsers.length,
                  itemBuilder: (context, index) {
                    final user = blockedUsers[index];
                    return UserTile(
                        name: user["email"],
                        ontap: () {
                          _showUnblockBox(context, user['uid']);
                        });
                  });
            }));
  }
}
