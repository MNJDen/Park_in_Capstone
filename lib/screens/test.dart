import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:park_in/components/secondary_btn.dart';

class testScreen extends StatefulWidget {
  const testScreen({super.key});

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> {
  final TextEditingController _userNumber = TextEditingController();

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
              
            ],
          ),
        ),
      ),
    );
  }
}
