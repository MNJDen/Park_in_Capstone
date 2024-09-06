import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

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
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          alignment: alignment,
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 15.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isCurrentUser)
              CircleAvatar(
                radius: 14.w,
              ),
              SizedBox(
                  width: isCurrentUser
                      ? 0
                      : 8.w), 
              Expanded(
                child: Column(
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (!isCurrentUser)
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color.fromARGB(255, 129, 129, 129),
                        ),
                      ),
                    SizedBox(height: 2.h),
                    Container(
                      margin: isCurrentUser
                          ? EdgeInsets.only(left: 50.w)
                          : EdgeInsets.only(right: 50.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? blueColor
                            : const Color.fromRGBO(240, 240, 240, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isCurrentUser ? whiteColor : blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}