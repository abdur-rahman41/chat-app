import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/modules/chat_room/view_model/chat_room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomView extends GetView<ChatRoomViewModel> {
  @override
  Widget build(BuildContext context) {
    var currentUserID = PreferenceManager.readData(key: 'user-id');
    String name;
    String? imageUrl;
    String nameImg;
    if (controller.chatRoom?.roomType == 'Single') {
      if (controller.chatRoom!.users.first.uid != currentUserID) {
        name = controller.chatRoom!.users.first.name!;
        imageUrl = controller.chatRoom!.users.first.imageUrl!;
      } else {
        name = controller.chatRoom!.users.last.name!;
        imageUrl = controller.chatRoom!.users.last.imageUrl!;
      }
    } else {
      name = controller.chatRoom!.roomName!;
    }
    var isEmoji = controller.isEmoji(name);
    if (isEmoji == false) {
      nameImg = name[0].toUpperCase().toString();
    } else {
      nameImg = name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            imageUrl != null
                ? Container(
                    height: 48,
                    width: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder.png', // your character image asset
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  )
                : Container(
                    height: 48,
                    width: 48,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        (nameImg != null ? nameImg : 'A') as String,
                        style: TextStyle(color: Colors.amber, fontSize: 24),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  ),
            SizedBox(
              width: 16,
            ),
            Text(name),
          ],
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back)),
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

                    String partnerImage = '';
                    String partnerName = '';

                    String formattedTime =
                        DateFormat('hh:mm a').format(message.timestamp!);
                    if (isMe == false) {
                      for (var user in controller.chatRoom!.users) {
                        if (message.senderId == user.uid) {
                          partnerImage = user.imageUrl!;
                          partnerName = user.name!;
                        }
                      }
                    }

                    if (isMe == true) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(64, 4, 4, 4),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(message.content!),
                          ),
                        ),
                      );
                    }

                    if (controller.chatRoom?.roomType == 'Single') {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(partnerImage)),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blue[200]
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(message.content!),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(partnerImage)),
                                SizedBox(
                                  width: 14,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          partnerName,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 3, 0, 1),
                                            child: Text(
                                              formattedTime,
                                              style: TextStyle(fontSize: 12),
                                            )),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 2),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? Colors.blue[200]
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(message.content!),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    SizedBox(
                      height: 16,
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
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration:
                          const InputDecoration(hintText: 'Type a message...'),
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
