import 'package:flutter/material.dart';

import '../game_recommendation/assessment_screen.dart';

class NeuroPlayPage extends StatelessWidget {
  const NeuroPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NeuroPlay',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF6200EE),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6200EE), Color(0xFF3700B3)],
          ),
        ),
        child: Column(
          children: [
            // Header image of brain
            Container(
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 24),
              child: Image.network(
                'https://th.bing.com/th/id/OIP.V4v_r3KjukTgtQvCVO47TgHaHK?w=202&h=196&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.psychology,
                        size: 80,
                        color: Color(0xFF6200EE),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main content
            Expanded(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cognitive Assessment",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3700B3),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Discover your cognitive strengths and areas for improvement with our scientifically designed assessment tools.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Assessment categories with icons
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildAssessmentCard(
                            'Memory',
                            Icons.memory,
                            Colors.orange,
                          ),
                          _buildAssessmentCard(
                            'Attention',
                            Icons.visibility,
                            Colors.blue,
                          ),
                          _buildAssessmentCard(
                            'Problem Solving',
                            Icons.psychology,
                            Colors.green,
                          ),
                          _buildAssessmentCard(
                            'Processing Speed',
                            Icons.speed,
                            Colors.red,
                          ),
                        ],
                      ),
                    ),

                    // Start assessment button
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 24),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssessmentScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6200EE),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'START ASSESSMENT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
