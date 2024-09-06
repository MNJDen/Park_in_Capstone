import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKIconBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTapFunc;

  PRKIconBtn({
    required this.icon,
    required this.onTapFunc,
  });

  @override
  _PRKIconBtnState createState() => _PRKIconBtnState();
}

class _PRKIconBtnState extends State<PRKIconBtn> {
  bool _isPressed = false;

  void _handlePress() {
    setState(() {
      _isPressed = true; // Change color when tapped
    });

    // Reset color back to original after 300ms
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _isPressed = false;
      });
    });

    widget.onTapFunc();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handlePress, // Trigger color change on tap
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation, // Fade effect for smooth transition
            child: child,
          );
        },
        child: Icon(
          widget.icon,
          key: ValueKey<bool>(_isPressed),
          color: _isPressed
              ? blueColor
              : blackColor, // Toggle between red and grey
          size: 20.r,
        ),
      ),
    );
  }
}
