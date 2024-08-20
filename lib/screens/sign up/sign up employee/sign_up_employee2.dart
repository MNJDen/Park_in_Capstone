import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpEmployeeScreen2 extends StatefulWidget {
  const SignUpEmployeeScreen2({super.key});

  @override
  State<SignUpEmployeeScreen2> createState() => _SignUpEmployeeScreen2State();
}

class _SignUpEmployeeScreen2State extends State<SignUpEmployeeScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String initialCountry = 'PH';
  PhoneNumber number = PhoneNumber(isoCode: 'PH');
  bool _isFocused = false;
  late FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void dispose() {
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
              SizedBox(
                height: 28.h,
              ),
              Text(
                "What’s your number?",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 24.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "This will serve as an additional means to notify you of any violations.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Form(
                key: _formKey,
                child: InternationalPhoneNumberInput(
                  textStyle: TextStyle(fontSize: 12.r),
                  selectorTextStyle: TextStyle(fontSize: 12.r),
                  searchBoxDecoration: InputDecoration(
                    label: Text(
                      "Search for your country",
                      style: TextStyle(
                        fontSize: 14.r,
                      ),
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
                    print(number.phoneNumber);
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
