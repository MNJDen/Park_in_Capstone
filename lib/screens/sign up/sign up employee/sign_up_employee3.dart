import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/field/search_field.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:searchfield/searchfield.dart';
import 'package:provider/provider.dart';
import 'package:park_in/providers/user_data_provider.dart';

class SignUpEmployeeScreen3 extends StatefulWidget {
  final ValueChanged<bool> onFormValidityChanged;

  const SignUpEmployeeScreen3({Key? key, required this.onFormValidityChanged})
      : super(key: key);

  @override
  State<SignUpEmployeeScreen3> createState() => SignUpEmployeeScreen3State();
}

class SignUpEmployeeScreen3State extends State<SignUpEmployeeScreen3> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFocused = false;
  late FocusNode _focusNode;

  void _onSuggestionTap(String suggestion) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Initialize focus node
    _focusNode = FocusNode()..addListener(_onFocusChange);

    // Get the stored department from the provider and set it in the search controller
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;
    _searchController.text = userData.department ?? '';

    _searchController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    Provider.of<UserDataProvider>(context, listen: false)
        .updateUserData(department: _searchController.text);
    _checkFormValidity();
  }

  void _checkFormValidity() {
    final isValid = _searchController.text.isNotEmpty;
    widget.onFormValidityChanged(isValid); // Notify parent about form validity
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

  bool isFormValid() {
    return _searchController.text.isNotEmpty;
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
              PRKSearchField(
                prefixIcon: Icons.apartment_rounded,
                labelText: "Department Type",
                searchFieldListItems: [
                  SearchFieldListItem(
                      child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "English Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),
                      'English Department'),
                  SearchFieldListItem(
                      child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Math Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),
                      'Math Department'),
                  SearchFieldListItem(
                    child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Natural Science Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Natural Science Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Media Studies Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Media Studies Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "P.E. Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'P.E. Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Philosophy Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Philosophy Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Psychology Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Psychology Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Social Science Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Social Science Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Theology Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Theology Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Business Management Courses",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Business Management Courses'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Allied Business Courses",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Allied Business Courses'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Computer Science Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Computer Science Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "DACA Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'DACA Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "Education Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'Education Department'),
                  SearchFieldListItem(child: Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Text(
                          "ECE/CoE Department",
                          style: TextStyle(
                            fontSize: 12.r,
                            color: blackColor,
                          ),
                        ),
                      ),'ECE/CoE Department'),
                ],
                controller: _searchController,
                onTap: (text) {
                  _onSuggestionTap(text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
