import 'dart:async';

import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  initiate() {
    var userId = PreferenceManager.readData(key: 'user-id');
    print("userId :${userId}");
    Timer(Duration(seconds: 5), () {
      Get.offNamed(
        PreferenceManager.readData(key: 'user-id') == null
            ? AppRoutes.LOGIN
            : AppRoutes.ROOMLIST,
      );
    });
  }
}
