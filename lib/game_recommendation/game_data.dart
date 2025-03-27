import 'game_model.dart'; // Import the Game class

class GameData {
  static final List<Game> games = [
    Game(
      id: '1',
      name: 'Memory Match',
      category: 'Memory',
      description: 'Improve your memory by matching pairs of cards.',
    ),
    Game(
      id: '2',
      name: 'Focus Grid',
      category: 'Attention',
      description: 'Enhance your focus by following patterns on a grid.',
    ),
 
    Game(
      id: '4',
      name: 'Puzzle Solver',
      category: 'Problem Solving',
      description: 'Solve puzzles to improve cognitive flexibility.',
    ),
  ];
}