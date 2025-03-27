import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neurorevive/wrapper.dart';
import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of auth changes for app state changes
  Stream<User?> get user => _auth.authStateChanges();

  // Sign Up Method
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user ID from the authenticated user
      String uid = userCredential.user!.uid;

      // Store user data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'createdAt': Timestamp.now(),
        'lastLogin': Timestamp.now(),
      });

      return userCredential;
    } catch (e) {
      print('Error during signup: $e');
      rethrow;
    }
  }

  // Sign In Method
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Get the user ID from the authenticated user
      String uid = userCredential.user!.uid;

      // Update last login timestamp in Firestore
      await _firestore.collection('users').doc(uid).update({
        'lastLogin': Timestamp.now(),
      });

      return userCredential;
    } catch (e) {
      print('Error during signin: $e');
      rethrow;
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthService _authService = AuthService();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool isLoading = false;

  Future<void> signup() async {
    if (email.text.isEmpty || password.text.isEmpty || name.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Use the auth service to sign up
      await _authService.signUpWithEmailAndPassword(
          email.text, password.text, name.text);

      // Navigate to Wrapper screen
      Get.offAll(() => Wrapper());
    } catch (e) {
      // Handle errors
      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 65, 55, 79),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: name,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter name',
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
            isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    onPressed: signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 50),
                      child: Text("Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Get.to(() => Signin());
              },
              child: Text(
                "Already have an account? Sign In",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final AuthService _authService = AuthService();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  Future<void> signin() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Use the auth service to sign in
      await _authService.signInWithEmailAndPassword(email.text, password.text);

      // Navigate to Wrapper screen
      Get.offAll(() => Wrapper());
    } catch (e) {
      // Handle errors
      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('Sign In', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 65, 55, 79),
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
            isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    onPressed: signin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 50),
                      child: Text("Sign In",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Get.to(() => Signup());
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
