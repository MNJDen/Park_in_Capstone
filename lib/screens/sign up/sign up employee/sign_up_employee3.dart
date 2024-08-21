import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/search_field.dart';
import 'package:searchfield/searchfield.dart';

class SignUpEmployeeScreen3 extends StatefulWidget {
  const SignUpEmployeeScreen3({super.key});

  @override
  State<SignUpEmployeeScreen3> createState() => _SignUpEmployeeScreen3State();
}

class _SignUpEmployeeScreen3State extends State<SignUpEmployeeScreen3> {
  final TextEditingController _searchController = TextEditingController();

  void _onSuggestionTap(String suggestion) {
    setState(() {});
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
              SizedBox(
                height: 28.h,
              ),
              Text(
                "What department are you?",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 24.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "By choosing your department, you will receive messages and announcements from your corresponding dean.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              PRKSearchField(
                prefixIcon: Icons.apartment_rounded,
                labelText: "Search Department",
                searchFieldListItems: [
                  SearchFieldListItem('Department 1'),
                  SearchFieldListItem('Department 2'),
                  SearchFieldListItem('Department 3'),
                  SearchFieldListItem('Department 4'),
                  SearchFieldListItem('Department 5'),
                  SearchFieldListItem('Department 6'),
                  SearchFieldListItem('Department 7'),
                  SearchFieldListItem('Department 8'),
                  SearchFieldListItem('Department 9'),
                ],
                controller: _searchController,
                onTap: (text) {
                  _onSuggestionTap(text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
