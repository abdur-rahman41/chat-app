import 'dart:async';
import 'dart:developer';

import 'package:chat_app/core/models/message_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/chat_services.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomViewModel extends GetxController {

 // final UserModel userModel;
 // final UserModel receiver;
String? receiverName;
  var arguments = Get.arguments;
  RxList<Message> messages = <Message>[].obs;
  final ChatService chatService = ChatService();
  // final UserModel currentUser = UserModel().obs();
  //  final UserModel receiver = UserModel().obs();
  //  String? receiverID="".obs();
  String? receiverID="" ;
  UserModel? receiver;
  final userID = PreferenceManager.readData(key: 'user-id');
  StreamSubscription? _subscription;
  String chatRoomId = "";
  final messageController = TextEditingController();



  @override
  void onInit() {
    super.onInit();
    receiver = arguments[0] as UserModel;
    receiverID = receiver!.uid;
    receiverName = receiver!.name;
    getChatRoom();

    print("receiver:${receiver}");
    fetchMessage();

  }



  getChatRoom() {
    if (userID.hashCode > receiverID.hashCode) {
      chatRoomId = "${userID}_${receiverID}";
    } else {
      chatRoomId = "${receiverID}_${userID}";
    }
  }

  saveMessage() async {
    log("Send Message");
    try {
      if (messageController.text.isEmpty) {
        throw Exception("Please enter some text");
      }
      final now = DateTime.now();

      final message = Message(
          id: now.millisecondsSinceEpoch.toString(),
          content: messageController.text,
          senderId: userID,
          receiverId: receiverID,
          timestamp: now);
      print("Receiver id:{$receiverID}");
      print("Chat room ID:${chatRoomId}");

      await chatService.saveMessage(message.toMap(), chatRoomId);

       chatService.updateLastMessage(userID!, receiverID!,
          message.content!, now.millisecondsSinceEpoch);

      messageController.clear();
    } catch (e) {
      rethrow;
    }
  }

  fetchMessage()
  {
    print("Fetch");
    print(chatRoomId);
    chatService.getMessages(chatRoomId).listen((data){
      messages.value = data.docs.map((e) => Message.fromMap(e.data())).toList();

      print(" Data information");

      print(data.docs);
    });

    print("Messages:${messages}");
  }

  @override
  void dispose() {
    super.dispose();

    _subscription?.cancel();
  }

}
