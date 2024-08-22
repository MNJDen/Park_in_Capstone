import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/controls%20admin/tab_admin.dart';
import 'package:park_in/components/total_available_card.dart';

class ParkingAreas4WAdmin extends StatefulWidget {
  const ParkingAreas4WAdmin({super.key});

  @override
  State<ParkingAreas4WAdmin> createState() => _ParkingAreas4WAdminState();
}

class _ParkingAreas4WAdminState extends State<ParkingAreas4WAdmin> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          PRKTotalAvailableCard(value: "44"),
          SizedBox(
            height: 12.h,
          ),
          PRKTabAdmin(), // Use Expanded here
        ],
      ),
    );
  }
}
