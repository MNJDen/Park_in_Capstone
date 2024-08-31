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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16.h,
        ),
        Row(
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
              dotColor: parkingGreenColor,
            ).animate().fade(delay: const Duration(milliseconds: 100)),
            PRKAlingalB4WStundent(
              parkingArea: "Alingal B",
              availableSpace: _alingalBAvailableSpace.toString(),
              image: "assets/building_images/AlingalB-4W-S.png",
              dotColor: parkingGreenColor,
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
              dotColor: parkingYellowColor,
            ).animate().fade(delay: const Duration(milliseconds: 140)),
            PRKCoko4WStundent(
              parkingArea: "Coko Cafe",
              availableSpace: _cokoCafeAvailableSpace.toString(),
              image: "assets/building_images/Coko-4W-S.png",
              dotColor: parkingYellowColor,
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
              dotColor: parkingRedColor,
            ).animate().fade(delay: const Duration(milliseconds: 180)),
            PRKLibrary4WStundent(
              parkingArea: "Library",
              availableSpace: _libraryAvailableSpace.toString(),
              image: "assets/building_images/Library-4W-S.png",
              dotColor: parkingRedColor,
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
