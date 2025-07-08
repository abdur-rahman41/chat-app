import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();
  User? currentUser;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signInController = TextEditingController();

  final isLoading = false.obs;

  void onInit() {
    super.onInit();
    print("Called on init");
  }

  Future<void> getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      String? token = await messaging.getToken();
      print("✅ Device Token: $token");
      PreferenceManager.writeData(key: 'device-token', value: token);
    } catch (e) {
      print("❌ Error getting device token: $e");
    }
  }

  // Sign In
  logIn() async {
    try {
      print("Login model view");
      final res = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      PreferenceManager.writeData(key: 'user-id', value: res.user!.uid);

      if (res.user != null) {
        Get.offAndToNamed(AppRoutes.ROOMLIST);
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

//  Google Sign-In
//   Future<void> signInWithGoogle() async {
//     try {
//
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//       if (googleUser == null) return;
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final userCredential = await _auth.signInWithCredential(credential);
//       var user = userCredential.user;
//       if (user== null) {
//         throw Exception("Google sign-in returned null user.");
//       }
//
//
//       final client =  await databaseService.loadUser(user.uid);
//
//
//
//       PreferenceManager.writeData(key: 'user-id', value: user.uid);
//
//       if(client!=null)
//         {
//           UserModel currentClient = UserModel(
//               uid: client!['uid'], email: client['email'],name:client['name'],imageUrl: client['imageURL'] );
//
//           PreferenceManager.writeData(key: 'user-id', value: userCredential.user!.uid);
//           Get.offAndToNamed(AppRoutes.ROOMLIST);
//         }
//       else
//         {
//           UserModel currentClient = UserModel(
//               uid: user.uid, email: user.email,name:user.displayName ,imageUrl: user.photoURL);
//           databaseService.saveUser(currentClient.toMap());
//
//
//           print("User credential :${userCredential}");
//
//           if (user != null) {
//             currentUser=userCredential.user;
//             PreferenceManager.writeData(key: 'user-id', value: user.uid);
//             String userID =PreferenceManager.readData(key: 'user-id');
//
//             print("Google Sign-In Successful: ${user.uid}");
//             Get.offAndToNamed(AppRoutes.ROOMLIST);
//           }
//         }
//     } catch (e) {
//       print('Google Sign-In Error: $e');
//       Get.snackbar("Google Sign-In Failed", e.toString());
//     }
//   }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      getDeviceToken();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw Exception("Google sign-in returned null user.");
      }

      final client = await databaseService.loadUser(user.uid);

      PreferenceManager.writeData(key: 'user-id', value: user.uid);

      if (client != null) {
        final currentClient = UserModel(
            uid: client['uid'],
            email: client['email'],
            name: client['name'],
            imageUrl: client['imageURL'],
            deviceToken:
                PreferenceManager.readData(key: 'device-token') ?? ' ');

        Get.offNamed(AppRoutes.ROOMLIST);
      } else {
        final newUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          imageUrl: user.photoURL ?? '',
          deviceToken: PreferenceManager.readData(key: 'device-token') ?? ' ',
        );

        await databaseService.saveUser(newUser.toMap());

        currentUser = user;

        print("Google Sign-In Successful: ${user.uid}");
        Get.offNamed(AppRoutes.ROOMLIST);
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      Get.snackbar("Google Sign-In Failed", e.toString());
    }
  }
}
