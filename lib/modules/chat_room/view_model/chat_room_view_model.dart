import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/message_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/chat_services.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomViewModel extends GetxController {

  var arguments = Get.arguments;
  RxList<Message> messages = <Message>[].obs;
  final ChatService chatService = ChatService();
  DatabaseService db = DatabaseService();

  String? receiverID = "";
  ChatRoomModel? chatRoom;
  final userID = PreferenceManager.readData(key: 'user-id');

  String chatRoomId = "";
  final messageController = TextEditingController();
  String? imageController;

  @override
  void onInit() {
    super.onInit();
    chatRoom = arguments[0] as ChatRoomModel?;
    chatRoomId = arguments[1] as String;

    print("receiver:${chatRoom}");
    fetchMessage();
  }

  // getChatRoom() {
  //   if (userID.hashCode > receiverID.hashCode) {
  //     chatRoomId = "${userID}_${receiverID}";
  //   } else {
  //     chatRoomId = "${receiverID}_${userID}";
  //   }
  // }

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
      String? content;
      String? type;
      if (imageController != null) {
        content = imageController!;
        type = "image";
      } else {
        content = messageController.text;
        type = "text";
      }

      final message = Message(
        id: now.millisecondsSinceEpoch.toString(),
        content: content,
        senderId: userID,
        receiverId: receiverID,
        timestamp: now,
        type: type,
      );
      print("Receiver id:{$receiverID}");
      print("Chat room ID:${chatRoomId}");

      await chatService.saveMessage(message.toMap(), chatRoomId);
      await chatService.saveLastMessage(message.toMap(), chatRoomId);



      messageController.clear();
    } catch (e) {
      rethrow;
    }
  }

  fetchMessage() {
    print("Fetch");
    print(chatRoomId);
    chatService.getMessages(chatRoomId).listen((data) {
      messages.value = data.docs.map((e) => Message.fromMap(e.data())).toList();

      print(" Data information");

      print(data.docs);
    });

    print("Messages:${messages.length}");
  }

  Stream<UserModel> fetchUser(String uid) {
    return db.loadStreamUser(uid).map((snapshot) {
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  Future<void> pickImage() async {
    File? _selectedImage;
    final ImagePicker _picker = ImagePicker();

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    print("Picked File ${pickedFile}");
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
    }
    print("Image picked ${_selectedImage}");

    String? imageUrl = await chatService.uploadImage(_selectedImage!);

    if (imageUrl != null) {
      final now = DateTime.now();

      final imageMessage = Message(
        id: now.millisecondsSinceEpoch.toString(),
        content: imageUrl,
        senderId: userID,
        receiverId: receiverID,
        timestamp: now,
        type: 'image',
      );

      await chatService.saveMessage(imageMessage.toMap(), chatRoomId);
      await chatService.saveLastMessage(imageMessage.toMap(), chatRoomId);
    }
  }


  bool isEmoji(String input) {
    print("Print the emoji ${input}");
    if (input.isEmpty) return false;
    final codePoints = input.runes;

    for (var code in codePoints) {
      if (
      // Emoticons
      (code >= 0x1F600 && code <= 0x1F64F) ||
          // Misc Symbols and Pictographs
          (code >= 0x1F300 && code <= 0x1F5FF) ||
          // Transport and Map Symbols
          (code >= 0x1F680 && code <= 0x1F6FF) ||
          // Misc symbols
          (code >= 0x2600 && code <= 0x26FF) ||
          // Dingbats
          (code >= 0x2700 && code <= 0x27BF) ||
          // Supplemental Symbols and Pictographs
          (code >= 0x1F900 && code <= 0x1F9FF) ||
          // Extended pictographic range
          (code >= 0x1FA70 && code <= 0x1FAFF)
      ) {
        return true;
      }
    }
    return false;
  }

}
