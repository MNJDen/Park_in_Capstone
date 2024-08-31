import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreennState();
}

class _PersonalDetailsScreennState extends State<PersonalDetailsScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _userNumberCtrl = TextEditingController();
  final TextEditingController _phoneNumberCtrl = TextEditingController();

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
                height: 32.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
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
                  ),
                  Text(
                    "Personal Details",
                    style: TextStyle(
                      fontSize: 20.r,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 28.h,
              ),
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/images/AdNU_Logo.png",
                        height: 100.h,
                        width: 100.w,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Upload New Picture",
                        style: TextStyle(
                          fontSize: 12.r,
                          color: blueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 28.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "User Information",
                    style: TextStyle(
                      fontSize: 12.r,
                      color: blackColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 12.r,
                        color: blueColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              PRKFormField(
                prefixIcon: Icons.person_rounded,
                labelText: "Name",
                controller: _nameCtrl,
              ),
              SizedBox(
                height: 12.h,
              ),
              PRKFormField(
                prefixIcon: Icons.badge_rounded,
                labelText: "Student Number",
                controller: _userNumberCtrl,
              ),
              SizedBox(
                height: 12.h,
              ),
              PRKFormField(
                prefixIcon: Icons.phone_rounded,
                labelText: "Phone Number",
                controller: _phoneNumberCtrl,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //       onPressed: () {},
              //       child: Text(
              //         "Change Your Password?",
              //         style: TextStyle(
              //           fontSize: 12.r,
              //           fontWeight: FontWeight.w500,
              //           color: blueColor,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 20.h,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Owned Stickers",
              //       style: TextStyle(
              //         fontSize: 12.r,
              //         color: blackColor,
              //       ),
              //     ),
              //     Text(
              //       "Add New Sticker",
              //       style: TextStyle(
              //         fontSize: 12.r,
              //         color: blueColor,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 12.h,
              // ),
              // PRKStudenteSticker(
              //   stickerNumber: "1234",
              //   plateNumber: "NDA-1234",
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
