import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/text_area.dart';

class AnnouncementAdminScreen extends StatefulWidget {
  const AnnouncementAdminScreen({super.key});

  @override
  State<AnnouncementAdminScreen> createState() =>
      _AnnouncementAdminScreenState();
}

class _AnnouncementAdminScreenState extends State<AnnouncementAdminScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  String? _selectedRadio;

  void postAnnouncement({
    required String title,
    required String userType,
    required String details,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('Announcement').add({
        'title': title,
        'userType': userType,
        'details': details,
        'createdAt': Timestamp.now(),
      });
      print('Announcement posted successfully');
      // Clear form fields after posting
      _titleCtrl.clear();
      _descriptionCtrl.clear();
      setState(() {
        _selectedRadio = null; // Reset selected radio button
      });
    } catch (e) {
      print('Failed to post announcement: $e');
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
                  SizedBox(
                    height: 32.h,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 28.h,
                  ),
                  Text(
                    "Create an Announcement",
                    style: TextStyle(
                      fontSize: 24.r,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  PRKFormField(
                    prefixIcon: Icons.campaign_rounded,
                    labelText: "Announcement Title",
                    controller: _titleCtrl,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "Select the Audience:",
                    style: TextStyle(
                      fontSize: 12.r,
                      color: blackColor,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Radio(
                            value: "Student",
                            groupValue: _selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadio = value as String?;
                              });
                            },
                          ),
                          Text(
                            "Student",
                            style: TextStyle(
                              fontSize: 12.r,
                              color: blackColor,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Radio(
                            value: "Employees",
                            groupValue: _selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadio = value as String?;
                              });
                            },
                          ),
                          Text(
                            "Employees",
                            style: TextStyle(
                              fontSize: 12.r,
                              color: blackColor,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Radio(
                            value: "Everyone",
                            groupValue: _selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadio = value as String?;
                              });
                            },
                          ),
                          Text(
                            "Everyone",
                            style: TextStyle(
                              fontSize: 12.r,
                              color: blackColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PRKTextArea(
                    labelText: "Details",
                    controller: _descriptionCtrl,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: PRKPrimaryBtn(
                  label: "Post",
                  onPressed: () {
                    if (_titleCtrl.text.isNotEmpty &&
                        _descriptionCtrl.text.isNotEmpty &&
                        _selectedRadio != null) {
                      String userType = _selectedRadio!;
                      postAnnouncement(
                        title: _titleCtrl.text,
                        userType: userType,
                        details: _descriptionCtrl.text,
                      );
                    } else {
                      print('Please fill in all fields');
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
