import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/components/ui/violation_card.dart';
import 'package:park_in/screens/chat/group_chat.dart';
import 'package:park_in/screens/drawer/about.dart';
import 'package:park_in/screens/drawer/faqs.dart';
import 'package:park_in/screens/drawer/report.dart';
import 'package:park_in/screens/drawer/settings/change_password.dart';
import 'package:park_in/screens/drawer/settings/personal_details.dart';
import 'package:park_in/screens/drawer/settings/stickers.dart';
import 'package:park_in/screens/home%20employee/notification_employee.dart';
import 'package:park_in/screens/misc/violations_empty.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:park_in/services/auth/Auth_Service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomeEmployeeScreen2 extends StatefulWidget {
  final String userId; // Current logged-in user's ID
  final String userType;

  const HomeEmployeeScreen2({
    Key? key,
    required this.userType,
    required this.userId,
  }) : super(key: key);

  @override
  State<HomeEmployeeScreen2> createState() => _HomeEmployeeScreen2State();
}

class _HomeEmployeeScreen2State extends State<HomeEmployeeScreen2> {
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
      return '1st Offense';
    } else if (number == 2) {
      return '2nd Offense';
    } else if (number == 3) {
      return '3rd Offense';
    } else {
      return '${number}th Offense';
    }
  }

  List<String> majorViolations = [
    "Selling, attempting to sell, or giving their gate pass/sticker to another person",
    "False declaration in any application for a gate pass/sticker or in a report of a stolen gate pass/sticker",
    "Tampering/Falsification/Alteration or Duplication of gate pass/sticker",
    "Driving while under the influence of prohibited drugs or any alcoholic beverages",
    "Using the car as shelter for obnoxious and scandalous activities",
    "Driving without license or unregistered vehicles",
    "Disregard or refusal at the gate, or in any part of the campus, to submit to standard security requirements such as the routine inspection or checking of ID",
    "Verbal/physical abuse against security personnel",
  ];

  List<String> minorViolations = [
    "Blowing of horn or any alarming device and/or playing of music of a car radio in the ADNU campus",
    "Illegal parking",
    "Running the engines while parked",
    "Driving on a sidewalk or pathway",
    "Carrying or loading the car of any material when its edge portion causes damage or scrape the pavement of the road/street",
    "Driving inside the campus at a speed in excess of 10 km/hr",
  ];

// Function to classify violations
  String classifyViolation(String violation) {
    if (majorViolations.contains(violation)) {
      return "Major Violation";
    } else if (minorViolations.contains(violation)) {
      return "Minor Violation";
    }
    return "Unclassified Violation"; // Default if it doesn't match any
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
                        color: blueColor,
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
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 60.h,
                                        height: 60.h,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 14.r,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "General Sans",
                                      ),
                                    ),
                                    Text(
                                      userNumber,
                                      style: TextStyle(
                                        fontSize: 12.r,
                                        color: whiteColor,
                                        fontFamily: "General Sans",
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
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
                        if (snapshot.hasData && snapshot.data != null) {
                          final userData = snapshot.data!;
                          final String name =
                              (userData['name'] ?? 'Hello, User!')
                                  .split(' ')
                                  .first;
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
                                name,
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
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              // width: 60.h,
                              height: 20.r,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Tooltip(
                    triggerMode: TooltipTriggerMode.longPress,
                    message: "Chat",
                    textStyle: const TextStyle(
                      color: whiteColor,
                    ),
                    decoration: BoxDecoration(
                      color: blackColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
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
                                        curve: Curves.fastEaseInToSlowEaseOut)
                                    .animate(animation1)),
                                child: Material(
                                  elevation: 5,
                                  child: ChatScreen(),
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
                        Icons.message_outlined,
                        color: blackColor,
                        size: 26.r,
                      ),
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
                                        child: NotificationEmployeeScreen(
                                          userType: 'Employee',
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
                height: 12.h,
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
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                          color: blueColor, size: 50.r),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching tickets'));
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
                        return (b['timestamp'] as Timestamp)
                            .compareTo(a['timestamp'] as Timestamp);
                      });

                      final totalOffenses = tickets.length;

                      return Column(
                        children: List.generate(
                          tickets.length,
                          (index) {
                            final ticket = tickets[index];
                            final violation = ticket['violation'] as String;
                            final offenseNumber = totalOffenses - index;

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showViolationCard(
                                        context, ticket, offenseNumber);
                                    NavbarNotifier.hideBottomNavBar = true;
                                  },
                                  child: PRKViolationCard(
                                    violationClassification:
                                        classifyViolation(violation),
                                    offenseNumber:
                                        formatOffenseNumber(offenseNumber),
                                    date: (ticket['timestamp'] as Timestamp)
                                        .toDate()
                                        .toString()
                                        .split(' ')[0],
                                    violation: violation,
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                            .animate()
                            .fade(
                              delay: const Duration(
                                milliseconds: 200,
                              ),
                            )
                            .moveY(
                              begin: 10,
                              end: 0,
                              curve: Curves.fastEaseInToSlowEaseOut,
                              duration: const Duration(milliseconds: 350),
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
