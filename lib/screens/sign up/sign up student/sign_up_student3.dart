import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class SignUpStudentScreen3 extends StatefulWidget {
  const SignUpStudentScreen3({Key? key}) : super(key: key);

  @override
  State<SignUpStudentScreen3> createState() => SignUpStudentScreen3State();
}

class SignUpStudentScreen3State extends State<SignUpStudentScreen3> {
  final List<TextEditingController> _stickerNumberCtrls =
      <TextEditingController>[];
  final List<TextEditingController> _plateNumberCtrls =
      <TextEditingController>[];
  final List<Widget> _stickerCards = <Widget>[];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;

    // Debugging: Print the existing data
    print("Sticker Numbers: ${userData.stickerNumber}");
    print("Plate Numbers: ${userData.plateNumber}");

    // Initialize controllers with existing data
    if (userData.stickerNumber != null && userData.plateNumber != null) {
      for (int i = 0; i < userData.stickerNumber!.length; i++) {
        _stickerNumberCtrls
            .add(TextEditingController(text: userData.stickerNumber![i]));
        _plateNumberCtrls
            .add(TextEditingController(text: userData.plateNumber![i]));
        _stickerCards.add(
          StickerFormField(
            stickerNumberCtrl: _stickerNumberCtrls[i],
            plateNumberCtrl: _plateNumberCtrls[i],
            stickerIndex: i + 1,
            onDelete: _removeSticker,
            index: i,
            onChanged: updateProviderData,
          ),
        );
      }
    }
  }

  void _addSticker() {
    setState(() {
      _stickerNumberCtrls.add(TextEditingController());
      _plateNumberCtrls.add(TextEditingController());

      _stickerCards.add(
        StickerFormField(
          stickerNumberCtrl: _stickerNumberCtrls.last,
          plateNumberCtrl: _plateNumberCtrls.last,
          stickerIndex: _stickerCards.length + 1,
          onDelete: _removeSticker,
          index: _stickerCards.length,
          onChanged: updateProviderData,
        ),
      );
    });

    updateProviderData();
  }

  void _removeSticker(int index) {
    setState(() {
      _stickerNumberCtrls.removeAt(index);
      _plateNumberCtrls.removeAt(index);
      _stickerCards.removeAt(index);
      _updateStickerIndices();
    });

    updateProviderData();
  }

  void _updateStickerIndices() {
    _stickerCards.clear();
    for (int i = 0; i < _stickerNumberCtrls.length; i++) {
      _stickerCards.add(
        StickerFormField(
          stickerNumberCtrl: _stickerNumberCtrls[i],
          plateNumberCtrl: _plateNumberCtrls[i],
          stickerIndex: i + 1,
          onDelete: _removeSticker,
          index: i,
          onChanged: updateProviderData,
        ),
      );
    }
  }

  void updateProviderData() {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);

    // Extract values from the controllers
    final stickers =
        _stickerNumberCtrls.map((controller) => controller.text).toList();
    final plates =
        _plateNumberCtrls.map((controller) => controller.text).toList();

    // Update the provider with the new values
    userDataProvider.updateUserData(
      stickerNumber: stickers,
      plateNumber: plates,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.h),
              Text(
                "How many stickers do you have?",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 24.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "You may add another sticker based on your possession. The color indicates that you are a student.",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(height: 32.h),
              for (int i = 0; i < _stickerCards.length; i++) _stickerCards[i],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    iconSize: 30.r,
                    onPressed: () {
                      _addSticker();
                      updateProviderData();
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(yellowColor),
                    ),
                    icon: const Icon(
                      Icons.add_rounded,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StickerFormField extends StatelessWidget {
  final TextEditingController stickerNumberCtrl;
  final TextEditingController plateNumberCtrl;
  final int stickerIndex;
  final Function(int) onDelete;
  final int index;
  final VoidCallback onChanged;

  StickerFormField({
    required this.stickerNumberCtrl,
    required this.plateNumberCtrl,
    required this.stickerIndex,
    required this.onDelete,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 15,
          shadowColor: blackColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          color: yellowColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sticker #$stickerIndex",
                      style: TextStyle(
                        fontSize: 16.r,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      child: Icon(
                        Icons.highlight_remove_rounded,
                        size: 25.r,
                        color: whiteColor,
                      ),
                      onTap: () => onDelete(index),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                PRKFormField(
                  prefixIcon: Icons.tag_rounded,
                  labelText: "Sticker Number",
                  controller: stickerNumberCtrl,
                  onChanged: (value) => onChanged(),
                ),
                SizedBox(height: 12.h),
                PRKFormField(
                  prefixIcon: Icons.pin_rounded,
                  labelText: "Plate Number",
                  controller: plateNumberCtrl,
                  onChanged: (value) => onChanged(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
