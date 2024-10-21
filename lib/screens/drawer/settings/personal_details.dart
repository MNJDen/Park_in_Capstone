import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_in/components/snackbar/success_snackbar.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreennState();
}

class _PersonalDetailsScreennState extends State<PersonalDetailsScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _userNumberCtrl = TextEditingController();
  final TextEditingController _phoneNumberCtrl = TextEditingController();
  bool _isEditing = false;
  bool _isUpdatingImage = false;
  bool _isPickingImage = false;
  File? _selectedImage;
  Map<String, dynamic>? _userData; // igdi ma store si userdata after ma fetch
  String? _profilePicUrl; // igdi ma store si profilepicurl after ma fetch

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  //get user id of currently logged in user
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  //load/fetch si mga data from db
  Future<void> _loadUserData() async {
    final userId = await _getUserId();
    if (userId != null) {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      if (docSnapshot.exists && mounted) {
        setState(() {
          _userData = docSnapshot
              .data(); // after ma fetch gamit ang docsnapshot is i-assign si mga data sa _userData var
          //i-assign sa mga text controller si mga na fetch na data
          _nameCtrl.text = _userData?['name'] ?? '';
          _userNumberCtrl.text = _userData?['userNumber'] ?? '';
          _phoneNumberCtrl.text = _userData?['mobileNo'] ?? '';
          _profilePicUrl = _userData?['profilePicture'] ??
              "assets/images/default_pic.png"; // assign si na fetch na pfp sa _profilePicUrl
        });
      }
    }
  }

  //update si mga values once nag edit
  Future<void> _updateUserData() async {
    final userId = await _getUserId();
    if (userId != null) {
      if (_nameCtrl.text != _userData?['name'] ||
          _userNumberCtrl.text != _userData?['userNumber'] ||
          _phoneNumberCtrl.text != _userData?['mobileNo']) {
        await FirebaseFirestore.instance.collection('User').doc(userId).update({
          'name': _nameCtrl.text,
          'userNumber': _userNumberCtrl.text,
          'mobileNo': _phoneNumberCtrl.text,
        });
        if (mounted) {
          setState(() {
            _isEditing = false;
          });
          successSnackbar(context, "User details updated successfully!");
        }
      } else {
        if (mounted) {
          setState(() {
            _isEditing = false;
          });
        }
      }
    }
  }

  //pick image para mag replace pfp
  Future<void> _pickImage() async {
    if (_isPickingImage) return; // to avoid opening multiple image pickers
    setState(() {
      _isPickingImage = true; // set to true when picker is activated
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isUpdatingImage = true;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    } finally {
      setState(() {
        _isPickingImage = false; // Reset flag after image is picked
      });
    }
  }

  //once mag pick image upload image to db
  Future<String?> _uploadImage(File image) async {
    String? userNumber = _userData?['userNumber'];

    if (userNumber != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('User Profile Pictures')
            .child(
                '$userNumber"_"${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = storageRef.putFile(image);
        final snapshot = await uploadTask.whenComplete(() {});
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
        return null;
      }
    }
    return null;
  }

  //update si value kang pfp link sa db and delete si old pfp for storage optimization
  Future<void> _updateProfilePicture() async {
    if (_selectedImage != null) {
      final userId = await _getUserId();

      if (_userData != null && userId != null) {
        final oldProfilePicUrl = _userData?['profilePicture'];

        final newImageUrl = await _uploadImage(_selectedImage!);

        if (newImageUrl != null) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(userId)
              .update({
            'profilePicture': newImageUrl,
          });

          setState(() {
            _profilePicUrl = newImageUrl;
            _isUpdatingImage = false;
          });

          successSnackbar(context, "Profile picture updated successfully!");

          if (oldProfilePicUrl != null &&
              oldProfilePicUrl != "assets/images/default_pic.png") {
            try {
              final oldImageRef =
                  FirebaseStorage.instance.refFromURL(oldProfilePicUrl);
              await oldImageRef.delete();
            } catch (e) {
              print("Failed to delete old image: $e");
            }
          }

          if (mounted) {
            setState(() {
              _profilePicUrl = newImageUrl; // Update the profile picture URL
              _isUpdatingImage = false; // Exit image update mode
            });
          }
        } else {
          print("Failed to upload new image.");
        }
      } else {
        print("User data or user ID is missing.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: blackColor,
                      ),
                    ),
                  ),
                  Text(
                    "Personal Details",
                    style: TextStyle(
                      fontSize: 20.r,
                      color: blueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 100.h,
                              width: 100.h,
                              fit: BoxFit.cover,
                            )
                          : _profilePicUrl != null &&
                                  _profilePicUrl!.startsWith('http')
                              ? _isUpdatingImage
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 100.h,
                                        width: 100.h,
                                        color: Colors.grey.shade300,
                                      ),
                                    )
                                  : Image.network(
                                      _profilePicUrl!,
                                      height: 100.h,
                                      width: 100.h,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(
                                            height: 100.h,
                                            width: 100.h,
                                            color: Colors.grey.shade300,
                                          ),
                                        );
                                      },
                                    )
                              : Image.asset(
                                  "assets/images/default_pic.png",
                                  height: 100.h,
                                  width: 100.h,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    TextButton(
                      onPressed: _isPickingImage
                          ? null // Disable button while picking image
                          : () {
                              if (_isUpdatingImage) {
                                _updateProfilePicture(); // Update profile picture when "Save" is clicked
                              } else {
                                _pickImage(); // Pick a new image when "Upload New Picture" is clicked
                              }
                              setState(() {
                                _isUpdatingImage = !_isUpdatingImage;
                              });
                            },
                      child: Text(
                        _isUpdatingImage ? "Save" : "Upload New Picture",
                        style: TextStyle(
                          fontSize: 12.r,
                          color: blueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "User Information",
                    style: TextStyle(
                      fontSize: 12.r,
                      color: blackColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isEditing) {
                        _updateUserData(); // Save changes
                      }
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(
                      _isEditing ? "Save" : "Edit",
                      style: TextStyle(
                        fontSize: 12.r,
                        color: blueColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              PRKFormField(
                prefixIcon: Icons.person_rounded,
                labelText: "Name",
                controller: _nameCtrl,
                enable: _isEditing,
              ),
              SizedBox(height: 12.h),
              PRKFormField(
                prefixIcon: Icons.badge_rounded,
                labelText: "Student Number",
                controller: _userNumberCtrl,
                enable: _isEditing,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.h),
              PRKFormField(
                prefixIcon: Icons.phone_rounded,
                labelText: "Phone Number",
                controller: _phoneNumberCtrl,
                enable: _isEditing,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
