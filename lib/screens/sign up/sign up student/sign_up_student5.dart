import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'dart:io';

class SignUpStudentScreen5 extends StatefulWidget {
  final ValueChanged<bool> onFormValidityChanged;

  const SignUpStudentScreen5({
    Key? key,
    required this.onFormValidityChanged,
  }) : super(key: key);

  @override
  State<SignUpStudentScreen5> createState() => SignUpStudentScreen5State();
}

class SignUpStudentScreen5State extends State<SignUpStudentScreen5> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkFormValidity(); // Initialize the form validity when the screen is loaded
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Provider.of<UserDataProvider>(context, listen: false)
          .updateUserData(imageFile: File(image.path));
      _checkFormValidity();
    }
  }

  void _removeImage() {
    Provider.of<UserDataProvider>(context, listen: false)
        .updateUserData(imageFile: null);
    //debug
    print(
        'Current imageFile after removal: ${Provider.of<UserDataProvider>(context, listen: false).userData.imageFile}');
    _checkFormValidity();
  }

  void _checkFormValidity() {
    final imageFile = Provider.of<UserDataProvider>(context, listen: false)
        .userData
        .imageFile;
    bool isValid = imageFile != null; // Valid if an image is picked
    widget.onFormValidityChanged(isValid); // Notify parent about form validity
  }

  bool isFormValid() {
    // Check if an image file has been picked
    final imageFile = Provider.of<UserDataProvider>(context, listen: false)
        .userData
        .imageFile;
    return imageFile != null; // Valid if an image is picked
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
                "Upload an image with that charming face of yours. Images that are in 4:3 or 5:4 aspect ratios, or ensure that your face is centered for optimal results.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(height: 32.h),
              Center(
                child: Stack(
                  children: [
                    Consumer<UserDataProvider>(
                      builder: (context, userDataProvider, child) {
                        final imageUrl = userDataProvider.userData.imageFile;
                        return CircleAvatar(
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
                        );
                      },
                    ),
                    Consumer<UserDataProvider>(
                      builder: (context, userDataProvider, child) {
                        final imageUrl = userDataProvider.userData.imageFile;
                        return imageUrl == null
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: _pickImage,
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(blueColor),
                                    side: WidgetStatePropertyAll(
                                      BorderSide(
                                        width: 1,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add_rounded,
                                    color: whiteColor,
                                    size: 20.r,
                                  ),
                                  splashRadius: 20.r,
                                ),
                              )
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: _removeImage,
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(blackColor),
                                    side: WidgetStatePropertyAll(
                                      BorderSide(
                                        width: 1,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: whiteColor,
                                    size: 20.r,
                                  ),
                                  splashRadius: 20.r,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
