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
      if (_oldPasswordCtrl.text.isEmpty ||
          _newPasswordCtrl.text.isEmpty ||
          _confirmPasswordCtrl.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: MediaQuery.of(context).size.width * 0.95,
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color.fromARGB(255, 255, 226, 226),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color.fromRGBO(255, 0, 0, 1),
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: const Color.fromRGBO(255, 0, 0, 1),
                  size: 20.r,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Flexible(
                  child: Text(
                    "Fill out all the forms",
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .get();
        String oldPassword = docSnapshot['password'];

        if (oldPassword == _oldPasswordCtrl.text &&
            _newPasswordCtrl.text == _confirmPasswordCtrl.text) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(userId)
              .update({'password': _confirmPasswordCtrl.text});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              width: MediaQuery.of(context).size.width * 0.95,
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color.fromRGBO(217, 255, 214, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color.fromRGBO(20, 255, 0, 1),
                ),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: const Color.fromRGBO(20, 255, 0, 1),
                    size: 20.r,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Flexible(
                    child: Text(
                      "Password changed successfully",
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          _oldPasswordCtrl.clear();
          _newPasswordCtrl.clear();
          _confirmPasswordCtrl.clear();
        } else {
          if (oldPassword != _oldPasswordCtrl.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                width: MediaQuery.of(context).size.width * 0.95,
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color.fromARGB(255, 255, 226, 226),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: const Color.fromRGBO(255, 0, 0, 1),
                      size: 20.r,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Flexible(
                      child: Text(
                        "Old password is incorrect",
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (_newPasswordCtrl.text != _confirmPasswordCtrl.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                width: MediaQuery.of(context).size.width * 0.95,
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color.fromARGB(255, 255, 226, 226),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: const Color.fromRGBO(255, 0, 0, 1),
                      size: 20.r,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Flexible(
                      child: Text(
                        "New password does not match",
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
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
                        "Change Password",
                        style: TextStyle(
                          fontSize: 20.r,
                          color: blueColor,
                          fontWeight: FontWeight.w600,
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
                    suffixIcon: Icons.visibility_off_rounded,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
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
