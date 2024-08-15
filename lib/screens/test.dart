import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:park_in/components/secondary_btn.dart';
import 'package:park_in/screens/sign in/sign_in_admin.dart';
import 'package:park_in/services/auth/Auth_Service.dart';

class testScreen extends StatefulWidget {
  const testScreen({super.key});

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> {
  final TextEditingController _userNumber = TextEditingController();
  bool _isLoading = false;

  void logout(BuildContext context) async {
    final authService = AuthService();

    setState(() {
      _isLoading = true;
    });

    try {
      await authService.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation1,
              Animation<double> animation2) {
            return const SignInAdminScreen();
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    } catch (e) {
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
                  "Sign Up Unsuccessful", // Use the cleaned error message here
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PRKFormField(
                prefixIcon: Icons.person_rounded,
                labelText: "Username",
                controller: _userNumber,
              ),
              PRKPrimaryBtn(
                label: "Primary Button",
                onPressed: () {},
              ),
              PRKSecondaryBtn(
                label: "Secondary Button",
                onPressed: () {},
              ),
              PRKSecondaryBtn(
                label: "Logout",
                onPressed: () {
                  logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
