import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/violation_card.dart';
import 'package:park_in/screens/drawer/about.dart';
import 'package:park_in/screens/drawer/faqs.dart';
import 'package:park_in/screens/drawer/report.dart';
import 'package:park_in/screens/drawer/settings/change_password.dart';
import 'package:park_in/screens/drawer/settings/personal_details.dart';
import 'package:park_in/screens/drawer/settings/stickers.dart';
import 'package:park_in/screens/home%20student/notification_student.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:park_in/services/auth/Auth_Service.dart';

class HomeEmployeeScreen2 extends StatefulWidget {
  const HomeEmployeeScreen2({super.key});

  @override
  State<HomeEmployeeScreen2> createState() => _HomeEmployeeScreen2State();
}

class _HomeEmployeeScreen2State extends State<HomeEmployeeScreen2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      key: _scaffoldKey,
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
                      "Emmanuel",
                      style: TextStyle(
                        fontSize: 16.r,
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "2020000000",
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
                  logout(context);
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
                      "Hello, Emmanuel!",
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
                      // Navigator.push(
                      //   context,
                      //   PageRouteBuilder(
                      //     pageBuilder: (BuildContext context,
                      //         Animation<double> animation1,
                      //         Animation<double> animation2) {
                      //       return SlideTransition(
                      //         position: Tween<Offset>(
                      //           begin: const Offset(1, 0),
                      //           end: Offset.zero,
                      //         ).animate(CurveTween(
                      //                 curve: Curves.fastEaseInToSlowEaseOut)
                      //             .animate(animation1)),
                      //         child: const Material(
                      //           elevation: 5,
                      //           child: NotificationEmployeeScreen(),
                      //         ),
                      //       );
                      //     },
                      //     transitionDuration: const Duration(milliseconds: 400),
                      //   ),
                      // );
                    },
                    icon: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: blackColor,
                      size: 30.r,
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
                                  userType: 'Employee',
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
                offenseNumber: "1st Offense",
                date: "06/28/24",
                violation:
                    "Parking in front and/or the road/street leading to the four pillars.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}