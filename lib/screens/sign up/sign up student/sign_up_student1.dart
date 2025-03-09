import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/screens/misc/image_viewer.dart';
import 'package:provider/provider.dart';

class SignUpStudentScreen1 extends StatefulWidget {
  final ValueChanged<bool> onFormValidityChanged;

  const SignUpStudentScreen1({
    Key? key,
    required this.onFormValidityChanged,
  }) : super(key: key);

  @override
  State<SignUpStudentScreen1> createState() => SignUpStudentScreen1State();
}

class SignUpStudentScreen1State extends State<SignUpStudentScreen1> {
  late TextEditingController _emailCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _userNumberCtrl;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;

    _nameCtrl = TextEditingController(text: userData.name ?? '');
    _emailCtrl = TextEditingController(text: userData.email ?? '');
    _userNumberCtrl = TextEditingController(text: userData.userNumber ?? '');

    if (userData.imagePath != null && userData.imagePath!.isNotEmpty) {
      _selectedImage = File(userData.imagePath!);
    }

    // Listen for changes and update user data
    _nameCtrl.addListener(_onFieldChanged);
    _userNumberCtrl.addListener(_onFieldChanged);
    _emailCtrl.addListener(_onFieldChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFormValidity();
    });
  }

  void _onFieldChanged() {
    Provider.of<UserDataProvider>(context, listen: false).updateUserData(
      name: _nameCtrl.text,
      userNumber: _userNumberCtrl.text,
      email: _emailCtrl.text,
    );
    _checkFormValidity();
  }

  void _checkFormValidity() {
    final isValid = _nameCtrl.text.isNotEmpty &&
        _userNumberCtrl.text.isNotEmpty &&
        _selectedImage != null;
    widget.onFormValidityChanged(isValid); // Notify parent about form validity
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      Provider.of<UserDataProvider>(context, listen: false)
          .updateUserData(imagePath: image.path);
    }
    _checkFormValidity();
  }

  Future<void> _showImageSourceOptions() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      backgroundColor: whiteColor,
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

    if (source != null) {
      await _pickImage(source);
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });

    Provider.of<UserDataProvider>(context, listen: false)
        .updateUserData(imagePath: null);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _userNumberCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  bool isFormValid() {
    return _nameCtrl.text.isNotEmpty &&
        _userNumberCtrl.text.isNotEmpty &&
        _selectedImage != null;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 28.h),
                  Text(
                    "Who are you?",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 24.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Feel free to enter your preferred nickname. This will be the name we will use to address you.",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12.r,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  PRKFormField(
                    prefixIcon: Icons.alternate_email_rounded,
                    labelText: "Email",
                    controller: _emailCtrl,
                    isCapitalized: true,
                  ),
                  SizedBox(height: 12.h),
                  PRKFormField(
                    prefixIcon: Icons.person_rounded,
                    labelText: "Name",
                    controller: _nameCtrl,
                    isCapitalized: true,
                  ),
                  SizedBox(height: 12.h),
                  PRKFormField(
                    prefixIcon: Icons.badge_rounded,
                    labelText: "Student Number",
                    controller: _userNumberCtrl,
                    helperText: "Ex: 202100153",
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Attachment: ",
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 12.r,
                        ),
                      ),
                      Tooltip(
                        padding: EdgeInsets.all(12.r),
                        enableFeedback: true,
                        showDuration: const Duration(seconds: 3),
                        textStyle: TextStyle(
                          fontSize: 12.r,
                          color: whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        message: "Your ID will be used to verify your account.",
                        triggerMode: TooltipTriggerMode.tap,
                        child: const Icon(
                          Icons.help_outline_rounded,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      color: blueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: blueColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: _selectedImage != null
                                  ? GestureDetector(
                                      onTap: () {
                                        if (_selectedImage != null) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ImageViewer(
                                                imagePath: _selectedImage!.path,
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
                                  : Icon(
                                      Icons.image,
                                      color: blackColor.withOpacity(0.5),
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Image of your ID",
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 12.r,
                                ),
                              ),
                              Text(
                                "(Front)",
                                style: TextStyle(
                                  color: blackColor.withOpacity(0.5),
                                  fontSize: 10.r,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              _showImageSourceOptions();
                            },
                            icon: Icon(
                              _selectedImage != null
                                  ? Icons.highlight_remove_rounded
                                  : Icons.file_upload_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_rounded,
                      color: blackColor,
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Flexible(
                      child: Text(
                        "Your student number is permanent, please double check it.",
                        softWrap: true,
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 12.r,
                        ),
                      ),
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
