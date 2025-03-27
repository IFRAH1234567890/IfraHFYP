import 'package:flutter/material.dart';
import 'welcome_pages/neuroplay_page.dart';
import 'welcome_pages/social_connect_page.dart';
import 'welcome_pages/cognitherapist_page.dart';
import 'welcome_pages/insight_tracker_page.dart';
import 'welcome_pages/perceptoscan_page.dart';
import 'welcome_pages/lingoquest_page.dart';
import 'welcome_pages/thoughtbridge_page.dart';

class NeuroReviveHome extends StatelessWidget {
  const NeuroReviveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'NEURO REVIVE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'MindScape Hub',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            // Icon Grid
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _featureTile(context, Icons.videogame_asset, 'NeuroPlay', NeuroPlayPage()),
                  _featureTile(context, Icons.people, 'Social Connect', SocialConnectPage()),
                  _featureTile(context, Icons.psychology, 'CogniTherapist', CogniTherapistPage()),
                  _featureTile(context, Icons.school, 'Insight Tracker', InsightTrackerPage()),
                  _featureTile(context, Icons.book, 'PerceptoScan', PerceptoScanPage()),
                  _featureTile(context, Icons.event_note, 'LingoQuest', LingoQuestPage()),
                  _featureTile(context, Icons.group, 'ThoughtBridge', ThoughtBridgePage()),
                ],
              ),
            ),

            // Campus Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Cognition Core',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Image.network('https://www.bing.com/th?id=OIP.nENQFcaqbYneoL_BI4wRiwHaGL&w=150&h=125&c=8&rs=1&qlt=90&o=6&dpr=1.5&pid=3.1&rm=2'),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'The Neuro Revive Center is committed to mental wellness through interactive tools and AI assistance.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureTile(BuildContext context, IconData icon, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.purple[800]),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate files:
// welcome_pages/neuroplay_page.dart
// import 'package:flutter/material.dart';
// class NeuroPlayPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('NeuroPlay')),
//       body: Center(child: Text('Welcome to NeuroPlay!', style: TextStyle(fontSize: 24))),
//     );
//   }
// }

// Repeat similar structure for SocialConnectPage, CogniTherapistPage, InsightTrackerPage, PerceptoScanPage, LingoQuestPage, ThoughtBridgePage.
