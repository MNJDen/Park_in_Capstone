import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/four%20wheels%20employee/alingal.dart';
import 'package:park_in/components/four%20wheels%20employee/phelan.dart';

class ParkingArea4WEmployee extends StatefulWidget {
  const ParkingArea4WEmployee({super.key});

  @override
  State<ParkingArea4WEmployee> createState() => _ParkingArea4WEmployeeState();
}

class _ParkingArea4WEmployeeState extends State<ParkingArea4WEmployee> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _alingalAvailableSpace = 0;
  int _phelanAvailableSpace = 0;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    // Listen for changes to the Alingal parking area
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

    // Listen for changes to the Phelan parking area
    _databaseReference.child('Phelan').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _phelanAvailableSpace = data?['count'] ?? 0;
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
              child: PRKAlingal4WEmployee(
                parkingArea: "Alingal",
                availableSpace: _alingalAvailableSpace.toString(),
                image: "assets/building_images/AlingalA-4W-E.png",
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
              child: PRKPhelan4WEmployee(
                parkingArea: "Phelan",
                availableSpace: _phelanAvailableSpace.toString(),
                image: "assets/building_images/Phelan-4W-E.png",
                dotColor: parkingYellowColor,
              ),
            ),
          ],
        ).animate().fade(delay: const Duration(milliseconds: 120)),
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
        ).animate().fade(delay: const Duration(milliseconds: 140)),
      ],
    );
  }
}
