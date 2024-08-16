import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';

class SignUpEmployeeScreen1 extends StatefulWidget {
  const SignUpEmployeeScreen1({super.key});

  @override
  State<SignUpEmployeeScreen1> createState() => _SignUpEmployeeScreen1State();
}

class _SignUpEmployeeScreen1State extends State<SignUpEmployeeScreen1> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _userNumberCtrl = TextEditingController();

  bool positive = false;
  bool off = false;

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
                "Who are you?",
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
                "Feel free to enter your preferred nickname. This will be the name we will use to address you.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              PRKFormField(
                prefixIcon: Icons.person_rounded,
                labelText: "Name",
                controller: _nameCtrl,
              ),
              SizedBox(
                height: 12.h,
              ),
              PRKFormField(
                prefixIcon: Icons.badge_rounded,
                labelText: "Student Number",
                controller: _userNumberCtrl,
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                children: [
                  Switch(
                    value: off,
                    inactiveThumbColor: blackColor,
                    inactiveTrackColor: whiteColor,
                    activeTrackColor: blueColor,
                    activeColor: whiteColor,
                    onChanged: (bool value) {
                      setState(
                        () {
                          off = value;
                        },
                      );
                    },
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(
                    "I have a reserved parking space",
                    style: TextStyle(
                      fontSize: 12.r,
                      color: blackColor,
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

const tappableTextStyle = TextStyle(color: Colors.blue);
