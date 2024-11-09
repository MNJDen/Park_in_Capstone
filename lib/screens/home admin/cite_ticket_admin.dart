import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:park_in/components/controls%20admin/ticket_upload.dart';
import 'package:park_in/components/snackbar/error_snackbar.dart';
import 'package:park_in/components/snackbar/success_snackbar.dart';
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
  final String? _status = "Pending";
  bool _isCitingTicket = false;

  void _onSuggestionTap(String suggestion) {
    setState(() {});
  }

  Future<void> _pickCloseUpImage() async {
    final ImagePicker picker = ImagePicker();
    final ImageSource? source = await _showImageSourceOption();
    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
      );

      if (image != null) {
        setState(() {
          _closeUpImage = File(image.path);
        });
      }
    }
  }

  Future<void> _pickMidShotImage() async {
    final ImagePicker picker = ImagePicker();
    final ImageSource? source = await _showImageSourceOption();
    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
      );

      if (image != null) {
        setState(() {
          _midShotImage = File(image.path);
        });
      }
    }
  }

  Future<void> _pickWideShotImage() async {
    final ImagePicker picker = ImagePicker();
    final ImageSource? source = await _showImageSourceOption();
    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
      );

      if (image != null) {
        setState(() {
          _wideShotImage = File(image.path);
        });
      }
    }
  }

  Future<ImageSource?> _showImageSourceOption() async {
    return await showModalBottomSheet<ImageSource>(
      backgroundColor: whiteColor,
      showDragHandle: true,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            ListTile(
              dense: true,
              title: Text(
                "Choose a source: ",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: blackColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                "Camera",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: blackColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                "Gallery",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: blackColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
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
      errorSnackbar(context, "Please fill in all required fields");
      return;
    }

    if (_closeUpImage == null ||
        _midShotImage == null ||
        _wideShotImage == null) {
      errorSnackbar(context,
          "Please upload all required images (Close-up, Mid Shot, Wide Shot)");
      return;
    }

    setState(() {
      _isCitingTicket = true;
    });

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

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Violation Ticket')
        .orderBy('timestamp', descending: false)
        .get();

    final int ticketCount = snapshot.docs.length;
    final String newDocId = 'T${(ticketCount + 1).toString().padLeft(3, '0')}';

    try {
      await FirebaseFirestore.instance
          .collection('Violation Ticket')
          .doc(newDocId)
          .set({
        'plate_number': _plateNumberCtrl.text,
        'vehicle_type': _vehicleTypeCtrl.text,
        'violation': _searchCtrl.text,
        'description': _descriptionCtrl.text,
        'status': _status,
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

      setState(() {
        _isCitingTicket = false;
      });

      successSnackbar(context, "Ticket cited successfully!");
    } catch (e) {
      setState(() {
        _isCitingTicket = false;
      });
      errorSnackbar(context, "Error Occured: $e");
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
          child: _isCitingTicket
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.waveDots(
                        color: blueColor,
                        size: 50.r,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "Citing the ticket, wait a moment...",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: blackColor.withOpacity(0.8),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
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
                                fontWeight: FontWeight.w600,
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
                            //serious violations
                            SearchFieldListItem(
                                'Selling, attempting to sell, or giving their gate pass/sticker to another person.'),
                            SearchFieldListItem(
                                'False declaration in any application for a gate pass/sticker or in a report of a stolen gate pass/sticker.'),
                            SearchFieldListItem(
                                'Tampering/Falsification/Alteration or Duplication of gate pass/sticker.'),
                            SearchFieldListItem(
                                'Driving while under the influence of prohibited drugs or any alcoholic beverages.'),
                            SearchFieldListItem(
                                'Using the car as shelter for obnoxious and scandalous activities.'),
                            SearchFieldListItem(
                                'Driving without license or unregistered vehicles.'),
                            SearchFieldListItem(
                                'Disregard or refusal at the gate, or in any part of the campus, to submit to standard security requirements such as the routine inspection or checking of ID.'),
                            SearchFieldListItem(
                                'Verbal/physical abuse against security personnel.'),
                            //minor violations
                            SearchFieldListItem(
                                'Blowing of horn or any alarming device and/or playing of music of a car radio in the ADNU campus.'),
                            SearchFieldListItem('Illegal parking.'),
                            SearchFieldListItem(
                                'Running the engines while parked.'),
                            SearchFieldListItem(
                                'Driving on a sidewalk or pathway.'),
                            SearchFieldListItem(
                                'Carrying or loading the car of any material when its edge portion causes damage or scrape the pavement of the road/street.'),
                            SearchFieldListItem(
                                'Driving inside the campus at a speed in excess of 10 km/hr.'),
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
                              hint: "(Image of the plate number)",
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
                              hint: "(Photo of the vehicle)",
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
                              hint: "(Capture the surroundings)",
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
