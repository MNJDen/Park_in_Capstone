import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class SignUpStudentScreen4 extends StatefulWidget {
  const SignUpStudentScreen4({super.key});

  @override
  State<SignUpStudentScreen4> createState() => SignUpStudentScreen4State();
}

class SignUpStudentScreen4State extends State<SignUpStudentScreen4> {
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;

    // Debugging: Print the current password
    print("Password from provider: ${userData.password}");

    _passwordCtrl.text = userData.password ?? '';
    _confirmPasswordCtrl.text =
        userData.password ?? ''; // Confirm password should match
  }

  void updateProviderData() {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);

    print("Updating password: ${_passwordCtrl.text}");

    userDataProvider.updateUserData(
      password: _passwordCtrl.text,
    );

    // Debugging: Verify if the update is reflected
    print("Password after update: ${userDataProvider.userData.password}");
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

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
              SizedBox(height: 28.h),
              Text(
                "What’s your password?",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 24.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Of course we want your account to be secured, so make sure that your password is strong and a secret.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(height: 32.h),
              PRKFormField(
                prefixIcon: Icons.password_rounded,
                labelText: "Password",
                suffixIcon: Icons.visibility_off_rounded,
                controller: _passwordCtrl,
                obscureText: true,
                onChanged: (value) => updateProviderData(),
              ),
              SizedBox(height: 12.h),
              PRKFormField(
                prefixIcon: Icons.password_rounded,
                labelText: "Confirm Password",
                suffixIcon: Icons.visibility_off_rounded,
                controller: _confirmPasswordCtrl,
                obscureText: true,
                onChanged: (value) => updateProviderData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
