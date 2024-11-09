import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/field/soft_field.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/snackbar/success_snackbar.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/employee_eSticker.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/components/ui/student_eSticker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({super.key});

  @override
  State<StickersScreen> createState() => _StickersScreennState();
}

class _StickersScreennState extends State<StickersScreen> {
  final TextEditingController _stickerNumberCtrl = TextEditingController();
  final TextEditingController _plateNumberCtrl = TextEditingController();
  List<String> stickerNumbers = [];
  List<String> plateNumbers = [];
  String userType = '';

  @override
  void initState() {
    super.initState();
    _listenToUserStickers();
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  void _listenToUserStickers() async {
    final userId = await _getUserId();

    if (userId != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .snapshots()
          .listen((userDocSnapshot) {
        if (userDocSnapshot.exists) {
          // Fetch stickerNumber and plateNo lists from Firestore
          List<dynamic> fetchedStickerNumbers =
              userDocSnapshot.data()?['stickerNumber'] ?? [];
          List<dynamic> fetchedPlateNumbers =
              userDocSnapshot.data()?['plateNo'] ?? [];
          String fetchedUserType = userDocSnapshot.data()?['userType'] ?? '';

          // Update the local state
          setState(() {
            stickerNumbers = List<String>.from(fetchedStickerNumbers);
            plateNumbers = List<String>.from(fetchedPlateNumbers);
            userType = fetchedUserType;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
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
                    "Stickers",
                    style: TextStyle(
                      fontSize: 20.r,
                      color: blueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 28.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Owned Stickers",
                    style: TextStyle(
                      fontSize: 12.r,
                      color: blackColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showAddStickerModal(context);
                    },
                    child: Text(
                      "Add Sticker",
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
              // display stickers dynamically based on the fetched data
              Column(
                children: List.generate(
                  stickerNumbers.length,
                  (index) => Column(
                    children: [
                      // based on the user type, display the stickers
                      if (userType == 'Student')
                        PRKStudenteSticker(
                          stickerNumber: stickerNumbers[index],
                          plateNumber: plateNumbers[index],
                          heroTag: index.toString(),
                        )
                      else if (userType == 'Employee')
                        PRKEmployeeeSticker(
                          stickerNumber: stickerNumbers[index],
                          plateNumber: plateNumbers[index],
                          heroTag: index.toString(),
                        ),
                      SizedBox(
                        height: 12.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addSticker() async {
    final userId = await _getUserId();
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('User').doc(userId).get();

    // Check if user document exists
    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      // Retrieve existing arrays or create empty lists if fields are missing
      List<dynamic> existingStickerNumbers = userData?['stickerNumber'] ?? [];
      List<dynamic> existingPlateNumbers = userData?['plateNo'] ?? [];

      // Add the new values from the controllers
      existingStickerNumbers.add(_stickerNumberCtrl.text);
      existingPlateNumbers.add(_plateNumberCtrl.text);

      // Update the Firestore document with the new arrays
      await FirebaseFirestore.instance.collection('User').doc(userId).update({
        'stickerNumber': existingStickerNumbers,
        'plateNo': existingPlateNumbers,
      });
    }
  }

  void _showAddStickerModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: whiteColor,
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) => AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        // curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Adding a New Sticker',
                    style: TextStyle(
                      fontSize: 16.r,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'Check your physical sticker\'s information to avoid any discrepancy.',
                style: TextStyle(
                  fontSize: 12.r,
                  fontWeight: FontWeight.w400,
                  color: blackColor.withOpacity(0.5),
                ),
                
              ),
              SizedBox(height: 32.h),
              Container(
                width: 320.w,
                height: 175.h,
                decoration: BoxDecoration(
                  color: userType == 'Employee' ? blueColor : yellowColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      left: -60,
                      child: Container(
                        width: 200.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -50,
                      right: -30,
                      child: Container(
                        width: 140.w,
                        height: 140.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 20,
                      child: PRKSoftField(
                        hintText: "1234",
                        maxLength: 4,
                        maxWidth: 100.w,
                        controller: _stickerNumberCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: PRKSoftField(
                        hintText: "ESX458",
                        maxLength: 7,
                        maxWidth: 180.w,
                        controller: _plateNumberCtrl,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: -197,
                      child: Transform.rotate(
                        angle: -0.995398,
                        child: Container(
                          width: 400.w,
                          height: 37.5.h,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: -293,
                      child: Transform.rotate(
                        angle: -0.995398,
                        child: Container(
                          width: 400.w,
                          height: 37.5.h,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 13,
                      right: 10,
                      child: CircleAvatar(
                        radius: 24,
                        child: Image.asset(
                          'assets/images/AdNU_Logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 20,
                      child: Text(
                        '© 2024 Park-In. All Rights Reserved.',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 10.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              PRKPrimaryBtn(
                label: 'Add Sticker',
                onPressed: () async {
                  if (_stickerNumberCtrl.text.isEmpty ||
                      _plateNumberCtrl.text.isEmpty) {
                    errorSnackbar(context, "Please fill in all fields");
                  } else {
                    await _addSticker();

                    // Close the bottom sheet
                    Navigator.of(context).pop();

                    // Show a snackbar indicating that the sticker was added successfully
                    successSnackbar(context, "Sticker added successfully");
                  }
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
