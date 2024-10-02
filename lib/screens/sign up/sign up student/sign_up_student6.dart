import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_student.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:park_in/components/ui/student_eSticker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpStudentScreen6 extends StatefulWidget {
  const SignUpStudentScreen6({super.key});

  @override
  State<SignUpStudentScreen6> createState() => _SignUpStudentScreen6State();
}

class _SignUpStudentScreen6State extends State<SignUpStudentScreen6> {
  Future<void> _uploadData() async {
    try {
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final userData = userDataProvider.userData;

      // Upload the image and get the download URL
      String? downloadUrl;
      if (userData.imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('User Profile Pictures')
            .child('${userData.userNumber}.jpg');

        final uploadTask = storageRef.putFile(userData.imageFile!);
        final snapshot = await uploadTask.whenComplete(() {});
        downloadUrl = await snapshot.ref.getDownloadURL();

        // Update the userData with the download URL
        userDataProvider.updateUserData(imageUrl: downloadUrl);
      }

      // Create a new user document in Firestore
      final userDocument = FirebaseFirestore.instance.collection('User').doc();
      final newUserId = userDocument.id; // Get the new user's ID

      await userDocument.set({
        'userType': userData.usertype,
        'name': userData.name,
        'userNumber': userData.userNumber,
        'mobileNo': userData.phoneNumber,
        'department': userData.department,
        'password': userData.password,
        'profilePicture': downloadUrl, // Use the downloadUrl
        'stickerNumber': userData.stickerNumber,
        'plateNo': userData.plateNumber,
      });

      // Save the new userId and userType in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', newUserId); // Save new userId
      await prefs.setString('userType', userData.usertype ?? 'Employee');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // width: MediaQuery.of(context).size.width * 0.95,
            margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 90.h),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color.fromRGBO(217, 255, 214, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color.fromRGBO(20, 255, 0, 1),
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: const Color.fromRGBO(20, 255, 0, 1),
                  size: 20.r,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Flexible(
                  child: Text(
                    'Sign Up Successful!',
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBarStudent(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: EdgeInsets.only(bottom: 60.h),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 255, 226, 226),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromRGBO(255, 0, 0, 1),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: const Color.fromRGBO(255, 0, 0, 1),
                size: 20.r,
              ),
              SizedBox(
                width: 8.w,
              ),
              Flexible(
                child: Text(
                  "Error Occured: $e",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
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
                  // Generate PRKStudenteSticker
                  Column(
                    children: List.generate(
                      stickers.length,
                      (index) => Column(
                        children: [
                          PRKStudenteSticker(
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
