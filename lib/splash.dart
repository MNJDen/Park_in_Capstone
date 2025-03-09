import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_employee.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_student.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/home%20admin/home_admin.dart';
import 'package:park_in/screens/misc/verification.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  final String? userType;

  const SplashScreen(
      {required this.isLoggedIn, required this.userType, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _verificationStatus;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    Future.delayed(const Duration(seconds: 2), () async {
      await _checkVerificationStatus();
      _controller.forward().then((_) {
        _navigateToNextScreen();
      });
    });
  }

  Future<void> _checkVerificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .get();
        if (doc.exists) {
          _verificationStatus = doc['status'];
          print("SplashScreen - User Status: $_verificationStatus");
        }
      } catch (e) {
        print("Error fetching verification status: $e");
      }
    }
  }

  void _navigateToNextScreen() {
    Widget nextScreen;

    if (widget.isLoggedIn) {
      if (_verificationStatus == 'non-verified') {
        nextScreen = const NonVerified();
      } else if (widget.userType == 'Student') {
        nextScreen = const BottomNavBarStudent();
      } else if (widget.userType == 'Employee') {
        nextScreen = const BottomNavBarEmployee();
      } else {
        nextScreen = const SignInScreen();
      }
    } else {
      nextScreen = const SignInScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: _animation,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/Logo.png",
                  height: 73.h,
                  color: blueColor,
                ),
              ),
              Positioned(
                bottom: -240,
                left: 20,
                right: 20,
                child: Image.asset(
                  'assets/images/4-pillars.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
