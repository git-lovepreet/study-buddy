import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isSent;
  final Map<String, String> message;

  const ChatBubble({super.key, required this.message, required this.isSent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      decoration: BoxDecoration(
        color: isSent ? Colors.grey.shade100 : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(16).copyWith(
          bottomLeft: isSent ? Radius.circular(16) : Radius.circular(0),
          bottomRight: isSent ? Radius.circular(0) : Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message["message"] ?? '', // Safely access the 'message' key
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            message["time"] ?? '', // Safely access the 'time' key
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
