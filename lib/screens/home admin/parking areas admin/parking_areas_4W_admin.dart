import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/controls%20admin/tab_admin.dart';
import 'package:park_in/components/ui/total_available_card.dart';

class ParkingAreas4WAdmin extends StatefulWidget {
  const ParkingAreas4WAdmin({super.key});

  @override
  State<ParkingAreas4WAdmin> createState() => _ParkingAreas4WAdminState();
}

class _ParkingAreas4WAdminState extends State<ParkingAreas4WAdmin> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');
  int _totalCount = 0;

  final List<String> _parkingAreaNames = [
    'Alingal',
    'Phelan',
    'Alingal A',
    'Alingal B',
    'Burns',
    'Coko Cafe',
    'Covered Court',
    'Library'
  ];

  @override
  void initState() {
    super.initState();
    _initializeDatabaseListeners();
  }

  void _initializeDatabaseListeners() {
    for (String area in _parkingAreaNames) {
      _databaseReference.child(area).onValue.listen((event) {
        _updateTotalCount();
      });
    }
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
          PRKTabAdmin(),
        ],
      ),
    );
  }
}
