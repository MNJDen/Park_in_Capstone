import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/two%20wheels/alingal.dart';
import 'package:park_in/components/two%20wheels/dolan.dart';
import 'package:park_in/components/two%20wheels/library.dart';

class ParkingArea2W extends StatefulWidget {
  const ParkingArea2W({super.key});

  @override
  State<ParkingArea2W> createState() => _ParkingArea2WState();
}

class _ParkingArea2WState extends State<ParkingArea2W> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _alingalAvailableSpace = 0;
  int _dolanAvailableSpace = 0;
  int _libraryAvailableSpace = 0;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    // Alingal
    _databaseReference.child('Alingal (M)').onValue.listen((event) {
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

    // Dolan
    _databaseReference.child('Dolan (M)').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _dolanAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });

    // Library
    _databaseReference.child('Library (M)').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _libraryAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });
  }

  final int _alingal2wMaxSpace = 80;

  Color _getAlingalStatusColor() {
    if (_alingalAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_alingalAvailableSpace == _alingal2wMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_alingalAvailableSpace < 80 && _alingalAvailableSpace > 40) {
      return parkingGreenColor;
    } else if (_alingalAvailableSpace <= 40 && _alingalAvailableSpace > 10) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_alingalAvailableSpace <= 10) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  final int _dolan2wMaxSpace = 50;

  Color _getDolanStatusColor() {
    if (_dolanAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_dolanAvailableSpace == _dolan2wMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_dolanAvailableSpace < 50 && _dolanAvailableSpace > 25) {
      return parkingGreenColor;
    } else if (_dolanAvailableSpace <= 25 && _dolanAvailableSpace > 10) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_dolanAvailableSpace <= 10) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  final int _library2wMaxSpace = 80;

  Color _getLibraryStatusColor() {
    if (_libraryAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_libraryAvailableSpace == _library2wMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_libraryAvailableSpace < 80 && _libraryAvailableSpace > 40) {
      return parkingGreenColor;
    } else if (_libraryAvailableSpace <= 40 && _libraryAvailableSpace > 10) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_libraryAvailableSpace <= 10) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Parking Areas",
              style: TextStyle(
                fontSize: 16.r,
                color: blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Tooltip(
              padding: EdgeInsets.all(12.r),
              enableFeedback: true,
              showDuration: const Duration(seconds: 3),
              textStyle: TextStyle(
                fontSize: 12.r,
                color: whiteColor,
                fontWeight: FontWeight.w400,
              ),
              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.circular(10),
              ),
              message:
                  "The numbers indicate the available \nparking spaces in the parking area.",
              triggerMode: TooltipTriggerMode.tap,
              child: const Icon(
                Icons.help_outline_rounded,
              ),
            )
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        Row(
          children: [
            Expanded(
              child: PRKAlingal2W(
                parkingArea: "Alingal",
                availableSpace: _alingalAvailableSpace.toString(),
                image: "assets/building_images/Alingal-2W.png",
                dotColor: _getAlingalStatusColor(),
              ),
            ),
          ],
        ).animate().fade(delay: const Duration(milliseconds: 100)),
        SizedBox(
          height: 12.h,
        ),
        Row(
          children: [
            Expanded(
              child: PRKDolan2W(
                parkingArea: "Dolan",
                availableSpace: _dolanAvailableSpace.toString(),
                image: "assets/building_images/Dolan-2W.png",
                dotColor: _getDolanStatusColor(),
              ),
            ),
          ],
        ).animate().fade(delay: const Duration(milliseconds: 120)),
        SizedBox(
          height: 12.h,
        ),
        Row(
          children: [
            Expanded(
              child: PRKLibrary2W(
                parkingArea: "Library",
                availableSpace: _libraryAvailableSpace.toString(),
                image: "assets/building_images/Library-2W.png",
                dotColor: _getLibraryStatusColor(),
              ),
            ),
          ],
        ).animate().fade(delay: const Duration(milliseconds: 140)),
        SizedBox(
          height: 8.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Numbers displayed are approximate",
              softWrap: true,
              style: TextStyle(
                color: blackColor,
                fontSize: 12.r,
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ).animate().fade(delay: const Duration(milliseconds: 160)),
        SizedBox(
          height: 95.h,
        ),
      ],
    );
  }
}
