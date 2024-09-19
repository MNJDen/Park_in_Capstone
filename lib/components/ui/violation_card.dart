import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKViolationCard extends StatefulWidget {
  final String offenseNumber;
  final String date;
  final String violation;

  const PRKViolationCard({
    Key? key,
    required this.offenseNumber,
    required this.date,
    required this.violation,
  }) : super(key: key);

  @override
  State<PRKViolationCard> createState() => _PRKViolationCardState();
}

class _PRKViolationCardState extends State<PRKViolationCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
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
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.offenseNumber,
                        style: TextStyle(
                          fontSize: 16.r,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.date,
                        style: TextStyle(
                          fontSize: 12.r,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(height: 8.h),
                  Text(
                    "Violation:",
                    style: TextStyle(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(27, 27, 27, 0.5),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    widget.violation,
                    style: TextStyle(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
