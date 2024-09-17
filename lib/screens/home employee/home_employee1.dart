import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/screens/drawer/about.dart';
import 'package:park_in/screens/drawer/faqs.dart';
import 'package:park_in/screens/drawer/report.dart';
import 'package:park_in/screens/drawer/settings/change_password.dart';
import 'package:park_in/screens/drawer/settings/personal_details.dart';
import 'package:park_in/screens/drawer/settings/stickers.dart';
import 'package:park_in/screens/chat/group_chat.dart';
import 'package:park_in/screens/home%20employee/notification_employee.dart';
import 'package:park_in/screens/home%20employee/parking%20areas%20employee/parking_areas_4W_employee.dart';
import 'package:park_in/screens/home%20student/parking%20areas%20student/parking_areas_2W_student.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeEmployeeScreen1 extends StatefulWidget {
  const HomeEmployeeScreen1({super.key});

  @override
  State<HomeEmployeeScreen1> createState() => _HomeEmployeeScreen1State();
}

class _HomeEmployeeScreen1State extends State<HomeEmployeeScreen1> {
  int value = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late BehaviorSubject<DocumentSnapshot<Map<String, dynamic>>> userSubject;

  @override
  void initState() {
    super.initState();
    userSubject = BehaviorSubject();
    _getUserStream();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Redirect to the sign-in screen and remove all previous routes
    Navigator.pushAndRemoveUntil(
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
      (Route<dynamic> route) => false,
    );
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
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
                DrawerHeader(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bg1.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            profilePicture,
                            height: 70.h,
                            width: 70.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            (progress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/AdNU_Logo.png",
                                height: 70.h,
                                width: 70.h,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.r,
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          userNumber,
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
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
                      _logout();
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
          physics: const ClampingScrollPhysics(),
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
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: blackColor,
                        size: 30,
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
                              fontWeight: FontWeight.bold,
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
                                  fontWeight: FontWeight.bold,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                "$name",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  fontWeight: FontWeight.bold,
                                  color: blueColor,
                                ),
                              ),
                              Text(
                                "!",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
                              color: blackColor,
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
                        size: 30.r,
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
                            highlightColor: blueColor.withOpacity(0.2),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: blackColor,
                              size: 30,
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
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: blackColor,
                              size: 30,
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
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: blackColor,
                              size: 30,
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
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: blackColor,
                              size: 30,
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
              AnimatedToggleSwitch<int>.size(
                current: value,
                values: const [0, 1],
                iconOpacity: 0.8,
                indicatorSize: Size.infinite,
                iconBuilder: iconBuilder,
                borderWidth: 4.0,
                iconAnimationType: AnimationType.onHover,
                style: ToggleStyle(
                    backgroundColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    borderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    indicatorBorderRadius: BorderRadius.circular(6)),
                styleBuilder: (i) =>
                    const ToggleStyle(indicatorColor: blueColor),
                onChanged: (i) => setState(() => value = i),
              ),
              if (value == 0) ParkingArea4WEmployee(),
              if (value == 1) ParkingArea2W(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconBuilder(int value) {
  return iconWithTextByValue(value);
}

class IconWithText extends StatelessWidget {
  final IconData iconData;
  final String text;

  const IconWithText(this.iconData, {super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 16.r,
          color: whiteColor,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.r,
            color: whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

IconWithText iconWithTextByValue(int value) {
  final iconData = iconDataByValue(value);
  final text = iconTextByValue(value);
  return IconWithText(iconData, text: text);
}

IconData iconDataByValue(int value) {
  switch (value) {
    case 0:
      return Icons.airport_shuttle_outlined;
    case 1:
      return Icons.two_wheeler_rounded;
    default:
      return Icons.dangerous_outlined;
  }
}

String iconTextByValue(int value) {
  switch (value) {
    case 0:
      return 'Car';
    case 1:
      return 'Motorcycle';
    default:
      return 'Unknown';
  }
}
