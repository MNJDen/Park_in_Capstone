import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/total_available_card.dart';
import 'package:park_in/screens/home%20admin/controls%20admin/2W_controls_admin.dart';

class ParkingAreas2WAdmin extends StatefulWidget {
  const ParkingAreas2WAdmin({super.key});

  @override
  State<ParkingAreas2WAdmin> createState() => _ParkingAreas2WAdminState();
}

class _ParkingAreas2WAdminState extends State<ParkingAreas2WAdmin> {
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
          )
        ],
      ),
    );
  }
}
