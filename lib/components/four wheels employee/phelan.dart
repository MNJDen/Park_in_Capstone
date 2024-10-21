import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/parking%20areas/four%20wheels%20employee/phelan_4W_employee.dart';

class PRKPhelan4WEmployee extends StatefulWidget {
  final String parkingArea;
  final String availableSpace;
  final String image;
  final Color? dotColor;

  const PRKPhelan4WEmployee({
    super.key,
    required this.parkingArea,
    required this.availableSpace,
    required this.image,
    this.dotColor,
  });

  @override
  State<PRKPhelan4WEmployee> createState() => _PRKPhelan4WEmployeeState();
}

class _PRKPhelan4WEmployeeState extends State<PRKPhelan4WEmployee>
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
                        child: Phelan4wEmployee(),
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
                      bottom: -60,
                      right: -175,
                      child: Image.asset(
                        widget.image,
                        height: 206.h,
                        width: 360.w,
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
