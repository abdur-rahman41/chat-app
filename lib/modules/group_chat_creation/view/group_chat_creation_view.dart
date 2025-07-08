import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/modules/group_chat_creation/view_model/group_chat_creation_view_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChatCreationView extends GetView<GroupChatCreationViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Group Chat ')),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller.groupNameController,
                    onChanged: (value) {
                      controller.groupNameController.text = value;
                      controller.validate();
                    },
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
                          itemCount: controller.friendsList.length,
                          itemBuilder: (context, index) {
                            String image =
                                controller.friendsList[index].imageUrl ??
                                    'https://via.placeholder.com/150';
                            return ListTile(
                              title: Text(
                                  controller.friendsList[index].name ?? ""),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(image),
                              ),
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 0, 4, 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isValidate.value
                                ? Colors.green
                                : Colors.grey,
                          ),
                          onPressed: controller.isValidate.value
                              ? () async {
                                  var chatRoom = await controller.createRoom(
                                      controller.friendsList,
                                      controller.groupNameController.text);

                                  Get.delete<GroupChatCreationViewModel>();
                                  Get.offNamed(AppRoutes.CHATROOM,
                                      arguments: [chatRoom, chatRoom?.roomId]);
                                }
                              : null,
                          child: Text(
                            "Create Group",
                            style: TextStyle(
                              color: controller.isValidate.value
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  openBottomSheet() async {
    var selected = await Get.bottomSheet<List<UserModel>>(
      Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 32),
        height: MediaQuery.of(Get.context!).size.height,
        width: MediaQuery.of(Get.context!).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.users.length,
                    itemBuilder: (context, index) {
                      final user = controller.users[index];
                      final imageUrl =
                          user.imageUrl ?? 'https://via.placeholder.com/150';

                      var result =
                          controller.selectedUserIds.contains(user.uid);
                      RxBool isSelected = controller.selectedUserIds
                          .contains(user.uid)
                          .obs as RxBool;

                      print("Is selected ${isSelected}");

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 24,
                        ),
                        title: Text(user.name ?? 'No Name'),
                        subtitle: Text("Add to chat"),
                        trailing: Obx(
                          () => Icon(
                              isSelected.value
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              color: isSelected.value
                                  ? Colors.green
                                  : Colors.grey),
                        ),
                        onTap: () {
                          print(isSelected.value);
                          if (isSelected.value) {
                            // print(isSelected);
                            controller.selectedUserIds.remove(user.uid);
                            isSelected.value = false;
                          } else {
                            controller.selectedUserIds.add(user.uid!);
                            isSelected.value = true;
                          }
                        },
                      );
                    },
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final selectedUsers = controller.users
                        .where(
                            (u) => controller.selectedUserIds.contains(u.uid))
                        .toList();

                    Get.back(result: selectedUsers);
                  },
                  child: Text("Done", style: TextStyle(color: Colors.blueGrey)),
                ),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
    if (selected != null) {
      controller.friendsList.value = selected;
      controller.validate();
    }
  }
}
