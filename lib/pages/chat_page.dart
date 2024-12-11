import 'package:f_study_buddy/components/chat_bubble.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {

  final String recieverEmail;
  final String recieverID;
  ChatPage({super.key,required this.recieverEmail,required this.recieverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController=TextEditingController();

  final ChatService _chatService= ChatService();

  final AuthService _authService= AuthService();

  FocusNode myFocusNode=FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        //cause the delay so that keyboard has time toshow up
        //then the amount of remaining space will be calculated
        //then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
              ()=> scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
          ()=> scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }


  final ScrollController _scrollController= ScrollController();
  void scrollDown(){
    if(_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn);
    }
  }





  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.recieverID, _messageController.text);

      _messageController.clear();

      scrollDown();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("@jenny",
              style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
              fontSize: 18),),
        centerTitle: true,
          actions: [
            IconButton(
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.keyboard_option_key,
                    size: 18,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ],

        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: ChatBody(),
    );
  }
}

class ChatBody extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {"message": "Hey! How's your day going?", "time": "11:40 AM", "isSent": "false"},
    {"message": "Hi! It's going well, thanks. How about yours?", "time": "11:40 AM", "isSent": "true"},
    {"message": "Pretty good, just finished a workout. 💪 Do you like working out?", "time": "11:40 AM", "isSent": "false"},
    {"message": "Yes, I love it! I usually go for a run in the mornings. 🏃‍♀️", "time": "11:40 AM", "isSent": "true"},
    {"message": "That's awesome! I prefer the gym, but running sounds great too. 🏋️‍♂️", "time": "11:40 AM", "isSent": "false"},
    {"message": "Maybe we can go for a run together sometime? 😊", "time": "11:40 AM", "isSent": "true"},
    {"message": "I'd like that! Do you have any favorite routes? 🏞️", "time": "11:40 AM", "isSent": "false"},
    {"message": "Yes, there's a beautiful trail by the lake. It's so peaceful there. 🏞️", "time": "11:40 AM", "isSent": "true"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true, // Messages appear from the bottom
            padding: EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[messages.length - 1 - index];
              final isSent = message["isSent"] == "true";
              return Align(
                alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                child: ChatBubble(message: message,isSent: isSent,),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
