import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/Chat_Bubble.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/models/Message.dart';
import 'package:park_in/services/auth/Auth_Service.dart';
import 'package:park_in/services/chat/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Color _sendButtonColor = blackColor;

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  //cheking the who the current user is, and assigning uid to current user
  // Future<void> _initializeUser() async {
  //   final user = await _authService.getCurrentUser();
  //   if (user != null) {
  //     setState(() {
  //       currentUserID = user.uid;
  //     });
  //   } else {
  //     setState(() {
  //       currentUserID = 'unknown';
  //     });
  //   }
  // }

  Future<void> _getUserId() async {
    // Get the current user from Firebase Auth
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // if may value ang currentUser ibig sabihon admin ang nakalog in
      setState(() {
        currentUserID = currentUser.uid; // Store the uid ng admin
      });

      _fetchUserData(); // Fetch user's data from 'User' collection
    } else if (currentUser == null) {
      //if nag null siya ibig sabihon bakong admin ang nakalog in
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        currentUserID = prefs.getString('userId'); // Store uid ng employee
      });
    } else {
      print("No user found");
    }
  }

  Future<void> _fetchUserData() async {
    if (currentUserID != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('User')
            .doc(
                currentUserID) // Use currentUserID to fetch data from 'User' collection
            .get();

        if (userDoc.exists) {
          print('User data: ${userDoc.data()}');
          // Process the userDoc data if needed
        } else {
          print('User not found');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  // sending message logic, ito ang tig ssave sa firebase, tig papasa niya lang ang value kani sa "sendMessage" function sa chat_service.dart which saves the values to Firebase
  void sendMessage(String content) async {
    if (content.trim().isEmpty || currentUserID == null) return;

    // Fetch the user's name from Firestore
    String? name;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUserID)
          .get();
      if (userDoc.exists) {
        name = userDoc.get(
            'name'); // Assuming 'name' is the field storing the user's name
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return;
    }

    final userType = await _chatService
        .getUserType(currentUserID!); // Get the userType of the currentUser

    final message = Message(
      senderID: currentUserID!,
      name: name ?? 'Admin', // unknown ang name if not found
      message: content,
      timestamp: Timestamp.now(),
      userType: userType,
    );

    await _chatService.sendMessage(message); // Save the message to Firestore
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // header
            SizedBox(
              height: 8.h,
            ),
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Stack(
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
                    "Chat Room",
                    style: TextStyle(
                      fontSize: 20.r,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // header

            // body, the convo, tig rretrieve niya si messages from firebase
            Expanded(
              child: Container(
                color: whiteColor,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatService
                      .getGroupMessagesStream(), //using this function in chat_service.dart tig rretrive niya si messages
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
                      reverse: true,
                      children: messageWidgets.reversed.toList(),
                    );
                  },
                ),
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
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: blackColor,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: whiteColor,
                        hintText: "Type your message here...",
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: const Color.fromARGB(90, 27, 27, 27),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.w,
                            color: blueColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 0.5.w,
                            color: borderBlack,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        setState(
                          () {
                            if (text.trim().isEmpty) {
                              _sendButtonColor = blackColor;
                            } else {
                              _sendButtonColor = blueColor;
                            }
                          },
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: _sendButtonColor,
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
