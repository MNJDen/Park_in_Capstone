import 'package:flutter/material.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class PRKBackBtn extends StatelessWidget {
  const PRKBackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: blackColor,
      enableFeedback: true,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }
}
