import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/notification_announcement_card.dart';
import 'package:park_in/components/ui/notification_parking_violation_card.dart';
import 'package:park_in/screens/misc/announcement_empty.dart';
import 'package:park_in/screens/misc/violations_empty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationEmployeeScreen extends StatefulWidget {
  final String userType;
  final String userId;

  const NotificationEmployeeScreen({
    Key? key,
    required this.userType,
    required this.userId,
  }) : super(key: key);

  @override
  State<NotificationEmployeeScreen> createState() =>
      _NotificationStudeEmployeenState();
}

class _NotificationStudeEmployeenState
    extends State<NotificationEmployeeScreen> {
  List<String>? _plateNumbers; // Holds the current user's plate number
  String? userId;

  @override
  void initState() {
    super.initState();
    _getUserId(); // Fetch the user's data when the screen initializes
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });

    if (userId != null) {
      _fetchUserData(); // Fetch user's data once we have the userId
    } else {
      print('No userId found in SharedPreferences');
    }
  }

  // Function to fetch the user's data
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.userId) // Get the document with the current user's ID
          .get();

      final plateNoField = userDoc['plateNo'];

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
          child: _plateNumbers == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.waveDots(
                        color: blueColor,
                        size: 50.r,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "Getting everything ready, wait a moment...",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor.withOpacity(0.8),
                        ),
                      )
                    ],
                  ),
                )
              : DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: GestureDetector(
                            //     onTap: () {},
                            //     child: Icon(
                            //       Icons.delete_outline_rounded,
                            //       color: blackColor,
                            //       size: 26.r,
                            //     ),
                            //   ),
                            // ),
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
                              "Notifications",
                              style: TextStyle(
                                fontSize: 20.r,
                                color: blueColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        splashBorderRadius: BorderRadius.circular(10),
                        enableFeedback: true,
                        labelColor: blueColor,
                        unselectedLabelColor: blackColor,
                        tabs: const [
                          Tab(text: 'Violations'),
                          Tab(text: 'Announcements'),
                        ],
                      ),
                      Flexible(
                        child: TabBarView(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Violation Ticket')
                                  .where('plate_number', whereIn: _plateNumbers)
                                  .where('status', isEqualTo: 'Pending')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: LoadingAnimationWidget.waveDots(
                                      color: blueColor,
                                      size: 50.r,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Error fetching tickets'));
                                } else if (snapshot.hasData) {
                                  final tickets =
                                      snapshot.data!.docs.map((doc) {
                                    return doc.data() as Map<String, dynamic>;
                                  }).toList();

                                  if (tickets.isEmpty) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 80.h),
                                      child: const ViolationsEmpty(),
                                    );
                                  } else {
                                    return ListView.builder(
                                      itemCount: tickets.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 6.h),
                                              PRKParkingViolationNotificationCard(
                                                date: (tickets[index]
                                                            ['timestamp']
                                                        as Timestamp)
                                                    .toDate()
                                                    .toString()
                                                    .split(' ')[0],
                                              ),
                                              SizedBox(height: 6.h),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 80.h),
                                    child: const ViolationsEmpty(),
                                  );
                                }
                              },
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Announcement')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: LoadingAnimationWidget.waveDots(
                                      color: blueColor,
                                      size: 50.r,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child:
                                          Text('Error fetching announcements'));
                                } else if (snapshot.hasData) {
                                  final announcements = snapshot.data!.docs
                                      .map((doc) =>
                                          doc.data() as Map<String, dynamic>)
                                      .where((announcement) {
                                    String announcementUserType =
                                        announcement['userType'];
                                    return announcementUserType ==
                                            widget.userType ||
                                        announcementUserType == 'Everyone';
                                  }).toList();

                                  if (announcements.isEmpty) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 80.h),
                                      child: const AnnouncementEmpty(),
                                    );
                                  } else {
                                    return ListView.builder(
                                      itemCount: announcements.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 6.h),
                                              PRKAnnouncementNotificationCard(
                                                title: announcements[index]
                                                    ['title'],
                                                date: announcements[index]
                                                        ['createdAt']
                                                    .toDate()
                                                    .toString()
                                                    .split(' ')[0],
                                                description:
                                                    announcements[index]
                                                        ['details'],
                                              ),
                                              SizedBox(height: 6.h),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 80.h),
                                    child: const AnnouncementEmpty(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
