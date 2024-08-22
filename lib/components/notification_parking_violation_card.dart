import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

class PRKParkingViolationNotificationCard extends StatelessWidget {
  final String date;

  PRKParkingViolationNotificationCard({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Icon(
              Icons.priority_high_rounded,
              color: parkingRedColor,
              size: 30.r,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Parking Violation",
                      style: TextStyle(
                        fontSize: 16.r,
                        fontWeight: FontWeight.w700,
                        color: blackColor,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12.r,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "You just got cited a ticket. Check it on your record and settle it asap.",
                  style: TextStyle(
                    fontSize: 12.r,
                    color: blackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
