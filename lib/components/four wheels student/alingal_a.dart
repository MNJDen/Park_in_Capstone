import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/parking%20areas/four%20wheels%20student/alingal_A_4W.dart';

class PRKAlingalA4WStundent extends StatefulWidget {
  final String parkingArea;
  final String availableSpace;
  final String image;
  final Color? dotColor;

  const PRKAlingalA4WStundent({
    super.key,
    required this.parkingArea,
    required this.availableSpace,
    required this.image,
    this.dotColor,
  });

  @override
  State<PRKAlingalA4WStundent> createState() => _PRKAlingalA4WStundentState();
}

class _PRKAlingalA4WStundentState extends State<PRKAlingalA4WStundent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _colorAnimation = ColorTween(
      begin: whiteColor,
      end: const Color.fromARGB(255, 209, 210, 253),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_animationController.isAnimating) {
          _animationController.forward(from: 0);
          Timer(
            const Duration(milliseconds: 350),
            () {
              _animationController.reverse();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(
                          CurveTween(curve: Curves.fastEaseInToSlowEaseOut)
                              .animate(animation1)),
                      child: const Material(
                        elevation: 5,
                        child: AlingalA4W(),
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
              NavbarNotifier.hideBottomNavBar = true;
            },
          );
        }
      },
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            width: 154.w,
            height: 140.h,
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
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.availableSpace,
                        style: TextStyle(
                          fontSize: 48.r,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -16,
                    right: -51,
                    child: Image.asset(
                      widget.image,
                      // height: 97.h,
                      width: 150.w,
                    ),
                  ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
