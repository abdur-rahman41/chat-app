
import 'package:chat_app/modules/auth/login/view_model/login_view_model.dart';
import 'package:get/get.dart';



class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginViewModel>(() => LoginViewModel());
  }
}