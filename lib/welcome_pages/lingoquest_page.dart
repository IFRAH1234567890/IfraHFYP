import 'package:flutter/material.dart';

class LingoQuestPage extends StatelessWidget {
  const LingoQuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LingoQuest')),
      body: Center(
        child: Text('Welcome to LingoQuest!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
