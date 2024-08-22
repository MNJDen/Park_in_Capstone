import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/notification_announcement_card.dart';
import 'package:park_in/components/notification_parking_violation_card.dart';

class NotificationStudentScreen extends StatefulWidget {
  const NotificationStudentScreen({super.key});

  @override
  State<NotificationStudentScreen> createState() =>
      _NotificationStudentScreenState();
}

class _NotificationStudentScreenState extends State<NotificationStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: blackColor,
                        size: 30.r,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: blackColor,
                      ),
                    ),
                  ),
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 20.r,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              PRKParkingViolationNotificationCard(date: "06/27/24"),
              SizedBox(
                height: 12.h,
              ),
              PRKParkingViolationNotificationCard(date: "06/26/24"),
              SizedBox(
                height: 12.h,
              ),
              PRKAnnouncementNotificationCard(
                title: "Limitation on Parking",
                date: "06/22/24",
                description:
                    "No parking on Alingal A, Alingal B, and Covered Court due to graduation rites.",
              ),
              SizedBox(
                height: 12.h,
              ),
              PRKAnnouncementNotificationCard(
                title: "Sticker Renewal",
                date: "06/22/24",
                description:
                    "After this intersession, gate pass stickers should be renewed.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
