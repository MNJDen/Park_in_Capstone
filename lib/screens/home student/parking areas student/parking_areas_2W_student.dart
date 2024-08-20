import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/two%20wheels/alingal.dart';
import 'package:park_in/components/two%20wheels/dolan.dart';
import 'package:park_in/components/two%20wheels/library.dart';

class ParkingArea2W extends StatelessWidget {
  const ParkingArea2W({super.key});

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
              child: PRKAlingal2W(
                parkingArea: "Alingal",
                availableSpace: "11",
                image: "assets/building_images/Alingal-2W.png",
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
              child: PRKDolan2W(
                parkingArea: "Dolan",
                availableSpace: "11",
                image: "assets/building_images/Dolan-2W.png",
                dotColor: parkingYellowColor,
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
              child: PRKLibrary2W(
                parkingArea: "Library",
                availableSpace: "11",
                image: "assets/building_images/Library-2W.png",
                dotColor: parkingRedColor,
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
        SizedBox(
          height: 100.h,
        ),
      ],
    );
  }
}
