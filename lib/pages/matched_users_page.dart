import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth/auth_service.dart';
import 'chat_page.dart'; // Replace with your actual ChatPage import

class MatchedUsersPage extends StatefulWidget {
  const MatchedUsersPage({Key? key}) : super(key: key);

  @override
  State<MatchedUsersPage> createState() => _MatchedUsersPageState();
}

class _MatchedUsersPageState extends State<MatchedUsersPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    String? currentUserId = _authService.getUId();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Buddies",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body:Center(
        child: Text(
          "No matched users found.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )

      // StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance.collection('Users').snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return const Center(
      //         child: Text(
      //           "No matched users found.",
      //           style: TextStyle(fontSize: 16, color: Colors.grey),
      //         ),
      //       );
      //     }
      //
      //     // Filter matched users (excluding the current user)
      //     List<QueryDocumentSnapshot> matchedUsers = snapshot.data!.docs
      //         .where((doc) => doc.id != currentUserId)
      //         .toList();
      //
      //     return ListView.builder(
      //       itemCount: matchedUsers.length,
      //       itemBuilder: (context, index) {
      //         Map<String, dynamic> user =
      //         matchedUsers[index].data() as Map<String, dynamic>;
      //
      //         return Card(
      //           margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //           elevation: 3,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: ListTile(
      //             leading: CircleAvatar(
      //               radius: 25,
      //               backgroundImage: user['avatar'] != null &&
      //                   user['avatar'].isNotEmpty
      //                   ? NetworkImage(user['avatar'])
      //                   : null,
      //               child: user['avatar'] == null || user['avatar'].isEmpty
      //                   ? const Icon(Icons.person, size: 30)
      //                   : null,
      //             ),
      //             title: Text(
      //               user['name'] ?? 'Unnamed User',
      //               style: TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 color: Theme.of(context).colorScheme.onBackground,
      //               ),
      //             ),
      //             subtitle: Text(
      //               user['email'] ?? 'No email provided',
      //               style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      //             ),
      //             onTap: () => _navigateToChatPage(
      //               context,
      //               matchedUsers[index].id,
      //               user['email'] ?? 'Unknown User',
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }

  void _navigateToChatPage(BuildContext context, String receiverID, String receiverEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          recieverEmail: 'test006@gmail.com', recieverID: 'HzJbTMcBB5WDQubkGfwdg4InL8b2',
        ),
      ),
    );
  }
}
