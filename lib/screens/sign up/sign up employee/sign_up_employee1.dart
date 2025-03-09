import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_in/screens/misc/image_viewer.dart';
import 'package:provider/provider.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/providers/user_data_provider.dart';

class SignUpEmployeeScreen1 extends StatefulWidget {
  final ValueChanged<bool> onFormValidityChanged;

  const SignUpEmployeeScreen1({
    Key? key,
    required this.onFormValidityChanged,
  }) : super(key: key);

  @override
  State<SignUpEmployeeScreen1> createState() => SignUpEmployeeScreen1State();
}

class SignUpEmployeeScreen1State extends State<SignUpEmployeeScreen1> {
  late TextEditingController _nameCtrl;
  late TextEditingController _userNumberCtrl;
  File? _selectedImage;

  bool off = false;

  @override
  void initState() {
    super.initState();
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;
    _nameCtrl = TextEditingController(text: userData.name ?? '');
    _userNumberCtrl = TextEditingController(text: userData.userNumber ?? '');

    // Listen for changes and update user data
    _nameCtrl.addListener(_onFieldChanged);
    _userNumberCtrl.addListener(_onFieldChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFormValidity();
    });
  }

  void _onFieldChanged() {
    Provider.of<UserDataProvider>(context, listen: false).updateUserData(
      name: _nameCtrl.text,
      userNumber: _userNumberCtrl.text,
    );
    _checkFormValidity();
  }

  void _checkFormValidity() {
    final isValid =
        _nameCtrl.text.isNotEmpty && _userNumberCtrl.text.isNotEmpty;
    widget.onFormValidityChanged(isValid); // Notify parent about form validity
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _userNumberCtrl.dispose();
    super.dispose();
  }

  bool isFormValid() {
    return _nameCtrl.text.isNotEmpty && _userNumberCtrl.text.isNotEmpty;
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
                    controller: _nameCtrl,
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
                    labelText: "Employee Number",
                    controller: _userNumberCtrl,
                    helperText: "Ex: 202100228",
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                  ),
                  SizedBox(height: 12.h),
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
                              _pickImage();
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
                  // Row(
                  //   children: [
                  //     Switch(
                  //       value: off,
                  //       inactiveThumbColor: blackColor,
                  //       inactiveTrackColor: whiteColor,
                  //       activeTrackColor: blueColor,
                  //       activeColor: whiteColor,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           off = value;
                  //         });
                  //       },
                  //     ),
                  //     SizedBox(width: 12.w),
                  //     Text(
                  //       "I have a reserved parking space",
                  //       style: TextStyle(
                  //         fontSize: 12.r,
                  //         color: blackColor,
                  //       ),
                  //     )
                  //   ],
                  // ),
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
                        "Your employee number is permanent, please double check it.",
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
