import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../view_model/splash_view_model.dart';

class SplashView extends GetView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initiate();
    return Scaffold(
        body: Container(
          color: Colors.blueAccent,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset('assets/images/splash.png', fit: BoxFit.cover)
              ),

              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Image.asset('assets/images/pulsetechlogo.png', height: 160,
                        width: 130,)

                    ],
                  )
              )
            ],
          ),
        )
    );
  }

}