import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

class Alingal4wEmployee extends StatelessWidget {
  const Alingal4wEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 32.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: blackColor,
                      ),
                    ),
                  ),
                  Text(
                    "Alingal",
                    style: TextStyle(
                      fontSize: 20.r,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Capacity",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: blackColor,
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Container(
                            width: 7.w,
                            height: 7.w,
                            decoration: BoxDecoration(
                              color: parkingGreenColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "11",
                    style: TextStyle(
                      fontSize: 52.sp,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Image.asset(
                "assets/building_images/AlingalA-4W-E.png",
                width: 352.w,
                height: 232.h,
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_rounded,
                    color: blackColor,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Flexible(
                    child: Text(
                      "Always be mindful of the space between vehicles.",
                      softWrap: true,
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
