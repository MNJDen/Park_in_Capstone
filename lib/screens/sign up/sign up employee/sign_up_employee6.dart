import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/components/theme/color_scheme.dart';
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
      Provider.of<UserDataProvider>(context, listen: false)
          .updateUserData(imageFile: File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = Provider.of<UserDataProvider>(context).userData.imageFile;

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
                "Upload an image with that charming face of yours. Please upload images that are in 4:3 or 5:4 aspect ratios, or ensure that your face is centered for optimal results.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 77.r,
                    backgroundColor: whiteColor,
                    child: imageUrl == null
                        ? Icon(
                            Icons.image_rounded,
                            color: blackColor,
                            size: 25.r,
                          )
                        : ClipOval(
                            child: Image.file(
                              imageUrl,
                              width: 154.r,
                              height: 154.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Center(
                child: TextButton(
                  onPressed: _pickImage,
                  child: Text(
                    imageUrl == null
                        ? "Upload Profile Picture"
                        : "Change Picture",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 12.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
