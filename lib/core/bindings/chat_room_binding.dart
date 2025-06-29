
import 'package:chat_app/modules/chat_room/view_model/chat_room_view_model.dart';
import 'package:get/get.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRoomViewModel>(() => ChatRoomViewModel());
  }
}
