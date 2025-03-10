import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'dart:io';

class SignUpEmployeeScreen6 extends StatefulWidget {
  final ValueChanged<bool> onFormValidityChanged;

  const SignUpEmployeeScreen6({
    Key? key,
    required this.onFormValidityChanged,
  }) : super(key: key);

  @override
  State<SignUpEmployeeScreen6> createState() => SignUpEmployeeScreen6State();
}

class SignUpEmployeeScreen6State extends State<SignUpEmployeeScreen6> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;
    print('Before Upload - Proof Path: ${userData.imagePath}');
    _checkFormValidity();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      Provider.of<UserDataProvider>(context, listen: false)
          .updateUserData(imageFile: File(image.path));
      _checkFormValidity();
    }
  }

  void _removeImage() {
    Provider.of<UserDataProvider>(context, listen: false)
        .updateUserData(imageFile: null);
    print(
        'Current imageFile after removal: ${Provider.of<UserDataProvider>(context, listen: false).userData.imageFile}');
    _checkFormValidity();
  }

  void _checkFormValidity() {
    final imageFile = Provider.of<UserDataProvider>(context, listen: false)
        .userData
        .imageFile;
    bool isValid = imageFile != null;
    widget.onFormValidityChanged(isValid);
  }

  bool isFormValid() {
    final imageFile = Provider.of<UserDataProvider>(context, listen: false)
        .userData
        .imageFile;
    return imageFile != null;
  }

  Future<void> _showImageSourceOption() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
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

    if (source != null) {
      await _pickImage(source);
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
                                  onPressed: _showImageSourceOption,
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
