import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neurorevive/wrapper.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:neurorevive/game_recommendation/assessment_provider.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider( // Wrap the app with ChangeNotifierProvider
      create: (context) => AssessmentProvider(), // Provide AssessmentProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Neuro Revive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Wrapper(), // Your existing Wrapper
    );
  }
}
