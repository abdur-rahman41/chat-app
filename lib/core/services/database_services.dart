import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _fire = FirebaseFirestore.instance;

   Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
     final user = await _fire.collection("users").doc(userData["uid"]).set(userData);

      print("User saved successfully");

    } catch (e) {
      rethrow;
    }
  }


  Future<void> updateDeviceToken(String uid, String newDeviceToken) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'deviceToken': newDeviceToken,
      });
      print('Device token updated successfully');
    } catch (e) {
      print('Failed to update device token: $e');
    }
  }

  Future<void> updateTime(String uid,Timestamp time) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'updateTime':time,
      });
      // print('Time updated successfully');
    } catch (e) {
      print('Failed to update Time: $e');
    }
  }

  Future<Map<String, dynamic>?> loadUser(String uid) async {
    try {
      print("Load Users");
      final res = await _fire.collection("users").doc(uid).get();

      if (res.data() != null) {
        log("User fetched successfully");
        return res.data();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> loadStreamUser(String uid)
  {
    return _fire
        .collection("users")
        .doc(uid)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>?> fetchUsers(String currentUserId) async {
    try {
      final res = await _fire
          .collection("users")
          .where("uid", isNotEqualTo: currentUserId)
          .get();

      return res.docs.map((e) => e.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserStream(
      String currentUserId) =>
      _fire
          .collection("users")
          .where("uid", isNotEqualTo: currentUserId)
          .snapshots();
}