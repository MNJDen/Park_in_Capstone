import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_employee.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_student.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/home%20admin/home_admin.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';

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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    Future.delayed(const Duration(seconds: 2), () {
      _controller.forward().then((_) {
        _navigateToNextScreen();
      });
    });
  }

  void _navigateToNextScreen() {
    Widget nextScreen;

    if (widget.isLoggedIn) {
      switch (widget.userType) {
        case 'Admin':
          nextScreen = const HomeAdminScreen1();
          break;
        case 'Student':
          nextScreen = const BottomNavBarStudent();
          break;
        case 'Employee':
          nextScreen = const BottomNavBarEmployee();
          break;
        default:
          nextScreen = const SignInScreen();
      }
    } else {
      nextScreen = const SignInScreen();
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation1,
            Animation<double> animation2) {
          return FadeTransition(
            opacity: animation1,
            child: nextScreen,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
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
