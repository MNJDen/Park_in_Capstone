import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/controls%20admin/control_admin.dart';

class Controls2WAdmin extends StatefulWidget {
  const Controls2WAdmin({super.key});

  @override
  State<Controls2WAdmin> createState() => _Controls2WAdminState();
}

class _Controls2WAdminState extends State<Controls2WAdmin> {
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
          parkingArea: "Dolan",
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
