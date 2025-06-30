import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/modules/group_chat_creation/view_model/group_chat_creation_view_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChatCreationView extends GetView<GroupChatCreationViewModel> {
   
  final RxList<UserModel> friendsList = <UserModel>[].obs;
  final TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Chat Creation')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔹 Group name input
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                hintText: "Enter group name ",
                border: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text("Add Member"),
                onPressed: () {
                  openBottomSheet();
                  print("Add Member tapped");
                  // Add member logic here
                },
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: friendsList.length,
                itemBuilder: (context, index) {
                  int cnt = index + 1;
                  return ListTile(
                    title: Text(friendsList[index].name ?? ""),
                    leading: Text(cnt.toString()),
                  );
                },
              )),
            ),





            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  print("Group Name: ${groupNameController.text}");
                },
                child:  Text("Create Group",style: TextStyle(color: Colors.blueGrey),),
              ),
            ),
          ],
        ),
      ),
    );
  }


  openBottomSheet() async {

    final userID = PreferenceManager.readData(key: 'user-id');
    var selected = await Get.bottomSheet<UserModel>(
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 32),
          height: MediaQuery.of(Get.context!).size.height,
          width: MediaQuery.of(Get.context!).size.width,
          child: Column(
            children: [
              // Top bar with close button
              Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Get.back(), // Dismiss bottom sheet
                    ),
                  ],
                ),
              ),
              Expanded(

                child: ListView.builder(
                  // padding: EdgeInsets.only(top: 4),
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    final lastMessage = user.lastMessage?['content'] ?? 'No messages yet';
                    final imageUrl = user.imageUrl ?? 'https://via.placeholder.com/150';
                    final receiverID = user.uid;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 24,
                      ),
                      title: Text(user.name ?? 'No Name'),
                      subtitle: Text(
                        "Add Friend",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () async {
                        // var result =  await controller.createRoom(receiverID!, user.name!, user.imageUrl!);
                        // if(result != null) {
                        //
                        //
                        //   Get.back(result: result);
                        // } else {
                        //   // show error message
                        // }
                        Get.back(result: user);

                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        isScrollControlled: true
    );



    print("Selected ${selected?.name}");
    friendsList.add(selected!);

  }
}
