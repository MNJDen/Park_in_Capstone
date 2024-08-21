import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';

class PRKFormField extends StatefulWidget {
  final IconData? prefixIcon;
  final String labelText;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool? enable;
  final bool obscureText; // Add this property
  final TextInputType? keyboardType; // Add this property
  final void Function(String)? onChanged;

  PRKFormField({
    required this.prefixIcon,
    required this.labelText,
    this.suffixIcon,
    required this.controller,
    this.validator,
    this.enable,
    this.obscureText = false, // Set default value to false
    this.keyboardType,
    this.onChanged, // Set default value to null
  });

  @override
  _PRKFormFieldState createState() => _PRKFormFieldState();
}

class _PRKFormFieldState extends State<PRKFormField> {
  bool _obscureText = true;
  bool _isFocused = false;

  late FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.obscureText;
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

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enable,
      focusNode: _focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      style: TextStyle(
        fontSize: 12.r,
        color: blackColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: whiteColor,
        prefixIcon: Icon(
          size: 20,
          widget.prefixIcon,
          color: _isFocused ? blueColor : blackColor,
        ),
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                icon: Icon(
                  _obscureText ? widget.suffixIcon : Icons.visibility_rounded,
                  color: _isFocused ? blueColor : blackColor,
                ),
                onPressed: () {
                  if (widget.suffixIcon != null) {
                    _toggleObscureText();
                  }
                },
              )
            : null,
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
            width: 0.5.w,
            color: borderBlack,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontSize: 12.r,
          color: _isFocused ? blueColor : blackColor,
        ),
      ),
      validator: widget.validator,
      onFieldSubmitted: (_) {
        setState(() {
          _isFocused = false;
        });
      },
    );
  }
}
