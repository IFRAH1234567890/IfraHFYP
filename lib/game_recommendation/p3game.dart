import 'package:flutter/material.dart';

class P3Game extends StatelessWidget {
  const P3Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game 3'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to Game 3!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}