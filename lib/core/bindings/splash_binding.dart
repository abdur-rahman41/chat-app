
import 'package:get/get.dart';

import '../../modules/splash/view_model/splash_view_model.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashViewModel>(() => SplashViewModel());
  }
}