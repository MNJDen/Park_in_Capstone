import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

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
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
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
                      fontWeight: FontWeight.w600,
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
                    fontWeight: FontWeight.w600),
              ),
              Divider(
                height: 16.h,
              ),
              Text(
                "This application, Park-in, is a prerequisite for Capstone I and II, and it was initially conceptualized and developed to assist people who were using the parking facilities within the campus due to limited parking availability for a mobile development subject.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: blackColor,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Later on, it was pushed by the proponents’ adviser, Kevin G. Vega, as a proposed topic for Capstone I which led to its further development into its current form.",
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
                    fontWeight: FontWeight.w600),
              ),
              Divider(
                height: 16.h,
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "The people responsible for the application was a two-man team. They are the following: ",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: blackColor,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 45.r,
                    backgroundImage: const AssetImage("assets/images/den.png"),
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
                          'Responsible for the UI/UX design, logo development, typeface selection, creation of 3D models for the buildings, and front-end development of Park-in.',
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
                    radius: 45.r,
                    backgroundImage: const AssetImage("assets/images/doms.png"),
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
                          'Managed the entire back-end infrastructure of Park-in, which includes setting up the database and its integration with the application, enabling real-time data accessibility.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                        // Image.asset(
                        //   "assets/images/group_logo.png",
                        //   height: 39.h,
                        //   width: 86.w,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
