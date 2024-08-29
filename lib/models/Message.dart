import 'package:cloud_firestore/cloud_firestore.dart';


// ito controller lang naman, nag sset lang format kang i-ssave sa firebase
class Message {
  final String senderID;
  final String name;
  final String message;
  final Timestamp timestamp;
  final String userType;

  Message({
    required this.senderID,
    required this.name,
    required this.message,
    required this.timestamp,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'name': name,
      'message': message,
      'timestamp': timestamp,
      'userType': userType,
    };
  }
}
