import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKSwitchBtn extends StatefulWidget {
  final String parkingArea;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const PRKSwitchBtn({
    super.key,
    required this.parkingArea,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<PRKSwitchBtn> createState() => _PRKSwitchBtnState();
}

class _PRKSwitchBtnState extends State<PRKSwitchBtn> {
  late bool currentIndex; // Store toggle state locally

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialValue; // Set initial value
    _loadToggleState(); // Load saved state from SharedPreferences
  }

  // Load toggle state from SharedPreferences
  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedState = prefs.getBool(widget.parkingArea);
    if (savedState != null && mounted) {
      setState(() {
        currentIndex = savedState;
      });
    }
  }

  // Save toggle state to SharedPreferences
  Future<void> _saveToggleState(bool isOccupied) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.parkingArea, isOccupied);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedToggleSwitch<bool>.dual(
            current: currentIndex,
            first: false,
            second: true,
            indicatorSize: const Size(40, 40),
            indicatorTransition: const ForegroundIndicatorTransition.fading(),
            textMargin: const EdgeInsets.only(left: 1),
            spacing: 1,
            animationDuration: const Duration(milliseconds: 500),
            style: const ToggleStyle(
              borderColor: Colors.transparent,
              indicatorColor: Colors.white,
            ),
            customStyleBuilder: (context, local, global) => ToggleStyle(
              backgroundGradient: LinearGradient(
                colors: [blueColor, blueColor.withOpacity(0.2)],
                stops: [
                  global.position -
                      (1 - 2 * max(0, global.position - 0.5)) * 0.5,
                  global.position + max(0, 2 * (global.position - 0.5)) * 0.5,
                ],
              ),
            ),
            borderWidth: 5.0,
            height: 50.h,
            loadingIconBuilder: (context, global) => CupertinoActivityIndicator(
              color: Color.lerp(blackColor, blueColor, global.position),
            ),
            onChanged: (b) async {
              setState(() => currentIndex = b);
              await _saveToggleState(b); // Save locally
              widget.onChanged(b); // Notify parent widget
            },
            iconBuilder: (value) => value
                ? const Icon(Icons.chevron_left_rounded,
                    color: blueColor, size: 28)
                : const Icon(Icons.chevron_right_rounded,
                    color: blackColor, size: 28),
            textBuilder: (value) => Text(
              value ? 'Occupying Parking' : 'Occupy Parking?',
              style: TextStyle(
                color: value ? whiteColor : blackColor,
                fontSize: 16.r,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
