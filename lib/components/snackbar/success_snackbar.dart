import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

void successSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    elevation: 0,
    width: MediaQuery.of(context).size.width * 0.95,
    behavior: SnackBarBehavior.floating,
    backgroundColor: blackColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          color: successColor,
          size: 20.r,
        ),
        SizedBox(
          width: 8.w,
        ),
        Flexible(
          child: Text(
            message,
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
