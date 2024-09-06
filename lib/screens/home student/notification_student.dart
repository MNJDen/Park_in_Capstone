import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/notification_announcement_card.dart';
import 'package:park_in/components/ui/notification_parking_violation_card.dart';

class NotificationStudentScreen extends StatefulWidget {
  final String userId; // Current logged-in user's ID
  final String userType; // Current logged-in user's type

  const NotificationStudentScreen({
    Key? key,
    required this.userType,
    required this.userId,
  }) : super(key: key);

  @override
  State<NotificationStudentScreen> createState() =>
      _NotificationStudentScreenState();
}

class _NotificationStudentScreenState extends State<NotificationStudentScreen> {
  List<String>? _plateNumbers; // Holds the current user's plate number

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch the user's data when the screen initializes
  }

  // Function to fetch the user's data
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.userId) // Get the document with the current user's ID
          .get();

      final plateNoField = userDoc['plateNo']; // This might be a List or String

      setState(() {
        if (plateNoField is List) {
          _plateNumbers =
              plateNoField.map((plate) => plate.toString()).toList();
        } else {
          _plateNumbers =
              plateNoField != null ? [plateNoField.toString()] : null;
        }
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: _plateNumbers == null
            ? Center(
                child: Text(
                  "Loading",
                  style: TextStyle(
                    fontSize: 12.r,
                    color: const Color.fromARGB(129, 27, 27, 10),
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
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
                              Navigator.pop(context);
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
                    SizedBox(height: 32.h),
                    // Fetch and display tickets that match the user's plate number
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Violation Ticket')
                          .where('plate_number', whereIn: _plateNumbers)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error fetching tickets'));
                        } else if (snapshot.hasData) {
                          final tickets = snapshot.data!.docs.map((doc) {
                            return doc.data() as Map<String, dynamic>;
                          }).toList();

                          if (tickets.isEmpty) {
                            return Center(
                                child: Text('No violation tickets found'));
                          } else {
                            return Column(
                              children: tickets.map((ticket) {
                                return Column(
                                  children: [
                                    PRKParkingViolationNotificationCard(
                                      date: (ticket['timestamp'] as Timestamp)
                                          .toDate()
                                          .toString()
                                          .split(' ')[0],
                                    ),
                                    SizedBox(height: 12.h),
                                  ],
                                );
                              }).toList(),
                            );
                          }
                        } else {
                          return Center(
                              child: Text('No violation tickets found'));
                        }
                      },
                    ),

                    // SizedBox(height: 12.h),
                    // Fetch and display announcements
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Announcement')
                          .snapshots(), // Listen to real-time updates
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error fetching announcements'));
                        } else if (snapshot.hasData) {
                          final announcements = snapshot.data!.docs
                              .map((doc) => doc.data() as Map<String, dynamic>)
                              .where((announcement) {
                            String announcementUserType =
                                announcement['userType'];
                            return announcementUserType == widget.userType ||
                                announcementUserType == 'Everyone';
                          }).toList();

                          if (announcements.isEmpty) {
                            return Center(
                                child: Text('No announcements available'));
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
                          return Center(
                              child: Text('No announcements available'));
                        }
                      },
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
