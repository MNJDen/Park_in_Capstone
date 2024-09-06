import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/ui/total_available_card.dart';
import 'package:park_in/screens/home%20admin/controls%20admin/2W_controls_admin.dart';

class ParkingAreas2WAdmin extends StatefulWidget {
  const ParkingAreas2WAdmin({super.key});

  @override
  State<ParkingAreas2WAdmin> createState() => _ParkingAreas2WAdminState();
}

class _ParkingAreas2WAdminState extends State<ParkingAreas2WAdmin> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');
  int _totalCount = 0;
  final List<String> _parkingAreaNames = [
    'Alingal (M)',
    'Dolan (M)',
    'Library (M)'
  ];

  late List<StreamSubscription<DatabaseEvent>> _subscriptions;

  @override
  void initState() {
    super.initState();
    _initializeDatabaseListeners();
  }

  void _initializeDatabaseListeners() {
    _subscriptions = _parkingAreaNames.map((area) {
      return _databaseReference.child(area).onValue.listen((event) {
        if (mounted) {
          _updateTotalCount();
        }
      });
    }).toList();
  }

  void _updateTotalCount() async {
    int totalCount = 0;

    for (String area in _parkingAreaNames) {
      DatabaseEvent event = await _databaseReference.child(area).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<String, dynamic>? areaData =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        int count = areaData?['count'] ?? 0;
        totalCount += count;
      }
    }

    if (mounted) {
      setState(() {
        _totalCount = totalCount;
      });
    }
  }

  @override
  void dispose() {
    // Cancel all subscriptions when the widget is disposed
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 12.h,
          ),
          PRKTotalAvailableCard(value: _totalCount.toString()),
          SizedBox(
            height: 12.h,
          ),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Controls2WAdmin(),
          ),
        ],
      ),
    );
  }
}
