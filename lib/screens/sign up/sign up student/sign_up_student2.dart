import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class SignUpStudentScreen2 extends StatefulWidget {
  final ValueChanged<bool> onFormValidityChanged;

  const SignUpStudentScreen2({
    Key? key,
    required this.onFormValidityChanged,
  }) : super(key: key);

  @override
  State<SignUpStudentScreen2> createState() => SignUpStudentScreen2State();
}

class SignUpStudentScreen2State extends State<SignUpStudentScreen2> {
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
    _controller.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    Provider.of<UserDataProvider>(context, listen: false)
        .updateUserData(phoneNumber: _controller.text);
    _checkFormValidity();
  }

  void _checkFormValidity() {
    final isValid = _controller.text.isNotEmpty;
    widget.onFormValidityChanged(isValid); // Notify parent about form validity
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

  bool isFormValid() {
    return _controller.text.isNotEmpty;
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
                  textStyle: TextStyle(
                    fontSize: 12.r,
                  ),
                  selectorTextStyle: TextStyle(
                    fontSize: 12.r,
                  ),
                  spaceBetweenSelectorAndTextField: 0,
                  maxLength: 12,
                  searchBoxDecoration: InputDecoration(
                    label: Text(
                      "Search for your country",
                      style: TextStyle(fontSize: 14.r),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 0.1.w,
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
                    if (value) {
                      print(value);
                    }
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    trailingSpace: true,
                    useBottomSheetSafeArea: true,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  initialValue: number,
                  textFieldController: _controller,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
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
                        width: 0.1.w,
                        color: borderBlack,
                      ),
                    ),
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      fontSize: 12.r,
                      color: _isFocused ? blueColor : blackColor,
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
