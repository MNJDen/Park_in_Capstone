import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class AuthService {
  // Instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Error Messages
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unknown error occurred. Please try again later.';
    }
  }

  // Sign In
  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .get();

      // Check if the username exists in Firestore
      if (!userDoc.exists) {
        throw AuthServiceException("User data not found in Firestore");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(getErrorMessage(e.code));
    }
  }

  // Sign Up
  Future<UserCredential?> signUpWithEmailPassword(
      String email, String password, File image) async {
    try {
      // Create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // await userCredential.user!.updateDisplayName(username);

      // Upload image
      String? imageUrl = await uploadImage(
          image, userCredential.user!.uid); // Pass the user's UID as userId

      // Save user info along with image URL in Firestore
      await _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'profileImageUrl': imageUrl,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(getErrorMessage(e.code));
    }
  }

  Future<String?> uploadImage(File image, String userId) async {
    try {
      // Generate a unique filename for the image
      String fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create a reference to the location you want to upload to in Firestore
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(fileName); // Set the unique filename as the child

      // Upload the file to Firestore
      await ref.putFile(image);

      // Once uploaded, get the download URL
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Return null if upload fails
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}

class AuthServiceException implements Exception {
  final String message;
  AuthServiceException(this.message);

  @override
  String toString() => message; // Override toString to return just the message
}
