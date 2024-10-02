import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/snackbar/success_snackbar.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/components/ui/secondary_btn.dart';
import 'package:park_in/screens/home%20admin/home_admin.dart';
import 'package:park_in/services/auth/Auth_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInAdminScreen extends StatefulWidget {
  const SignInAdminScreen({super.key});

  @override
  State<SignInAdminScreen> createState() => _SignInAdminScreenState();
}

class _SignInAdminScreenState extends State<SignInAdminScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  void login(BuildContext context) async {
    final authService = AuthService();

    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      errorSnackbar(context, "Please fill in all fields");
      return;
    }

    try {
      await authService.signInWithEmailPassword(
        _emailCtrl.text,
        _passwordCtrl.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'Admin'); // Store user type
      await prefs.setBool('isLoggedIn', true); // Store login status

      successSnackbar(context, "Sign In Successful!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAdminScreen1()),
      );
    } catch (e) {
      if (mounted) {
        String errorMessage;
        if (e is AuthServiceException) {
          errorMessage = e.message;
        } else {
          errorMessage = 'An unknown error occurred';
        }

        errorSnackbar(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      "Welcome Back!",
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
                      prefixIcon: Icons.alternate_email_rounded,
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50.h),
                child: Column(
                  children: [
                    PRKPrimaryBtn(
                        label: "Sign In",
                        onPressed: () {
                          login(context);
                        }),
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
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
