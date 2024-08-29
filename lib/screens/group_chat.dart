import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/Chat_Bubble.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/models/Message.dart';
import 'package:park_in/services/auth/Auth_Service.dart';
import 'package:park_in/services/chat/chat_service.dart';


// ito tig ccall ito kang home_employee1.dart saka home_admin.dart
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  String? currentUserID;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  // cheking the who the current user is, and assigning uid to current user
  Future<void> _initializeUser() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        currentUserID = user.uid;
      });
    } else {
      setState(() {
        currentUserID = 'unknown';
      });
    }
  }

  // sending message logic, ito ang tig ssave sa firebase, tig papasa niya lang ang value kani sa "sendMessage" function sa chat_service.dart which saves the values to Firebase
  void sendMessage(String content) async {
    if (content.trim().isEmpty || currentUserID == null) return;

    final userType = await _chatService.getUserType(currentUserID!); //pag check niya kang userType of currentUser

    // ito ang tig ssave sa firebase
    final message = Message(
      senderID: currentUserID!,
      name: 'Your Name',
      message: content,
      timestamp: Timestamp.now(),
      userType: userType,
    );

    await _chatService.sendMessage(message); // pag pass niya nang values to chat_service.dart to save sa firebase
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // header
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                      NavbarNotifier.hideBottomNavBar = false;
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: blackColor,
                    ),
                  ),
                ),
                Text(
                  "Chat",
                  style: TextStyle(
                    fontSize: 20.r,
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // header

            // body, the convo, tig rretrieve niya si messages from firebase 
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatService.getGroupMessagesStream(), //using this function in chat_service.dart tig rretrive niya si messages
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!.docs;
                  List<Widget> messageWidgets = messages.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final messageText = data['message'] as String;
                    final messageSender = data['name'] as String;
                    final isCurrentUser = currentUserID == data['senderID'];

                    // si values tig papasa niya ki ChatBubble (Chat_Bubble.dart). basically si Chat_Bubble sa UI man lang siya 
                    return ChatBubble(
                      message: messageText,
                      userName: messageSender,
                      isCurrentUser: isCurrentUser,
                    );
                  }).toList();

                  return ListView(
                    children: messageWidgets,
                  );
                },
              ),
            ),

            // text field 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration:
                          InputDecoration(hintText: 'Enter your message...'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
            // text field
          ],
        ),
      ),
    );
  }
}
