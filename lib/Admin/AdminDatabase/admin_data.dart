import 'package:cloud_firestore/cloud_firestore.dart';

class AdminData {
  static getAdmin(uid) {
    return FirebaseFirestore.instance
        .collection('Admin')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }
}
