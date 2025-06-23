import 'dart:developer';

import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/message_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/chat_services.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:convert';


class RoomListViewModel extends GetxController {
  final ChatService _chatService = ChatService();
  final DatabaseService db = DatabaseService();
  final currentReceiver = UserModel();
  RxList<UserModel> users = <UserModel>[].obs;
  RxList<Message> messages = <Message>[].obs;
  RxList<String> lastMessages = <String>[].obs;
  final userID = PreferenceManager.readData(key: 'user-id');

  RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatRooms();
    fetchUsers();


  }


  void fetchChatRooms() {
    var userID = PreferenceManager.readData(key: 'user-id');

    _chatService.getChatRoomSnapshots(userID).listen((snapshot) {
      print('snapshot data: ${snapshot.docs}');
      chatRooms.value = snapshot.docs
          .map((doc) => ChatRoomModel.fromMap(doc.data()))
          .toList();

         }, onError: (e) {
      print(" Error fetching chat rooms: $e");
    });
    fetchLastMessges();

  }

  fetchLastMessges() async {

    var loggedInUserID = PreferenceManager.readData(key: 'user-id');

    try {

      for (int i = 0; i < chatRooms.length; i++) {
        final room = chatRooms[i];

        _chatService.getLastMessage(room.roomId).listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            var doc = snapshot.docs.first;
            final message = Message.fromMap(doc.data());



          } else {
            print("No message found for chat room: ${room.roomId}");
          }
        });
      }

    } catch (e) {
      log("Error fetching last messages: $e");
    }
  }

  fetchUsers() async {
    try {
      db.fetchUserStream(userID).listen((data) {
        users.value = data.docs.map((e) => UserModel.fromMap(e.data())).toList();
      });

    } catch (e) {

      log("Error Fetching Users: $e");
    }
  }

 Future<ChatRoomModel?> createRoom(String receiverID,String name, String image) async {

    print(receiverID);

    try {

      final now = DateTime.now();


      String chatRoomID ="${userID}_${receiverID}";
      final client =  await db.loadUser(userID);
      final user= UserModel.fromMap(client as Map<String, dynamic>);
      print("user:${user}");



      final user1 = UserModel(
        name: user.name!,
        uid: userID,
        imageUrl: user.imageUrl,

      );
      final user2 = UserModel(
        name: name,
        uid : receiverID,
        imageUrl: image,

      );
      var partner = UserModel(name:name,uid: receiverID);
      List<String>userIds=[userID,receiverID];


       var result = await _chatService.createRoom([user1,user2],userIds);


      if(result.docs.isNotEmpty) {
        var responseData = ChatRoomModel.fromMap(result.docs.first.data());
        return responseData;
      } else {
        return null;
      }

    } catch (e) {
      rethrow;
    }
  }


}
