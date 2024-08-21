import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:park_in/components/search_field.dart';
import 'package:park_in/components/text_area.dart';
import 'package:searchfield/searchfield.dart';

class HomeAdminScreen2 extends StatefulWidget {
  const HomeAdminScreen2({super.key});

  @override
  State<HomeAdminScreen2> createState() => _HomeAdminScreen2State();
}

class _HomeAdminScreen2State extends State<HomeAdminScreen2> {
  final TextEditingController _plateNumberCtrl = TextEditingController();
  final TextEditingController _vehicleTypeCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  void _onSuggestionTap(String suggestion) {
    setState(() {});
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
                  SizedBox(
                    height: 32.h,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 28.h,
                  ),
                  Text(
                    "Cite A Ticket",
                    style: TextStyle(
                      fontSize: 24.r,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  PRKFormField(
                    prefixIcon: Icons.pin_rounded,
                    labelText: "Plate Number",
                    controller: _plateNumberCtrl,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PRKFormField(
                    prefixIcon: Icons.bike_scooter_rounded,
                    labelText: "Vehicle Type",
                    controller: _vehicleTypeCtrl,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PRKSearchField(
                    prefixIcon: Icons.warning_rounded,
                    labelText: "Violation",
                    searchFieldListItems: [
                      SearchFieldListItem('Violation 1'),
                      SearchFieldListItem('Violation 2'),
                      SearchFieldListItem('Violation 3'),
                      SearchFieldListItem('Violation 4'),
                      SearchFieldListItem('Violation 5'),
                      SearchFieldListItem('Violation 6'),
                      SearchFieldListItem('Violation 7'),
                      SearchFieldListItem('Violation 8'),
                      SearchFieldListItem('Violation 9'),
                    ],
                    controller: _searchCtrl,
                    onTap: (text) {
                      _onSuggestionTap(text);
                    },
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PRKTextArea(
                    labelText: "Description",
                    controller: _descriptionCtrl,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Attachments",
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 12.r,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.attachment_rounded,
                          color: blackColor,
                          size: 24.r,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: PRKPrimaryBtn(
                  label: "Cite Ticket",
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
