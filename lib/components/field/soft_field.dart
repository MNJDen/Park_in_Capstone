import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKSoftField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final int? maxLength;
  final double maxWidth;
  final bool isFocused;

  const PRKSoftField({
    super.key,
    required this.controller,
    this.onChanged,
    this.keyboardType,
    required this.hintText,
    this.maxLength,
    required this.maxWidth,
    required this.isFocused,
  });

  @override
  _PRKSoftFieldState createState() => _PRKSoftFieldState();
}

class _PRKSoftFieldState extends State<PRKSoftField> {
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
      keyboardType: widget.keyboardType,
      autofocus: widget.isFocused,
      inputFormatters: [
        TextInputFormatter.withFunction(
          (oldValue, newValue) {
            return newValue.copyWith(text: newValue.text.toUpperCase());
          },
        ),
      ],
      style: TextStyle(
        color: whiteColor,
        fontSize: 40.r,
        fontWeight: FontWeight.w700,
      ),
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        counterText: '',
        isDense: true,
        isCollapsed: true,
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth,
          // maxHeight: 70.h,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.h,
            color: whiteColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.h,
            color: whiteColor.withOpacity(0.3),
          ),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: whiteColor.withOpacity(0.3),
          fontSize: 40.r,
          fontWeight: FontWeight.w700,
        ),
      ),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
