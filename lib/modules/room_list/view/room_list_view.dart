import 'dart:developer';

import 'package:chat_app/core/models/chat_room_model.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/modules/chat_room/view_model/chat_room_view_model.dart';
import 'package:chat_app/modules/room_list/model_view/room_list_view_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomListView extends GetView<RoomListViewModel> {

  @override
  Widget build(BuildContext context) {
    var userID = PreferenceManager.readData(key: 'user-id');

    if (userID == null || userID.isEmpty) {

      return Scaffold(
        body: Center(
          child: Text("⚠️ User ID not found. Please log in again."),
        ),
      );
    }





    return  Scaffold(
      appBar: AppBar(
          title: Text('Chat Room List'),
          actions: [
            GestureDetector(
                onTap: (){
                  // openBottomSheet();
                  // showChatTypeDialog(context);
                  // showDynamicActionSheet(context, ['Single', 'Group', 'Broadcast','Multicast']);
                  showActionSheetUI(context,['Single', 'Group'] );

                },
                child: Icon(Icons.add_circle)
            ),
          ],
        leading: GestureDetector(
            onTap: (){

              PreferenceManager.removeData(key: 'user-id');
              var userId = PreferenceManager.readData(key: 'user-id');
              print("UserID:${userId}");
              Get.offNamed(AppRoutes.LOGIN);
            },
            child: Icon(Icons.logout_outlined)
        ),

      ),
      body: Obx(() {
        if(controller.isLoading.value == true)
          {
            return Center(child: CircularProgressIndicator());
          }

        return RefreshIndicator(
          onRefresh: ()async
          {
            await controller.fetchChatRooms();
            await controller.fetchUsers();
          },
          child: ListView.builder(
            itemCount: controller.chatRooms.length,
            itemBuilder: (context, index) {
              var room = controller.chatRooms[index];
              String roomName = room.roomName ?? 'No room name';
              print(room.roomType);
              UserModel? info;
              String flag;
              if(room.roomType == 'Single') {
                  if( room.users.first.uid!=userID)
                  {
                    info = room.users.first;
                  }
                  else
                  {
                    info = room.users.last;
                  }
                  flag = room.users.first.name!;

                }
              else
                {
                  flag = room.roomName!;
                }



            // print("Frst user name:${info?.name!}");
            // print("Update At 🔥 ${room.updateAt}");
              final imageUrl = info?.imageUrl ??
                  'https://via.placeholder.com/150';

              final otherUser = room.users.firstWhere(
                    (u) => u.uid != userID,
                orElse: () => room.users.last,
              );
              // if(room.roomType!=null || room.roomType=='Group')
              //   {
              //     return Text(room.roomName??'No name');
              //   }

              return ListTile(
                leading: info?.imageUrl != null ?CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 24,
                )
                    : Container(
                  height: 48,
                  width:48,
                  padding: EdgeInsets.fromLTRB(14, 4, 4,4),
                  child: Text((flag != null? flag![0].toUpperCase() :'A' )as String  ,style: TextStyle(color: Colors.amber,fontSize: 24),),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),


                  ),
                ),
                title: Text(room.roomType == 'Single' ? (info?.name ?? "") : roomName),
                 subtitle: Text(
                   room.lastMessage?.content ?? 'No Message available',
                   maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                 ),
                onTap: () {
                  // Navigate to chat detail screen
                  print("Tapped on room: ${room.roomId}");

                  Get.toNamed(AppRoutes.CHATROOM, arguments: [room,room.roomId]);
                },
              );
            },
          ),
        );
      }),



    );

  }


  void showActionSheetUI(BuildContext context, List<String> options) {
    showModalBottomSheet(
      context: context,


      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      backgroundColor: Colors.grey[100],
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...options.asMap().entries.map((entry){
                int index = entry.key;
                String option = entry.value;

                return Column(

                  children: [
                    Container(

                      width: double.infinity,
                      // margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(

                        color: Colors.white,
                        borderRadius: index == 0
                            ? const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        )
                            : BorderRadius.zero,

                        // borderRadius: BorderRadius.only(
                         //   topLeft: Radius.circular(16),
                         //   topRight: Radius.circular(16)
                         // )

                         // borderRadius: BorderRadius.circular(16)
                      ),
                      child: TextButton(
                        onPressed: ()  {
                          if(option=='Single')
                            {
                              Get.back();
                              openBottomSheet();
                              // Get.back();
                            }
                          else if(option == 'Group')
                            {

                              Get.back();
                              Get.toNamed(AppRoutes.GROUPCHATCREATION);
                            }
                          // Navigator.pop(context);
                          print("Selected: $option");
                          // Handle tap
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),

                    const Divider(height: 1, thickness: 0.5),
                    // const SizedBox(height: 4),
                  ],
                );
              }).toList(),

              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal:8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  openBottomSheet() async {

    final userID = PreferenceManager.readData(key: 'user-id');
    var selected = await Get.bottomSheet<ChatRoomModel>(
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
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),


              Expanded(
                child: Obx(()=>
                    controller.isLoading.value == true ? Center(child: CircularProgressIndicator()): ListView.builder(
                      // padding: EdgeInsets.only(top: 4),
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        final user = controller.users[index];
                        final lastMessage = user.lastMessage?['content'] ?? 'No messages yet';
                        final imageUrl = user.imageUrl ?? 'https://via.placeholder.com/150';
                        final receiverID = user.uid;

                        Obx(()=>

                        controller.isLoading.value == true ? CircularProgressIndicator( color: Colors.blueGrey,) : ListTile(
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
                            var result =  await controller.createRoom(receiverID!, user.name!, user.imageUrl!);

                            if(result != null) {


                              Get.back(result: result);
                            } else {

                              // show error message
                            }
                          },
                        )
                        );


                        return  ListTile(
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

                            var result =  await controller.createRoom(receiverID!, user.name!, user.imageUrl!);

                            if(result != null) {


                              Get.back(result: result);
                            } else {

                              // show error message
                            }
                          },
                        );




                      },
                    ),
                )
              ),
            ],
          ),
        ),

        isScrollControlled: true
    );


    if(selected != null) {
      UserModel user;
      if(selected.users.first.uid!=userID )
      {
        user= selected.users.first ;

      }
      else
      {
        user= selected.users.last ;
      }
      // UserModel client = UserModel(name: user.name, imageUrl:  user.imageUrl,uid: user.uid);

      Get.toNamed(AppRoutes.CHATROOM, arguments: [selected,selected.roomId]);

    }


  }
}


