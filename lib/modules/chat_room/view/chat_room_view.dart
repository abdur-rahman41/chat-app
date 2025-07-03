import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/modules/chat_room/view_model/chat_room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomView extends GetView<ChatRoomViewModel> {


  @override
  Widget build(BuildContext context) {
    // controller.initialize(currentId: currentUserId, otherUserId: receiverId);
    var currentUserID = PreferenceManager.readData(key: 'user-id');
    String name;
    String? imageUrl;
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
            imageUrl!=null ? CircleAvatar(
              backgroundImage: NetworkImage(imageUrl??'room_list_view.dart'),
              radius: 24,
            ) : Container(
      height: 48,
      width:48,
      padding: EdgeInsets.fromLTRB(14, 5, 4,4),
      child: Text((name != null? name![0].toUpperCase() :'A' )as String  ,style: TextStyle(color: Colors.amber,fontSize: 24),),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),


      ),
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
                    UserModel partner;
                    String partnerImage='';
                    String partnerName= '';
                    String partnerMsg='';
                    String formattedTime = DateFormat('hh:mm a').format(message.timestamp!);
                    if(isMe==false)
                      {

                        for(var user in controller.chatRoom!.users){
                          if(message.senderId == user.uid )
                            {
                              partnerImage=user.imageUrl!;
                              partnerName =user.name!;

                            }
                        }
                      }
                    print("Partner Image:${partnerImage}");
                    if(isMe==true)
                      {
                        return Align(
                          alignment: isMe ?  Alignment.centerRight :Alignment.centerLeft,
                          child:Container(
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(message.content!),
                          ),
                        );

                      }
                    if(controller.chatRoom?.roomType=='Single')
                      {
                        return Align(
                            alignment: isMe ?  Alignment.centerRight :Alignment.centerLeft,
                            child:

                          Row(
                            children: [
                              CircleAvatar(

                                  backgroundImage: NetworkImage(partnerImage)
                              ),
                                Container(
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isMe ? Colors.blue[200] : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(message.content!),
                              )
                            ],
                          ),


                        );
                      }
                    else
                      {
                        return Align(
                            alignment: isMe ?  Alignment.centerRight :Alignment.centerLeft,
                            child:ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(partnerImage),
                                radius: 24,
                              ) ,
                              title:Row(children: [
                                Text(partnerName),
                                SizedBox(width:8,),
                                Text(formattedTime,style: TextStyle(fontSize: 10),),
                              ],) ,
                              subtitle: Text(message.content!,),

                            )

                          // Row(
                          //   children: [
                          //     CircleAvatar(
                          //
                          //         backgroundImage: NetworkImage(partnerImage)
                          //     ),
                          //       Container(
                          //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          //       padding: const EdgeInsets.all(10),
                          //       decoration: BoxDecoration(
                          //         color: isMe ? Colors.blue[200] : Colors.grey[300],
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(message.content!),
                          //     )
                          //   ],
                          // ),


                        );
                      }
        

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


