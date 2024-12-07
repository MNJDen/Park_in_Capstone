import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:park_in/components/bottom%20nav%20bar/bottom_nav_bar_employee.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';

class SignUpEmployeeScreen7 extends StatefulWidget {
  const SignUpEmployeeScreen7({super.key});

  @override
  State<SignUpEmployeeScreen7> createState() => _SignUpEmployeeScreen7State();
}

class _SignUpEmployeeScreen7State extends State<SignUpEmployeeScreen7> {
  bool _isSigningUp = false;
  final ConfettiController _leftConfettiController =
      ConfettiController(duration: const Duration(seconds: 3));
  final ConfettiController _rightConfettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _leftConfettiController.play();
      _rightConfettiController.play();
    });
  }

  @override
  void dispose() {
    _leftConfettiController.dispose();
    _rightConfettiController.dispose();
    super.dispose();
  }

  Future<void> _uploadData() async {
    setState(() {
      _isSigningUp = true;
    });

    try {
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final userData = userDataProvider.userData;

      // Upload the image and get the download URL (if any)
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
            elevation: 0,
            margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 90.h),
            behavior: SnackBarBehavior.floating,
            backgroundColor: blackColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: successColor,
                  size: 20.r,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Flexible(
                  child: Text(
                    'Sign Up Successful!',
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
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
            builder: (context) => BottomNavBarEmployee(),
          ),
        );
      }
    } catch (e) {
      errorSnackbar(context, "Error Occurred: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSigningUp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _isSigningUp
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.waveDots(
                            color: blueColor,
                            size: 50.r,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "Getting everything ready, wait a moment...",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: blackColor.withOpacity(0.8),
                            ),
                          )
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/success_image.png",
                                  height: 160.h),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                "Looks like you’re all set up!",
                                softWrap: true,
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16.r,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                "You can now access real-time information regarding parking availability on campus.",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 12.r,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
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
            Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _leftConfettiController,
                blastDirection: 270,
                emissionFrequency: 0.09,
                numberOfParticles: 10,
                shouldLoop: false,
                colors: const [
                  parkingRedColor,
                  blueColor,
                  parkingGreenColor,
                  yellowColor,
                  parkingOrangeColor,
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _rightConfettiController,
                blastDirection: 180,
                emissionFrequency: 0.09,
                numberOfParticles: 10,
                shouldLoop: false,
                colors: const [
                  parkingRedColor,
                  blueColor,
                  parkingGreenColor,
                  yellowColor,
                  parkingOrangeColor,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
