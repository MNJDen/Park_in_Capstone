import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_in/models/Message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // pag send niya nang messages sa "group_chat" collection
  Future<void> sendMessage(Message message) async {
    await _firestore.collection('group_chat').add(message.toMap());
  }

  Future<String> getUserType(String uid) async {
    // check if the user is an admin, ini nag gagana, nakukuha niya si Admin idk why, kung igwa kang why duman sa providers mo pwede mo man palitan kung gusto mo
    DocumentSnapshot adminDoc =
        await _firestore.collection('Admin').doc(uid).get();
    if (adminDoc.exists) {
      return adminDoc['userType'];
    }

    // check if the user is an employee, dai ni nag gagana try mo si sa providers mo igdi
    DocumentSnapshot userDoc =
        await _firestore.collection('User').doc(uid).get();
    if (userDoc.exists) {
      return userDoc['userType'];
    }

    return 'unknown';
  }

  // pag retreive kang messages
  Stream<QuerySnapshot> getGroupMessagesStream() {
    return _firestore
        .collection('group_chat')
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // ito hula ko kaya nakukuha niya si admin as admin sa userType ta nag gagamit _auth = FirebaseAuth, which is true ta nasa Authentication baga talaga si mga Admin kasi dai man customized ang login ninda
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
}
