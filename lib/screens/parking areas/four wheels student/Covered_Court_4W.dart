import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/switch_btn.dart';

void showCC4WBottomSheet(BuildContext context) {
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
          child: const CoveredCourt4wBottomSheet());
    },
  );
}

class CoveredCourt4wBottomSheet extends StatefulWidget {
  const CoveredCourt4wBottomSheet({Key? key}) : super(key: key);

  @override
  _CoveredCourt4wBottomSheetState createState() =>
      _CoveredCourt4wBottomSheetState();
}

class _CoveredCourt4wBottomSheetState extends State<CoveredCourt4wBottomSheet> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _coveredCourtAvailableSpace = 0;

  final int _maxSpace = 19;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _databaseReference.child('Covered Court').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _coveredCourtAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });
  }

  Color _getStatusColor() {
    if (_coveredCourtAvailableSpace == 0) {
      return parkingRedColor;
    } else if (_coveredCourtAvailableSpace == _maxSpace) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_coveredCourtAvailableSpace < 19 &&
        _coveredCourtAvailableSpace > 9) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_coveredCourtAvailableSpace <= 9 &&
        _coveredCourtAvailableSpace > 5) {
      return parkingYellowColor;
    } else if (_coveredCourtAvailableSpace <= 5) {
      return parkingOrangeColor;
    } else {
      return parkingYellowColor;
    }
  }

  String _getStatusText() {
    if (_coveredCourtAvailableSpace == 0) {
      return "Full";
    } else if (_coveredCourtAvailableSpace == _maxSpace) {
      return "Plenty of Space";
    } else if (_coveredCourtAvailableSpace < 19 &&
        _coveredCourtAvailableSpace > 9) {
      return "Plenty of Space";
    } else if (_coveredCourtAvailableSpace <= 9 &&
        _coveredCourtAvailableSpace > 5) {
      return "Half Full";
    } else if (_coveredCourtAvailableSpace <= 5) {
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
              "Covered Court",
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
                    style: TextStyle(fontSize: 12.sp, color: blackColor),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Status:",
                        style: TextStyle(fontSize: 12.sp, color: blackColor),
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
                "$_coveredCourtAvailableSpace",
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
            "assets/building_images/CC-4W-S.png",
            width: 358.w,
            height: 242.h,
          ),
          SizedBox(height: 30.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.info_rounded, color: blackColor),
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
