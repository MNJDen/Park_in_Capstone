import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/field/soft_field.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class SignUpStudentScreen3 extends StatefulWidget {
  final ValueChanged<bool> onFormValidityChanged;

  const SignUpStudentScreen3({Key? key, required this.onFormValidityChanged})
      : super(key: key);

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
        final stickerController =
            TextEditingController(text: userData.stickerNumber![i]);
        final plateController =
            TextEditingController(text: userData.plateNumber![i]);

        stickerController.addListener(_checkFormValidity);
        plateController.addListener(_checkFormValidity);

        _stickerNumberCtrls.add(stickerController);
        _plateNumberCtrls.add(plateController);

        _stickerCards.add(
          StickerFormField(
            stickerNumberCtrl: stickerController,
            plateNumberCtrl: plateController,
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
    final stickerController = TextEditingController();
    final plateController = TextEditingController();

    stickerController.addListener(_checkFormValidity);
    plateController.addListener(_checkFormValidity);

    setState(() {
      _stickerNumberCtrls.add(stickerController);
      _plateNumberCtrls.add(plateController);

      _stickerCards.add(
        StickerFormField(
          stickerNumberCtrl: stickerController,
          plateNumberCtrl: plateController,
          stickerIndex: _stickerCards.length + 1,
          onDelete: _removeSticker,
          index: _stickerCards.length,
          onChanged: updateProviderData,
        ),
      );
    });

    updateProviderData();
    _checkFormValidity();
  }

  void _removeSticker(int index) {
    setState(() {
      _stickerNumberCtrls.removeAt(index);
      _plateNumberCtrls.removeAt(index);
      _stickerCards.removeAt(index);
      _updateStickerIndices();
    });

    updateProviderData();
    widget.onFormValidityChanged(isFormValid());
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
    widget.onFormValidityChanged(isFormValid());
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

    _checkFormValidity();
  }

  bool isStickerCardsNotEmpty() {
    // Check if the list of sticker cards is not empty
    return _stickerCards.isNotEmpty;
  }

  bool isFormValid() {
    // Check if all sticker and plate number fields are filled
    bool areStickersValid =
        _stickerNumberCtrls.every((controller) => controller.text.isNotEmpty);
    bool arePlatesValid =
        _plateNumberCtrls.every((controller) => controller.text.isNotEmpty);
    bool isStickerCardsValid = isStickerCardsNotEmpty();

    return areStickersValid && arePlatesValid && isStickerCardsValid;
  }

  void _checkFormValidity() {
    bool isValid = _stickerNumberCtrls
            .every((controller) => controller.text.isNotEmpty) &&
        _plateNumberCtrls.every((controller) => controller.text.isNotEmpty) &&
        _stickerCards.isNotEmpty;

    widget.onFormValidityChanged(isValid); // Notify parent about form validity
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

  const StickerFormField({
    super.key,
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
        Container(
          width: 320.w,
          height: 175.h,
          decoration: BoxDecoration(
            color: yellowColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                left: -60,
                child: Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              Positioned(
                top: -50,
                right: -30,
                child: Container(
                  width: 140.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 20,
                child: PRKSoftField(
                  hintText: "1234",
                  maxLength: 4,
                  maxWidth: 100.w,
                  controller: stickerNumberCtrl,
                  keyboardType: TextInputType.number,
                  isFocused: false,
                ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                child: PRKSoftField(
                  hintText: "ESX458",
                  maxLength: 7,
                  maxWidth: 175.w,
                  controller: plateNumberCtrl,
                  keyboardType: TextInputType.text,
                  isFocused: false,
                ),
              ),
              Positioned(
                top: 0,
                right: -197,
                child: Transform.rotate(
                  angle: -0.995398,
                  child: Container(
                    width: 400.w,
                    height: 37.5.h,
                    color: whiteColor,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: -293,
                child: Transform.rotate(
                  angle: -0.995398,
                  child: Container(
                    width: 400.w,
                    height: 37.5.h,
                    color: whiteColor,
                  ),
                ),
              ),
              Positioned(
                top: 13,
                right: 10,
                child: GestureDetector(
                  child: Icon(
                    Icons.highlight_remove_rounded,
                    size: 25.r,
                    color: blackColor,
                  ),
                  onTap: () => onDelete(index),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 20,
                child: Text(
                  '© 2024 Park-In. All Rights Reserved.',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 10.r,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
