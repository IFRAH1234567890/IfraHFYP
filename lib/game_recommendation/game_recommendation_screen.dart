import 'package:flutter/material.dart';
import 'assessment_provider.dart';
import 'package:provider/provider.dart';

// Import the screens for each game category
import 'memory_game.dart';
import 'problem_solving_game.dart';
import 'focus_game.dart';

class GameRecommendationScreen extends StatelessWidget {
  const GameRecommendationScreen({super.key});

  // Game category color mapping
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Memory':
        return Colors.purple.shade600;
      case 'Problem Solving':
        return Colors.teal.shade600;
      case 'Attention':
        return Colors.orange.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  // Game category icon mapping
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Memory':
        return Icons.psychology;
      case 'Problem Solving':
        return Icons.lightbulb;
      case 'Attention':
        return Icons.visibility;
      default:
        return Icons.games;
    }
  }

  // Game category image mapping
  String getCategoryImage(String category) {
    switch (category) {
      case 'Memory':
        return 'https://th.bing.com/th?q=Cartoon+Brain+Art+Styles+Pinterest&w=120&h=120&c=1&rs=1&qlt=90&cb=1&dpr=1.5&pid=InlineBlock&mkt=en-WW&cc=PK&setlang=en&adlt=strict&t=1&mw=247';
      case 'Problem Solving':
        return 'https://th.bing.com/th/id/OIP.cPgjF5x3cmYe9JUV04FFaQHaH0?w=179&h=189&c=7&r=0&o=5&dpr=1.5&pid=1.7';
      case 'Attention':
        return 'https://th.bing.com/th?q=Solving+Puzzle+with+Brain&w=120&h=120&c=1&rs=1&qlt=90&cb=1&dpr=1.5&pid=InlineBlock&mkt=en-WW&cc=PK&setlang=en&adlt=strict&t=1&mw=247';
      default:
        return 'https://th.bing.com/th/id/OIP.ail0FpdWMS6ML8QwzhPo3gHaH0?w=134&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the AssessmentProvider instance
    final assessmentProvider = Provider.of<AssessmentProvider>(context);
    final recommendedGames = assessmentProvider.recommendedGames;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Games', 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade800, Colors.indigo.shade200],
          ),
        ),
        child: recommendedGames.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_esports, size: 80, color: Colors.white70),
                    const SizedBox(height: 16),
                    const Text(
                      'No games recommended yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Complete the assessment to get personalized game recommendations',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: recommendedGames.length,
                itemBuilder: (context, index) {
                  final game = recommendedGames[index];
                  final categoryColor = getCategoryColor(game.category);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            // Navigation logic with debug print
                            print('Navigating to game: ${game.category}');
                            
                            if (game.category == 'Memory') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemoryGame(),
                                ),
                              );
                            } else if (game.category == 'Problem Solving') {
                              // Add debug print to check if this path is being executed
                              print('Navigating to Problem Solving Game');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProblemSolvingGame(),
                                ),
                              );
                            } else if (game.category == 'Attention') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FocusGame(),
                                ),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Game image
                              Stack(
                                children: [
                                  Image.network(
                                    getCategoryImage(game.category),
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    // Placeholder if image fails to load
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 180,
                                        color: categoryColor.withOpacity(0.3),
                                        child: Icon(
                                          getCategoryIcon(game.category),
                                          size: 80,
                                          color: categoryColor,
                                        ),
                                      );
                                    },
                                  ),
                                  // Category label
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: categoryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            getCategoryIcon(game.category),
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            game.category,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Game details
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      game.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Improves ${game.category.toLowerCase()} skills through interactive challenges',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: categoryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 14,
                                                color: categoryColor,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '5-10 min',
                                                style: TextStyle(
                                                  color: categoryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: categoryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}