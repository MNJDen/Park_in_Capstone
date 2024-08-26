import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_in/components/bottom_nav_bar_employee.dart';
import 'package:park_in/components/bottom_nav_bar_student.dart';
import 'package:park_in/screens/home%20admin/home_admin.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatefulWidget {
  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _userType;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final userType = prefs.getString('userType');
      setState(() {
        _userType = userType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userType == null) {
      return const SignInScreen(); // Or another initial screen
    } else if (_userType == 'Admin') {
      return const HomeAdminScreen1();
    } else if (_userType == 'Student') {
      return const BottomNavBarStudent();
    } else if (_userType == 'Employee') {
      return const BottomNavBarEmployee();
    } else {
      return const SignInScreen();
    }
  }
}
