import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:park_in/services/auth/Auth_Service.dart';

class NonVerified extends StatefulWidget {
  const NonVerified({super.key});

  @override
  State<NonVerified> createState() => _NonVerifiedState();
}

class _NonVerifiedState extends State<NonVerified> {
  void logout(BuildContext context) async {
    final authService = AuthService();
    bool _isLoading = false;

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/verify.png",
                      height: 130.h,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      "You are not verified yet :(",
                      style: TextStyle(
                        fontSize: 20.r,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.r),
                      child: Text(
                        "Please wait here for awhile while the admins are verifying your account.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 12.r,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        logout(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45.h,
                        width: double.infinity,
                        child: Text(
                          "Back to Sign-in",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
