import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    helperText: "Ex: 202100153",
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                  ),
                  SizedBox(height: 12.h),
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
