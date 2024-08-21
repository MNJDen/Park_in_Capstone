import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_in/components/bottom_nav_bar_admin.dart';
import 'package:park_in/screens/home%20admin/home_admin1.dart';
import 'package:park_in/screens/sign%20in/sign_in_student_employee.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeAdminScreen1();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
