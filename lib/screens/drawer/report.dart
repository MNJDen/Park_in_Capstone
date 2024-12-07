import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/snackbar/success_snackbar.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/components/field/text_area.dart';
import 'package:park_in/screens/misc/image_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _plateNumberCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  File? _selectedImage;
  bool _isReporting = false;
  bool _isAnonymous = false; // Checkbox state

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final ImageSource? source = await _showImageSourceOption();
    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

  Future<ImageSource?> _showImageSourceOption() async {
    return await showModalBottomSheet<ImageSource>(
      backgroundColor: bgColor,
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            ListTile(
              dense: true,
              title: Text(
                "Choose a source: ",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: blackColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              dense: true,
              enableFeedback: true,
              title: Text(
                "Camera",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: blackColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
            ),
            ListTile(
              dense: true,
              enableFeedback: true,
              title: Text(
                "Gallery",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: blackColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('Incident Report Attachments')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> _citeReport() async {
    if (_plateNumberCtrl.text.isEmpty) {
      errorSnackbar(
        context,
        "Provide the vehicle's plate number for the report",
      );
      return;
    } else if (_plateNumberCtrl.text.length < 6) {
      errorSnackbar(context, "Invalid plate number");
      return;
    } else if (_descriptionCtrl.text.isEmpty) {
      errorSnackbar(context, "Describe what happened");
      return;
    } else if (_selectedImage == null) {
      errorSnackbar(context, "Upload an image for evidence");
      return;
    }

    setState(() {
      _isReporting = true;
    });

    String reporterName = "Anonymous";
    String? userNumber;
    String? userType;

    if (!_isAnonymous) {
      final userId = await _getUserId();
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .get();
        reporterName = userDoc['name'];
        userNumber = userDoc['userNumber'];
        userType = userDoc['userType'];
      }
    }

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    final reportData = {
      'reportedPlateNumber': _plateNumberCtrl.text,
      'reportDescription': _descriptionCtrl.text,
      'image_url': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'reporterName': reporterName,
    };

    if (!_isAnonymous && userNumber != null && userType != null) {
      reportData.addAll({
        'universityRole': userType,
        'reporterUserNumber': userNumber,
      });
    }

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Incident Report')
        .orderBy('timestamp', descending: false)
        .get();

    final int reportCount = snapshot.docs.length;
    final String newDocId = 'IR${(reportCount + 1).toString().padLeft(3, '0')}';

    try {
      await FirebaseFirestore.instance
          .collection('Incident Report')
          .doc(newDocId)
          .set(reportData);

      _plateNumberCtrl.clear();
      _descriptionCtrl.clear();
      _clearImage();
      setState(() {
        _isAnonymous = false;
      });
      successSnackbar(context, "Report submitted successfully");

      setState(() {
        _isReporting = false;
      });
    } catch (e) {
      errorSnackbar(context, "Failed to submit report");
      setState(() {
        _isReporting = false;
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
          child: _isReporting
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
                        "Reporting to authorities, wait a moment...",
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
                        SizedBox(height: 20.h),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: blackColor,
                                ),
                              ),
                            ),
                            Text(
                              "Report an Incident",
                              style: TextStyle(
                                fontSize: 20.r,
                                color: blueColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Send as Anonymous? (Optional)",
                              style: TextStyle(fontSize: 12.r),
                            ),
                            Checkbox(
                              value: _isAnonymous,
                              onChanged: (value) {
                                setState(() {
                                  _isAnonymous = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        PRKFormField(
                          prefixIcon: Icons.pin_rounded,
                          labelText: "Plate Number",
                          controller: _plateNumberCtrl,
                          maxLength: 7,
                          helperText: "Don't include the dash(-). Ex. ESX668",
                          isUpperCase: true,
                        ),
                        SizedBox(height: 12.h),
                        PRKTextArea(
                          labelText: "Details",
                          controller: _descriptionCtrl,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              "Attachment: ",
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 12.r,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: blueColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _selectedImage != null
                                    ? GestureDetector(
                                        onTap: () {
                                          if (_selectedImage != null) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                  imagePath:
                                                      _selectedImage!.path,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _pickImage();
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .add_photo_alternate_rounded,
                                                color: blackColor,
                                              ),
                                            ),
                                            Text(
                                              "Tap to upload an image",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: blackColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            if (_selectedImage != null)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton.filled(
                                  onPressed: _clearImage,
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(blackColor),
                                  ),
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: whiteColor,
                                    size: 20.r,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.h),
                      child: PRKPrimaryBtn(
                        label: "Submit",
                        onPressed: () {
                          _citeReport();
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
