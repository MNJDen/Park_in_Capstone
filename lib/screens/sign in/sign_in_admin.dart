import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/secondary_btn.dart';

class SignInAdminScreen extends StatefulWidget {
  const SignInAdminScreen({super.key});

  @override
  State<SignInAdminScreen> createState() => _SignInAdminScreenState();
}

class _SignInAdminScreenState extends State<SignInAdminScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/Logo.png",
                    height: 53.h,
                    width: 38.w,
                  ),
                ],
              ),
              SizedBox(
                height: 88.h,
              ),
              Text(
                "Welcome",
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
                "Enter your given account credentials.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              PRKFormField(
                prefixIcon: Icons.email_rounded,
                labelText: "Email Address",
                controller: _emailCtrl,
              ),
              SizedBox(
                height: 12.h,
              ),
              PRKFormField(
                prefixIcon: Icons.password_rounded,
                labelText: "Password",
                suffixIcon: Icons.visibility_off_rounded,
                controller: _passwordCtrl,
                obscureText: true,
              ),
              SizedBox(
                height: 228.h,
              ),
              PRKPrimaryBtn(
                label: "Sign In",
                onPressed: () {},
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 0.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: Text(
                      "or",
                      style: TextStyle(
                        color: blackColor,
                        backgroundColor: bgColor,
                        fontSize: 12.r,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              PRKSecondaryBtn(
                label: "Continue as a Student/Employee",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
