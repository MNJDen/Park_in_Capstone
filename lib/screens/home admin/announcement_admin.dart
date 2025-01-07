import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/snackbar/success_snackbar.dart';
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
  bool _isPostingAnnouncement = false;

  void postAnnouncement({
    required String title,
    required String userType,
    required String details,
  }) async {
    setState(() {
      _isPostingAnnouncement = true;
    });

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Announcement')
        .orderBy('createdAt', descending: false)
        .get();

    final int announcementCount = snapshot.docs.length;
    final String newDocId =
        'AN${(announcementCount + 1).toString().padLeft(3, '0')}';

    try {
      final userDocument =
          FirebaseFirestore.instance.collection('Announcement').doc(newDocId);

      await userDocument.set({
        'title': title,
        'userType': userType,
        'details': details,
        'createdAt': Timestamp.now(),
      });

      successSnackbar(context, "Announcement successfully posted");

      _titleCtrl.clear();
      _descriptionCtrl.clear();
      setState(() {
        _selectedRadio = null;
      });
    } catch (e) {
      errorSnackbar(context, "Error Occurred: $e");
    } finally {
      setState(() {
        _isPostingAnnouncement = false;
      });
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
          child: _isPostingAnnouncement
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.waveDots(
                        color: blueColor,
                        size: 50.r,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "Posting, wait a moment...",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor.withOpacity(0.8),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
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
                        Text(
                          "Select the audience:",
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
                        PRKFormField(
                          prefixIcon: Icons.campaign_rounded,
                          labelText: "Announcement Title",
                          controller: _titleCtrl,
                          isCapitalized: true,
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
                            errorSnackbar(context, "Please fill in all fields");
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
