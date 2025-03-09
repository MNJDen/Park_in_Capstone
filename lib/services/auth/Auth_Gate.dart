import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_employee.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_student.dart';
import 'package:park_in/screens/misc/verification.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatefulWidget {
  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _userType;
  String? _verificationStatus;

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
      final userId = prefs.getString('userId');

      if (userId != null) {
        final verificationStatus =
            await _getVerificationStatus(userId, userType);
        print("User Verification Status: $verificationStatus");

        setState(() {
          _userType = userType;
          _verificationStatus = verificationStatus;
        });
      }
    }
  }

  Future<String?> _getVerificationStatus(
      String userId, String? userType) async {
    try {
      if (userType == 'Student' || userType == 'Employee') {
        final doc = await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .get();
        if (doc.exists) {
          return doc['status'];
        }
      }
    } catch (e) {
      print("Error fetching verification status: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_userType == null || _verificationStatus == null) {
      return const SignInScreen();
    } else if (_verificationStatus == 'non-verified') {
      return const NonVerified();
    } else if (_userType == 'Student') {
      return const BottomNavBarStudent();
    } else if (_userType == 'Employee') {
      return const BottomNavBarEmployee();
    } else {
      return const SignInScreen();
    }
  }
}
