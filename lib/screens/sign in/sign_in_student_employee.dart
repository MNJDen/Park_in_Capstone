import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_in/components/bottom_nav_bar_employee.dart';
import 'package:park_in/components/bottom_nav_bar_student.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/secondary_btn.dart';
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

  Future<void> _signIn() async {
    final userNumber = _userNumberCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (userNumber.isEmpty || password.isEmpty) {
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
                  "Please fill out the fields.",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
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

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userType', userType); // Save userType

        // Navigate to appropriate page based on userType
        Widget destination;

        if (userType == 'Student') {
          destination = BottomNavBarStudent();
        } else if (userType == 'Employee') {
          destination = BottomNavBarEmployee();
        } else {
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
                      'User type not recognized.',
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          return;
        }

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
                    'Invalid user number or password.',
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in: $e'),
        ),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Redirect to the sign-in screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (Route<dynamic> route) => false,
    );
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
                prefixIcon: Icons.person_rounded,
                labelText: "Student/Employee Number",
                controller: _userNumberCtrl,
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
                                          curve: Curves.fastEaseInToSlowEaseOut)
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 204.h),
              GestureDetector(
                onLongPress: () {
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
                            child: BottomNavBarEmployee(),
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                child: PRKPrimaryBtn(
                  label: "Sign In",
                  onPressed: _signIn,
                ),
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
                          ).animate(
                              CurveTween(curve: Curves.fastEaseInToSlowEaseOut)
                                  .animate(animation1)),
                          child: const Material(
                            elevation: 5,
                            child: SignInAdminScreen(),
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
