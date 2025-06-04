import 'package:chat_app/modules/chat_list/view_model/chat_list_view_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListView extends GetView<ChatListViewModel> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl!),
                radius: 24,
              ),
              title: Text(user.name??'No Name'),
              subtitle: Text(
                user.lastMessage.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // trailing: Text(
              //   chat.time,
              //   style: const TextStyle(fontSize: 12, color: Colors.grey),
              // ),
              onTap: () {
                Get.offAndToNamed(AppRoutes.CHATROOM, arguments: [user]);
                // Navigate to the chat detail screen
              },
            );
          },
        );
      }),
    );
  }
}
