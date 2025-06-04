
import 'package:chat_app/modules/auth/login/view_model/login_view_model.dart';
import 'package:chat_app/modules/auth/sign_up/view_model/sign_up_view_model.dart';
import 'package:get/get.dart';



class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpViewModel>(() => SignUpViewModel());
  }
}