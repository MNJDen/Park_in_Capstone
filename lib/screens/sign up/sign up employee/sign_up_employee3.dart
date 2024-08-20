import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:searchfield/searchfield.dart';

class SignUpEmployeeScreen3 extends StatefulWidget {
  const SignUpEmployeeScreen3({super.key});

  @override
  State<SignUpEmployeeScreen3> createState() => _SignUpEmployeeScreen3State();
}

class _SignUpEmployeeScreen3State extends State<SignUpEmployeeScreen3> {
  final TextEditingController _searchController = TextEditingController();

  bool _isFocused = false;

  late FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onSuggestionTap(String suggestion) {
    setState(() {});
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
                "What department are you?",
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
                "By choosing your department, you will receive messages and announcements from your corresponding dean.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Material(
                child: SearchField(
                  focusNode: _focusNode,
                  searchInputDecoration: InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon: Icon(
                      size: 20,
                      Icons.apartment_rounded,
                      color: _isFocused ? blueColor : blackColor,
                    ),
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
                    labelText: "Search Department",
                    labelStyle: TextStyle(
                      fontSize: 12.r,
                      color: _isFocused ? blueColor : blackColor,
                    ),
                  ),
                  suggestionStyle: TextStyle(
                    fontSize: 12.r,
                    color: blackColor,
                  ),
                  suggestionsDecoration: SuggestionDecoration(
                      elevation: 15,
                      color: whiteColor,
                      selectionColor: Color.fromRGBO(45, 49, 250, 0.2),
                      borderRadius: BorderRadius.circular(10)),
                  searchStyle: TextStyle(
                    fontSize: 12.r,
                    color: blackColor,
                  ),
                  scrollbarDecoration: ScrollbarDecoration(
                    thumbColor: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  offset: Offset(0, 55),
                  controller: _searchController,
                  suggestions: [
                    SearchFieldListItem('Department 1'),
                    SearchFieldListItem('Department 2'),
                    SearchFieldListItem('Department 3'),
                    SearchFieldListItem('Department 4'),
                    SearchFieldListItem('Department 5'),
                    SearchFieldListItem('Department 6'),
                    SearchFieldListItem('Department 7'),
                    SearchFieldListItem('Department 8'),
                    SearchFieldListItem('Department 9'),
                  ],
                  maxSuggestionsInViewPort: 6,
                  itemHeight: 40,
                  onTap: () {
                    _onSuggestionTap(_searchController.text);
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
