import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/modules/group_chat_creation/view_model/group_chat_creation_view_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChatCreationView extends GetView<GroupChatCreationViewModel> {
   
  final RxList<UserModel> friendsList = <UserModel>[].obs;


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
              controller: controller.groupNameController,
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


                  controller.createRoom(friendsList,controller.groupNameController.text);
                  // friendsList.clear();
                  // controller.groupNameController.clear();
                },
                child:  Text("Create Group",style: TextStyle(color: Colors.blueGrey),),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // openBottomSheet() async {
  //
  //   final userID = PreferenceManager.readData(key: 'user-id');
  //
  //   List<UserModel>selectedUsers=[];
  //   var selected = await Get.bottomSheet<List<UserModel>>(
  //       Container(
  //         color: Colors.white,
  //         padding: EdgeInsets.only(top: 32),
  //         height: MediaQuery.of(Get.context!).size.height,
  //         width: MediaQuery.of(Get.context!).size.width,
  //         child: Column(
  //           children: [
  //             // Top bar with close button
  //             Padding(
  //               padding: const EdgeInsets.only(top: 16.0, right: 8.0),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   IconButton(
  //                     icon: Icon(Icons.close),
  //                     onPressed: () => Get.back(), // Dismiss bottom sheet
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //
  //               child: ListView.builder(
  //                 // padding: EdgeInsets.only(top: 4),
  //                 itemCount: controller.users.length,
  //                 itemBuilder: (context, index) {
  //                   RxBool isSelect=true.obs;
  //                   final user = controller.users[index];
  //
  //                   final lastMessage = user.lastMessage?['content'] ?? 'No messages yet';
  //                   final imageUrl = user.imageUrl ?? 'https://via.placeholder.com/150';
  //                   final receiverID = user.uid;
  //
  //                   return ListTile(
  //                     leading: CircleAvatar(
  //                       backgroundImage: NetworkImage(imageUrl),
  //                       radius: 24,
  //                     ),
  //                     title: Text(user.name ?? 'No Name'),
  //                     subtitle: Text(
  //                       "Add to chat",
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //
  //                     trailing: Obx(() =>
  //                     isSelect.value
  //                         ? Icon(Icons.add)
  //                         : Icon(Icons.close)
  //                     ),
  //
  //                     onTap: () async {
  //                       // var result =  await controller.createRoom(receiverID!, user.name!, user.imageUrl!);
  //                       // if(result != null) {
  //                       //
  //                       //
  //                       //   Get.back(result: result);
  //                       // } else {
  //                       //   // show error message
  //                       // }
  //                       selectedUsers.add(user);
  //                       isSelect.value=false;
  //                       print("Selected");
  //                       // Get.back(result: user);
  //
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //             // Container(
  //             //   width: double.infinity,
  //             //   margin: const EdgeInsets.symmetric(horizontal:8, vertical: 8),
  //             //   decoration: BoxDecoration(
  //             //     color: Colors.white,
  //             //     borderRadius: BorderRadius.circular(12),
  //             //   ),
  //             //   child: TextButton(
  //             //     onPressed: () => Get.back(),
  //             //     child: const Padding(
  //             //       padding: EdgeInsets.symmetric(vertical: 14),
  //             //       child: Text(
  //             //         "Done",
  //             //         style: TextStyle(
  //             //           fontSize: 16,
  //             //           color: Colors.red,
  //             //           fontWeight: FontWeight.w500,
  //             //         ),
  //             //       ),
  //             //     ),
  //             //   ),
  //             // ),
  //             Padding(
  //               padding:  EdgeInsets.fromLTRB(0,0,0,16),
  //               child: ElevatedButton(
  //                 onPressed: () {
  //
  //                       Get.back(result: selectedUsers);
  //
  //                 },
  //                 child:  Text("Done",style: TextStyle(color: Colors.blueGrey),),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //
  //       isScrollControlled: true
  //   );
  //
  //   friendsList.value = selectedUsers;
  //
  //   print("Selected ${selected?.length}");
  //
  //   // friendsList.add(selected!);
  //
  //
  //
  // }


  openBottomSheet() async {
    final userID = PreferenceManager.readData(key: 'user-id');
    // ✅ Persistent selection

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
                  final imageUrl = user.imageUrl ?? 'https://via.placeholder.com/150';

                  var result = controller.selectedUserIds.contains(user.uid);
                  RxBool isSelected = controller.selectedUserIds.contains(user.uid).obs as RxBool;


                  print("Is selected ${isSelected}");

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      radius: 24,
                    ),
                    title: Text(user.name ?? 'No Name'),
                    subtitle: Text("Add to chat"),
                    // trailing: obx(()=>Icon(
                    //   isSelected ? Icons.check_circle : Icons.add_circle_outline,
                    //   color: isSelected ? Colors.green : Colors.grey,
                    // )),
                    trailing: Obx(() =>
                     // isSelected.value ? Icon(Icons.add) : Icon(Icons.close),
                    Icon( isSelected.value ? Icons.check_circle : Icons.add_circle_outline,
                          color: isSelected.value ? Colors.green : Colors.grey),

                    ),



                    onTap: () {
                      print(isSelected.value);
                      if (isSelected.value) {
                        // print(isSelected);
                        controller.selectedUserIds.remove(user.uid);
                        isSelected.value=false;
                      } else {
                        controller.selectedUserIds.add(user.uid!);
                        isSelected.value=true;
                      }
                    },
                  );
                },
              )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: ElevatedButton(
                onPressed: () {
                  final selectedUsers = controller.users
                      .where((u) => controller.selectedUserIds.contains(u.uid))
                      .toList();

                  Get.back(result: selectedUsers);
                },
                child: Text("Done", style: TextStyle(color: Colors.blueGrey)),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );

    if (selected != null) {
      friendsList.value = selected;
    }
  }



}





