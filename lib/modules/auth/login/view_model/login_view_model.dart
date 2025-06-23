import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/core/services/preference_service.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Sign In
   logIn() async {
    try {
      print("Login model view");
   final res =   await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

   PreferenceManager.writeData(key: 'user-id', value: res.user!.uid);

   if(res.user != null)
     {

        Get.offAndToNamed(AppRoutes.ROOMLIST);
     }

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

//  Google Sign-In Method
  Future<void> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);


      final client =  await databaseService.loadUser(userCredential.user!.uid);
       UserModel currentClient = UserModel(
          uid: client!['uid'], email: client['email'],name:client['name'],imageUrl: client['imageURL'] );


      PreferenceManager.writeData(key: 'user-id', value: userCredential.user!.uid);

      if(currentClient!=null)
        {
          PreferenceManager.writeData(key: 'user-id', value: userCredential.user!.uid);
          Get.offAndToNamed(AppRoutes.ROOMLIST);
        }
      else
        {
          UserModel user = UserModel(
              uid: userCredential.user!.uid, email: userCredential.user!.email,name:userCredential.user!.displayName ,imageUrl: userCredential.user!.photoURL);
          databaseService.saveUser(user.toMap());


          print("User credential :${userCredential}");

          if (userCredential.user != null) {
            currentUser=userCredential.user;
            PreferenceManager.writeData(key: 'user-id', value: userCredential.user!.uid);
            String userID =PreferenceManager.readData(key: 'user-id');

            print("Google Sign-In Successful: ${userCredential.user!.uid}");
            Get.offAndToNamed(AppRoutes.ROOMLIST);
          }
        }
    } catch (e) {
      print('Google Sign-In Error: $e');
      Get.snackbar("Google Sign-In Failed", e.toString());
    }
  }


}
