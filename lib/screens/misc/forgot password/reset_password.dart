import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String userId; // Receive userId to update Firestore

  const ResetPasswordScreen({super.key, required this.userId});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _newPasswordCtrl = TextEditingController();
  TextEditingController _confirmPasswordCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    String newPassword = _newPasswordCtrl.text.trim();
    String confirmPassword = _confirmPasswordCtrl.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a new password.")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.userId) // Update user's password using userId
          .update({'password': newPassword});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successfully.")),
      );

      // Navigate back to login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false, // Clear the navigation stack
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error resetting password: $e")),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: blackColor),
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    "Change Password",
                    style: TextStyle(
                        fontSize: 24.r,
                        color: blueColor,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Make sure that your password comprises a combination of alphanumeric characters, to enhance the security of your account.",
                    style: TextStyle(color: blackColor, fontSize: 12.r),
                  ),
                  SizedBox(height: 32.h),
                  PRKFormField(
                    prefixIcon: Icons.password_rounded,
                    labelText: "New Password",
                    controller: _newPasswordCtrl,
                    suffixIcon: Icons.visibility_off_rounded,
                    obscureText: true,
                  ),
                  SizedBox(height: 12.h),
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
                child: PRKPrimaryBtn(
                  label: _isLoading ? "Resetting..." : "Reset Password",
                  onPressed: _resetPassword,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
