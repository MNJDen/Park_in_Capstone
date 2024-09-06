import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/screens/home%20admin/announcement_admin.dart';

class PRKAnnouncement extends StatefulWidget {
  const PRKAnnouncement({super.key});

  @override
  State<PRKAnnouncement> createState() => _PRKAnnouncementState();
}

class _PRKAnnouncementState extends State<PRKAnnouncement>
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
            Duration(milliseconds: 350),
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
                        child: AnnouncementAdminScreen(),
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
          );
        }
      },
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            width: 98.w,
            height: 74.h,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.campaign_outlined,
                  size: 24.r,
                  color: blackColor,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "Post",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 12.r,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}