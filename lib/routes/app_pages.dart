

import 'package:chat_app/core/bindings/chat_room_binding.dart';
import 'package:chat_app/core/bindings/login_binding.dart';
import 'package:chat_app/core/bindings/room_list_binding.dart';
import 'package:chat_app/core/bindings/signup_binding.dart';
import 'package:chat_app/core/bindings/splash_binding.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/modules/auth/login/view/login_view.dart';
import 'package:chat_app/modules/auth/sign_up/view/sign_up_view.dart';

import 'package:chat_app/modules/chat_room/view/chat_room_view.dart';
import 'package:chat_app/modules/room_list/view/room_list_view.dart';
import 'package:chat_app/modules/splash/view/splash_view.dart';

import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const SignUpView(),
      binding: SignupBinding(),
    ),

    GetPage(
      name: AppRoutes.CHATROOM,
      page: () => ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    //

    GetPage(
      name: AppRoutes.ROOMLIST,
      page: () =>  RoomListView(),
      binding: RoomListBinding(),
    )


  ];
}