import 'package:chat_app/modules/chat_list/view_model/chat_list_view_model.dart';
import 'package:get/get.dart';

class ChatListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatListViewModel>(() => ChatListViewModel());
  }
}
