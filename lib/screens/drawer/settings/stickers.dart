import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/employee_eSticker.dart';
import 'package:park_in/components/ui/student_eSticker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({super.key});

  @override
  State<StickersScreen> createState() => _StickersScreennState();
}

class _StickersScreennState extends State<StickersScreen> {
  List<String> stickerNumbers = [];
  List<String> plateNumbers = [];
  String userType = '';

  @override
  void initState() {
    super.initState();
    _fetchUserStickers();
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _fetchUserStickers() async {
    final userId = await _getUserId();
    if (userId != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      // fetch stickerNumber and plateNo lists from Firestore
      List<dynamic> fetchedStickerNumbers =
          userDoc.data()?['stickerNumber'] ?? [];
      List<dynamic> fetchedPlateNumbers = userDoc.data()?['plateNo'] ?? [];
      String fetchedUserType = userDoc.data()?['userType'] ?? '';

      setState(() {
        stickerNumbers = List<String>.from(fetchedStickerNumbers);
        plateNumbers = List<String>.from(fetchedPlateNumbers);
        userType = fetchedUserType;
      });
    }
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
                    "Stickers",
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
                    onPressed: () {},
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
}
