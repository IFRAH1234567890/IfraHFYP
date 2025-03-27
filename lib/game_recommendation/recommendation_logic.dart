import 'game_model.dart';
import 'assessment_questions.dart';
import 'game_data.dart';

class RecommendationLogic {
  static List<Game> recommendGames(Map<String, String> responses) {
    List<Game> recommendedGames = [];
    responses.forEach((question, response) {
      if (response == 'Yes' || response == 'Sometimes') {
        // Find the question and its category
        final questionData = AssessmentQuestions.questions
            .firstWhere((q) => q['question'] == question, orElse: () => {});

        // Safely access the category
        final category = questionData['category'] as String?;

        // Only proceed if category is not null
        if (category != null) {
          recommendedGames.addAll(
            GameData.games.where((game) => game.category == category).toList(),
          );
        }
      }
    });
    return recommendedGames.toSet().toList(); // Remove duplicates
  }
}
