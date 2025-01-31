import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/switch_btn.dart';

void showAlingal4wEmployeeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: bgColor,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) {
      return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              NavbarNotifier.hideBottomNavBar = false;
              return;
            }
          },
          child: const Alingal4wEmployeeBottomSheet());
    },
  );
}

class Alingal4wEmployeeBottomSheet extends StatefulWidget {
  const Alingal4wEmployeeBottomSheet({super.key});

  @override
  _Alingal4wEmployeeBottomSheetState createState() =>
      _Alingal4wEmployeeBottomSheetState();
}

class _Alingal4wEmployeeBottomSheetState
    extends State<Alingal4wEmployeeBottomSheet> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _alingalAvailableSpace = 0;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _databaseReference.child('Alingal').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _alingalAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });
  }

  final int _maxSpace = 30;

  Color _getStatusColor() {
    if (_alingalAvailableSpace == 0) {
      return parkingRedColor;
    } else if (_alingalAvailableSpace == _maxSpace) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_alingalAvailableSpace < 30 && _alingalAvailableSpace > 15) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_alingalAvailableSpace <= 15 && _alingalAvailableSpace > 5) {
      return parkingYellowColor;
    } else if (_alingalAvailableSpace <= 5) {
      return parkingOrangeColor;
    } else {
      return parkingYellowColor;
    }
  }

  String _getStatusText() {
    if (_alingalAvailableSpace == 0) {
      return "Full";
    } else if (_alingalAvailableSpace == _maxSpace) {
      return "Plenty of Space";
    } else if (_alingalAvailableSpace < 30 && _alingalAvailableSpace > 15) {
      return "Plenty of Space";
    } else if (_alingalAvailableSpace <= 15 && _alingalAvailableSpace > 5) {
      return "Half Full";
    } else if (_alingalAvailableSpace <= 5) {
      return "Almost Full";
    } else {
      return "Filling";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Alingal",
              style: TextStyle(
                fontSize: 20.r,
                color: blueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20.h),
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
                      SizedBox(width: 8.w),
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
                "$_alingalAvailableSpace",
                style: TextStyle(
                  fontSize: 52.sp,
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Image.asset(
            "assets/building_images/AlingalA-4W-E.png",
            width: 352.w,
            height: 232.h,
          ),
          SizedBox(height: 30.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_rounded,
                color: blackColor,
              ),
              SizedBox(width: 12.w),
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
          SizedBox(height: 40.h),
          const PRKSwitchBtn(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
