import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _newPasswordCtrl = TextEditingController();
  TextEditingController _confirmPasswordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _newPasswordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32.h,
                  ),
                  GestureDetector(
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
                  SizedBox(
                    height: 28.h,
                  ),
                  Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 24.r,
                      color: blueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "Make sure that your password comprises a combination of alphanumeric characters, to enhance the security of your account.",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12.r,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  PRKFormField(
                    prefixIcon: Icons.password_rounded,
                    labelText: "New Password",
                    controller: _newPasswordCtrl,
                    suffixIcon: Icons.visibility_off_rounded,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PRKFormField(
                    prefixIcon: Icons.password_rounded,
                    labelText: "Confirm New Password",
                    controller: _confirmPasswordCtrl,
                    suffixIcon: Icons.visibility_off_rounded,
                    obscureText: true,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50.h),
                child: PRKPrimaryBtn(label: "Reset Password", onPressed: () {}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
