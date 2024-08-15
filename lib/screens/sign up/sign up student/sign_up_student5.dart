import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

class SignUpStudentScreen5 extends StatefulWidget {
  const SignUpStudentScreen5({super.key});

  @override
  State<SignUpStudentScreen5> createState() => _SignUpStudentScreen5State();
}

class _SignUpStudentScreen5State extends State<SignUpStudentScreen5> {
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
                height: 28.h,
              ),
              Text(
                "What do you look like?",
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
                "Upload an image with that charming face of yours.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 164.h,
                    width: 154.h,
                    child: Card(
                      elevation: 15,
                      shadowColor: Color.fromRGBO(27, 27, 27, 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      color: whiteColor,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filled(
                              iconSize: 20.r,
                              onPressed: () {},
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(blueColor),
                              ),
                              icon: const Icon(
                                Icons.add_rounded,
                                color: whiteColor,
                              ),
                            ),
                            Text(
                              "Upload a photo",
                              style: TextStyle(
                                fontSize: 12.r,
                                color: blackColor,
                              ),
                            )
                          ],
                        ),
                      ),
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
