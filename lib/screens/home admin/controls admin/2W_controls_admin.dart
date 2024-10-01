import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/controls%20admin/control_admin.dart';

class Controls2WAdmin extends StatefulWidget {
  const Controls2WAdmin({super.key});

  @override
  State<Controls2WAdmin> createState() => _Controls2WAdminState();
}

class _Controls2WAdminState extends State<Controls2WAdmin> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');
  List<Map<String, dynamic>> _parkingAreas = [];

  final List<String> _parkingAreaNames = [
    'Alingal (M)',
    'Dolan (M)',
    'Library (M)'
  ];

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
          'dotColor': parkingGreenColor,
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
        return PRKControlsAdmin(
          parkingArea: parkingArea['parkingArea'],
          count: parkingArea['count'],
          dotColor: parkingArea['dotColor'],
        );
      }).toList(),
    );
  }
}
