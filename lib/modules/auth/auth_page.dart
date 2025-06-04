import 'package:flutter/material.dart';
import 'auth_service.dart'; // Import the AuthService above

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Auth")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          ElevatedButton(
            child: Text("Sign Up"),
            onPressed: () async {
              final res = await authService.signUp(
                emailController.text,
                passwordController.text,
              );
              setState(() => message = res ?? '');
            },
          ),
          ElevatedButton(
            child: Text("Sign In"),
            onPressed: () async {
              final res = await authService.signIn(
                emailController.text,
                passwordController.text,
              );
              setState(() => message = res ?? '');
            },
          ),
          Text(message, style: TextStyle(color: Colors.red)),
        ]),
      ),
    );
  }
}
