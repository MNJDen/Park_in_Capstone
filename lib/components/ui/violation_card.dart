import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:park_in/screens/misc/image_viewer_carousel.dart';
import 'package:shimmer/shimmer.dart';

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

    return DateFormat('MMM dd, yyyy | hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Offense #$offenseNumber",
                      style: TextStyle(
                        fontSize: 20.r,
                        color: blueColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fade(delay: const Duration(milliseconds: 200)),
                    Text(
                      formatTimestamp(ticket['timestamp']),
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w300),
                    ).animate().fade(delay: const Duration(milliseconds: 250)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                      color: blueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    ticket['vehicle_type'] == 'Two Wheels'
                        ? Icons.two_wheeler_rounded
                        : Icons.airport_shuttle_rounded,
                    size: 25.r,
                    color: blackColor,
                  ),
                ).animate().fade(delay: const Duration(milliseconds: 300)),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Violation:",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fade(delay: const Duration(milliseconds: 350)),
            SizedBox(height: 4.h),
            Text(
              "${ticket['violation']}",
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ).animate().fade(delay: const Duration(milliseconds: 400)),
            SizedBox(height: 12.h),
            Text(
              "Description:",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fade(delay: const Duration(milliseconds: 450)),
            SizedBox(height: 4.h),
            Text(
              "${ticket['description']?.isNotEmpty == true ? ticket['description'] : 'N/A'}",
              style: TextStyle(fontSize: 12.sp),
            ).animate().fade(delay: const Duration(milliseconds: 500)),
            SizedBox(height: 12.h),
            Text(
              "Attachments:",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fade(delay: const Duration(milliseconds: 550)),
            SizedBox(height: 4.h),
            ticket['close_up_image_url'] != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViolationImageViewer(
                                  currentImageUrl: ticket['close_up_image_url'],
                                  closeUpImageUrl: ticket['close_up_image_url'],
                                  midShotImageUrl: ticket['mid_shot_image_url'],
                                  wideShotImageUrl:
                                      ticket['wide_shot_image_url'],
                                )),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: blackColor.withOpacity(0.15),
                          width: 0.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          ticket['close_up_image_url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ).animate().fade(delay: const Duration(milliseconds: 600))
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
            SizedBox(height: 8.h),
            ticket['mid_shot_image_url'] != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViolationImageViewer(
                                  currentImageUrl: ticket['mid_shot_image_url'],
                                  closeUpImageUrl: ticket['close_up_image_url'],
                                  midShotImageUrl: ticket['mid_shot_image_url'],
                                  wideShotImageUrl:
                                      ticket['wide_shot_image_url'],
                                )),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: blackColor.withOpacity(0.15),
                          width: 0.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          ticket['mid_shot_image_url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ).animate().fade(delay: const Duration(milliseconds: 650))
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
            SizedBox(height: 8.h),
            ticket['wide_shot_image_url'] != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViolationImageViewer(
                                  currentImageUrl:
                                      ticket['wide_shot_image_url'],
                                  closeUpImageUrl: ticket['close_up_image_url'],
                                  midShotImageUrl: ticket['mid_shot_image_url'],
                                  wideShotImageUrl:
                                      ticket['wide_shot_image_url'],
                                )),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: blackColor.withOpacity(0.15),
                          width: 0.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          ticket['wide_shot_image_url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ).animate().fade(delay: const Duration(milliseconds: 700))
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ViolationImageViewer extends StatefulWidget {
  final String? currentImageUrl;
  final String? closeUpImageUrl;
  final String? midShotImageUrl;
  final String? wideShotImageUrl;

  const ViolationImageViewer({
    required this.currentImageUrl,
    required this.closeUpImageUrl,
    required this.midShotImageUrl,
    required this.wideShotImageUrl,
    super.key,
  });

  @override
  _ViolationImageViewerState createState() => _ViolationImageViewerState();
}

class _ViolationImageViewerState extends State<ViolationImageViewer> {
  late String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    currentImageUrl = widget.currentImageUrl;
  }

  void _nextImage() {
    setState(() {
      if (currentImageUrl == widget.closeUpImageUrl &&
          widget.midShotImageUrl != null) {
        currentImageUrl = widget.midShotImageUrl;
      } else if (currentImageUrl == widget.midShotImageUrl &&
          widget.wideShotImageUrl != null) {
        currentImageUrl = widget.wideShotImageUrl;
      } else if (currentImageUrl == widget.wideShotImageUrl &&
          widget.closeUpImageUrl != null) {
        currentImageUrl = widget.closeUpImageUrl;
      }
    });
  }

  void _previousImage() {
    setState(() {
      if (currentImageUrl == widget.wideShotImageUrl &&
          widget.midShotImageUrl != null) {
        currentImageUrl = widget.midShotImageUrl;
      } else if (currentImageUrl == widget.midShotImageUrl &&
          widget.closeUpImageUrl != null) {
        currentImageUrl = widget.closeUpImageUrl;
      } else if (currentImageUrl == widget.closeUpImageUrl &&
          widget.wideShotImageUrl != null) {
        currentImageUrl = widget.wideShotImageUrl;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: currentImageUrl != null
                    ? Image.network(currentImageUrl!)
                    : const Text(
                        'No image available',
                        style: TextStyle(color: whiteColor),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    currentImageUrl == widget.closeUpImageUrl &&
                            widget.wideShotImageUrl == null
                        ? blackColor.withOpacity(0.2)
                        : blackColor.withOpacity(0.5),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded, color: whiteColor),
                onPressed: currentImageUrl == widget.closeUpImageUrl &&
                        widget.wideShotImageUrl == null
                    ? null
                    : _previousImage,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    currentImageUrl == widget.wideShotImageUrl &&
                            widget.closeUpImageUrl == null
                        ? blackColor.withOpacity(0.2)
                        : blackColor.withOpacity(0.5),
                  ),
                ),
                icon:
                    const Icon(Icons.arrow_forward_rounded, color: whiteColor),
                onPressed: currentImageUrl == widget.wideShotImageUrl &&
                        widget.closeUpImageUrl == null
                    ? null
                    : _nextImage,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton.filled(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(whiteColor)),
                icon: const Icon(
                  Icons.close_rounded,
                  color: blackColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
