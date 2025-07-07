
import 'package:chat_app/modules/auth/login/view/login_view.dart';
import 'package:chat_app/modules/auth/sign_up/view/sign_up_view.dart';
import 'package:chat_app/routes/app_pages.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔕 Background Message: ${message.messageId}");
}


Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),

    );
  }
}

