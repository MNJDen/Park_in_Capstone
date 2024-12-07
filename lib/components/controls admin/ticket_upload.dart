import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKTicketsUpload extends StatefulWidget {
  final String label;
  final String hint;
  final VoidCallback onPressed;
  final File? image;
  final IconData icon;
  final VoidCallback onTap;

  const PRKTicketsUpload({
    super.key,
    required this.label,
    required this.hint,
    required this.onPressed,
    this.image,
    required this.icon,
    required this.onTap,
  });

  @override
  State<PRKTicketsUpload> createState() => _PRKTicketsUploadState();
}

class _PRKTicketsUploadState extends State<PRKTicketsUpload> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: blueColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: 50.w,
              decoration: BoxDecoration(
                color: blueColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: widget.image != null
                    ? GestureDetector(
                        onTap: () {
                          widget.onTap();
                        },
                        child: Image.file(
                          widget.image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.image,
                        color: blackColor.withOpacity(0.5),
                      ),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 12.r,
                  ),
                ),
                Text(
                  widget.hint,
                  style: TextStyle(
                    color: blackColor.withOpacity(0.5),
                    fontSize: 10.r,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                widget.onPressed();
              },
              icon: Icon(widget.icon),
            ),
          ],
        ),
      ),
    );
  }
}
