import 'package:flutter/material.dart';

// Assuming UserData is a data class with default values and a copyWith method.
class UserData {
  String? name;
  String? userNumber;
  String? phoneNumber;
  String? password;
  String? imageUrl;
  List<String> stickerNumber;
  List<String> plateNumber;

  UserData({
    this.name,
    this.userNumber,
    this.phoneNumber,
    this.password,
    this.imageUrl,
    List<String>? stickerNumber,
    List<String>? plateNumber,
  })  : stickerNumber = stickerNumber ?? [],
        plateNumber = plateNumber ?? [];

  UserData copyWith({
    String? name,
    String? userNumber,
    String? phoneNumber,
    String? password,
    String? imageUrl,
    List<String>? stickerNumber,
    List<String>? plateNumber,
  }) {
    return UserData(
      name: name ?? this.name,
      userNumber: userNumber ?? this.userNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      imageUrl: imageUrl ?? this.imageUrl,
      // Deep copy the lists to ensure immutability
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
    String? userNumber,
    String? phoneNumber,
    String? password,
    String? imageUrl,
    List<String>? stickerNumber,
    List<String>? plateNumber,
  }) {
    _userData = _userData.copyWith(
      name: name,
      userNumber: userNumber,
      phoneNumber: phoneNumber,
      password: password,
      imageUrl: imageUrl,
      stickerNumber: stickerNumber,
      plateNumber: plateNumber,
    );

    notifyListeners(); // Notify listeners about the change
  }
}
