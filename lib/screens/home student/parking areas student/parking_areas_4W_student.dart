import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/four%20wheels%20student/alingal_a.dart';
import 'package:park_in/components/four%20wheels%20student/alingal_b.dart';
import 'package:park_in/components/four%20wheels%20student/burns.dart';
import 'package:park_in/components/four%20wheels%20student/coko_cafe.dart';
import 'package:park_in/components/four%20wheels%20student/covered_court.dart';
import 'package:park_in/components/four%20wheels%20student/library.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ParkingArea4WStudent extends StatefulWidget {
  const ParkingArea4WStudent({super.key});

  @override
  State<ParkingArea4WStudent> createState() => _ParkingArea4WStudentState();
}

class _ParkingArea4WStudentState extends State<ParkingArea4WStudent> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _alingalAAvailableSpace = 0;
  int _alingalBAvailableSpace = 0;
  int _burnsAvailableSpace = 0;
  int _cokoCafeAvailableSpace = 0;
  int _coveredCourtAvailableSpace = 0;
  int _libraryAvailableSpace = 0;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    // Alingal A
    _databaseReference.child('Alingal A').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _alingalAAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });

    // Alingal B
    _databaseReference.child('Alingal B').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _alingalBAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });

    // Burns
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

    // Coko Cafe
    _databaseReference.child('Coko Cafe').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _cokoCafeAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });

    // Covered Court
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

    // Library
    _databaseReference.child('Library').onValue.listen((event) {
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

  final int _alingalAMaxSpace = 35;

  Color _getAlingalAStatusColor() {
    if (_alingalAAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_alingalAAvailableSpace == _alingalAMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_alingalAAvailableSpace < 35 && _alingalAAvailableSpace > 17) {
      return parkingGreenColor;
    } else if (_alingalAAvailableSpace <= 17 && _alingalAAvailableSpace > 5) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_alingalAAvailableSpace <= 5) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  final int _alingalBMaxSpace = 13;

  Color _getAlingalBStatusColor() {
    if (_alingalBAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_alingalBAvailableSpace == _alingalBMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_alingalBAvailableSpace < 13 && _alingalBAvailableSpace > 7) {
      return parkingGreenColor;
    } else if (_alingalBAvailableSpace <= 7 && _alingalBAvailableSpace > 5) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_alingalBAvailableSpace <= 5) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  final int _burnsMaxSpace = 15;

  Color _getBurnsStatusColor() {
    if (_burnsAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_burnsAvailableSpace == _burnsMaxSpace) {
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

  final int _cokoMaxSpace = 16;

  Color _getCokoStatusColor() {
    if (_cokoCafeAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_cokoCafeAvailableSpace == _cokoMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_cokoCafeAvailableSpace < 16 && _cokoCafeAvailableSpace > 8) {
      return parkingGreenColor;
    } else if (_cokoCafeAvailableSpace <= 8 && _cokoCafeAvailableSpace > 4) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_cokoCafeAvailableSpace <= 4) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  final int _coveredCourtMaxSpace = 19;

  Color _getCoveredCourtStatusColor() {
    if (_coveredCourtAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_coveredCourtAvailableSpace == _coveredCourtMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_coveredCourtAvailableSpace < 19 &&
        _coveredCourtAvailableSpace > 9) {
      return parkingGreenColor;
    } else if (_coveredCourtAvailableSpace <= 9 &&
        _coveredCourtAvailableSpace > 5) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_coveredCourtAvailableSpace <= 5) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  final int _libraryMaxSpace = 9;

  Color _getLibraryStatusColor() {
    if (_libraryAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_libraryAvailableSpace == _libraryMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_libraryAvailableSpace < 9 && _libraryAvailableSpace > 6) {
      return parkingGreenColor;
    } else if (_libraryAvailableSpace <= 6 && _libraryAvailableSpace > 3) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_libraryAvailableSpace <= 3) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PRKAlingalA4WStundent(
              parkingArea: "Alingal A",
              availableSpace: _alingalAAvailableSpace.toString(),
              image: "assets/building_images/AlingalA-4W-S.png",
              dotColor: _getAlingalAStatusColor(),
            ).animate().fade(delay: const Duration(milliseconds: 100)),
            PRKAlingalB4WStundent(
              parkingArea: "Alingal B",
              availableSpace: _alingalBAvailableSpace.toString(),
              image: "assets/building_images/AlingalB-4W-S.png",
              dotColor: _getAlingalBStatusColor(),
            ).animate().fade(delay: const Duration(milliseconds: 120)),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PRKBurns4WStundent(
              parkingArea: "Burns",
              availableSpace: _burnsAvailableSpace.toString(),
              image: "assets/building_images/Burns-4W-S.png",
              dotColor: _getBurnsStatusColor(),
            ).animate().fade(delay: const Duration(milliseconds: 140)),
            PRKCoko4WStundent(
              parkingArea: "Coko Cafe",
              availableSpace: _cokoCafeAvailableSpace.toString(),
              image: "assets/building_images/Coko-4W-S.png",
              dotColor: _getCokoStatusColor(),
            ).animate().fade(delay: const Duration(milliseconds: 160)),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PRKCC4WStundent(
              parkingArea: "Covered Court",
              availableSpace: _coveredCourtAvailableSpace.toString(),
              image: "assets/building_images/CC-4W-S.png",
              dotColor: _getCoveredCourtStatusColor(),
            ).animate().fade(delay: const Duration(milliseconds: 180)),
            PRKLibrary4WStundent(
              parkingArea: "Library",
              availableSpace: _libraryAvailableSpace.toString(),
              image: "assets/building_images/Library-4W-S.png",
              dotColor: _getCoveredCourtStatusColor(),
            ).animate().fade(delay: const Duration(milliseconds: 200)),
          ],
        ),
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
        ).animate().fade(delay: const Duration(milliseconds: 220)),
        SizedBox(
          height: 100.h,
        ),
      ],
    );
  }
}
