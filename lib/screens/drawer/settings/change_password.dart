import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreennState();
}

class ChangePasswordScreennState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  void _checkUpdatePassword() async {
    final userId = await _getUserId();
    if (userId != null) {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();
      String oldPassword = docSnapshot['password'];

      if (oldPassword == _oldPasswordCtrl.text &&
          _newPasswordCtrl.text == _confirmPasswordCtrl.text) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .update({'password': _confirmPasswordCtrl.text});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _oldPasswordCtrl.clear();
        _newPasswordCtrl.clear();
        _confirmPasswordCtrl.clear();
      } else {
        if (oldPassword != _oldPasswordCtrl.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Old password is incorrect.'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (_newPasswordCtrl.text != _confirmPasswordCtrl.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New password does not match.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      print('Error: User ID not found.');
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
                        "Change Password",
                        style: TextStyle(
                          fontSize: 20.r,
                          color: blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 28.h,
                  ),
                  Text(
                    "Make sure that your password comprises a combination of alphanumeric characters, including both numbers and special characters, to enhance the security of your account.",
                    style: TextStyle(
                      fontSize: 12.r,
                      color: blackColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  PRKFormField(
                    prefixIcon: Icons.password_rounded,
                    labelText: "Old Password",
                    controller: _oldPasswordCtrl,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PRKFormField(
                    prefixIcon: Icons.password_rounded,
                    labelText: "New Password",
                    controller: _newPasswordCtrl,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PRKFormField(
                    prefixIcon: Icons.password_rounded,
                    labelText: "Confirm New Password",
                    controller: _confirmPasswordCtrl,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: PRKPrimaryBtn(
                  label: "Confirm",
                  onPressed: () {
                    _checkUpdatePassword();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
