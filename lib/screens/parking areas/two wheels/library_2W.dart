import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

class Library2w extends StatefulWidget {
  const Library2w({super.key});

  _Library2wState createState() => _Library2wState();
}

class _Library2wState extends State<Library2w> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('parkingAreas');

  int _library2wAvailableSpace = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _databaseReference.child('Library (M)').onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        final Map<String, dynamic>? data =
            (snapshot.value as Map?)?.cast<String, dynamic>();
        if (mounted) {
          setState(() {
            _library2wAvailableSpace = data?['count'] ?? 0;
          });
        }
      }
    });
  }

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
                    "Library",
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
                              color: _library2wAvailableSpace > 0
                                  ? parkingGreenColor
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "$_library2wAvailableSpace",
                    style: TextStyle(
                      fontSize: 52.sp,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Image.asset(
                "assets/building_images/Library-2W.png",
                width: 360.w,
                height: 436.h,
              ),
              SizedBox(
                height: 20.h,
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
