import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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


  Future<QuerySnapshot<Map<String, dynamic>>>  createRoom( List<UserModel>users,List<String>userIds) async {
    try {

      final sortedUserIds = List<String>.from(userIds)..sort();

      var chatRoomId = sortedUserIds.join('_');
      final String userId="";
      final snapshot=  await _fire.collection("chatRooms")
                            .where("roomId", isEqualTo: chatRoomId).get();
      // final snapshot1=  await _fire.collection("chatRooms")
      //     .where("userIds", arrayContainsAny: userIds)
      //     // .where("userIds", arrayContains: userIds[1])
      //     .get();

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
        "lastMessage":message
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
}