import 'package:flutter/material.dart';

class PerceptoScanPage extends StatelessWidget {
  const PerceptoScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PerceptoScan')),
      body: Center(
        child: Text('Welcome to PerceptoScan!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
