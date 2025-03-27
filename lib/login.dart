import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neurorevive/forgot.dart';
import 'package:neurorevive/signup.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text, password: password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter email',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.blueGrey[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: password,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter password',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.blueGrey[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 104, 84, 122),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 50),
                child: Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.to(Forgot()),
              child: Text("Forgot password?", style: TextStyle(color: Colors.white70)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.to(Signup()),
              child: Text("Register now", style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}
