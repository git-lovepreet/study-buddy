import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter for current user ID
  String get currentUserID => _auth.currentUser?.uid ?? '';

  // Getter for current user email
  String get currentUserEmail => _auth.currentUser?.email ?? '';

  // Stream to fetch all users
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Send message
  Future<void> sendMessage(String receiverID, String message) async {
    if (receiverID.isEmpty || message.isEmpty) {
      throw Exception('Receiver ID or message cannot be empty.');
    }

    try {
      final String senderID = currentUserID;
      final String senderEmail = currentUserEmail;
      final Timestamp timestamp = Timestamp.now();

      // Create a new message
      Message newMessage = Message(
        senderID: senderID,
        senderEmail: senderEmail,
        recieverID: receiverID,
        message: message,
        timestamp: timestamp,
      );

      // Construct chatroom ID for two users
      List<String> ids = [senderID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      // Add message to the database
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Update typing status
  Future<void> updateTypingStatus(String chatRoomID, bool isTyping) async {
    try {
      await _firestore.collection("chat_rooms").doc(chatRoomID).update({
        "typing_${currentUserID}": isTyping,
      });
    } catch (e) {
      throw Exception('Failed to update typing status: $e');
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatRoomID) async {
    try {
      final unreadMessages = await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .where("recieverID", isEqualTo: currentUserID)
          .where("read", isEqualTo: false)
          .get();

      for (var doc in unreadMessages.docs) {
        await doc.reference.update({"read": true});
      }
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }
}
