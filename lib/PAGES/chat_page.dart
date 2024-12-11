import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mitch_chatapp/Components/mytextfeild.dart';
import 'package:mitch_chatapp/auth/auth_service.dart';
import 'package:mitch_chatapp/auth/chat_service.dart';
import 'package:mitch_chatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void sendMessage(String message, String receiverId) async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverId, message);
    }
    _messageController.clear();
  }

  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
  }

  ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        title: Text(
          widget.receiverEmail,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildUserInput(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    void _reportDialog(BuildContext context, String messageld, String userId) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Report User"),
                content: Text("Are you sure you want to report this user?"),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                      child: Text("Report"),
                      onPressed: () {
                        ChatService().reportUser(userId, messageld);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Message Reported")));
                      })
                ],
              ));
    }

    void _blockDialog(BuildContext context, String userId) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Block User"),
                content: Text("Are you sure you want to block this user?"),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                      child: Text("Block"),
                      onPressed: () {
                        ChatService().blockUser(userId);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Blocked User")));
                      })
                ],
              ));
    }

    void showOptions(BuildContext context, String messageId, String userId) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SafeArea(
                child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _reportDialog(context, messageId, userId);
                  },
                  leading: Icon(Icons.flag),
                  title: Text("Report"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _blockDialog(context, userId);
                  },
                  leading: Icon(Icons.block),
                  title: Text("Block"),
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: Icon(Icons.cancel_outlined),
                  title: Text("Cancel"),
                ),
              ],
            ));
          });
    }

    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool? isSender = data['senderId'] == _authService.getCurrentUser()!.uid;
    return GestureDetector(
      onLongPress: () {
        showOptions(context, doc.id, data['senderId']);
      },
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            color: isSender
                ? (isDarkMode
                    ? Colors.deepPurple.shade300
                    : Colors.grey.shade500)
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            data["message"],
            style: TextStyle(
                color: isSender
                    ? Colors.white
                    : (isDarkMode ? Colors.white : Colors.black)),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String _senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(_senderId, widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error, please try refreshing the app."));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages yet."));
        }

        // Display list of messages
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) {
            return _buildMessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
            child: Mytextfeild(
          focusNode: myFocusNode,
          hintText: "Type a message",
          isObsecure: false,
          textEditingController: _messageController,
        )),
        Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.deepPurple.shade300),
          child: IconButton(
              onPressed: () {
                sendMessage(_messageController.text, widget.receiverId);
              },
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: Theme.of(context).colorScheme.background,
              )),
        )
      ],
    );
  }
}
