import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
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
      // Handle error, e.g., show a Snackbar or log the error
      return null;
    }
  }

  Future<void> _citeReport() async {
    if (_selectedRadio == null) {
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
                  "Select one if you want to anonymously report or no",
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
      return;
    } else if (_plateNumberCtrl.text.isEmpty) {
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
                  "Provide the vehicle's plate number for the report",
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
      return;
    } else if (_descriptionCtrl.text.isEmpty) {
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
                  "Describe what is being reported",
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
      return;
    } else if (_selectedImage == null) {
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
                  "Upload images for evidence",
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
      return;
    }

    // Fetch current user's details if the selected radio is "No"
    String? name;
    String? userNumber;
    String? userType;
    if (_selectedRadio == 'No') {
      final userId = await _getUserId();
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('User')
            .doc(userId)
            .get();
        name = userDoc['name'];
        userNumber = userDoc['userNumber'];
        userType = userDoc['userType'];
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
      'anonymous': _selectedRadio ?? 'No',
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Include user details if the report is not anonymous
    if (_selectedRadio == 'No' &&
        name != null &&
        userNumber != null &&
        userType != null) {
      reportData.addAll({
        'universityRole': userType,
        'reporterName': name,
        'reporterUserNumber': userNumber,
      });
    }

    // Add the report to Firestore
    await FirebaseFirestore.instance
        .collection('Incident Report')
        .add(reportData);

    _plateNumberCtrl.clear();
    _descriptionCtrl.clear();
    _clearImage();
    setState(() {
      _selectedRadio = null; // Reset selected radio button
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Incident report submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
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
                          fontWeight: FontWeight.bold,
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
                        "Attachments",
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 12.r,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Icon(
                          Icons.attachment_rounded,
                          color: blackColor,
                          size: 24.r,
                        ),
                      )
                    ],
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Image.file(
                        _selectedImage!,
                        height: 100.h,
                        width: 100.h,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: PRKPrimaryBtn(
                  label: "Confirm",
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
