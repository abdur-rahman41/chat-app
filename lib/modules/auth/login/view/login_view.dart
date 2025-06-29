import 'package:chat_app/modules/auth/login/view_model/login_view_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginViewModel> {


  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: controller.logIn,
              child: const Text('Sign In'),
            )),
            if (controller.currentUser != null)
              CircleAvatar(
                backgroundImage: NetworkImage(controller.currentUser!.photoURL ?? ''),
                radius: 40,
              ),

            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: Image.asset(
                'assets/images/logo.jpeg',
                height: 24,
                width: 24,
              ),
              label: const Text('Sign in with Google'),
              onPressed: controller.signInWithGoogle,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 16,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                InkWell(
                  onTap: () {
                    Get.offAndToNamed(AppRoutes.SIGNUP);
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
