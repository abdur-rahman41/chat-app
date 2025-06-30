
import 'package:chat_app/modules/group_chat_creation/view_model/group_chat_creation_view_model.dart';
import 'package:chat_app/modules/room_list/model_view/room_list_view_model.dart';

import 'package:get/get.dart';

class GroupChatCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupChatCreationViewModel>(() => GroupChatCreationViewModel());
  }
}
