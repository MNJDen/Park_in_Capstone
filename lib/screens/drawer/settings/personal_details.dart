import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:park_in/components/theme/color_scheme.dart';
import 'package:park_in/components/field/form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
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

  Future<String?> _uploadImage(File image) async {
    final userData = await _getUserData();
    String? userNumber = userData?['userNumber'];

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
        // Handle error
        print('Error uploading image: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> _updateProfilePicture() async {
    if (_selectedImage != null) {
      final userData = await _getUserData();
      final userId = await _getUserId();

      if (userData != null && userId != null) {
        // Get the old profile picture URL
        final oldProfilePicUrl = userData['profilePicture'];

        // Upload the new image
        final newImageUrl = await _uploadImage(_selectedImage!);

        if (newImageUrl != null) {
          // Update Firestore with the new image URL
          await FirebaseFirestore.instance
              .collection('User')
              .doc(userId)
              .update({
            'profilePicture': newImageUrl,
          });

          // Delete the old image from Firebase Storage if it exists
          if (oldProfilePicUrl != null &&
              oldProfilePicUrl != "assets/images/default_profile.png") {
            try {
              final oldImageRef =
                  FirebaseStorage.instance.refFromURL(oldProfilePicUrl);
              await oldImageRef.delete();
            } catch (e) {
              // Log or handle the error if deletion fails
              print("Failed to delete old image: $e");
            }
          }

          if (mounted) {
            setState(() {
              _isEditing = false; // Exit editing mode after saving
            });
          }
        } else {
          // Handle the case where the new image URL could not be retrieved
          print("Failed to upload new image.");
        }
      } else {
        // Handle the case where userData or userId is null
        print("User data or user ID is missing.");
      }
    }
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    final userId = await _getUserId();

    if (userId != null) {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
    }

    return null;
  }

  void _loadUserData() async {
    final userData = await _getUserData();
    if (userData != null && mounted) {
      setState(() {
        _nameCtrl.text = userData['name'] ?? '';
        _userNumberCtrl.text = userData['userNumber'] ?? '';
        _phoneNumberCtrl.text = userData['mobileNo'] ?? '';
      });
    }
  }

  void _updateUserData() async {
    final userId = await _getUserId();
    if (userId != null) {
      await FirebaseFirestore.instance.collection('User').doc(userId).update({
        'name': _nameCtrl.text,
        'userNumber': _userNumberCtrl.text,
        'mobileNo': _phoneNumberCtrl.text,
      });
      setState(() {
        _isEditing = false; // Exit editing mode after saving
      });
    }
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
              SizedBox(
                height: 32.h,
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 28.h,
              ),
              Center(
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error loading profile picture');
                    } else if (snapshot.hasData) {
                      final profilePicUrl = snapshot.data?['profilePicture'] ??
                          "assets/images/default_profile.png";
                      return Column(
                        children: [
                          ClipOval(
                            child: Image.network(
                              profilePicUrl,
                              height: 100.h,
                              width: 100.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_isUpdatingImage) {
                                _updateProfilePicture();
                                // Save changes
                              } else {
                                _pickImage();
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
                          ),
                        ],
                      );
                    } else {
                      return Text('No profile picture available');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 28.h,
              ),
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
              SizedBox(
                height: 4.h,
              ),
              PRKFormField(
                prefixIcon: Icons.person_rounded,
                labelText: "Name",
                controller: _nameCtrl,
                enable: _isEditing,
              ),
              SizedBox(
                height: 12.h,
              ),
              PRKFormField(
                prefixIcon: Icons.badge_rounded,
                labelText: "Student Number",
                controller: _userNumberCtrl,
                enable: _isEditing,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 12.h,
              ),
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
