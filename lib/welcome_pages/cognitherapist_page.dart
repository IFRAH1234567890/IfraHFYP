import 'package:flutter/material.dart';

class CogniTherapistPage extends StatelessWidget {
  const CogniTherapistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CogniTherapist')),
      body: Center(
        child: Text('Welcome to CogniTherapist!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
