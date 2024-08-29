import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

// para sa UI lang ni
class ChatBubble extends StatelessWidget {
  final String message;
  final String userName;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.userName,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isCurrentUser
          ? EdgeInsets.only(left: 50.w)
          : EdgeInsets.only(right: 15.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 8.h),
        margin: EdgeInsets.symmetric(horizontal: 15.h, vertical: 1.h),
        decoration: BoxDecoration(
          color:
              isCurrentUser ? blueColor : Color.fromRGBO(59, 59, 59, 0.298),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}
