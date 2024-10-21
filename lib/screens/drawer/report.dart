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
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _plateNumberCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  String? _selectedRadio;
  File? _selectedImage;
  bool _isReporting = false;

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
      backgroundColor: whiteColor,
      showDragHandle: true,
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

  // Method to clear the selected image
  void _clearImage() {
    setState(() {
      _selectedImage = null; // Clear the selected image
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
    if (_selectedRadio == null) {
      errorSnackbar(context, "Choose if you want to anonymously report or no");
      return;
    } else if (_plateNumberCtrl.text.isEmpty) {
      errorSnackbar(
          context, "Provide the vehicle's plate number for the report");
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

    // Fetch current user's details if the selected radio is "No"
    String? name;
    String? userNumber;
    String? userType;
    String reporterName = "Anonymous";

    if (_selectedRadio == 'No') {
      final userId = await _getUserId();
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('User ')
            .doc(userId)
            .get();
        name = userDoc['name'];
        userNumber = userDoc['userNumber'];
        userType = userDoc['userType'];

        reporterName = name!;
      }
    }

    // Handle image upload if an image is selected
    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    // Prepare the report data
    final reportData = {
      'reportedPlateNumber': _plateNumberCtrl.text,
      'reportDescription': _descriptionCtrl.text,
      'image_url': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'reporterName': reporterName,
    };

    // Include user details if the report is not anonymous
    if (_selectedRadio == 'No' &&
        name != null &&
        userNumber != null &&
        userType != null) {
      reportData.addAll({
        'universityRole': userType,
        'reporterUser Number': userNumber,
      });
    }

    // Fetch the current number of incident reports to generate the document ID
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Incident Report')
        .orderBy('timestamp', descending: false)
        .get();

    final int reportCount = snapshot.docs.length;
    final String newDocId = 'IR${(reportCount + 1).toString().padLeft(3, '0')}';

    try {
      // Add the report to Firestore
      await FirebaseFirestore.instance
          .collection('Incident Report')
          .doc(newDocId)
          .set(reportData);

      _plateNumberCtrl.clear();
      _descriptionCtrl.clear();
      _clearImage();
      setState(() {
        _selectedRadio = null; // Reset selected radio button
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
                              "Report an Incident",
                              style: TextStyle(
                                fontSize: 20.r,
                                color: blueColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Send it as anonymous?",
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
                                  value: "Yes",
                                  groupValue: _selectedRadio,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRadio = value as String?;
                                    });
                                  },
                                ),
                                Text(
                                  "Yes",
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
                                  value: "No",
                                  groupValue: _selectedRadio,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRadio = value as String?;
                                    });
                                  },
                                ),
                                Text(
                                  "No",
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
                          prefixIcon: Icons.pin_rounded,
                          labelText: "Plate Number",
                          controller: _plateNumberCtrl,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        PRKTextArea(
                          labelText: "Details",
                          controller: _descriptionCtrl,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
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
                        SizedBox(
                          height: 8.h,
                        ),
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
                                    ? Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
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
                                              icon: Icon(
                                                Icons.image_rounded,
                                                color: blackColor,
                                                size: 20.r,
                                              ),
                                            ),
                                            Text(
                                              "Tap to upload an image",
                                              style: TextStyle(
                                                color: blackColor,
                                                fontSize: 12.r,
                                              ),
                                            ),
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
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.h),
                      child: PRKPrimaryBtn(
                        label: "Report",
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
