import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mitch_chatapp/model/message_model.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List<Map<String, dynamic>> means
  // [
  // {
  // "email": "ajkjak@gmail.com"
  // "uid":21312313
  // }
  // ]
//send message
  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    //construct chat room id for two users
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    _firestore
        .collection("chat_rooms") // chat room akyee g create
        .doc(chatRoomId) //id tuu tae 2 kg ko sitt
        .collection("messages") // thu doh 2 kg messages create pyy
        .add(newMessage.tomap()); // add new message

    // new message to database
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()["email"] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });
  }

  //GET ALL USERS EXCEPT BLOCKED USERS
  Stream<List<Map<String, dynamic>>> getUsersStreamExceptBlcoked() {
    final currentUser = _auth.currentUser!;
    //get blocked user ids
    return _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .snapshots()
        .asyncMap((snapshot) async {
      //get blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
//get all Users
      final userSnapshot = await _firestore.collection("Users").get();
      //return as a stream list
      return userSnapshot.docs
          .where((doc) =>
              doc.data()["email"] != currentUser.email &&
              !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

//REPORT USER
  Future<void> reportUser(String reportedUserId, String messageId) async {
    final String currentUserId = _auth.currentUser!.uid;
    final report = {
      "reporterId": currentUserId,
      "messageId": messageId,
      "messageOwnerId": reportedUserId,
      "timestamp": FieldValue.serverTimestamp()
    };
    await _firestore.collection("Reports").add(report);
  }

//BLOCK USER
  Future<void> blockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(blockedUserId)
        .set({});
    notifyListeners();
  }

//UNBLOCK USER
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(blockedUserId)
        .delete();

    notifyListeners();
  }

//GET ALL BLOCKED USERS STREAM

  Stream<List<Map<String, dynamic>>> getAllBlockedUsersSream(String userId) {
    final currentUser = _auth.currentUser;
//get list of bloced user list
    return _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      final userDocs = await Future.wait(blockedUserIds
          .map((id) => _firestore.collection('Users').doc(id).get()));

      //return as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
