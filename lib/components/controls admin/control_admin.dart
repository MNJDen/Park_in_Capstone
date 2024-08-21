import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

class PRKControlsAdmin extends StatefulWidget {
  final String parkingArea;
  final int count;
  final Color dotColor;

  const PRKControlsAdmin({
    super.key,
    required this.parkingArea,
    required this.count,
    required this.dotColor,
  });

  @override
  State<PRKControlsAdmin> createState() => _PRKControlsAdminState();
}

class _PRKControlsAdminState extends State<PRKControlsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.parkingArea,
              style: TextStyle(
                fontSize: 12.r,
                color: blackColor,
              ),
            ),
          ),
          Container(
            width: 7.w,
            height: 7.w,
            decoration: BoxDecoration(
              color: widget.dotColor,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          SizedBox(
            width: 40.w,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                iconSize: 30,
                color: blueColor,
                onPressed: () {},
              ),
              SizedBox(width: 5.w),
              Text(
                "${widget.count}",
                style: TextStyle(
                  fontSize: 16.r,
                  color: blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 5.w),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                iconSize: 30,
                color: blueColor,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
