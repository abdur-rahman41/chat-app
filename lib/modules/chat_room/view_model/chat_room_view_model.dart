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


String? receiverName;
  var arguments = Get.arguments;
  RxList<Message> messages = <Message>[].obs;
  final ChatService chatService = ChatService();

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
    chatRoomId = arguments[1] as String;
    receiverID = receiver!.uid;
    receiverName = receiver!.name;
    // getChatRoom();

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
    print("Text Field : ${messageController.text}");
    log("Send Message");
    try {

      if (messageController.text.trim().isEmpty) {
        Get.snackbar(
          "Empty Message",
          "Please enter some text",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
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
       await chatService.saveLastMessage(message.toMap(), chatRoomId);

       // chatService.updateLastMessage(userID!, receiverID!,
       //    message.content!, now.millisecondsSinceEpoch);

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



}
