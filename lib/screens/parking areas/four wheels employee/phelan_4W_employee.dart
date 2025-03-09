import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/switch_btn.dart';

void showPhelan4wEmployeeBottomSheet(BuildContext context) {
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
          child: const Phelan4wEmployeeBottomSheet());
    },
  );
}

class Phelan4wEmployeeBottomSheet extends StatefulWidget {
  const Phelan4wEmployeeBottomSheet({super.key});
  @override
  _Phelan4wEmployeeBottomSheet createState() => _Phelan4wEmployeeBottomSheet();
}

class _Phelan4wEmployeeBottomSheet extends State<Phelan4wEmployeeBottomSheet> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _phelanAvailableSpace = 0;
  bool _isOccupied = false;
  final int _maxSpace = 30;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _databaseReference.child('Phelan').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _phelanAvailableSpace = data?['count'] ?? 0;
            _isOccupied = _phelanAvailableSpace == 0;
          });
        }
      }
    });
  }

  void _updateCount(bool value) {
    final int newCount = value
        ? (_phelanAvailableSpace > 0 ? _phelanAvailableSpace - 1 : 0)
        : (_phelanAvailableSpace < _maxSpace
            ? _phelanAvailableSpace + 1
            : _maxSpace);

    _databaseReference.child('Phelan').update({'count': newCount});
  }

  Color _getStatusColor() {
    if (_phelanAvailableSpace == 0) {
      return parkingRedColor;
    } else if (_phelanAvailableSpace == _maxSpace) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_phelanAvailableSpace < 30 && _phelanAvailableSpace > 15) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_phelanAvailableSpace <= 15 && _phelanAvailableSpace > 5) {
      return parkingYellowColor;
    } else if (_phelanAvailableSpace <= 5) {
      return parkingOrangeColor;
    } else {
      return parkingYellowColor;
    }
  }

  String _getStatusText() {
    if (_phelanAvailableSpace == 0) {
      return "Full";
    } else if (_phelanAvailableSpace == _maxSpace) {
      return "Plenty of Space";
    } else if (_phelanAvailableSpace < 30 && _phelanAvailableSpace > 15) {
      return "Plenty of Space";
    } else if (_phelanAvailableSpace <= 15 && _phelanAvailableSpace > 5) {
      return "Half Full";
    } else if (_phelanAvailableSpace <= 5) {
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
              "Phelan",
              style: TextStyle(
                fontSize: 20.r,
                color: blueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
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
                          color: _getStatusColor().withOpacity(0.09),
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
                "$_phelanAvailableSpace",
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
            "assets/building_images/Phelan-4W-E.png",
            width: 357.w,
            height: 191.h,
          ),
          SizedBox(height: 30.h),
          Row(
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
          SizedBox(height: 40.h),
          PRKSwitchBtn(
            parkingArea: 'Phelan',
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
