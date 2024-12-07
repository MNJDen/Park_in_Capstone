import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/chat/Chat_Bubble.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/models/Message.dart';
import 'package:park_in/services/auth/Auth_Service.dart';
import 'package:park_in/services/chat/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  String? _profilePictureUrl;

  Map<String, String?> _profilePictureCache = {};

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _getUserId();
  }

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
          // para kuhaon si profile picture
          String? profilePictureUrl = userDoc.get('profilePicture') ?? null;
          setState(() {
            _profilePictureUrl = profilePictureUrl;
          });
        } else {
          print('User not found');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  //fetch si profile picture kang kada sender
  Future<void> _preloadProfilePictures(
      List<QueryDocumentSnapshot> messages) async {
    for (var message in messages) {
      final data = message.data() as Map<String, dynamic>;
      final senderID = data['senderID'] as String;

      if (!_profilePictureCache.containsKey(senderID)) {
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('User')
              .doc(senderID)
              .get();

          if (userDoc.exists) {
            String? profilePictureUrl = userDoc.get('profilePicture');
            setState(() {
              _profilePictureCache[senderID] = profilePictureUrl;
            });
          }
        } catch (e) {
          print('Error fetching profile picture: $e');
        }
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          NavbarNotifier.hideBottomNavBar = false;
          return;
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // header
              SizedBox(
                height: 8.h,
              ),
              Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // header

              // body, the convo, tig rretrieve niya si messages from firebase
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border(
                      top: BorderSide(width: 0.1.w, color: borderBlack),
                      // bottom: BorderSide(width: 0.1.w, color: borderBlack),
                    ),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _chatService.getGroupMessagesStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: LoadingAnimationWidget.waveDots(
                            color: blueColor,
                            size: 50.r,
                          ),
                        );
                      }
                      final messages = snapshot.data!.docs;

                      //fetch si profile picture
                      _preloadProfilePictures(messages);

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final data = messages[messages.length - 1 - index]
                              .data() as Map<String, dynamic>;
                          final messageText = data['message'] as String;
                          final messageSender = data['name'] as String;
                          final senderID = data['senderID'] as String;
                          final isCurrentUser = currentUserID == senderID;

                          final Timestamp timestamp =
                              data['timestamp'] as Timestamp;
                          final DateTime utcTime = timestamp.toDate().toUtc();

                          final DateTime localTime = tz.TZDateTime.from(
                              utcTime, tz.getLocation('Asia/Manila'));

                          // Fetch cached profile picture URL
                          final profilePictureUrl =
                              _profilePictureCache[senderID];

                          return ChatBubble(
                            message: messageText,
                            userName: messageSender,
                            isCurrentUser: isCurrentUser,
                            profilePictureUrl: profilePictureUrl,
                            timestamp: localTime,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // text field
              Container(
                color: whiteColor,
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 20.h),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                        ),
                        minLines: 1,
                        maxLines: 3,
                        // autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
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
                              width: 0.1.w,
                              color: borderBlack,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send_rounded),
                            color: _sendButtonColor,
                            onPressed: () => sendMessage(_controller.text),
                            iconSize: 20.r,
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
                  ],
                ),
              ),
              // text field
            ],
          ),
        ),
      ),
    );
  }
}
