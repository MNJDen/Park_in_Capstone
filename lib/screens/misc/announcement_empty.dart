import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class AnnouncementEmpty extends StatelessWidget {
  const AnnouncementEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/announcement_image.png",
            height: 130.h,
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            "No announcements yet",
            softWrap: true,
            style: TextStyle(
              color: blackColor,
              fontSize: 16.r,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            "Don’t worry, announcements posted will be displayed here. :)",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: blackColor,
              fontSize: 12.r,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
