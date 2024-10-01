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

  final int _alingalMaxSpace = 30;

  Color _getAlingalStatusColor() {
    if (_alingalAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_alingalAvailableSpace == _alingalMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_alingalAvailableSpace < 30 && _alingalAvailableSpace > 15) {
      return parkingGreenColor;
    } else if (_alingalAvailableSpace <= 15 && _alingalAvailableSpace > 5) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_alingalAvailableSpace <= 5) {
      return parkingOrangeColor; // Orange when almost full.
    } else {
      return parkingYellowColor;
    }
  }

  final int _phelanMaxSpace = 30;

  Color _getPhelanStatusColor() {
    if (_phelanAvailableSpace == 0) {
      return parkingRedColor; // Red when full.
    } else if (_phelanAvailableSpace == _phelanMaxSpace) {
      return parkingGreenColor; // Green when completely empty.
    } else if (_phelanAvailableSpace < 30 && _phelanAvailableSpace > 15) {
      return parkingGreenColor;
    } else if (_phelanAvailableSpace <= 15 && _phelanAvailableSpace > 5) {
      return parkingYellowColor; // Yellow when mid-way full.
    } else if (_phelanAvailableSpace <= 5) {
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
              child: PRKAlingal4WEmployee(
                parkingArea: "Alingal",
                availableSpace: _alingalAvailableSpace.toString(),
                image: "assets/building_images/AlingalA-4W-E.png",
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
              child: PRKPhelan4WEmployee(
                parkingArea: "Phelan",
                availableSpace: _phelanAvailableSpace.toString(),
                image: "assets/building_images/Phelan-4W-E.png",
                dotColor: _getPhelanStatusColor(),
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
