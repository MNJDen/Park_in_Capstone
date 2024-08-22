import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/violation_card.dart';
import 'package:park_in/screens/home%20student/notification_student.dart';

class HomeEmployeeScreen2 extends StatefulWidget {
  const HomeEmployeeScreen2({super.key});

  @override
  State<HomeEmployeeScreen2> createState() => _HomeEmployeeScreen2State();
}

class _HomeEmployeeScreen2State extends State<HomeEmployeeScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
                    onTap: () {},
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
                                child: NotificationStudentScreen(),
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
