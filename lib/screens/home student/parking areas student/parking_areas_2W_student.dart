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
          children: [
            Expanded(
              child: PRKAlingal2W(
                parkingArea: "Alingal",
                availableSpace: _alingalAvailableSpace.toString(),
                image: "assets/building_images/Alingal-2W.png",
                dotColor: parkingGreenColor,
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
                dotColor: parkingYellowColor,
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
                dotColor: parkingRedColor,
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
          height: 100.h,
        ),
      ],
    );
  }
}
