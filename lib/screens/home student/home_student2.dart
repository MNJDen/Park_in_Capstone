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
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStudentScreen2 extends StatefulWidget {
  const HomeStudentScreen2({super.key});

  @override
  State<HomeStudentScreen2> createState() => _HomeStudentScreen2State();
}

class _HomeStudentScreen2State extends State<HomeStudentScreen2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                        color: const Color.fromRGBO(27, 27, 27, 0.5),
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
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/AdNU_Logo.png"),
                        radius: 20.r,
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
                  FutureBuilder<String?>(
                    future: _getUserId(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return IconButton(
                          splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                          highlightColor:
                              const Color.fromRGBO(45, 49, 250, 0.5),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: blackColor,
                            size: 30,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return IconButton(
                          splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                          highlightColor:
                              const Color.fromRGBO(45, 49, 250, 0.5),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: blackColor,
                            size: 30,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final userId = snapshot.data;
                        return IconButton(
                          splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                          highlightColor:
                              const Color.fromRGBO(45, 49, 250, 0.5),
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
                                            curve:
                                                Curves.fastEaseInToSlowEaseOut)
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
                          },
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: blackColor,
                            size: 30,
                          ),
                        );
                      } else {
                        return IconButton(
                          splashColor: const Color.fromRGBO(45, 49, 250, 0.5),
                          highlightColor:
                              const Color.fromRGBO(45, 49, 250, 0.5),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: blackColor,
                            size: 30,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 28.h,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              PRKViolationCard(
                offenseNumber: "3rd Offense",
                date: "06/27/24",
                violation:
                    "Blowing of horn or any alarming device and/or playing of music of a car radio/stereo in the ADNU campus.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
