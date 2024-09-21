import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/components/field/text_area.dart';

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromRGBO(217, 255, 214, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromRGBO(20, 255, 0, 1),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: const Color.fromRGBO(20, 255, 0, 1),
                size: 20.r,
              ),
              SizedBox(
                width: 8.w,
              ),
              Flexible(
                child: Text(
                  "Announcement successfully posted",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      _titleCtrl.clear();
      _descriptionCtrl.clear();
      setState(() {
        _selectedRadio = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 255, 226, 226),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromRGBO(255, 0, 0, 1),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: const Color.fromRGBO(255, 0, 0, 1),
                size: 20.r,
              ),
              SizedBox(
                width: 8.w,
              ),
              Flexible(
                child: Text(
                  "Error Occured: $e",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
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
                    height: 20.h,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
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
                      ),
                      Text(
                        "Create an Announcement",
                        style: TextStyle(
                          fontSize: 20.r,
                          color: blueColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32.h,
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
                            value: "Employee",
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: MediaQuery.of(context).size.width * 0.95,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 226, 226),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Color.fromRGBO(255, 0, 0, 1),
                            ),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: const Color.fromRGBO(255, 0, 0, 1),
                                size: 20.r,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Flexible(
                                child: Text(
                                  "Fill out all of the fields",
                                  style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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
