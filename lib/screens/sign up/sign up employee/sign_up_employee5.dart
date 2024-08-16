import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';

class SignUpEmployeeScreen5 extends StatefulWidget {
  const SignUpEmployeeScreen5({super.key});

  @override
  State<SignUpEmployeeScreen5> createState() => _SignUpEmployeeScreen5State();
}

class _SignUpEmployeeScreen5State extends State<SignUpEmployeeScreen5> {
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

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
                "What’s your password?",
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
                "Of course we want your account to be secured, so make sure that your password is strong and a secret.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              PRKFormField(
                prefixIcon: Icons.password_rounded,
                labelText: "Password",
                suffixIcon: Icons.visibility_off_rounded,
                controller: _passwordCtrl,
                obscureText: true,
              ),
              SizedBox(
                height: 12.h,
              ),
              PRKFormField(
                prefixIcon: Icons.password_rounded,
                labelText: "Confirm Password",
                suffixIcon: Icons.visibility_off_rounded,
                controller: _confirmPasswordCtrl,
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
