import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

class PRKAlingalB4WStundent extends StatefulWidget {
  final String parkingArea;
  final String availableSpace;
  final String image;
  final Color? dotColor;

  const PRKAlingalB4WStundent({
    super.key,
    required this.parkingArea,
    required this.availableSpace,
    required this.image,
    this.dotColor,
  });

  @override
  State<PRKAlingalB4WStundent> createState() => _PRKAlingalB4WStundentState();
}

class _PRKAlingalB4WStundentState extends State<PRKAlingalB4WStundent>
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
          Timer(Duration(milliseconds: 350), () {
            _animationController.reverse();
          });
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
                  offset: Offset(0, 4),
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
                    top: 38,
                    left: 21,
                    child: Text(
                      widget.availableSpace,
                      style: TextStyle(
                        fontSize: 48.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -41,
                    right: -60,
                    child: Image.asset(
                      widget.image,
                      height: 103.h,
                      width: 156.w,
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
