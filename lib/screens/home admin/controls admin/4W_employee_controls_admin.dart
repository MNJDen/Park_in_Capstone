import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/controls%20admin/control_admin.dart';

class Controls4WEmployeeAdmin extends StatefulWidget {
  const Controls4WEmployeeAdmin({super.key});

  @override
  State<Controls4WEmployeeAdmin> createState() =>
      _Controls4WEmployeeAdminState();
}

class _Controls4WEmployeeAdminState extends State<Controls4WEmployeeAdmin> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');
  List<Map<String, dynamic>> _parkingAreas = [];

  final List<String> _parkingAreaNames = ['Alingal', 'Phelan'];

  @override
  void initState() {
    super.initState();
    _fetchSpecificParkingAreas();
  }

  void _fetchSpecificParkingAreas() async {
    List<Map<String, dynamic>> fetchedParkingAreas = [];

    for (String area in _parkingAreaNames) {
      DatabaseEvent event = await _databaseReference.child(area).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<String, dynamic>? areaData =
            (snapshot.value as Map?)?.cast<String, dynamic>();

        fetchedParkingAreas.add({
          'parkingArea': area,
          'count': areaData?['count'] ?? 0,
          'dotColor': parkingGreenColor, // Customize the color logic as needed
        });
      }
    }

    setState(() {
      _parkingAreas = fetchedParkingAreas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _parkingAreas.map((parkingArea) {
        return Padding(
          padding:
              EdgeInsets.symmetric(vertical: 2.h), // Reduced vertical padding
          child: PRKControlsAdmin(
            parkingArea: parkingArea['parkingArea'],
            count: parkingArea['count'],
            dotColor: parkingArea['dotColor'],
          ),
        );
      }).toList(),
    );
  }
}