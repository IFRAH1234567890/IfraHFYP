import 'package:flutter/material.dart';
import 'package:neurorevive/welcome_pages/cognitherapist_page.dart';
import 'package:neurorevive/welcome_pages/insight_tracker_page.dart';
import 'package:neurorevive/welcome_pages/lingoquest_page.dart';
import 'package:neurorevive/welcome_pages/neuroplay_page.dart';
import 'package:neurorevive/welcome_pages/perceptoscan_page.dart';
import 'package:neurorevive/welcome_pages/thoughtbridge_page.dart';
import 'package:neurorevive/welcome_pages/settings_page.dart';
import 'package:neurorevive/welcome_pages/social_connect_page.dart';
class NeuroReviveHome extends StatelessWidget {
  const NeuroReviveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'NEURO REVIVE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.deepPurple[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[800]!, Colors.indigo[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'MindScape Hub',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
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
                    _featureTile(
                      context,
                      Icons.videogame_asset,
                      'NeuroPlay',
                      Colors.orange[700]!,
                      NeuroPlayPage(),
                    ),
                    _featureTile(
                      context,
                      Icons.people,
                      'Social Connect',
                      Colors.teal[400]!,
                      SocialConnectPage(),
                    ),
                    _featureTile(
                      context,
                      Icons.psychology,
                      'CogniTherapist',
                      Colors.pink[400]!,
                      CogniTherapistPage(),
                    ),
                    _featureTile(
                      context,
                      Icons.school,
                      'Insight Tracker',
                      Colors.blue[400]!,
                      InsightTrackerPage(),
                    ),
                    _featureTile(
                      context,
                      Icons.book,
                      'PerceptoScan',
                      Colors.green[400]!,
                      PerceptoScanPage(),
                    ),
                    _featureTile(
                      context,
                      Icons.event_note,
                      'LingoQuest',
                      Colors.purple[400]!,
                      LingoQuestPage(),
                    ),
                    _featureTile(
                      context,
                      Icons.group,
                      'ThoughtBridge',
                      Colors.amber[700]!,
                      ThoughtBridgePage(),
                    ),
                    // Add this import at the top of your file

// Then add this to your GridView.count children list
                    _featureTile(
                      context,
                      Icons.settings,
                      'Settings',
                      Colors.grey[700]!,
                      SettingsPage(),
                    ),
                  ],
                ),
              ),

              // Campus Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Cognition Core',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://wallpapers.com/images/hd/brain-power-illustration-png-yny-l867mp4b196b3hts.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'The Neuro Revive Center is committed to mental wellness through interactive tools and AI assistance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureTile(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    Widget nextScreen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => nextScreen,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
