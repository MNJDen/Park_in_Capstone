import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/controls%20admin/control_admin.dart';

class Controls4WEmployeeAdmin extends StatefulWidget {
  const Controls4WEmployeeAdmin({super.key});

  @override
  State<Controls4WEmployeeAdmin> createState() => _Controls4WEmployeeAdminState();
}

class _Controls4WEmployeeAdminState extends State<Controls4WEmployeeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 4.h,
        ),
        PRKControlsAdmin(
          parkingArea: "Alingal",
          count: 14,
          dotColor: parkingGreenColor,
        ),
         PRKControlsAdmin(
          parkingArea: "Phelan",
          count: 14,
          dotColor: parkingGreenColor,
        ),
      ],
    );
  }
}
