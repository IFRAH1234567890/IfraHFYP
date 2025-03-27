import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'assessment_questions.dart';
import 'assessment_provider.dart';
import 'game_recommendation_screen.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  // Define category colors for a vibrant yet professional look
  Map<String, Color> getCategoryColor(String category) {
    switch (category) {
      case 'Memory':
        return {'primary': Colors.purple, 'light': Colors.purple.shade50};
      case 'Attention':
        return {'primary': Colors.teal, 'light': Colors.teal.shade50};
      case 'Emotional Regulation':
        return {'primary': Colors.pink, 'light': Colors.pink.shade50};
      default:
        return {'primary': Colors.indigo, 'light': Colors.indigo.shade50};
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssessmentProvider>(context);
    final questions = AssessmentQuestions.questions;
    final totalQuestions = questions.length;
    final answeredQuestions = provider.responses.length;
    final progress = answeredQuestions / totalQuestions;

    return Scaffold(
      // Custom gradient app bar for visual appeal
      appBar: AppBar(
        title: Text(
          'Initial Assessment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo, Colors.purple],
            ),
          ),
        ),
        elevation: 0,
        actions: [
          // Progress indicator in app bar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Colorful background
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            minHeight: 6.0,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index]['question'];
                final options = questions[index]['options'];
                final category = questions[index]['category'];
                final colors = getCategoryColor(category);

                // Check if this question is answered
                final isAnswered = provider.responses.containsKey(question);

                return Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: isAnswered
                            ? colors['primary']!
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badge
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colors['primary'],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        // Question and options
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 12),

                              // Radio options with custom styling
                              ...options.map((option) {
                                final isSelected =
                                    provider.responses[question] == option;

                                return Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors['light']
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? colors['primary']!
                                          : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: RadioListTile(
                                    title: Text(
                                      option,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? colors['primary']
                                            : Colors.black87,
                                      ),
                                    ),
                                    value: option,
                                    groupValue: provider.responses[question],
                                    activeColor: colors['primary'],
                                    onChanged: (value) {
                                      provider.addResponse(
                                          question, value.toString());
                                    },
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating action button with gradient
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo, Colors.purple],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            // Show a message if not all questions are answered
            if (answeredQuestions < totalQuestions) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Please answer all questions before continuing.'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              return;
            }

            provider.recommendGames();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameRecommendationScreen(),
              ),
            );
          },
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
