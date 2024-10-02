import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/components/ui/violation_card.dart';
import 'package:park_in/screens/drawer/about.dart';
import 'package:park_in/screens/drawer/faqs.dart';
import 'package:park_in/screens/drawer/report.dart';
import 'package:park_in/screens/drawer/settings/change_password.dart';
import 'package:park_in/screens/drawer/settings/personal_details.dart';
import 'package:park_in/screens/drawer/settings/stickers.dart';
import 'package:park_in/screens/home%20student/notification_student.dart';
import 'package:park_in/screens/misc/violations_empty.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:park_in/services/auth/Auth_Service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomeStudentScreen2 extends StatefulWidget {
  final String userId; // Current logged-in user's ID
  final String userType;

  const HomeStudentScreen2({
    Key? key,
    required this.userType,
    required this.userId,
  }) : super(key: key);

  @override
  State<HomeStudentScreen2> createState() => _HomeStudentScreen2State();
}

class _HomeStudentScreen2State extends State<HomeStudentScreen2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late BehaviorSubject<DocumentSnapshot<Map<String, dynamic>>> userSubject;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userSubject = BehaviorSubject();
    _fetchUserData();
    _getUserStream(); // Fetch the user's data when the screen initializes
  }

  void logout(BuildContext context) async {
    final authService = AuthService();

    setState(() {
      _isLoading = true;
    });

    try {
      await authService.signOut();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation1,
              Animation<double> animation2) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)
                  .animate(animation1)),
              child: const Material(
                elevation: 5,
                child: SignInScreen(),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  List<String>? _plateNumbers; // Holds the current user's plate number

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

  void _getUserStream() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .snapshots()
          .listen((snapshot) {
        userSubject.add(snapshot);
      });
    }
  }

  String formatOffenseNumber(int number) {
    if (number == 1) {
      return '1st offense';
    } else if (number == 2) {
      return '2nd offense';
    } else if (number == 3) {
      return '3rd offense';
    } else {
      return '${number}th offense';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      drawer: Drawer(
        backgroundColor: whiteColor,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userSubject.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching user data'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User not found'));
            }

            final userData = snapshot.data!;
            final String name = userData['name'] ?? 'N/A';
            final String userNumber = userData['userNumber'] ?? 'N/A';
            final String profilePicture =
                userData['profilePicture'] ?? "assets/images/AdNU_Logo.png";
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 140.h,
                  child: Stack(
                    children: [
                      Container(
                        color: yellowColor,
                      ),
                      Positioned(
                        top: -50,
                        left: -60,
                        child: Container(
                          width: 200.w,
                          height: 200.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -50,
                        right: -30,
                        child: Container(
                          width: 140.w,
                          height: 140.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: -197,
                        child: Transform.rotate(
                          angle: -0.995398,
                          child: Container(
                            width: 400.w,
                            height: 37.5.h,
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: -293,
                        child: Transform.rotate(
                          angle: -0.995398,
                          child: Container(
                            width: 400.w,
                            height: 37.5.h,
                            color: whiteColor,
                          ),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerTheme: const DividerThemeData(
                            thickness: 0,
                            color: Colors.transparent,
                          ),
                        ),
                        child: DrawerHeader(
                          margin: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  profilePicture,
                                  height: 60.h,
                                  width: 60.h,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) {
                                      return child;
                                    } else {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 60.w,
                                          height: 60.h,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/AdNU_Logo.png",
                                      height: 60.h,
                                      width: 60.h,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 14.r,
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "General Sans",
                                    ),
                                  ),
                                  Text(
                                    userNumber,
                                    style: TextStyle(
                                      fontSize: 12.r,
                                      color: blackColor.withOpacity(0.5),
                                      fontFamily: "General Sans",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.only(left: 12.w),
                          expansionAnimationStyle: AnimationStyle(
                              curve: Curves.fastLinearToSlowEaseIn),
                          leading: Icon(
                            Icons.manage_accounts_outlined,
                            color: blackColor,
                            size: 24.r,
                          ),
                          title: Text(
                            'Account Settings',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.account_box_outlined,
                                color: blackColor,
                                size: 24.r,
                              ),
                              title: Text(
                                "Personal Details",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation1,
                                        Animation<double> animation2) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(CurveTween(
                                                curve: Curves
                                                    .fastEaseInToSlowEaseOut)
                                            .animate(animation1)),
                                        child: const Material(
                                          elevation: 5,
                                          child: PersonalDetailsScreen(),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.shield_outlined,
                                color: blackColor,
                                size: 24.r,
                              ),
                              title: Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation1,
                                        Animation<double> animation2) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(CurveTween(
                                                curve: Curves
                                                    .fastEaseInToSlowEaseOut)
                                            .animate(animation1)),
                                        child: const Material(
                                          elevation: 5,
                                          child: ChangePasswordScreen(),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.confirmation_num_outlined,
                                color: blackColor,
                                size: 24.r,
                              ),
                              title: Text(
                                "Stickers",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation1,
                                        Animation<double> animation2) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(CurveTween(
                                                curve: Curves
                                                    .fastEaseInToSlowEaseOut)
                                            .animate(animation1)),
                                        child: const Material(
                                          elevation: 5,
                                          child: StickersScreen(),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.flag_outlined,
                          color: blackColor,
                          size: 24.r,
                        ),
                        title: Text(
                          'Report',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation1,
                                  Animation<double> animation2) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(CurveTween(
                                          curve: Curves.fastEaseInToSlowEaseOut)
                                      .animate(animation1)),
                                  child: const Material(
                                    elevation: 5,
                                    child: ReportScreen(),
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.question_answer_outlined,
                          color: blackColor,
                          size: 24.r,
                        ),
                        title: Text(
                          'FAQs',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation1,
                                  Animation<double> animation2) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(CurveTween(
                                          curve: Curves.fastEaseInToSlowEaseOut)
                                      .animate(animation1)),
                                  child: const Material(
                                    elevation: 5,
                                    child: FaqsScreen(),
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.people_outline_rounded,
                          color: blackColor,
                          size: 24.r,
                        ),
                        title: Text(
                          'About Park-in',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation1,
                                  Animation<double> animation2) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(CurveTween(
                                          curve: Curves.fastEaseInToSlowEaseOut)
                                      .animate(animation1)),
                                  child: const Material(
                                    elevation: 5,
                                    child: AboutScreen(),
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.5.w,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: PRKPrimaryBtn(
                    label: "Sign Out",
                    onPressed: () {
                      logout(context);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          NavbarNotifier.hideBottomNavBar = false;
        }
      },
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Tooltip(
                    triggerMode: TooltipTriggerMode.longPress,
                    message: "Menu",
                    textStyle: const TextStyle(
                      color: whiteColor,
                    ),
                    decoration: BoxDecoration(
                      color: blackColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      highlightColor: blueColor.withOpacity(0.2),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                        NavbarNotifier.hideBottomNavBar = true;
                      },
                      icon: Icon(
                        Icons.menu_rounded,
                        color: blackColor,
                        size: 26.r,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: userSubject.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Hello, ---!',
                            style: TextStyle(
                              fontSize: 20.r,
                              fontWeight: FontWeight.w600,
                              color: blackColor,
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final userData = snapshot.data!;
                          final String name =
                              userData['name'] ?? 'Hello, User!';
                          return Wrap(
                            children: [
                              Text(
                                "Hello, ",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  fontWeight: FontWeight.w600,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                "$name",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  fontWeight: FontWeight.w600,
                                  color: blueColor,
                                ),
                              ),
                              Text(
                                "!",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  fontWeight: FontWeight.w600,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text(
                            'Hello, ---!',
                            style: TextStyle(
                              fontSize: 20.r,
                              fontWeight: FontWeight.w600,
                              color: blackColor,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  FutureBuilder<String?>(
                    future: _getUserId(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Tooltip(
                          triggerMode: TooltipTriggerMode.longPress,
                          message: "Notifications",
                          textStyle: const TextStyle(
                            color: whiteColor,
                          ),
                          decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            highlightColor: blueColor.withOpacity(0.2),
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: blackColor,
                              size: 26.r,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Tooltip(
                          triggerMode: TooltipTriggerMode.longPress,
                          message: "Notifications",
                          textStyle: const TextStyle(
                            color: whiteColor,
                          ),
                          decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            highlightColor: blueColor.withOpacity(0.2),
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: blackColor,
                              size: 26.r,
                            ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final userId = snapshot.data;
                        return Tooltip(
                          triggerMode: TooltipTriggerMode.longPress,
                          message: "Notifications",
                          textStyle: const TextStyle(
                            color: whiteColor,
                          ),
                          decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            highlightColor: blueColor.withOpacity(0.2),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation1,
                                      Animation<double> animation2) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(CurveTween(
                                              curve: Curves
                                                  .fastEaseInToSlowEaseOut)
                                          .animate(animation1)),
                                      child: Material(
                                        elevation: 5,
                                        child: NotificationStudentScreen(
                                          userType: 'Student',
                                          userId: userId!,
                                        ),
                                      ),
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 400),
                                ),
                              );
                              NavbarNotifier.hideBottomNavBar = true;
                            },
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: blackColor,
                              size: 26.r,
                            ),
                          ),
                        );
                      } else {
                        return Tooltip(
                          triggerMode: TooltipTriggerMode.longPress,
                          message: "Notifications",
                          textStyle: const TextStyle(
                            color: whiteColor,
                          ),
                          decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            highlightColor: blueColor.withOpacity(0.2),
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: blackColor,
                              size: 26.r,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Violations Committed",
                    softWrap: true,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 16.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Violation Ticket')
                    .where('plate_number', whereIn: _plateNumbers)
                    .where('status', isEqualTo: 'Pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching tickets'));
                  } else if (snapshot.hasData) {
                    final tickets = snapshot.data!.docs.map((doc) {
                      return doc.data() as Map<String, dynamic>;
                    }).toList();

                    if (tickets.isEmpty) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.6),
                        child: const ViolationsEmpty(),
                      );
                    } else {
                      // Sort tickets by timestamp
                      tickets.sort((a, b) {
                        return (a['timestamp'] as Timestamp)
                            .compareTo(b['timestamp'] as Timestamp);
                      });

                      // Map to track how many times a violation the user has committed
                      Map<String, int> violationCounts = {};

                      return Column(
                        children: List.generate(
                          tickets.length,
                          (index) {
                            final ticket = tickets[index];
                            final violationType = ticket['violation'];

                            // Increment the violation count
                            violationCounts[violationType] =
                                (violationCounts[violationType] ?? 0) + 1;

                            return PRKViolationCard(
                              offenseNumber: formatOffenseNumber(
                                  violationCounts[violationType]!),
                              date: (ticket['timestamp'] as Timestamp)
                                  .toDate()
                                  .toString()
                                  .split(' ')[0],
                              violation: violationType,
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6),
                      child: const ViolationsEmpty(),
                    );
                  }
                },
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}
