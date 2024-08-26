import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/components/color_scheme.dart';
import 'dart:io';

class SignUpEmployeeScreen6 extends StatefulWidget {
  const SignUpEmployeeScreen6({super.key});

  @override
  State<SignUpEmployeeScreen6> createState() => _SignUpEmployeeScreen6State();
}

class _SignUpEmployeeScreen6State extends State<SignUpEmployeeScreen6> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Update the provider with the image URL
      Provider.of<UserDataProvider>(context, listen: false)
          .updateUserData(imageUrl: image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = Provider.of<UserDataProvider>(context).userData.imageUrl;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.h),
              Text(
                "What do you look like?",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 24.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Upload an image with that charming face of yours.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 164.h,
                    width: 154.h,
                    child: Card(
                      elevation: 15,
                      shadowColor: Color.fromRGBO(27, 27, 27, 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      color: whiteColor,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: imageUrl == null
                                  ? IconButton.filled(
                                      iconSize: 20.r,
                                      onPressed: _pickImage,
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(blueColor),
                                      ),
                                      icon: Icon(
                                        Icons.add_rounded,
                                        color: whiteColor,
                                      ),
                                    )
                                  : Image.file(File(imageUrl)),
                            ),
                            Text(
                              imageUrl == null
                                  ? "Upload a photo"
                                  : "Change photo",
                              style: TextStyle(
                                fontSize: 12.r,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}