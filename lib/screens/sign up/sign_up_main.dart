import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/back_btn.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/secondary_btn.dart';
import 'package:park_in/screens/sign%20up/sign%20up%20student/page_indicator.dart';

class SignUpMainScreen extends StatelessWidget {
  const SignUpMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  const PRKBackBtn(),
                  SizedBox(
                    height: 28.h,
                  ),
                  Text(
                    "What are you?",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 24.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "Choose from the options to continue.",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12.r,
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  PRKPrimaryBtn(
                    label: "I'm a Student",
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
                                child: PageIndicator(),
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PRKSecondaryBtn(
                    label: "I'm an Employee",
                    onPressed: () {},
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: blackColor,
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Flexible(
                      child: Text(
                        "This cannot be altered after signing up.",
                        softWrap: true,
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 12.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
