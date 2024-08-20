import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/four%20wheels%20employee/alingal.dart';
import 'package:park_in/components/four%20wheels%20employee/phelan.dart';

class ParkingArea4WEmployee extends StatelessWidget {
  const ParkingArea4WEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Parking Areas",
              style: TextStyle(
                fontSize: 16.r,
                color: blackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        const Row(
          children: [
            Expanded(
              child: PRKAlingal4WEmployee(
                parkingArea: "Alingal",
                availableSpace: "11",
                image: "assets/building_images/AlingalA-4W-E.png",
                dotColor: parkingGreenColor,
              ),
            )
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        const Row(
          children: [
            Expanded(
              child: PRKPhelan4WEmployee(
                parkingArea: "Phelan",
                availableSpace: "11",
                image: "assets/building_images/Phelan-4W-E.png",
                dotColor: parkingYellowColor,
              ),
            )
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Numbers displayed are approximate",
              softWrap: true,
              style: TextStyle(
                color: blackColor,
                fontSize: 12.r,
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
