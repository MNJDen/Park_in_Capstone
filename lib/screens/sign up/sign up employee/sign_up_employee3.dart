import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    SearchFieldListItem('College of Business and Accountancy'),
                    SearchFieldListItem('College of Computer Studies'),
                    SearchFieldListItem('College of Education'),
                    SearchFieldListItem(
                        'College of Humanities and Social Sciences'),
                    SearchFieldListItem('College of Law'),
                    SearchFieldListItem('College of Nursing'),
                    SearchFieldListItem(
                        'College of Science, Engineering, and Acrhitecture'),
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
