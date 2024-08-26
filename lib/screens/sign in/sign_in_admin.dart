import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/secondary_btn.dart';
import 'package:park_in/screens/home%20admin/home_admin.dart';
import 'package:park_in/screens/test.dart';
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

    try {
      await authService.signInWithEmailPassword(
        _emailCtrl.text,
        _passwordCtrl.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'Admin'); // Store user type
      await prefs.setBool('isLoggedIn', true); // Store login status

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromRGBO(217, 255, 214, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: const Color.fromRGBO(20, 255, 0, 1),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: const Color.fromRGBO(20, 255, 0, 1),
                size: 24.r,
              ),
              SizedBox(
                width: 4.w,
              ),
              Flexible(
                child: Text(
                  'Sign In Successful!', // Use the cleaned error message here
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: MediaQuery.of(context).size.width * 0.95,
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color.fromRGBO(255, 214, 214, 1),
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
                  Icons.error_rounded,
                  color: const Color.fromRGBO(255, 0, 0, 1),
                  size: 24.r,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Flexible(
                  child: Text(
                    errorMessage, // Use the cleaned error message here
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.r,
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
        ),
      ),
    );
  }
}
