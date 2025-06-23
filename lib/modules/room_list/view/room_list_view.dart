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

    return Scaffold(
      appBar: AppBar(
          title: Text('Chat Room List'),
          actions: [
            GestureDetector(
                onTap: (){
                  openBottomSheet();
                },
                child: Icon(Icons.add_circle)
            ),
          ],
        leading: GestureDetector(
            onTap: (){

              PreferenceManager.removeData(key: 'user-id');
              Get.toNamed(AppRoutes.LOGIN);
            },
            child: Icon(Icons.logout_outlined)
        ),

      ),
      body: Obx(() {
        if (controller.chatRooms.isEmpty) {
          return Center(child: Text("No chat rooms found."));
        }

        return ListView.builder(
          itemCount: controller.chatRooms.length,
          itemBuilder: (context, index) {
            var room = controller.chatRooms[index];


            print("Room:${room.users[1]}");
            UserModel info;
            if( room.users.first.uid!=userID)
              {
                info = room.users.first;
              }
            else
              {
                info = room.users.last;
              }


            final imageUrl = info.imageUrl ??
                'https://via.placeholder.com/150';

            final otherUser = room.users.firstWhere(
                  (u) => u.uid != userID,
              orElse: () => room.users.last,
            );

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 24,
              ),
              title: Text(info.name??'No name'),
               // subtitle: Text(
               //   message.content!??'not yet',
               //   maxLines: 1,
               //  overflow: TextOverflow.ellipsis,
               // ),
              onTap: () {
                // Navigate to chat detail screen
                print("Tapped on room: ${room.roomId}");


                Get.toNamed(AppRoutes.CHATROOM, arguments: [info,room.roomId]);
              },
            );
          },
        );
      }),
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
      UserModel client = UserModel(name: user.name, imageUrl:  user.imageUrl,uid: user.uid);

      Get.toNamed(AppRoutes.CHATROOM, arguments: [client,selected.roomId]);

    }


  }
}


