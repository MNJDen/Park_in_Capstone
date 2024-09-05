import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _selectedImage;

  void _onSuggestionTap(String suggestion) {
    setState(() {});
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Method to clear the selected image
  void _clearImage() {
    setState(() {
      _selectedImage = null; // Clear the selected image
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
      // Handle error, e.g., show a Snackbar or log the error
      return null;
    }
  }

  Future<void> _citeTicket() async {
    if (_plateNumberCtrl.text.isEmpty ||
        _vehicleTypeCtrl.text.isEmpty ||
        _searchCtrl.text.isEmpty ||
        _descriptionCtrl.text.isEmpty) {
      // Show an error, e.g., a Snackbar or AlertDialog
      return;
    }

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    await FirebaseFirestore.instance.collection('Violation Ticket').add({
      'plate_number': _plateNumberCtrl.text,
      'vehicle_type': _vehicleTypeCtrl.text,
      'violation': _searchCtrl.text,
      'description': _descriptionCtrl.text,
      'image_url': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _plateNumberCtrl.clear();
    _vehicleTypeCtrl.clear();
    _searchCtrl.clear();
    _descriptionCtrl.clear();
    _clearImage();
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
                  SizedBox(height: 32.h),
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
                  PRKFormField(
                    prefixIcon: Icons.bike_scooter_rounded,
                    labelText: "Vehicle Type",
                    controller: _vehicleTypeCtrl,
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
                    labelText: "Description",
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
                      const Spacer(),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Icon(
                          Icons.attachment_rounded,
                          color: blackColor,
                          size: 24.r,
                        ),
                      ),
                    ],
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Image.file(
                        _selectedImage!,
                        height: 100.h,
                        width: 100.h,
                      ),
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
