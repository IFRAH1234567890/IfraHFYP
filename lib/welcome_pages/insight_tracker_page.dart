import 'package:flutter/material.dart';

class InsightTrackerPage extends StatelessWidget {
  const InsightTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Insight Tracker')),
      body: Center(
        child: Text('Welcome to Insight Tracker!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
