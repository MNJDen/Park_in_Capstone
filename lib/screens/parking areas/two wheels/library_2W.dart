import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class Library2w extends StatefulWidget {
  const Library2w({super.key});

  _Library2wState createState() => _Library2wState();
}

class _Library2wState extends State<Library2w> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _library2wAvailableSpace = 0;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _databaseReference.child('Library (M)').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _library2wAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });
  }

  final int _maxSpace = 80;

  Color _getStatusColor() {
    if (_library2wAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_library2wAvailableSpace == _maxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_library2wAvailableSpace < 80 && _library2wAvailableSpace > 40) {
      return parkingGreenColor;
    } else if (_library2wAvailableSpace <= 40 &&
        _library2wAvailableSpace > 10) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_library2wAvailableSpace <= 10) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  String _getStatusText() {
    if (_library2wAvailableSpace == 0) {
      return "Full"; // Red status.
    } else if (_library2wAvailableSpace == _maxSpace) {
      return "Available"; // Green status.
    } else if (_library2wAvailableSpace < 80 && _library2wAvailableSpace > 40) {
      return "Available"; // Green status.
    } else if (_library2wAvailableSpace <= 40 &&
        _library2wAvailableSpace > 10) {
      return "Mid-way Full"; // Yellow status.
    } else if (_library2wAvailableSpace <= 10) {
      return "Almost Full"; // Orange status.
    } else {
      return "Filling";
    }
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
                        "Library",
                        style: TextStyle(
                          fontSize: 20.r,
                          color: blueColor,
                          fontWeight: FontWeight.bold,
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
                                  color: _getStatusColor().withOpacity(0.1),
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
                        "$_library2wAvailableSpace",
                        style: TextStyle(
                          fontSize: 52.sp,
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Image.asset(
                    "assets/building_images/Library-2W.png",
                    width: 360.w,
                    height: 436.h,
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
                        "Always be mindful of the space between vehicles.",
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
    );
  }
}
