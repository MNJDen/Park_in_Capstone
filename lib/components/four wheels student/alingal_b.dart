import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/parking%20areas/four%20wheels%20student/alingal_B_4W.dart';

class PRKAlingalB4WStundent extends StatefulWidget {
  final String parkingArea;
  final String availableSpace;
  final String image;
  final Color? dotColor;
  final bool isFull;

  const PRKAlingalB4WStundent({
    super.key,
    required this.parkingArea,
    required this.availableSpace,
    required this.image,
    this.dotColor,
    required this.isFull,
  });

  @override
  State<PRKAlingalB4WStundent> createState() => _PRKAlingalB4WStundentState();
}

class _PRKAlingalB4WStundentState extends State<PRKAlingalB4WStundent>
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
                        child: AlingalB4W(),
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
                  Positioned(
                    bottom: -41,
                    right: -63,
                    child: Image.asset(
                      widget.image,
                      // height: 103.h,
                      width: 160.w,
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
                  ).animate().fade(delay: const Duration(milliseconds: 350)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
