import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/parking%20areas/four%20wheels%20employee/alingal_4W_employee.dart';

class PRKAlingal4WEmployee extends StatefulWidget {
  final String parkingArea;
  final String availableSpace;
  final String image;
  final Color? dotColor;
  final bool isFull;

  const PRKAlingal4WEmployee({
    super.key,
    required this.parkingArea,
    required this.availableSpace,
    required this.image,
    this.dotColor,
    required this.isFull,
  });

  @override
  State<PRKAlingal4WEmployee> createState() => _PRKAlingal4WEmployeeState();
}

class _PRKAlingal4WEmployeeState extends State<PRKAlingal4WEmployee>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  double _blurOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _colorAnimation = ColorTween(
      begin: whiteColor,
      end: const Color.fromRGBO(171, 198, 255, 1),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFull) {
      _blurOpacity = 1;
    } else {
      _blurOpacity = 0;
    }

    return GestureDetector(
      onTap: () {
        if (!_animationController.isAnimating) {
          _animationController.forward(from: 0);
          Timer(
            const Duration(milliseconds: 350),
            () {
              _animationController.reverse();
              NavbarNotifier.hideBottomNavBar = true;
              showAlingal4wEmployeeBottomSheet(context);
            },
          );
        }
      },
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 140.h,
            child: Container(
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(
                  10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Text(
                        widget.parkingArea,
                        style: TextStyle(
                          fontSize: 12.r,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -35,
                      right: -139,
                      child: Image.asset(
                        widget.image,
                        height: 206.h,
                        width: 360.w,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 7.w,
                        height: 7.w,
                        decoration: BoxDecoration(
                          color: widget.dotColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _blurOpacity,
                      duration: const Duration(milliseconds: 500),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                          child: const SizedBox()),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Opacity(
                          opacity: widget.isFull ? 1 : 1,
                          child: Text(
                            widget.availableSpace,
                            style: TextStyle(
                              fontSize: 48.r,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ).animate().fade(delay: const Duration(milliseconds: 300)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
