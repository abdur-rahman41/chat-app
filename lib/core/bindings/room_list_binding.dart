
import 'package:chat_app/modules/room_list/model_view/room_list_view_model.dart';

import 'package:get/get.dart';

class RoomListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomListViewModel>(() => RoomListViewModel());
  }
}
