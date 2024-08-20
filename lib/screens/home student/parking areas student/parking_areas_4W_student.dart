import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/four%20wheels%20student/alingal_a.dart';
import 'package:park_in/components/four%20wheels%20student/alingal_b.dart';
import 'package:park_in/components/four%20wheels%20student/burns.dart';
import 'package:park_in/components/four%20wheels%20student/coko_cafe.dart';
import 'package:park_in/components/four%20wheels%20student/covered_court.dart';
import 'package:park_in/components/four%20wheels%20student/library.dart';


class ParkingArea4WStudent extends StatefulWidget {
  const ParkingArea4WStudent({super.key});

  @override
  State<ParkingArea4WStudent> createState() => _ParkingArea4WStudentState();
}

class _ParkingArea4WStudentState extends State<ParkingArea4WStudent> {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PRKAlingalA4WStundent(
              parkingArea: "Alingal A",
              availableSpace: "11",
              image: "assets/building_images/AlingalA-4W-S.png",
              dotColor: parkingGreenColor,
            ),
            PRKAlingalB4WStundent(
              parkingArea: "Alingal B",
              availableSpace: "28",
              image: "assets/building_images/AlingalB-4W-S.png",
              dotColor: parkingGreenColor,
            ),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PRKBurns4WStundent(
              parkingArea: "Burns",
              availableSpace: "01",
              image: "assets/building_images/Burns-4W-S.png",
              dotColor: parkingYellowColor,
            ),
            PRKCoko4WStundent(
              parkingArea: "Coko Cafe",
              availableSpace: "20",
              image: "assets/building_images/Coko-4W-S.png",
              dotColor: parkingYellowColor,
            ),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PRKCC4WStundent(
              parkingArea: "Covered Court",
              availableSpace: "13",
              image: "assets/building_images/CC-4W-S.png",
              dotColor: parkingRedColor,
            ),
            PRKLibrary4WStundent(
              parkingArea: "Library",
              availableSpace: "7",
              image: "assets/building_images/Library-4W-S.png",
              dotColor: parkingRedColor,
            ),
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
