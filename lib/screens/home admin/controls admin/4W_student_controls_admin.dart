import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/controls%20admin/control_admin.dart';

class Controls4WStudentAdmin extends StatefulWidget {
  const Controls4WStudentAdmin({super.key});

  @override
  State<Controls4WStudentAdmin> createState() => _Controls4WAdminState();
}

class _Controls4WAdminState extends State<Controls4WStudentAdmin> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');
  List<Map<String, dynamic>> _parkingAreas = [];

  final List<String> _parkingAreaNames = [
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
    _fetchSpecificParkingAreas();
  }

  void _fetchSpecificParkingAreas() async {
    List<Map<String, dynamic>> fetchedParkingAreas = [];

    for (String area in _parkingAreaNames) {
      DatabaseEvent event = await _databaseReference.child(area).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        // cast the value to a Map<String, dynamic>
        Map<String, dynamic>? areaData =
            (snapshot.value as Map?)?.cast<String, dynamic>();

        fetchedParkingAreas.add({
          'parkingArea': area,
          'count': areaData?['count'] ?? 0, // Default to 0 if count is null
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
    return ListView.builder(
      itemCount: _parkingAreas.length,
      itemBuilder: (context, index) {
        final parkingArea = _parkingAreas[index];
        return PRKControlsAdmin(
          parkingArea: parkingArea['parkingArea'],
          count: parkingArea['count'],
          dotColor: parkingArea['dotColor'],
        );
      },
    );
  }
}
