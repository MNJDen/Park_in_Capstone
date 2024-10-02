import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKControlsAdmin extends StatefulWidget {
  final String parkingArea;
  final int count;
  final Color dotColor;

  const PRKControlsAdmin({
    super.key,
    required this.parkingArea,
    this.count = 0, // Ensure a default value if count is not provided
    required this.dotColor,
  });

  @override
  State<PRKControlsAdmin> createState() => _PRKControlsAdminState();
}

class _PRKControlsAdminState extends State<PRKControlsAdmin> {
  late int _currentCount;
  late DatabaseReference _databaseReference;

  // Define maximum counts for each parking area
  final Map<String, int> _maxCounts = {
    'Alingal': 30,
    'Phelan': 30,
    'Alingal A': 35,
    'Alingal B': 13,
    'Burns': 15,
    'Coko Cafe': 16,
    'Covered Court': 19,
    'Library': 9,
    'Alingal (M)': 80,
    'Dolan (M)': 50,
    'Library (M)': 80,
  };

  @override
  void initState() {
    super.initState();
    _currentCount = widget.count;
    _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('parkingAreas')
        .child(widget.parkingArea);
  }

  void _updateCount(int change) {
    // Calculate the new count
    int newCount = _currentCount + change;

    // Get the maximum allowed count for the parking area
    int maxCount = _maxCounts[widget.parkingArea] ?? 0;

    if (newCount < 0) {
      newCount = 0;
      errorSnackbar(context, "Already at 0");
    } else if (newCount > maxCount) {
      newCount = maxCount;
      errorSnackbar(context, "Already at maximum capacity");
    } else {
      setState(() {
        _currentCount = newCount;
      });

      // Update the count in the Realtime Database
      _databaseReference.update({
        'count': _currentCount,
      });
    }
  }

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
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 30,
                color: blueColor,
                onPressed: () => _updateCount(-1),
              ),
              SizedBox(width: 5.w),
              Container(
                alignment: Alignment.center,
                width: 20.w,
                child: Text(
                  "$_currentCount",
                  style: TextStyle(
                    fontSize: 16.r,
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 30,
                color: blueColor,
                onPressed: () => _updateCount(1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
