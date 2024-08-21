import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/controls%20admin/control_admin.dart';

class Controls4WStudentAdmin extends StatefulWidget {
  const Controls4WStudentAdmin({super.key});

  @override
  State<Controls4WStudentAdmin> createState() => _Controls4WAdminState();
}

class _Controls4WAdminState extends State<Controls4WStudentAdmin> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 4.h,
        ),
        PRKControlsAdmin(
          parkingArea: "Alingal A",
          count: 14,
          dotColor: parkingGreenColor,
        ),
        PRKControlsAdmin(
          parkingArea: "Alingal B",
          count: 14,
          dotColor: parkingGreenColor,
        ),
         PRKControlsAdmin(
          parkingArea: "Burns",
          count: 14,
          dotColor: parkingGreenColor,
        ),
         PRKControlsAdmin(
          parkingArea: "Coko Cafe",
          count: 14,
          dotColor: parkingGreenColor,
        ),
         PRKControlsAdmin(
          parkingArea: "Covered Court",
          count: 14,
          dotColor: parkingGreenColor,
        ),
         PRKControlsAdmin(
          parkingArea: "Library",
          count: 14,
          dotColor: parkingGreenColor,
        ),
      ],
    );
  }
}
