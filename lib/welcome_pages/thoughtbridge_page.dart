import 'package:flutter/material.dart';

class ThoughtBridgePage extends StatelessWidget {
  const ThoughtBridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ThoughtBridge')),
      body: Center(
        child: Text('Welcome to ThoughtBridge!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
