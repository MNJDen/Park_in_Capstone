import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/switch_btn.dart';

void showCoko4WBottomSheet(BuildContext context) {
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
          child: const Coko4wBottomSheet());
    },
  );
}

class Coko4wBottomSheet extends StatefulWidget {
  const Coko4wBottomSheet({Key? key}) : super(key: key);

  @override
  _Coko4wBottomSheetState createState() => _Coko4wBottomSheetState();
}

class _Coko4wBottomSheetState extends State<Coko4wBottomSheet> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child("parkingAreas");

  int _coko4wAvailableSpace = 0;
  bool _isOccupied = false;
  final int _maxSpace = 16;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _databaseReference.child('Coko Cafe').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _coko4wAvailableSpace = data?['count'] ?? 0;
            _isOccupied = _coko4wAvailableSpace == 0;
          });
        }
      }
    });
  }

  void _updateCount(bool value) {
    final int newCount = value
        ? (_coko4wAvailableSpace > 0 ? _coko4wAvailableSpace - 1 : 0)
        : (_coko4wAvailableSpace < _maxSpace
            ? _coko4wAvailableSpace + 1
            : _maxSpace);

    _databaseReference.child('Coko Cafe').update({'count': newCount});
  }

  Color _getStatusColor() {
    if (_coko4wAvailableSpace == 0) {
      return parkingRedColor;
    } else if (_coko4wAvailableSpace == _maxSpace) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_coko4wAvailableSpace < 16 && _coko4wAvailableSpace > 8) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_coko4wAvailableSpace <= 8 && _coko4wAvailableSpace > 4) {
      return parkingYellowColor;
    } else if (_coko4wAvailableSpace <= 4) {
      return parkingOrangeColor;
    } else {
      return parkingYellowColor;
    }
  }

  String _getStatusText() {
    if (_coko4wAvailableSpace == 0) {
      return "Full";
    } else if (_coko4wAvailableSpace == _maxSpace) {
      return "Plenty of Space";
    } else if (_coko4wAvailableSpace < 16 && _coko4wAvailableSpace > 8) {
      return "Plenty of Space";
    } else if (_coko4wAvailableSpace <= 8 && _coko4wAvailableSpace > 4) {
      return "Half Full";
    } else if (_coko4wAvailableSpace <= 4) {
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
              "Coko Cafe",
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
                "$_coko4wAvailableSpace",
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
            "assets/building_images/Coko-4W-S.png",
            width: 354.w,
            height: 248.h,
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
                  "Always be mindful of the space between vehicles. Be careful parking",
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
            parkingArea: 'Coko Cafe',
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
