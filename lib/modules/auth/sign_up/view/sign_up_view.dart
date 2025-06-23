import 'package:chat_app/modules/auth/sign_up/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpView extends GetView<SignUpViewModel> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'),
        leading: IconButton(onPressed: (){Get.back();},
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              final imageFile = controller.pickedImage.value;
              return GestureDetector(
                onTap: controller.pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile)
                        : const AssetImage('assets/placeholder.png')
                  as ImageProvider,
                  child: imageFile == null
                      ? const Icon(Icons.add_a_photo, size: 32, color: Colors.white70)
                      : null,
                ),
              );
            }),
            const SizedBox(height: 20),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
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
              onPressed: controller.signUp,
              child: const Text('Sign Up'),
            )),
          ],
        ),
      ),
    );
  }
}
