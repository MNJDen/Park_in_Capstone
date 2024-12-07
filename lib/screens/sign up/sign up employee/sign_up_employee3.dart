import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:searchfield/searchfield.dart';
import 'package:provider/provider.dart';
import 'package:park_in/providers/user_data_provider.dart';

class SignUpEmployeeScreen3 extends StatefulWidget {
  const SignUpEmployeeScreen3({super.key});

  @override
  State<SignUpEmployeeScreen3> createState() => _SignUpEmployeeScreen3State();
}

class _SignUpEmployeeScreen3State extends State<SignUpEmployeeScreen3> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    // Initialize focus node
    _focusNode = FocusNode()..addListener(_onFocusChange);

    // Get the stored department from the provider and set it in the search controller
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;
    _searchController.text = userData.department ?? '';
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
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
                child: SearchField<dynamic>(
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
                        width: 0.1.w,
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
                    selectionColor: blueColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                  offset: const Offset(0, 50),
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
                  dynamicHeight: true,
                  maxSuggestionBoxHeight: 185.h,
                  textCapitalization: TextCapitalization.sentences,
                  onSuggestionTap: (SearchFieldListItem<dynamic> item) {
                    setState(() {
                      _searchController.text = item.searchKey;
                    });

                    // Update the department in the provider
                    Provider.of<UserDataProvider>(context, listen: false)
                        .updateUserData(department: item.searchKey);
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
