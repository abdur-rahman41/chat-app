import 'dart:developer';

import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/message_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/chat_services.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChatCreationViewModel extends GetxController {
  final ChatService _chatService = ChatService();
  final DatabaseService db = DatabaseService();
  final currentReceiver = UserModel();
  RxList<UserModel> users = <UserModel>[].obs;
  RxList<Message> messages = <Message>[].obs;
  RxList<String> lastMessages = <String>[].obs;
  RxSet<String> selectedUserIds = <String>{}.obs;
  final RxList<UserModel> friendsList = <UserModel>[].obs;
  RxBool isValidate = false.obs;

  final userID = PreferenceManager.readData(key: 'user-id');

  RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;
  TextEditingController groupNameController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("Called on init");

    fetchUsers();
    validate();
    selectedUserIds.clear();
    print("Selected user Id list ${selectedUserIds.length}");
  }

  // void fetchChatRooms() {
  //   var userID = PreferenceManager.readData(key: 'user-id');
  //
  //   _chatService.getChatRoomSnapshots(userID).listen((snapshot) {
  //     print('snapshot data: ${snapshot.docs}');
  //     chatRooms.value = snapshot.docs
  //         .map((doc) => ChatRoomModel.fromMap(doc.data()))
  //         .toList();
  //
  //   }, onError: (e) {
  //     print(" Error fetching chat rooms: $e");
  //   });
  //
  //   fetchLastMessges();
  //
  // }

  fetchLastMessges() async {
    print("Last msg");

    try {
      print("Chat room length ${chatRooms.length}");
      for (int i = 0; i < chatRooms.length; i++) {
        final room = chatRooms[i];
        print("index ${room.userIds}");

        _chatService.getLastMessage(room.roomId).listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            var doc = snapshot.docs.first;
            print("Document${doc.data()}");
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
        users.value =
            data.docs.map((e) => UserModel.fromMap(e.data())).toList();
      });
    } catch (e) {
      log("Error Fetching Users: $e");
    }
  }

  Future<ChatRoomModel?> createRoom(
      List<UserModel> friendList, String roomName) async {
    try {
      isLoading.value = true;

      final client = await db.loadUser(userID);
      final user = UserModel.fromMap(client as Map<String, dynamic>);
      print("user:${user}");

      final user1 = UserModel(
        name: user.name!,
        uid: userID,
        imageUrl: user.imageUrl,
      );

      friendList.add(user1);

      List<String> userIds = friendList.map((u) => u.uid!).toList();

      var result =
          await _chatService.createRoom(friendList, userIds, 'Group', roomName);
      friendList.clear();

      if (result.docs.isNotEmpty) {
        var responseData = ChatRoomModel.fromMap(result.docs.first.data());
        isLoading.value = false;

        return responseData;
      } else {
        isLoading.value = false;
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  validate() {
    isValidate.value =
        friendsList.isNotEmpty && groupNameController.text.isNotEmpty;
    print("Validation : ${isValidate}");
    update();
  }
}
