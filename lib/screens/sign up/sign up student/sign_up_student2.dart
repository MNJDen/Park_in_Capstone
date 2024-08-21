import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class SignUpStudentScreen2 extends StatefulWidget {
  const SignUpStudentScreen2({super.key});

  @override
  State<SignUpStudentScreen2> createState() => _SignUpStudentScreen2State();
}

class _SignUpStudentScreen2State extends State<SignUpStudentScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  String initialCountry = 'PH';
  PhoneNumber number = PhoneNumber(isoCode: 'PH');
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;
    _controller = TextEditingController(text: userData.phoneNumber ?? '');
    _focusNode = FocusNode()..addListener(_onFocusChange);

    // Add listener to update the phone number in UserDataProvider
    _controller.addListener(() {
      Provider.of<UserDataProvider>(context, listen: false)
          .updateUserData(phoneNumber: _controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
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
                "What’s your number?",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 24.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "This will serve as an additional means to notify you of any violations.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(height: 32.h),
              Form(
                key: _formKey,
                child: InternationalPhoneNumberInput(
                  textStyle: TextStyle(fontSize: 12.r),
                  selectorTextStyle: TextStyle(fontSize: 12.r),
                  searchBoxDecoration: InputDecoration(
                    label: Text(
                      "Search for your country",
                      style: TextStyle(fontSize: 14.r),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 0.5.w,
                        color: borderBlack,
                      ),
                    ),
                  ),
                  focusNode: _focusNode,
                  onInputChanged: (PhoneNumber number) {
                    // Update the phone number in the provider whenever it changes
                    Provider.of<UserDataProvider>(context, listen: false)
                        .updateUserData(phoneNumber: number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    trailingSpace: true,
                    useBottomSheetSafeArea: true,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  initialValue: number,
                  textFieldController: _controller,
                  formatInput: true,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputDecoration: InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 1.w,
                        color: blueColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 0.5.w,
                        color: borderBlack,
                      ),
                    ),
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      fontSize: 12.r,
                      color: _isFocused ? blueColor : blackColor,
                    ),
                  ),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
