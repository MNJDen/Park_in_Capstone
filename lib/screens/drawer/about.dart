import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: blackColor,
                      ),
                    ),
                  ),
                  Text(
                    "About Park-in",
                    style: TextStyle(
                      fontSize: 20.r,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Creation of Park-in",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: blackColor,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 16.h,
              ),
              Text(
                "This application, Park-in, is a prerequisite for Capstone I and II, and it was initially conceptualized to assist people who were using the parking facilities within the campus due to limited parking availability.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: blackColor,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Meet the Team",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: blackColor,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 16.h,
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: AssetImage("assets/images/den.png"),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mark Niño Joseph A. Alden',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Front-end Developer',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color.fromRGBO(27, 27, 27, 0.5),
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          'Responsible for the user interface design, logo creation, typeface selection, 3D models of the buildings, and front-end development of Park-in.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                      ],
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
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: AssetImage("assets/images/doms.png"),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emmanuel Dominic A. Esperida',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Back-end Developer',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color.fromRGBO(27, 27, 27, 0.5),
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          'Responsible for overseeing the entire back-end infrastructure of Park-in, which includes setting up the database and establishing its connection with the application.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Developed by:",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: blackColor,
                        ),
                      ),
                      Image.asset(
                        "assets/images/group_logo.png",
                        height: 39.h,
                        width: 86.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
