import 'dart:io';

import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/services/database_services.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class SignUpViewModel extends GetxController {
  final db = DatabaseService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Picked image file
  final Rx<File?> pickedImage = Rx<File?>(null);

  // Pick image from gallery
  Future<void> pickImage() async {
    print("Tapped");
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path);
    }
  }


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
     String? imageUrl = pickedImage.value?.path;
     UserModel user = UserModel(
         uid: res.user!.uid, email: res.user!.email,name:nameController.text,imageUrl: imageUrl );

     db.saveUser(user.toMap());

     if(res.user!.uid != null)
       {
         Get.offAndToNamed(AppRoutes.LOGIN);
       }

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

}


