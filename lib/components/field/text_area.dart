import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKTextArea extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;

  PRKTextArea({
    required this.labelText,
    required this.controller,
  });

  @override
  _PRKTextAreaState createState() => _PRKTextAreaState();
}

class _PRKTextAreaState extends State<PRKTextArea> {
  bool _isFocused = false;

  late FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      maxLines: 5,
      style: TextStyle(
        fontSize: 12.r,
        color: blackColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: whiteColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1.w,
            color: blueColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0.1.w,
            color: borderBlack,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontSize: 12.r,
          color: _isFocused ? blueColor : blackColor,
        ),
        alignLabelWithHint: true, // Add this line
      ),
      onFieldSubmitted: (_) {
        setState(() {
          _isFocused = false;
        });
      },
    );
  }
}