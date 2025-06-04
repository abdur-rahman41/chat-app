import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignUpViewModel extends GetxController {
  final db = DatabaseService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up
   signUp() async {
    try {
     final res = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
     print("User created successfully");
     print(res);
     print(res.user!.uid);
     UserModel user = UserModel(
         uid: res.user!.uid, email: res.user!.email,name:nameController.text );

     db.saveUser(user.toMap());

     if(res.user!.uid != null)
       {
         Get.offAndToNamed(AppRoutes.LOGIN);
       }

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }



  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();

  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}

extension on UserCredential {
  get uid => null;
}
