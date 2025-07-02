import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/modules/chat_room/view_model/chat_room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomView extends GetView<ChatRoomViewModel> {


  @override
  Widget build(BuildContext context) {
    // controller.initialize(currentId: currentUserId, otherUserId: receiverId);
    var currentUserID = PreferenceManager.readData(key: 'user-id');
    String name;
    String imageUrl='https://via.placeholder.com/150';
    if(controller.chatRoom?.roomType=='Single')
      {
        if(controller.chatRoom!.users.first.uid!=currentUserID)
          {
            name = controller.chatRoom!.users.first.name!;
            imageUrl = controller.chatRoom!.users.first.imageUrl!;
          }
        else
          {
            name = controller.chatRoom!.users.last.name!;
            imageUrl = controller.chatRoom!.users.last.imageUrl!;
          }
      }
    else
      {
        name = controller.chatRoom!.roomName!;
      }


    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl??'room_list_view.dart'),
              radius: 24,
            ),
            SizedBox(width: 16,),
            Text(name),

        ],
        ),
        leading: GestureDetector(
            onTap: (){
                Get.back();
              },
            child: Icon(Icons.arrow_back)
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  reverse: true,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final isMe = message.senderId == currentUserID;
        
                    return Align(
                      alignment: isMe ?  Alignment.centerRight :Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(message.content!),
                      ),
                    );
                  },
                );
              }),
            ),
            Container(
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 0),
              child: Row(
                children: [
                  // GestureDetector(
                  //   child: Icon(Icons.image),
                  //   onTap:controller.pickImage
                  // ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: const InputDecoration(hintText: 'Type a message...'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      controller.saveMessage();
        
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
