import 'dart:io';

import 'package:flutter/material.dart';

class UserData {
  String? name;
  String? email;
  String? userNumber;
  String? phoneNumber;
  String? password;
  String? imageUrl;
  String? imageUrl1;
  File? imageFile1;
  File? imageFile;
  String? imagePath;
  String? usertype;
  String? department;
  List<String> stickerNumber;
  List<String> plateNumber;

  UserData({
    this.name,
    this.email,
    this.userNumber,
    this.phoneNumber,
    this.password,
    this.imageUrl,
    this.imageUrl1,
    this.imagePath,
    this.imageFile,
    this.imageFile1,
    this.department,
    List<String>? stickerNumber,
    List<String>? plateNumber,
    this.usertype,
  })  : stickerNumber = stickerNumber ?? [],
        plateNumber = plateNumber ?? [];

  UserData copyWith({
    String? name,
    String? email,
    String? userNumber,
    String? phoneNumber,
    String? password,
    String? imageUrl,
    String? imageUrl1,
    String? imagePath,
    File? imageFile,
    File? imageFile1,
    String? usertype,
    String? department,
    List<String>? stickerNumber,
    List<String>? plateNumber,
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
      userNumber: userNumber ?? this.userNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrl1: imageUrl1 ?? this.imageUrl1,
      imageFile: imageFile != null ? imageFile : null,
      imageFile1: imageFile1 != null ? imageFile1 : null,
      usertype: usertype ?? this.usertype,
      department: department ?? this.department,
      stickerNumber: stickerNumber ?? List<String>.from(this.stickerNumber),
      plateNumber: plateNumber ?? List<String>.from(this.plateNumber),
    );
  }
}

class UserDataProvider extends ChangeNotifier {
  UserData _userData = UserData(); // Initialize with default values

  UserData get userData => _userData;

  /// Update the user data with the provided values.
  void updateUserData({
    String? name,
    String? email,
    String? userNumber,
    String? phoneNumber,
    String? password,
    String? imageUrl,
    String? imageUrl1,
    File? imageFile,
    File? imageFile1,
    String? imagePath,
    String? usertype,
    String? department,
    List<String>? stickerNumber,
    List<String>? plateNumber,
  }) {
    _userData = _userData.copyWith(
      name: name,
      email: email,
      userNumber: userNumber,
      phoneNumber: phoneNumber,
      password: password,
      imageUrl: imageUrl,
      imageUrl1: imageUrl1,
      imageFile: imageFile,
      imageFile1: imageFile1,
      imagePath: imagePath,
      usertype: usertype,
      department: department,
      stickerNumber: stickerNumber,
      plateNumber: plateNumber,
    );

    notifyListeners(); // Notify listeners about the change
  }
}
