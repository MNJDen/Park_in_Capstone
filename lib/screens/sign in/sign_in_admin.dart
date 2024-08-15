import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/secondary_btn.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:park_in/services/auth/Auth_Service.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromRGBO(34, 109, 34, 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Color.fromRGBO(49, 255, 49, 1),
              ),
              SizedBox(
                width: 4.w,
              ),
              Flexible(
                child: Text(
                  'Sign In Successful!', // Use the cleaned error message here
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
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
            backgroundColor: Color.fromRGBO(59, 23, 23, 1),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_rounded,
                  color: Color.fromRGBO(255, 49, 49, 1),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Flexible(
                  child: Text(
                    errorMessage, // Use the cleaned error message here
                    style: TextStyle(
                      color: whiteColor,
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
                onPressed: () => login(context),
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
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(
                              CurveTween(curve: Curves.fastEaseInToSlowEaseOut)
                                  .animate(animation1)),
                          child: const Material(
                            elevation: 5,
                            child: SignInScreen(),
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
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
