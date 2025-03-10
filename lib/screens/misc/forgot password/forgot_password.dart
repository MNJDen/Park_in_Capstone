import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/screens/misc/forgot%20password/reset_password.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailCtrl;
  late TextEditingController _userNumberCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;

    _userNumberCtrl = TextEditingController(text: userData.userNumber ?? '');
    _emailCtrl = TextEditingController(text: userData.email ?? '');
  }

  Future<void> _validateUser() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    String email = _emailCtrl.text.trim();
    String userNumber = _userNumberCtrl.text.trim();

    if (email.isEmpty || userNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter both email and user number.")),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('email', isEqualTo: email)
          .where('userNumber', isEqualTo: userNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId =
            querySnapshot.docs.first.id; // Get the docID from Firestore

        if (mounted) {
          Navigator.push(
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
                    child: ResetPasswordScreen(userId: userId),
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No matching account found.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error checking user: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: blackColor,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    "Forgot Your Password?",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 24.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Enter your email and student/employee number to trace your account.",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12.r,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  PRKFormField(
                    prefixIcon: Icons.alternate_email_rounded,
                    labelText: "Email",
                    controller: _emailCtrl,
                    isCapitalized: true,
                  ),
                  SizedBox(height: 12.h),
                  PRKFormField(
                    prefixIcon: Icons.person_rounded,
                    labelText: "Student/Employee Number",
                    controller: _userNumberCtrl,
                    isCapitalized: true,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 50.h),
                child: PRKPrimaryBtn(
                  label: _isLoading ? "Checking..." : "Continue",
                  onPressed: () => _validateUser(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
