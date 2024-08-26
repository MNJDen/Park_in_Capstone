import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/screens/drawer/about.dart';
import 'package:park_in/screens/drawer/faqs.dart';
import 'package:park_in/screens/drawer/report.dart';
import 'package:park_in/screens/home%20student/notification_student.dart';
import 'package:park_in/screens/home%20student/parking%20areas%20student/parking_areas_2W_student.dart';
import 'package:park_in/screens/home%20student/parking%20areas%20student/parking_areas_4W_student.dart';
import 'package:park_in/screens/drawer/settings/change_password.dart';
import 'package:park_in/screens/drawer/settings/personal_details.dart';
import 'package:park_in/screens/drawer/settings/stickers.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStudentScreen1 extends StatefulWidget {
  const HomeStudentScreen1({super.key});

  @override
  State<HomeStudentScreen1> createState() => _HomeStudentScreen1State();
}

class _HomeStudentScreen1State extends State<HomeStudentScreen1> {
  int value = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Redirect to the sign-in screen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      drawer: Drawer(
        backgroundColor: whiteColor,
        child: Column(
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/images/AdNU_Logo.png",
                        height: 70.h,
                        width: 70.w,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      "Den",
                      style: TextStyle(
                        fontSize: 16.r,
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "202100153",
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
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      childrenPadding: EdgeInsets.only(left: 12.w),
                      expansionAnimationStyle:
                          AnimationStyle(curve: Curves.fastLinearToSlowEaseIn),
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
                                            curve:
                                                Curves.fastEaseInToSlowEaseOut)
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
                                            curve:
                                                Curves.fastEaseInToSlowEaseOut)
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
                                            curve:
                                                Curves.fastEaseInToSlowEaseOut)
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
                          transitionDuration: const Duration(milliseconds: 400),
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
                          transitionDuration: const Duration(milliseconds: 400),
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
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: PRKPrimaryBtn(
                label: "Sign Out",
                onPressed: () {
                  _logout();
                },
              ),
            ),
          ],
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
                height: 32.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    highlightColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                      NavbarNotifier.hideBottomNavBar = true;
                    },
                    child: Card(
                      elevation: 0,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        "assets/images/AdNU_Logo.png",
                        fit: BoxFit.fill,
                        height: 40.h,
                        width: 40.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: Text(
                      "Hello, Den!",
                      style: TextStyle(
                        fontSize: 20.r,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                  ),
                  IconButton(
                    splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                    highlightColor: const Color.fromRGBO(45, 49, 250, 0.5),
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
                              child: const Material(
                                elevation: 5,
                                child: NotificationStudentScreen(
                                  userType: 'Student',
                                ),
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: blackColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 28.h,
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
              if (value == 0) ParkingArea4WStudent(),
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
