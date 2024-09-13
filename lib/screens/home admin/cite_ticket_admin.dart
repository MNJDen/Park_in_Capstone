import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_in/components/controls%20admin/ticket_upload.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:park_in/components/ui/primary_btn.dart';
import 'package:park_in/components/field/search_field.dart';
import 'package:park_in/components/field/text_area.dart';
import 'package:searchfield/searchfield.dart';
import 'dart:io';

class CiteTicketAdminScreen extends StatefulWidget {
  const CiteTicketAdminScreen({super.key});

  @override
  State<CiteTicketAdminScreen> createState() => _CiteTicketAdminScreenState();
}

class _CiteTicketAdminScreenState extends State<CiteTicketAdminScreen> {
  final TextEditingController _plateNumberCtrl = TextEditingController();
  final TextEditingController _vehicleTypeCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  File? _closeUpImage;
  File? _midShotImage;
  File? _wideShotImage;

  void _onSuggestionTap(String suggestion) {
    setState(() {});
  }

  Future<void> _pickCloseUpImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _closeUpImage = File(image.path);
      });
    }
  }

  Future<void> _pickMidShotImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _midShotImage = File(image.path);
      });
    }
  }

  Future<void> _pickWideShotImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _wideShotImage = File(image.path);
      });
    }
  }

  void _clearImage() {
    setState(() {
      _closeUpImage = null;
      _midShotImage = null;
      _wideShotImage = null;
    });
  }

  void _clearCloseUpImage() {
    setState(() {
      _closeUpImage = null;
    });
  }

  void _clearMidShotImage() {
    setState(() {
      _midShotImage = null;
    });
  }

  void _clearWideShotImage() {
    setState(() {
      _wideShotImage = null;
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('Ticket Violation Attachments')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> _citeTicket() async {
    if (_plateNumberCtrl.text.isEmpty ||
        _vehicleTypeCtrl.text.isEmpty ||
        _searchCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 255, 226, 226),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromRGBO(255, 0, 0, 1),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: const Color.fromRGBO(255, 0, 0, 1),
                size: 20.r,
              ),
              SizedBox(
                width: 8.w,
              ),
              Flexible(
                child: Text(
                  "Fill out all the required fields",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    if (_closeUpImage == null ||
        _midShotImage == null ||
        _wideShotImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 255, 226, 226),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromRGBO(255, 0, 0, 1),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: const Color.fromRGBO(255, 0, 0, 1),
                size: 20.r,
              ),
              SizedBox(
                width: 8.w,
              ),
              Flexible(
                child: Text(
                  "Please upload all required images (Close-up, Mid Shot, Wide Shot)",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    String? closeUpImageUrl, midShotImageUrl, wideShotImageUrl;
    if (_closeUpImage != null) {
      closeUpImageUrl = await _uploadImage(_closeUpImage!);
    }
    if (_midShotImage != null) {
      midShotImageUrl = await _uploadImage(_midShotImage!);
    }
    if (_wideShotImage != null) {
      wideShotImageUrl = await _uploadImage(_wideShotImage!);
    }

    try {
      await FirebaseFirestore.instance.collection('Violation Ticket').add({
        'plate_number': _plateNumberCtrl.text,
        'vehicle_type': _vehicleTypeCtrl.text,
        'violation': _searchCtrl.text,
        'description': _descriptionCtrl.text,
        'close_up_image_url': closeUpImageUrl,
        'mid_shot_image_url': midShotImageUrl,
        'wide_shot_image_url': wideShotImageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _plateNumberCtrl.clear();
      _vehicleTypeCtrl.clear();
      _searchCtrl.clear();
      _descriptionCtrl.clear();
      _clearImage();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromRGBO(217, 255, 214, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromRGBO(20, 255, 0, 1),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: const Color.fromRGBO(20, 255, 0, 1),
                size: 20.r,
              ),
              SizedBox(
                width: 8.w,
              ),
              Flexible(
                child: Text(
                  "Ticket cited successfully",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.of(context).size.width * 0.95,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 255, 226, 226),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Color.fromRGBO(255, 0, 0, 1),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: const Color.fromRGBO(255, 0, 0, 1),
                size: 20.r,
              ),
              SizedBox(
                width: 8.w,
              ),
              Flexible(
                child: Text(
                  "Error Occured: $e",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: blackColor,
                          ),
                        ),
                      ),
                      Text(
                        "Cite A Ticket",
                        style: TextStyle(
                          fontSize: 20.r,
                          color: blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  PRKFormField(
                    prefixIcon: Icons.pin_rounded,
                    labelText: "Plate Number",
                    controller: _plateNumberCtrl,
                  ),
                  SizedBox(height: 12.h),
                  PRKSearchField(
                    prefixIcon: Icons.bike_scooter_rounded,
                    labelText: "Vehicle Type",
                    searchFieldListItems: [
                      SearchFieldListItem('Two-Wheels'),
                      SearchFieldListItem('Four-Wheels'),
                    ],
                    controller: _vehicleTypeCtrl,
                    onTap: (text) {
                      _onSuggestionTap(text);
                    },
                  ),
                  SizedBox(height: 12.h),
                  PRKSearchField(
                    prefixIcon: Icons.warning_rounded,
                    labelText: "Violation",
                    searchFieldListItems: [
                      SearchFieldListItem(
                          'Blowing of horn or any alarming device and/or playing of music of a car radio in the ADNU campus'),
                      SearchFieldListItem('Illegal parking'),
                      SearchFieldListItem('Running the engines while parked'),
                      SearchFieldListItem('Driving on a sidewalk or pathway'),
                      SearchFieldListItem(
                          'Carrying or loading the car of any material when its edge portion causes damage or scrape the pavement of the road/street.'),
                      SearchFieldListItem(
                          'Driving inside the campus at a speed in excess of 10 km/hr'),
                    ],
                    controller: _searchCtrl,
                    onTap: (text) {
                      _onSuggestionTap(text);
                    },
                  ),
                  SizedBox(height: 12.h),
                  PRKTextArea(
                    labelText: "Description (Optional)",
                    controller: _descriptionCtrl,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Text(
                        "Attachments",
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 12.r,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Column(
                    children: [
                      PRKTicketsUpload(
                        label: "Close-up Shot",
                        onPressed: _closeUpImage != null
                            ? _clearCloseUpImage
                            : _pickCloseUpImage,
                        image: _closeUpImage,
                        icon: _closeUpImage != null
                            ? Icons.highlight_remove_rounded
                            : Icons.file_upload_outlined,
                      ),
                      SizedBox(height: 8.h),
                      PRKTicketsUpload(
                        label: "Mid Shot",
                        onPressed: _midShotImage != null
                            ? _clearMidShotImage
                            : _pickMidShotImage,
                        image: _midShotImage,
                        icon: _midShotImage != null
                            ? Icons.highlight_remove_rounded
                            : Icons.file_upload_outlined,
                      ),
                      SizedBox(height: 8.h),
                      PRKTicketsUpload(
                        label: "Wide Shot",
                        onPressed: _wideShotImage != null
                            ? _clearWideShotImage
                            : _pickWideShotImage,
                        image: _wideShotImage,
                        icon: _wideShotImage != null
                            ? Icons.highlight_remove_rounded
                            : Icons.file_upload_outlined,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: PRKPrimaryBtn(
                  label: "Cite Ticket",
                  onPressed: _citeTicket,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
