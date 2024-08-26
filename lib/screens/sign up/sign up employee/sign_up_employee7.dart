import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/bottom_nav_bar_employee.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/employee_eSticker.dart';
import 'package:park_in/components/primary_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpEmployeeScreen7 extends StatefulWidget {
  const SignUpEmployeeScreen7({super.key});

  @override
  State<SignUpEmployeeScreen7> createState() => _SignUpEmployeeScreen7State();
}

class _SignUpEmployeeScreen7State extends State<SignUpEmployeeScreen7> {
  Future<void> _uploadData() async {
    try {
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final userData = userDataProvider.userData;

      final userDocument = FirebaseFirestore.instance
          .collection('User') // Use 'Employee' collection for employees
          .doc(); // Create a new document

      await userDocument.set({
        'userType': userData.usertype,
        'name': userData.name,
        'userNumber': userData.userNumber,
        'mobileNo': userData.phoneNumber,
        'department': userData.department,
        'password': userData.password,
        'profilePicture': userData.imageUrl,
        'stickerNumber': userData.stickerNumber,
        'plateNo': userData.plateNumber,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userType', userData.usertype ?? 'Employee');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBarEmployee()),
        );
      }
      // Navigate to another screen or do additional processing here
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload data: $e'),
        behavior: SnackBarBehavior.fixed,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final userData = userDataProvider.userData;

    final stickers = userData.stickerNumber;
    final plates = userData.plateNumber;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  Text(
                    "Looks like you’re all set up!",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 24.r,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Since you're finished signing up, here’s your digital sticker!",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 12.r,
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Column(
                    children: List.generate(
                      stickers.length,
                      (index) => Column(
                        children: [
                          PRKEmployeeeSticker(
                            stickerNumber: stickers[index],
                            plateNumber: plates[index],
                            heroTag:
                                'sticker_${stickers[index]}_${plates[index]}',
                          ),
                          if (index < stickers.length - 1)
                            SizedBox(
                                height: 16.h), // Add space between stickers
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: PRKPrimaryBtn(
                  label: "Continue",
                  onPressed: _uploadData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
