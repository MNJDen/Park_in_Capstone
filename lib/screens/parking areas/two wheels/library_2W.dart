import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/switch_btn.dart';

void showLibrary2WBottomSheet(BuildContext context) {
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
          child: const Library2wBottomSheet());
    },
  );
}

class Library2wBottomSheet extends StatefulWidget {
  const Library2wBottomSheet({super.key});

  _Library2wBottomSheetState createState() => _Library2wBottomSheetState();
}

class _Library2wBottomSheetState extends State<Library2wBottomSheet> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _library2wAvailableSpace = 0;
  bool _isOccupied = false;
  final int _maxSpace = 80;

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
            _isOccupied = _library2wAvailableSpace == 0;
          });
        }
      }
    });
  }

  void _updateCount(bool value) {
    final int newCount = value
        ? (_library2wAvailableSpace > 0 ? _library2wAvailableSpace - 1 : 0)
        : (_library2wAvailableSpace < _maxSpace
            ? _library2wAvailableSpace + 1
            : _maxSpace);

    _databaseReference.child('Library (M)').update({'count': newCount});
  }

  Color _getStatusColor() {
    if (_library2wAvailableSpace == 0) {
      return parkingRedColor;
    } else if (_library2wAvailableSpace == _maxSpace) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_library2wAvailableSpace < 80 && _library2wAvailableSpace > 40) {
      return const Color.fromARGB(255, 17, 194, 1);
    } else if (_library2wAvailableSpace <= 40 &&
        _library2wAvailableSpace > 10) {
      return parkingYellowColor;
    } else if (_library2wAvailableSpace <= 10) {
      return parkingOrangeColor;
    } else {
      return parkingYellowColor;
    }
  }

  String _getStatusText() {
    if (_library2wAvailableSpace == 0) {
      return "Full";
    } else if (_library2wAvailableSpace == _maxSpace) {
      return "Plenty of Space";
    } else if (_library2wAvailableSpace < 80 && _library2wAvailableSpace > 40) {
      return "Plenty of Space";
    } else if (_library2wAvailableSpace <= 40 &&
        _library2wAvailableSpace > 10) {
      return "Half Full";
    } else if (_library2wAvailableSpace <= 10) {
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
              "Library",
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
                "$_library2wAvailableSpace",
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
            "assets/building_images/Library-2W.png",
            width: 360.w,
            // height: 436.h,
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
            parkingArea: 'Library (M)',
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
