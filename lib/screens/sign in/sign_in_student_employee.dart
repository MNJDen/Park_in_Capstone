import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_employee.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_student.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/components/ui/secondary_btn.dart';
import 'package:park_in/screens/sign%20in/sign_in_admin.dart';
import 'package:park_in/screens/sign%20up/sign_up_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _userNumberCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _isSigningIn = false;

  Future<void> _signIn() async {
    final userNumber = _userNumberCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (userNumber.isEmpty || password.isEmpty) {
      errorSnackbar(context, "Please fill in all fields");
      return;
    }

    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('userNumber', isEqualTo: userNumber)
          .where('password', isEqualTo: password)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userType = userDoc['userType'];
        final userId = userDoc.id;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userType', userType);
        await prefs.setString('userId', userId);

        // Show loading screen only now, as credentials are correct
        setState(() {
          _isSigningIn = true;
        });

        // Navigate to appropriate page based on userType
        Widget destination;

        if (userType == 'Student') {
          destination = BottomNavBarStudent();
        } else if (userType == 'Employee') {
          destination = BottomNavBarEmployee();
        } else {
          errorSnackbar(context, "User type not recognized");
          setState(() {
            _isSigningIn = false;
          });
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 90.h),
            behavior: SnackBarBehavior.floating,
            backgroundColor: blackColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: successColor,
                  size: 20.r,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Flexible(
                  child: Text(
                    'Sign In Successful!',
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)
                    .animate(animation1)),
                child: Material(
                  elevation: 5,
                  child: destination,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      } else {
        errorSnackbar(context, "Invalid user number or password");
      }
    } catch (e) {
      errorSnackbar(context, "Error Occurred: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
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
          child: _isSigningIn
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.waveDots(
                        color: blueColor,
                        size: 50.r,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "Signing in, wait a moment...",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor.withOpacity(0.8),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
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
                          SizedBox(height: 88.h),
                          Text(
                            "Hey There!",
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 24.r,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Enter your account credentials to continue.",
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 12.r,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          PRKFormField(
                            prefixIcon: Icons.badge_rounded,
                            labelText: "Student/Employee Number",
                            controller: _userNumberCtrl,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 12.h),
                          PRKFormField(
                            prefixIcon: Icons.password_rounded,
                            labelText: "Password",
                            suffixIcon: Icons.visibility_off_rounded,
                            controller: _passwordCtrl,
                            obscureText: true,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Wrap(
                                spacing: 2.w,
                                children: [
                                  Text(
                                    "Don’t have an account yet?",
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 12.r,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
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
                                              ).animate(CurveTween(
                                                      curve: Curves
                                                          .fastEaseInToSlowEaseOut)
                                                  .animate(animation1)),
                                              child: const Material(
                                                elevation: 5,
                                                child: SignUpMainScreen(),
                                              ),
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 400),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color: blueColor,
                                          fontSize: 12.r,
                                          decoration: TextDecoration.underline,
                                          decorationColor: blueColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                            onPressed: _signIn,
                          ),
                          SizedBox(height: 8.h),
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
                          SizedBox(height: 8.h),
                          PRKSecondaryBtn(
                            label: "Continue as an Admin",
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
                                      ).animate(CurveTween(
                                              curve: Curves
                                                  .fastEaseInToSlowEaseOut)
                                          .animate(animation1)),
                                      child: const Material(
                                        elevation: 5,
                                        child: SignInAdminScreen(),
                                      ),
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 400),
                                ),
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
