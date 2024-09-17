import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ChatBubble extends StatelessWidget {
  final String message;
  final String userName;
  final bool isCurrentUser;
  final String? profilePictureUrl;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.userName,
    required this.isCurrentUser,
    required this.profilePictureUrl,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    tz.initializeTimeZones();
    final location = tz.getLocation('Asia/Manila');

    final DateTime utcTime = timestamp.toUtc();
    final DateTime localTime = tz.TZDateTime.from(utcTime, location);

    final DateFormat dateFormat = DateFormat('MM/dd/yyyy');
    final DateFormat timeFormat = DateFormat('h:mm a');

    final String formattedDate = dateFormat.format(localTime);
    final String formattedTime = timeFormat.format(localTime);

    final String todayDate = dateFormat.format(DateTime.now());

    final String displayDate =
        formattedDate == todayDate ? 'Today' : formattedDate;

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Container(
            alignment: alignment,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isCurrentUser)
                  CircleAvatar(
                    radius: 14.w,
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl!)
                        : const AssetImage("assets/images/AdNU_Logo.png")
                            as ImageProvider,
                  ),
                SizedBox(width: isCurrentUser ? 0 : 8.w),
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
                            color: blackColor.withOpacity(0.8),
                          ),
                        ),
                      SizedBox(height: 2.h),
                      Container(
                        margin: isCurrentUser
                            ? EdgeInsets.only(left: 60.w)
                            : EdgeInsets.only(right: 60.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
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
        ),
        Padding(
          padding: isCurrentUser
              ? EdgeInsets.only(right: 10.w)
              : EdgeInsets.only(left: 46.w),
          child: Text(
            '$displayDate | $formattedTime',
            style: TextStyle(
              fontSize: 10.sp,
              color: blackColor.withOpacity(0.5),
            ),
          ),
        ),
        SizedBox(height: 4.h),
      ],
    );
  }
}
