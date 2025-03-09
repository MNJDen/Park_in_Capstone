import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/switch_btn.dart';

void showBurns4WBottomSheet(BuildContext context) {
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
          child: const Burns4wBottomSheet());
    },
  );
}

class Burns4wBottomSheet extends StatefulWidget {
  const Burns4wBottomSheet({Key? key}) : super(key: key);

  @override
  _Burns4wBottomSheetState createState() => _Burns4wBottomSheetState();
}

class _Burns4wBottomSheetState extends State<Burns4wBottomSheet> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _burnsAvailableSpace = 0;
  bool _isOccupied = false;
  final int _maxSpace = 15;

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
            _isOccupied = _burnsAvailableSpace == 0;
          });
        }
      }
    });
  }

  void _updateCount(bool value) {
    final int newCount = value
        ? (_burnsAvailableSpace > 0 ? _burnsAvailableSpace - 1 : 0)
        : (_burnsAvailableSpace < _maxSpace
            ? _burnsAvailableSpace + 1
            : _maxSpace);

    _databaseReference.child('Burns').update({'count': newCount});
  }

  Color _getStatusColor() {
    if (_burnsAvailableSpace == 0) {
      return parkingRedColor;
    } else if (_burnsAvailableSpace == _maxSpace) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_burnsAvailableSpace < 15 && _burnsAvailableSpace > 7) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_burnsAvailableSpace <= 7 && _burnsAvailableSpace > 5) {
      return parkingYellowColor;
    } else if (_burnsAvailableSpace <= 5) {
      return parkingOrangeColor;
    } else {
      return parkingYellowColor;
    }
  }

  String _getStatusText() {
    if (_burnsAvailableSpace == 0) {
      return "Full";
    } else if (_burnsAvailableSpace == _maxSpace) {
      return "Plenty of Space";
    } else if (_burnsAvailableSpace < 15 && _burnsAvailableSpace > 7) {
      return "Plenty of Space";
    } else if (_burnsAvailableSpace <= 7 && _burnsAvailableSpace > 5) {
      return "Half Full";
    } else if (_burnsAvailableSpace <= 5) {
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
              "Burns",
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
                  SizedBox(height: 2.h),
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
                "$_burnsAvailableSpace",
                style: TextStyle(
                  fontSize: 52.sp,
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Center(
            child: Image.asset(
              "assets/building_images/Burns-4W-S.png",
              width: 354.w,
              height: 163.h,
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_rounded,
                color: blackColor,
              ),
              SizedBox(width: 12.w),
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
          SizedBox(height: 40.h),
          PRKSwitchBtn(
            parkingArea: 'Burns',
            initialValue: _isOccupied,
            onChanged: (value) {
              setState(() {
                _isOccupied = value;
              });
              _updateCount(value);
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
