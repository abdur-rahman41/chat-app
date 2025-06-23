import 'dart:async';


import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashViewModel extends GetxController {
  var counter = 0.obs;

  @override
  void onInit() {
    super.onInit();

  }

  // initiate(){
  //   Timer(Duration(seconds: 5), () {
  //     Get.offNamed(PreferenceManager.readData(key: PrefKey.userID) == null
  //         ? AppRoutes.LOGIN
  //         : AppRoutes.ROOMLIST;
  //     // Get.offNamed(AppRoutes.LOGIN);
  //   });
  // }


  initiate() {
    Timer(Duration(seconds: 5), () {
      Get.offNamed(
        PreferenceManager.readData(key: 'user-id') == null
            ? AppRoutes.LOGIN
            : AppRoutes.ROOMLIST,
      );
    });
  }


}
