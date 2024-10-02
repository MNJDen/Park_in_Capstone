import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/snackbar/success_snackbar.dart';
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

  // Future<void> _addSticker() async {
  //   final userId = await _getUserId();
  //   DocumentSnapshot userDoc =
  //       await FirebaseFirestore.instance.collection('User').doc(userId).get();

  //   // Check if user document exists
  //   if (userDoc.exists) {
  //     Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
  //     // Retrieve existing arrays or create empty lists if fields are missing
  //     List<dynamic> existingStickerNumbers = userData?['stickerNumber'] ?? [];
  //     List<dynamic> existingPlateNumbers = userData?['plateNo'] ?? [];

  //     // Add the new values from the controllers
  //     existingStickerNumbers.add(_stickerNumberCtrl.text);
  //     existingPlateNumbers.add(_plateNumberCtrl.text);

  //     // Update the Firestore document with the new arrays
  //     await FirebaseFirestore.instance.collection('User').doc(userId).update({
  //       'stickerNumber': existingStickerNumbers,
  //       'plateNo': existingPlateNumbers,
  //     });

  //     // Close the dialog
  //     Navigator.of(context).pop();
  //   }
  // }

  void _showAddStickerModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Adding a Sticker',
          style: TextStyle(
            fontSize: 20.r,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PRKFormField(
              prefixIcon: Icons.tag_rounded,
              labelText: "Sticker Number",
              controller: _stickerNumberCtrl,
            ),
            SizedBox(
              height: 10.h,
            ),
            PRKFormField(
              prefixIcon: Icons.pin_rounded,
              labelText: "Plate Number",
              controller: _plateNumberCtrl,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: blueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Add',
              style: TextStyle(color: whiteColor),
            ),
            onPressed: () async {
              if (_stickerNumberCtrl.text.isEmpty ||
                  _plateNumberCtrl.text.isEmpty) {
                errorSnackbar(context, "Please fill in all fields");
              } else {
                final userId = await _getUserId();
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('User ')
                    .doc(userId)
                    .get();

                // Check if user document exists
                if (userDoc.exists) {
                  Map<String, dynamic>? userData =
                      userDoc.data() as Map<String, dynamic>?;
                  List<dynamic> existingStickerNumbers =
                      userData?['stickerNumber'] ?? [];
                  List<dynamic> existingPlateNumbers =
                      userData?['plateNo'] ?? [];

                  // Add the new values from the controllers
                  existingStickerNumbers.add(_stickerNumberCtrl.text);
                  existingPlateNumbers.add(_plateNumberCtrl.text);

                  // Update the Firestore document with the new arrays
                  await FirebaseFirestore.instance
                      .collection('User ')
                      .doc(userId)
                      .update({
                    'stickerNumber': existingStickerNumbers,
                    'plateNo': existingPlateNumbers,
                  });

                  // Close the dialog
                  Navigator.of(context).pop();

                  // Show a snackbar indicating that the sticker was added successfully
                  successSnackbar(context, "Sticker added successfully");
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
