import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_in/components/color_scheme.dart';
import 'package:park_in/components/form_field.dart';

class SignUpStudentScreen3 extends StatefulWidget {
  const SignUpStudentScreen3({super.key});

  @override
  State<SignUpStudentScreen3> createState() => _SignUpStudentScreen3State();
}

class _SignUpStudentScreen3State extends State<SignUpStudentScreen3> {
  final List<TextEditingController> _stickerNumberCtrls =
      <TextEditingController>[];
  final List<TextEditingController> _plateNumberCtrls =
      <TextEditingController>[];
  final List<Widget> _stickerCards = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 28.h,
              ),
              Text(
                "How many stickers do you have?",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 24.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "You may add another sticker based on your possession. The color indicates that you are a student. ",
                style: TextStyle(
                  color: blackColor,
                  fontSize: 12.r,
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              for (int i = 0; i < _stickerCards.length; i++) _stickerCards[i],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    iconSize: 30.r,
                    onPressed: () {
                      setState(
                        () {
                          _stickerNumberCtrls.add(TextEditingController());
                          _plateNumberCtrls.add(TextEditingController());
                          _stickerCards.add(
                            StickerFormField(
                              stickerNumberCtrl: _stickerNumberCtrls.last,
                              plateNumberCtrl: _plateNumberCtrls.last,
                              stickerIndex: _stickerCards.length + 1,
                              onDelete: (index) {
                                setState(() {
                                  _stickerNumberCtrls.removeAt(index);
                                  _plateNumberCtrls.removeAt(index);
                                  _stickerCards.removeAt(index);
                                  _updateStickerIndices();
                                });
                              },
                              index: _stickerCards.length,
                            ),
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(yellowColor),
                    ),
                    icon: Icon(
                      Icons.add_rounded,
                      color: blackColor,
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

  void _updateStickerIndices() {
    _stickerCards.clear();
    for (int i = 0; i < _stickerNumberCtrls.length; i++) {
      _stickerCards.add(
        StickerFormField(
          stickerNumberCtrl: _stickerNumberCtrls[i],
          plateNumberCtrl: _plateNumberCtrls[i],
          stickerIndex: i + 1,
          onDelete: (index) {
            setState(() {
              _stickerNumberCtrls.removeAt(index);
              _plateNumberCtrls.removeAt(index);
              _stickerCards.removeAt(index);
              _updateStickerIndices();
            });
          },
          index: i,
        ),
      );
    }
  }
}

class StickerFormField extends StatelessWidget {
  final TextEditingController stickerNumberCtrl;
  final TextEditingController plateNumberCtrl;
  final int stickerIndex;
  final Function(int) onDelete; // Change the type of onDelete to Function(int)
  final int index;

  StickerFormField({
    required this.stickerNumberCtrl,
    required this.plateNumberCtrl,
    required this.stickerIndex,
    required this.onDelete,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 15,
          shadowColor: Color.fromRGBO(27, 27, 27, 0.2),
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
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Icon(Icons.highlight_remove_rounded, size: 25.r,),
                      onTap:() => onDelete(index),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                PRKFormField(
                  prefixIcon: Icons.tag_rounded,
                  labelText: "Sticker Number",
                  controller: stickerNumberCtrl,
                ),
                SizedBox(
                  height: 12.h,
                ),
                PRKFormField(
                  prefixIcon: Icons.pin_rounded,
                  labelText: "Plate Number",
                  controller: plateNumberCtrl,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12.h,
        )
      ],
    );
  }
}
