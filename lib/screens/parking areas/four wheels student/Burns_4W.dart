import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:firebase_database/firebase_database.dart';

class Burns4w extends StatefulWidget {
  const Burns4w({super.key});

  @override
  _Burns4wState createState() => _Burns4wState();
}

class _Burns4wState extends State<Burns4w> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _burnsAvailableSpace = 0;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _databaseReference.child('Burns').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _burnsAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });
  }

  final int _maxSpace = 15;

  Color _getStatusColor() {
    if (_burnsAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_burnsAvailableSpace == _maxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_burnsAvailableSpace < 15 && _burnsAvailableSpace > 7) {
      return parkingGreenColor;
    } else if (_burnsAvailableSpace <= 7 && _burnsAvailableSpace > 5) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_burnsAvailableSpace <= 5) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  String _getStatusText() {
    if (_burnsAvailableSpace == 0) {
      return "Full"; // Red status.
    } else if (_burnsAvailableSpace == _maxSpace) {
      return "Plenty of Space"; // Green status.
    } else if (_burnsAvailableSpace < 15 && _burnsAvailableSpace > 7) {
      return "Plenty of Space"; // Green status.
    } else if (_burnsAvailableSpace <= 7 && _burnsAvailableSpace > 5) {
      return "Half Full"; // Yellow status.
    } else if (_burnsAvailableSpace <= 5) {
      return "Almost Full"; // Orange status.
    } else {
      return "Filling";
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          NavbarNotifier.hideBottomNavBar = false;
          return;
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                              NavbarNotifier.hideBottomNavBar = false;
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: blackColor,
                            ),
                          ),
                        ),
                        Text(
                          "Burns",
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Capacity:",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: blackColor,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Status:",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: blackColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor().withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    _getStatusText(),
                                    style: TextStyle(
                                      color: _getStatusColor(),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          "$_burnsAvailableSpace",
                          style: TextStyle(
                            fontSize: 52.sp,
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Image.asset(
                      "assets/building_images/Burns-4W-S.png",
                      width: 354.w,
                      height: 163.h,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_rounded,
                        color: blackColor,
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Flexible(
                        child: Text(
                          "Always be mindful of the space between vehicles. Please refrain from honking, as it may disrupt the service at the church.",
                          softWrap: true,
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 12.sp,
                          ),
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
    );
  }
}
