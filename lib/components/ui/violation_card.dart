import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PRKViolationCard extends StatefulWidget {
  final String offenseNumber;
  final String date;
  final String violation;
  final String violationClassification;

  const PRKViolationCard({
    Key? key,
    required this.offenseNumber,
    required this.date,
    required this.violation,
    required this.violationClassification,
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
                  offset: const Offset(0, 4),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Violation",
                        style: TextStyle(
                          fontSize: 12.r,
                          // fontWeight: FontWeight.w400,
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        widget.violationClassification,
                        style: TextStyle(
                          fontSize: 12.r,
                          // fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: blackColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    widget.violation,
                    style: TextStyle(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w400,
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

void showViolationCard(
    BuildContext context, Map<String, dynamic> ticket, int offenseNumber) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: bgColor,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            NavbarNotifier.hideBottomNavBar = false;
            return;
          }
        },
        child: ViolationCardBottomSheet(
            ticket: ticket, offenseNumber: offenseNumber),
      );
    },
  );
}

class ViolationCardBottomSheet extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final int offenseNumber;

  const ViolationCardBottomSheet(
      {super.key, required this.ticket, required this.offenseNumber});

  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "N/A";

    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate(); // Convert Firestore Timestamp
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return "Invalid date";
    }

    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Offense #$offenseNumber",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          SizedBox(height: 6.h),
          Text(
            "Violation: ${ticket['violation']}",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            "Description: ${ticket['description']?.isNotEmpty == true ? ticket['description'] : 'N/A'}",
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            "Vehicle Type: ${ticket['vehicle_type']}",
            style: TextStyle(fontSize: 14.sp, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 4.h),
          Text(
            "Time and Date Issued: ${formatTimestamp(ticket['timestamp'])}",
            style: TextStyle(fontSize: 14.sp, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 8.h),
          ticket['close_up_image_url'] != null
              ? Image.network(ticket['close_up_image_url'],
                  height: 100.h, fit: BoxFit.cover)
              : Container(),
          SizedBox(height: 8.h),
          ticket['mid_shot_image_url'] != null
              ? Image.network(ticket['mid_shot_image_url'],
                  height: 100.h, fit: BoxFit.cover)
              : Container(),
          SizedBox(height: 8.h),
          ticket['wide_shot_image_url'] != null
              ? Image.network(ticket['wide_shot_image_url'],
                  height: 100.h, fit: BoxFit.cover)
              : Container(),
        ],
      ),
    );
  }
}
