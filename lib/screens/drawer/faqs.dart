import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:disclosure/disclosure.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
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
                    "FAQs",
                    style: TextStyle(
                      fontSize: 20.r,
                      color: blueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Disclosure(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Duration(milliseconds: 300),
                  wrapper: (state, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  header: DisclosureButton(
                    child: ListTile(
                      title: Text(
                        'Can I reserve a parking space?',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const DisclosureIcon(
                        color: blackColor,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    ),
                  ),
                  divider: Divider(
                    thickness: 0.5.h,
                    height: 1.h,
                  ),
                  child: DisclosureView(
                    padding: EdgeInsets.all(16.r),
                    child: Text(
                      "The answer is no, the university is currently following a first-come, first-served policy.",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: blackColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Disclosure(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Duration(milliseconds: 300),
                  wrapper: (state, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  header: DisclosureButton(
                    child: ListTile(
                      title: Text(
                        'How can I get a gate pass sticker?',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const DisclosureIcon(
                        color: blackColor,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    ),
                  ),
                  divider: Divider(
                    thickness: 0.5.h,
                    height: 1.h,
                  ),
                  child: DisclosureView(
                    padding: EdgeInsets.all(16.r),
                    child: Wrap(
                      children: [
                        Text(
                          "You can obtain it by either contacting a security personnel or visiting the administration office on campus.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Disclosure(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Duration(milliseconds: 300),
                  wrapper: (state, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  header: DisclosureButton(
                    child: ListTile(
                      title: Text(
                        'What are the colored circles?',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const DisclosureIcon(
                        color: blackColor,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    ),
                  ),
                  divider: Divider(
                    thickness: 0.5.h,
                    height: 1.h,
                  ),
                  child: DisclosureView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "This indicator provides an overview of the status of the parking area. ",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Green",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: parkingGreenColor,
                                  fontFamily: 'General Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " signifies that there are ample parking spaces available.",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                  fontFamily: 'General Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Yellow",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: parkingYellowColor,
                                  fontFamily:
                                      'General Sans', // replace with your app's font family
                                  fontWeight: FontWeight
                                      .w500, // replace with your app's font weight
                                ),
                              ),
                              TextSpan(
                                text:
                                    " indicates that the parking area is at approximately 50% capacity.",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                  fontFamily:
                                      'General Sans', // replace with your app's font family
                                  fontWeight: FontWeight
                                      .w400, // replace with your app's font weight
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Red",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: parkingRedColor,
                                  fontFamily:
                                      'General Sans', // replace with your app's font family
                                  fontWeight: FontWeight
                                      .w500, // replace with your app's font weight
                                ),
                              ),
                              TextSpan(
                                text:
                                    " signals that the parking area is nearing full capacity or is already at full capacity.",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: blackColor,
                                  fontFamily:
                                      'General Sans', // replace with your app's font family
                                  fontWeight: FontWeight
                                      .w400, // replace with your app's font weight
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Disclosure(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Duration(milliseconds: 300),
                  wrapper: (state, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  header: DisclosureButton(
                    // padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
                    child: ListTile(
                      title: Text(
                        'How long is the validity of the gate pass sticker?',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const DisclosureIcon(
                        color: blackColor,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    ),
                  ),
                  divider: Divider(
                    thickness: 0.5.h,
                    height: 1.h,
                  ),
                  child: DisclosureView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Text(
                          "The gate pass sticker is valid until the conclusion of the semester and must be renewed at the beginning of each semester.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "It is recommended to renew your sticker promptly at the start of the semester in order to maximize its benefits.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Disclosure(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Duration(milliseconds: 300),
                  wrapper: (state, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  header: DisclosureButton(
                    // padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
                    child: ListTile(
                      title: Text(
                        'Can I sit in my car while turned on?',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const DisclosureIcon(
                        color: blackColor,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    ),
                  ),
                  divider: Divider(
                    thickness: 0.5.h,
                    height: 1.h,
                  ),
                  child: DisclosureView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Text(
                          "The answer is no for security reasons.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Disclosure(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Duration(milliseconds: 300),
                  wrapper: (state, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  header: DisclosureButton(
                    // padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
                    child: ListTile(
                      title: Text(
                        'What does the numbers displayed represent?',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const DisclosureIcon(
                        color: blackColor,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    ),
                  ),
                  divider: Divider(
                    thickness: 0.5.h,
                    height: 1.h,
                  ),
                  child: DisclosureView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Text(
                          "The numbers shown indicate the number of parking spaces currently available in a specific parking area.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Disclosure(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Duration(milliseconds: 300),
                  wrapper: (state, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  header: DisclosureButton(
                    // padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
                    child: ListTile(
                      title: Text(
                        'Why did I receive a ticket parking on Alingal A?',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const DisclosureIcon(
                        color: blackColor,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    ),
                  ),
                  divider: Divider(
                    thickness: 0.5.h,
                    height: 1.h,
                  ),
                  child: DisclosureView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Text(
                          "Parking on Alingal A starting at 5:30pm is prohibited as this area is designated for the College of Law.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Disclosure(
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Duration(milliseconds: 300),
                  wrapper: (state, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  header: DisclosureButton(
                    // padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
                    child: ListTile(
                      title: Text(
                        'Can I park on a reserved parking space?',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const DisclosureIcon(
                        color: blackColor,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                    ),
                  ),
                  divider: Divider(
                    thickness: 0.5.h,
                    height: 1.h,
                  ),
                  child: DisclosureView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        Text(
                          "The answer is no, it is a designated parking space for the university’s executives.",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: blackColor,
                          ),
                        ),
                      ],
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
