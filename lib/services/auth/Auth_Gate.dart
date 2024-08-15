import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_in/screens/sign in/sign_in_admin.dart';
import 'package:park_in/screens/test.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const testScreen();
          } else {
            return const SignInAdminScreen();
          }
        },
      ),
    );
  }
}
