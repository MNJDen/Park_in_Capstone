import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKEmployeeeSticker extends StatelessWidget {
  final String stickerNumber;
  final String plateNumber;
  final String heroTag; // Add a heroTag parameter

  const PRKEmployeeeSticker({
    super.key,
    required this.stickerNumber,
    required this.plateNumber,
    required this.heroTag, // Include heroTag in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag, // Use the heroTag here
      child: Container(
        width: 320.w,
        height: 175.h,
        decoration: BoxDecoration(
          color: blueColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -60,
              child: Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              top: -50,
              right: -30,
              child: Container(
                width: 140.w,
                height: 140.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 20,
              child: Text(
                stickerNumber,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 40.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              child: Text(
                plateNumber,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 40.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: -197,
              child: Transform.rotate(
                angle: -0.995398,
                child: Container(
                  width: 400.w,
                  height: 37.5.h,
                  color: whiteColor,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: -293,
              child: Transform.rotate(
                angle: -0.995398,
                child: Container(
                  width: 400.w,
                  height: 37.5.h,
                  color: whiteColor,
                ),
              ),
            ),
            Positioned(
              top: 13,
              right: 10,
              child: CircleAvatar(
                radius: 24,
                child: Image.asset(
                  'assets/images/AdNU_Logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 20,
              child: Text(
                '© 2024 Park-In. All Rights Reserved.',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 10.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
