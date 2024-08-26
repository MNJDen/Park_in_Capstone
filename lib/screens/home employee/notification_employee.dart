import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/notification_announcement_card.dart';
import 'package:park_in/components/notification_parking_violation_card.dart';

class NotificationEmployeeScreen extends StatefulWidget {
  final String userType;
  const NotificationEmployeeScreen({super.key, required this.userType});

  @override
  State<NotificationEmployeeScreen> createState() =>
      _NotificationStudeEmployeenState();
}

class _NotificationStudeEmployeenState
    extends State<NotificationEmployeeScreen> {
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
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Announcement')
                    .snapshots(), // Listen to real-time updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching announcements'));
                  } else if (snapshot.hasData) {
                    final announcements = snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .where((announcement) {
                      String announcementUserType = announcement['userType'];
                      return announcementUserType == widget.userType ||
                          announcementUserType == 'Everyone';
                    }).toList();

                    if (announcements.isEmpty) {
                      return Center(child: Text('No announcements available'));
                    } else {
                      return Column(
                        children: announcements.map((announcement) {
                          return Column(
                            children: [
                              PRKAnnouncementNotificationCard(
                                title: announcement['title'],
                                date: announcement['createdAt']
                                    .toDate()
                                    .toString()
                                    .split(' ')[0],
                                description: announcement['details'],
                              ),
                              SizedBox(height: 12.h),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  } else {
                    return Center(child: Text('No announcements available'));
                  }
                },
              ),
              SizedBox(
                height: 100.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
