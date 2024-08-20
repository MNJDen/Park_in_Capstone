import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/primary_btn.dart';

class SignUpEmployeeScreen7 extends StatefulWidget {
  const SignUpEmployeeScreen7({super.key});

  @override
  State<SignUpEmployeeScreen7> createState() => _SignUpEmployeeScreen7State();
}

class _SignUpEmployeeScreen7State extends State<SignUpEmployeeScreen7> {
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
                  Text(
                    "Looks like you’re all set up!",
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
                    "Since you're finished signing up, here’s your digital sticker!",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12.r,
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Container(
                    width: 320.w,
                    height: 175.h,
                    decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
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
                          top: 10,
                          left: 20,
                          child: Text(
                            '2876',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 40.r,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          left: 20,
                          child: Text(
                            'NDA-1234',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 40.r,
                              fontWeight: FontWeight.w700,
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
                        Positioned(
                          top: 13,
                          right: 10,
                          child: CircleAvatar(
                            radius: 24,
                            child: Image.asset(
                              'assets/images/AdNU_Logo.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 20,
                          child: Text(
                            '© 2024 Park-In. All Rights Reserved.',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 10.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: PRKPrimaryBtn(
                  label: "Continue",
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
