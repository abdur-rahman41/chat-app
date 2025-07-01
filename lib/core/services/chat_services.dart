import 'dart:io';

import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';

class ChatService {
  final _fire = FirebaseFirestore.instance;

  saveMessage(Map<String, dynamic> message, String chatRoomId) async {
    try {
      await _fire
          .collection("chatRooms")
          .doc(chatRoomId)
          .collection("messages")
          .add(message);
    } catch (e) {
      rethrow;
    }
  }


  Future<QuerySnapshot<Map<String, dynamic>>>  createRoom( List<UserModel>users,List<String>userIds,String? roomType,String? roomName) async {
    try {

      final sortedUserIds = List<String>.from(userIds)..sort();

      var chatRoomId = sortedUserIds.join('_');


      if(roomType=='Group')
        {
          final roomRef = _fire.collection("chatRooms").doc();
          Map<String,dynamic>? message;

            await roomRef.set({
              "roomId": chatRoomId,
              "createdAt": FieldValue.serverTimestamp(),
              "userIds":userIds.toList(),
              "users": users.map((user) => user.toMap()).toList(),
              "lastMessage":message,
              "roomType":roomType,
              "roomName":roomName
            });

            final createSnapshot = await _fire.collection("chatRooms")
                .where("roomId", isEqualTo: chatRoomId).get();

            print("✅ Firestore: Room '$chatRoomId' created successfully.");
            return createSnapshot;
        }
      // final snapshot1=  await _fire.collection("chatRooms")
      //     .where("userIds", arrayContainsAny: userIds)
      //     // .where("userIds", arrayContains: userIds[1])
      //     .get();
      final snapshot=  await _fire.collection("chatRooms")
          .where("roomId", isEqualTo: chatRoomId).get();

      if (snapshot.docs.isNotEmpty) {
        print("❌ Found existing rooms.");

        return snapshot;

      } else {



        print(" ✅No existing room found.");


      }



      final roomRef = _fire.collection("chatRooms").doc(chatRoomId);
      Map<String,dynamic>? message;

      await roomRef.set({
        "roomId": chatRoomId,
        "createdAt": FieldValue.serverTimestamp(),
        "userIds":userIds.toList(),
        "users": users.map((user) => user.toMap()).toList(),
        "lastMessage":message,
        "roomType":roomType,
        "roomName":roomName
      });

      final createSnapshot = await _fire.collection("chatRooms")
          .where("roomId", isEqualTo: chatRoomId).get();

      print("✅ Firestore: Room '$chatRoomId' created successfully.");
      return createSnapshot;
    } catch (e) {
      print("❌ Error creating room: $e");
      rethrow;
    }

  }



  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomSnapshots(String userId) {
    return _fire
        .collection('chatRooms')

         .where("userIds", arrayContains: userId)
        .snapshots();
  }

  saveLastMessage(Map<String,dynamic> message, String chatRoomId) async {
    try {

      final roomRef= await _fire
          .collection("chatRooms")
          .doc(chatRoomId);


      await roomRef.set({
        "lastMessage": message
      }, SetOptions(merge: true));

    } catch (e) {
      rethrow;
    }
  }


  // updateLastMessage(String currentUid, String receiverUid, String message,
  //     int timestamp) async {
  //   try {
  //     await _fire.collection("users").doc(currentUid).update({
  //       "lastMessage": {
  //         "content": message,
  //         "timestamp": timestamp,
  //         "senderId": currentUid
  //       },
  //       "unreadCounter": FieldValue.increment(1)
  //     });
  //
  //     await _fire.collection("users").doc(receiverUid).update({
  //       "lastMessage": {
  //         "content": message,
  //         "timestamp": timestamp,
  //         "senderId": currentUid,
  //       },
  //       "unreadCounter": 0
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return _fire
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(String chatRoomId) {
    return _fire
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots();
  }


  // Future<String?> uploadImage(File file) async {
  //   try {
  //     print("File : ${file}");
  //     final ref = FirebaseStorage.instance
  //         .ref()
  //         .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     print("Reference: ${ref}");
  //
  //     await ref.putFile(file);
  //
  //     return await ref.getDownloadURL();
  //   } catch (e) {
  //     print("Image upload failed: $e");
  //     return null;
  //   }
  // }


  Future<String?> uploadImage(File file) async {
    try {
      print("File: $file");

      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      print("Reference: $ref");

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final url = await ref.getDownloadURL();
        print("Upload successful. Download URL: $url");
        return url;
      } else {
        print("Upload failed with state: ${snapshot.state}");
        return null;
      }
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }



}
